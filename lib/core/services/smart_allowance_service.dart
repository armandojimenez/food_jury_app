import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/database/app_database.dart';
import '../../data/providers/database_provider.dart';
import '../../features/decision/data/models/verdict.dart';

/// Storage could not confirm the allowance. Never interpret this as unused.
class SmartAllowanceUnavailable implements Exception {
  const SmartAllowanceUnavailable(this.cause);
  final Object cause;
}

abstract interface class SmartAllowanceStore {
  Future<String?> read();
  Future<void> write(String value);
}

/// A preview/test owns this store; no platform channel or real allowance is used.
class MemorySmartAllowanceStore implements SmartAllowanceStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String value) async => this.value = value;
}

/// Uses the same platform strategy as Unworried: Apple Keychain and Android
/// backup-eligible preferences. Android restore depends on the user's backup.
/// This is local reinstall resistance, not server-verified device attestation.
class PersistentSmartAllowanceStore implements SmartAllowanceStore {
  static const key = 'foodjury_smart_allowance_v1';
  static const _keychain = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  final _preferences = SharedPreferencesAsync();
  bool get _usesKeychain => Platform.isIOS || Platform.isMacOS;

  @override
  Future<String?> read() =>
      _usesKeychain ? _keychain.read(key: key) : _preferences.getString(key);

  @override
  Future<void> write(String value) => _usesKeychain
      ? _keychain.write(key: key, value: value)
      : _preferences.setString(key, value);
}

/// A random app identity, never a hardware identifier, and a monotonic ledger.
/// Operation IDs preserve retry idempotency without storing food or photo data.
class SmartAllowance {
  SmartAllowance({
    required this.deviceId,
    required Set<String> chargedOperations,
  }) : chargedOperations = Set.unmodifiable(chargedOperations);

  static const freeUses = 3;
  final String deviceId;
  final Set<String> chargedOperations;
  int get remaining => (freeUses - chargedOperations.length).clamp(0, freeUses);

  String encode() => jsonEncode({
    'version': 1,
    'deviceId': deviceId,
    'chargedOperations': chargedOperations.toList()..sort(),
  });

  factory SmartAllowance.decode(String raw) {
    final value = jsonDecode(raw);
    if (value is! Map<String, dynamic> ||
        value['version'] != 1 ||
        value['deviceId'] is! String ||
        !RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
        ).hasMatch(value['deviceId'] as String) ||
        value['chargedOperations'] is! List ||
        (value['chargedOperations'] as List).any(
          (id) => id is! String || id.isEmpty,
        )) {
      throw const FormatException('Invalid Smart allowance record');
    }
    return SmartAllowance(
      deviceId: value['deviceId'] as String,
      chargedOperations: (value['chargedOperations'] as List)
          .cast<String>()
          .toSet(),
    );
  }
}

final smartAllowanceServiceProvider = Provider<SmartAllowanceService>((ref) {
  final db = ref.watch(databaseProvider);
  return SmartAllowanceService(
    db.usesEphemeralStorage
        ? MemorySmartAllowanceStore()
        : PersistentSmartAllowanceStore(),
  );
});

class SmartAllowanceService {
  SmartAllowanceService(this.store)
    : _lock = store is PersistentSmartAllowanceStore
          ? _persistentLock
          : (_isolatedLocks[store] ??= _AllowanceLock());

  static final _persistentLock = _AllowanceLock();
  static final _isolatedLocks = Expando<_AllowanceLock>();
  final _AllowanceLock _lock;
  final SmartAllowanceStore store;
  String? _deviceId;

  /// Available after successful preflight. Synchronous so an AI adapter called
  /// inside [decide] never re-enters the operation's serialization lock.
  String get deviceId =>
      _deviceId ??
      (throw SmartAllowanceUnavailable(
        StateError('The Smart identity has not been verified'),
      ));

  Future<SmartAllowance> reconcile(AppDatabase db) =>
      _lock.run(() => _reconcile(db));

  Future<SmartAllowance> _reconcile(AppDatabase db) async {
    final SmartAllowance? stored;
    try {
      final raw = await store.read();
      stored = raw == null ? null : SmartAllowance.decode(raw);
    } catch (error) {
      throw SmartAllowanceUnavailable(error);
    }
    final localIds = await db.chargedAiOperationIds();
    final combined = {...?stored?.chargedOperations, ...localIds};
    final state = SmartAllowance(
      deviceId: stored?.deviceId ?? const Uuid().v4(),
      chargedOperations: combined,
    );
    if (stored == null || combined.length != stored.chargedOperations.length) {
      try {
        await store.write(state.encode());
      } catch (error) {
        throw SmartAllowanceUnavailable(error);
      }
    }
    if (!localIds.containsAll(combined)) {
      await db.restoreChargedAiOperations(combined.difference(localIds));
    }
    _deviceId = state.deviceId;
    return state;
  }

  /// Preserve DB atomicity: only a committed verdict is charged. If mirroring
  /// fails, its retry reconciles that same saved operation before returning it.
  /// There is no transaction spanning SQLite and Keychain/preferences; a process
  /// interruption is repaired from SQLite on the next read while it exists.
  Future<Verdict> decide(
    AppDatabase db, {
    required String operationId,
    required bool premium,
    required Future<Verdict> Function() generate,
  }) => _lock.run(() async {
    final allowance = await _reconcile(db);
    final existing = await db.getVerdictById(operationId);
    if (existing != null) return existing;
    if (!premium && allowance.remaining == 0) throw AiAllowanceExhausted();
    final verdict = await generate();
    if (verdict.id != operationId || verdict.isRandom) {
      throw ArgumentError('The Smart result must match its operation');
    }
    await db.saveAiVerdict(verdict, premium: premium);
    if (!premium) await _reconcile(db);
    return verdict;
  });
}

/// Serialize complete operations across services sharing the same store.
/// Independent preview stores never wait on real user requests or each other.
class _AllowanceLock {
  Future<void> _pending = Future<void>.value();
  Future<T> run<T>(Future<T> Function() action) {
    final result = _pending.then((_) => action());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }
}
