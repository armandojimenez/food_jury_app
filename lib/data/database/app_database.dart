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

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Verdicts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Migration from v1 to v2: add bonus columns
      if (from < 2) {
        await m.addColumn(verdicts, verdicts.bonus);
        await m.addColumn(verdicts, verdicts.bonusType);
      }
    },
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Verdict Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Saves a verdict to the database.
  Future<void> saveVerdict(Verdict verdict) async {
    await into(verdicts).insertOnConflictUpdate(
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
      ),
    );
  }

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
      objective: Objective.values.firstWhere((e) => e.name == row.objective),
      judgeTone: JudgeTone.values.firstWhere((e) => e.name == row.judgeTone),
      createdAt: row.createdAt,
      bonus: row.bonus,
      bonusType: row.bonusType != null
          ? BonusType.values.firstWhere(
              (e) => e.name == row.bonusType,
              orElse: () => BonusType.funFact,
            )
          : null,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'food_jury.db'));
    return NativeDatabase.createInBackground(file);
  });
}
