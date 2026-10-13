import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Change when the disclosed data or processing recipients change.
const aiConsentVersion = 'foodjury-ai-v1-2026-10-13';
const aiConsentPreferenceKey = 'ai_data_consent_version';

/// Persists the exact disclosure accepted by the user, never an implied grant.
abstract interface class AiConsentStore {
  Future<String?> read();
  Future<void> write(String? version);
}

/// Each offline preview owns this store; it never touches app preferences.
class MemoryAiConsentStore implements AiConsentStore {
  String? _version;

  @override
  Future<String?> read() async => _version;

  @override
  Future<void> write(String? version) async => _version = version;
}

class PreferencesAiConsentStore implements AiConsentStore {
  @override
  Future<String?> read() async =>
      (await SharedPreferences.getInstance()).getString(aiConsentPreferenceKey);

  @override
  Future<void> write(String? version) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = version == null
        ? await preferences.remove(aiConsentPreferenceKey)
        : await preferences.setString(aiConsentPreferenceKey, version);
    if (!saved) throw StateError('AI data permission could not be saved');
  }
}

final aiConsentStoreProvider = Provider<AiConsentStore>(
  (ref) => PreferencesAiConsentStore(),
);

/// Null or an older version requires a fresh, explicit decision before sending.
final aiConsentProvider = NotifierProvider<AiConsentNotifier, String?>(
  AiConsentNotifier.new,
);

class AiConsentNotifier extends Notifier<String?> {
  late Future<void> ready;
  Future<void> _pending = Future.value();
  bool _disposed = false;
  int _revision = 0;
  Object? _storageError;

  @override
  String? build() {
    ref.onDispose(() => _disposed = true);
    ready = _load();
    return null;
  }

  Future<void> _load() async {
    final revision = _revision;
    try {
      final saved = await ref.read(aiConsentStoreProvider).read();
      if (!_disposed && revision == _revision) state = saved;
    } catch (error) {
      // An unavailable preference can never imply permission to send evidence.
      _storageError = error;
    }
  }

  /// Gateway calls this immediately before HTTP, after any pending revoke.
  Future<String?> acceptedVersion() async {
    await ready;
    Future<void> pending;
    do {
      pending = _pending;
      await pending;
    } while (!identical(pending, _pending));
    if (_disposed) return null;
    if (_storageError != null) {
      throw StateError('AI data permission unavailable');
    }
    return state == aiConsentVersion ? state : null;
  }

  Future<void> _write(String? version) {
    if (_disposed) return Future.value();
    final revision = ++_revision;
    final store = ref.read(aiConsentStoreProvider);
    final write = _pending.then((_) async {
      await ready;
      await store.write(version);
      if (!_disposed && revision == _revision) {
        _storageError = null;
        state = version;
      }
    });
    // Permit an explicit retry after unavailable storage.
    _pending = write.catchError((Object error) {
      _storageError = error;
    });
    return write;
  }

  /// Called only by the affirmative action on the current disclosure.
  Future<void> accept() => _write(aiConsentVersion);

  /// Block new requests immediately, even if saving the revocation fails.
  /// Already submitted requests cannot be recalled by a local permission change.
  Future<void> revoke() {
    if (!_disposed) state = null;
    return _write(null);
  }
}
