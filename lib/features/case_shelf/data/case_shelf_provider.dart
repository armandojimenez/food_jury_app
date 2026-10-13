import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/database_provider.dart';
import 'case_shelf_models.dart';

/// Uses the same database as verdicts, including the isolated preview database.
final caseShelfProvider = StreamProvider<CaseShelf>(
  (ref) => ref.watch(databaseProvider).watchCaseShelf(),
);

/// Serializes draft writes so quick edits cannot resurrect an older draft.
final caseShelfStoreProvider = Provider<CaseShelfStore>(
  (ref) => CaseShelfStore(ref.watch(databaseProvider)),
);

/// Local persistence operations shared by the editor and the counter.
class CaseShelfStore {
  /// Creates a store tied to the current database.
  CaseShelfStore(this._database);
  final AppDatabase _database;
  Future<void> _pending = Future.value();

  Future<void> _enqueue(Future<void> Function() operation) {
    final next = _pending.then((_) => operation());
    // A failed write must not prevent the next edit or explicit retry.
    _pending = next.catchError((Object _) {});
    return next;
  }

  /// Durably saves a snapshot, or removes an empty draft.
  Future<void> saveDraft(CaseDraft draft) =>
      _enqueue(() => _database.saveCaseDraft(draft));

  /// Removes the unfinished case after the user deliberately discards it.
  Future<void> discardDraft() => _enqueue(_database.deleteCaseDraft);

  /// Saves a new named lineup without replacing history or the active draft.
  Future<void> saveSet(SavedCaseSet value) =>
      _enqueue(() => _database.saveCaseSet(value));

  /// Deletes one reusable lineup, leaving any case opened from it intact.
  Future<void> deleteSet(String id) =>
      _enqueue(() => _database.deleteCaseSet(id));
}
