import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Verdicts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

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
      ),
    );
  }

  /// Gets all verdicts ordered by creation date (newest first).
  Future<List<Verdict>> getAllVerdicts() async {
    final rows = await (select(verdicts)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_rowToVerdict).toList();
  }

  /// Gets a single verdict by ID.
  Future<Verdict?> getVerdictById(String id) async {
    final row = await (select(verdicts)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _rowToVerdict(row) : null;
  }

  /// Gets the most recent verdicts (for home screen).
  Future<List<Verdict>> getRecentVerdicts({int limit = 5}) async {
    final rows = await (select(verdicts)
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
      'imagePath': option.imagePath,
    });
  }

  String _foodOptionsToJson(List<FoodOption> options) {
    return jsonEncode(options
        .map((o) => {
              'id': o.id,
              'name': o.name,
              'notes': o.notes,
              'imagePath': o.imagePath,
            })
        .toList());
  }

  FoodOption _jsonToFoodOption(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return FoodOption(
      id: map['id'] as String,
      name: map['name'] as String,
      notes: map['notes'] as String?,
      imagePath: map['imagePath'] as String?,
    );
  }

  List<FoodOption> _jsonToFoodOptions(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((item) => FoodOption(
              id: item['id'] as String,
              name: item['name'] as String,
              notes: item['notes'] as String?,
              imagePath: item['imagePath'] as String?,
            ))
        .toList();
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
