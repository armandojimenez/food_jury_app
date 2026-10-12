import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/decision/data/models/food_option.dart';
import '../../features/decision/data/models/objective.dart';
import '../../features/decision/data/models/verdict.dart';

part 'app_database.g.dart';

/// Verdicts table storing decision history.
@DataClassName('VerdictRow')
class Verdicts extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Winner food option as JSON.
  TextColumn get winnerJson => text()();

  /// All ranked options as JSON array.
  TextColumn get rankingsJson => text()();

  /// Judge's reasoning text.
  TextColumn get reasoning => text()();

  /// Objective enum name (fun, healthy, fit, quick).
  TextColumn get objective => text()();

  /// Judge tone enum name (stern, sassy, enthusiastic, chill).
  TextColumn get judgeTone => text()();

  /// When the verdict was created.
  DateTimeColumn get createdAt => dateTime()();

  /// Optional bonus content (joke, fun fact, tip, story).
  TextColumn get bonus => text().nullable()();

  /// Bonus type enum name (joke, funFact, tip, story).
  TextColumn get bonusType => text().nullable()();

  /// Original case order; old rows fall back to their stored AI ranking.
  TextColumn get contendersJson => text().withDefault(const Constant('[]'))();

  /// Null means an AI verdict. Otherwise stores method and the exact offline quote.
  TextColumn get randomJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Successful AI operations survive history deletion. Store/account sync is pending.
class AiUses extends Table {
  TextColumn get operationId => text()();
  BoolColumn get chargedFree => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {operationId};
}

/// Raised before a fourth free AI operation can be saved.
class AiAllowanceExhausted implements Exception {}

