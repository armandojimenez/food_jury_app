import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/decision/data/models/verdict.dart';
import 'database_provider.dart';

/// Provider for all verdicts (history).
///
/// Returns verdicts sorted by creation date (newest first).
final verdictsProvider = FutureProvider<List<Verdict>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllVerdicts();
});

/// Provider for recent verdicts (home screen).
///
/// Returns the 5 most recent verdicts.
final recentVerdictsProvider = FutureProvider<List<Verdict>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getRecentVerdicts(limit: 5);
});

/// Provider for a single verdict by ID.
final verdictByIdProvider =
    FutureProvider.family<Verdict?, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.getVerdictById(id);
});

/// Notifier for managing verdict operations (save, delete).
class VerdictNotifier extends Notifier<void> {
  @override
  void build() {}

  /// Saves a verdict to the database.
  Future<void> saveVerdict(Verdict verdict) async {
    final db = ref.read(databaseProvider);
    await db.saveVerdict(verdict);
    // Invalidate the providers to refresh data
    ref.invalidate(verdictsProvider);
    ref.invalidate(recentVerdictsProvider);
  }

  /// Deletes a verdict from the database.
  Future<void> deleteVerdict(String id) async {
    final db = ref.read(databaseProvider);
    await db.deleteVerdict(id);
    // Invalidate the providers to refresh data
    ref.invalidate(verdictsProvider);
    ref.invalidate(recentVerdictsProvider);
  }

  /// Deletes all verdicts (for testing/reset).
  Future<void> deleteAllVerdicts() async {
    final db = ref.read(databaseProvider);
    await db.deleteAllVerdicts();
    // Invalidate the providers to refresh data
    ref.invalidate(verdictsProvider);
    ref.invalidate(recentVerdictsProvider);
  }
}

/// Provider for verdict operations.
final verdictNotifierProvider = NotifierProvider<VerdictNotifier, void>(() {
  return VerdictNotifier();
});