@DriftDatabase(tables: [Verdicts, AiUses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Migration from v1 to v2: add bonus columns
      if (from < 2) {
        await m.addColumn(verdicts, verdicts.bonus);
        await m.addColumn(verdicts, verdicts.bonusType);
      }
      if (from < 3) {
        await m.addColumn(verdicts, verdicts.contendersJson);
        await m.addColumn(verdicts, verdicts.randomJson);
        await m.createTable(aiUses);
        // Existing AI decisions count toward the lifetime allowance.
        await customStatement(
          'INSERT INTO ai_uses (operation_id) SELECT id FROM verdicts',
        );
      }
    },
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Verdict Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Saves a verdict to the database.
  Future<void> saveVerdict(Verdict verdict) async {
    await into(verdicts).insert(
      VerdictsCompanion.insert(
        id: verdict.id,
        winnerJson: _foodOptionToJson(verdict.winner),
        rankingsJson: _foodOptionsToJson(verdict.rankings),
        reasoning: verdict.reasoning,
        objective: verdict.objective.name,
        judgeTone: verdict.judgeTone.name,
        createdAt: verdict.createdAt,
        bonus: Value(verdict.bonus),
        bonusType: Value(verdict.bonusType?.name),
        contendersJson: Value(_foodOptionsToJson(verdict.caseOptions)),
        randomJson: Value(
          verdict.random == null ? null : jsonEncode(verdict.random!.toJson()),
        ),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Remaining free AI decisions for this installation, independent of history.
  Future<int> remainingAiDecisions() async {
    final rows = await (select(
      aiUses,
    )..where((t) => t.chargedFree.equals(true))).get();
    return (3 - rows.length).clamp(0, 3);
  }

  /// Save the AI result and consume its allowance atomically and idempotently.
  /// A failed database write rolls back both operations.
  Future<void> saveAiVerdict(Verdict verdict, {bool premium = false}) =>
      transaction(() async {
        if (verdict.isRandom) throw ArgumentError('Expected an AI verdict');
        final existing = await (select(
          aiUses,
        )..where((t) => t.operationId.equals(verdict.id))).getSingleOrNull();
        if (existing != null) return;
        if (!premium && await remainingAiDecisions() == 0) {
          throw AiAllowanceExhausted();
        }
        await saveVerdict(verdict.snapshot());
        await into(aiUses).insert(
          AiUsesCompanion.insert(
            operationId: verdict.id,
            chargedFree: Value(!premium),
          ),
        );
      });

  /// Gets all verdicts ordered by creation date (newest first).
  Future<List<Verdict>> getAllVerdicts() async {
    final rows = await (select(
      verdicts,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return rows.map(_rowToVerdict).toList();
  }

  /// Gets a single verdict by ID.
  Future<Verdict?> getVerdictById(String id) async {
    final row = await (select(
      verdicts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _rowToVerdict(row) : null;
  }

  /// Gets the most recent verdicts (for home screen).
  Future<List<Verdict>> getRecentVerdicts({int limit = 5}) async {
    final rows =
        await (select(verdicts)
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
              ..limit(limit))
            .get();
    return rows.map(_rowToVerdict).toList();
  }

  /// Deletes a verdict by ID.
  Future<void> deleteVerdict(String id) async {
    await (delete(verdicts)..where((t) => t.id.equals(id))).go();
  }

  /// Deletes all verdicts.
  Future<void> deleteAllVerdicts() async {
    await delete(verdicts).go();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Serialization Helpers
  // ─────────────────────────────────────────────────────────────────────────

  String _foodOptionToJson(FoodOption option) {
    return jsonEncode({
      'id': option.id,
      'name': option.name,
      'notes': option.notes,
      'illustrationId': option.illustrationId,
      'imageBase64': option.imageBytes != null
          ? base64Encode(option.imageBytes!)
          : null,
    });
  }

  String _foodOptionsToJson(List<FoodOption> options) {
    return jsonEncode(
      options
          .map(
            (o) => {
              'id': o.id,
              'name': o.name,
              'notes': o.notes,
              'illustrationId': o.illustrationId,
              'imageBase64': o.imageBytes != null
                  ? base64Encode(o.imageBytes!)
                  : null,
            },
          )
          .toList(),
    );
  }

  FoodOption _jsonToFoodOption(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    final imageBase64 = map['imageBase64'] as String?;
    return FoodOption(
      id: map['id'] as String,
      name: map['name'] as String,
      notes: map['notes'] as String?,
      illustrationId: map['illustrationId'] as String?,
      imageBytes: _safeBase64Decode(imageBase64),
    );
  }

  List<FoodOption> _jsonToFoodOptions(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((item) {
      final imageBase64 = item['imageBase64'] as String?;
      return FoodOption(
        id: item['id'] as String,
        name: item['name'] as String,
        notes: item['notes'] as String?,
        illustrationId: item['illustrationId'] as String?,
        imageBytes: _safeBase64Decode(imageBase64),
      );
    }).toList();
  }

  /// Safely decode base64 string, returning null on failure.
  Uint8List? _safeBase64Decode(String? encoded) {
    if (encoded == null) return null;
    try {
      return base64Decode(encoded);
    } catch (e) {
      debugPrint('Failed to decode image data: $e');
      return null;
    }
  }

  Verdict _rowToVerdict(VerdictRow row) {
    return Verdict(
      id: row.id,
      winner: _jsonToFoodOption(row.winnerJson),
      rankings: _jsonToFoodOptions(row.rankingsJson),
      reasoning: row.reasoning,
      contenders: _jsonToFoodOptions(row.contendersJson),
      random: row.randomJson == null
          ? null
          : RandomRuling.fromJson(
              jsonDecode(row.randomJson!) as Map<String, dynamic>,
            ),
      objective: Objective.values.firstWhere(
        (e) => e.name == row.objective,
        orElse: () => Objective.fun, // Default fallback for data safety
      ),
      judgeTone: JudgeTone.values.firstWhere(
        (e) => e.name == row.judgeTone,
        orElse: () => JudgeTone.stern, // Default fallback for data safety
      ),
      createdAt: row.createdAt,
      bonus: row.bonus,
      bonusType: row.bonusType != null
          ? BonusType.values.firstWhere(
              (e) => e.name == row.bonusType,
              orElse: () => BonusType.funFact,
            )
          : null,
    ).snapshot();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'food_jury.db'));
    return NativeDatabase.createInBackground(file);
  });
}
