// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VerdictsTable extends Verdicts
    with TableInfo<$VerdictsTable, VerdictRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerdictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerJsonMeta = const VerificationMeta(
    'winnerJson',
  );
  @override
  late final GeneratedColumn<String> winnerJson = GeneratedColumn<String>(
    'winner_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankingsJsonMeta = const VerificationMeta(
    'rankingsJson',
  );
  @override
  late final GeneratedColumn<String> rankingsJson = GeneratedColumn<String>(
    'rankings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasoningMeta = const VerificationMeta(
    'reasoning',
  );
  @override
  late final GeneratedColumn<String> reasoning = GeneratedColumn<String>(
    'reasoning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectiveMeta = const VerificationMeta(
    'objective',
  );
  @override
  late final GeneratedColumn<String> objective = GeneratedColumn<String>(
    'objective',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _judgeToneMeta = const VerificationMeta(
    'judgeTone',
  );
  @override
  late final GeneratedColumn<String> judgeTone = GeneratedColumn<String>(
    'judge_tone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    winnerJson,
    rankingsJson,
    reasoning,
    objective,
    judgeTone,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verdicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerdictRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('winner_json')) {
      context.handle(
        _winnerJsonMeta,
        winnerJson.isAcceptableOrUnknown(data['winner_json']!, _winnerJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_winnerJsonMeta);
    }
    if (data.containsKey('rankings_json')) {
      context.handle(
        _rankingsJsonMeta,
        rankingsJson.isAcceptableOrUnknown(
          data['rankings_json']!,
          _rankingsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rankingsJsonMeta);
    }
    if (data.containsKey('reasoning')) {
      context.handle(
        _reasoningMeta,
        reasoning.isAcceptableOrUnknown(data['reasoning']!, _reasoningMeta),
      );
    } else if (isInserting) {
      context.missing(_reasoningMeta);
    }
    if (data.containsKey('objective')) {
      context.handle(
        _objectiveMeta,
        objective.isAcceptableOrUnknown(data['objective']!, _objectiveMeta),
      );
    } else if (isInserting) {
      context.missing(_objectiveMeta);
    }
    if (data.containsKey('judge_tone')) {
      context.handle(
        _judgeToneMeta,
        judgeTone.isAcceptableOrUnknown(data['judge_tone']!, _judgeToneMeta),
      );
    } else if (isInserting) {
      context.missing(_judgeToneMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerdictRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerdictRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      winnerJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_json'],
      )!,
      rankingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rankings_json'],
      )!,
      reasoning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasoning'],
      )!,
      objective: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective'],
      )!,
      judgeTone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judge_tone'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VerdictsTable createAlias(String alias) {
    return $VerdictsTable(attachedDatabase, alias);
  }
}

class VerdictRow extends DataClass implements Insertable<VerdictRow> {
  /// Unique identifier.
  final String id;

  /// Winner food option as JSON.
  final String winnerJson;

  /// All ranked options as JSON array.
  final String rankingsJson;

  /// Judge's reasoning text.
  final String reasoning;

  /// Objective enum name (fun, healthy, fit, quick).
  final String objective;

  /// Judge tone enum name (stern, sassy, enthusiastic, chill).
  final String judgeTone;

  /// When the verdict was created.
  final DateTime createdAt;
  const VerdictRow({
    required this.id,
    required this.winnerJson,
    required this.rankingsJson,
    required this.reasoning,
    required this.objective,
    required this.judgeTone,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['winner_json'] = Variable<String>(winnerJson);
    map['rankings_json'] = Variable<String>(rankingsJson);
    map['reasoning'] = Variable<String>(reasoning);
    map['objective'] = Variable<String>(objective);
    map['judge_tone'] = Variable<String>(judgeTone);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VerdictsCompanion toCompanion(bool nullToAbsent) {
    return VerdictsCompanion(
      id: Value(id),
      winnerJson: Value(winnerJson),
      rankingsJson: Value(rankingsJson),
      reasoning: Value(reasoning),
      objective: Value(objective),
      judgeTone: Value(judgeTone),
      createdAt: Value(createdAt),
    );
  }

  factory VerdictRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerdictRow(
      id: serializer.fromJson<String>(json['id']),
      winnerJson: serializer.fromJson<String>(json['winnerJson']),
      rankingsJson: serializer.fromJson<String>(json['rankingsJson']),
      reasoning: serializer.fromJson<String>(json['reasoning']),
      objective: serializer.fromJson<String>(json['objective']),
      judgeTone: serializer.fromJson<String>(json['judgeTone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'winnerJson': serializer.toJson<String>(winnerJson),
      'rankingsJson': serializer.toJson<String>(rankingsJson),
      'reasoning': serializer.toJson<String>(reasoning),
      'objective': serializer.toJson<String>(objective),
      'judgeTone': serializer.toJson<String>(judgeTone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VerdictRow copyWith({
    String? id,
    String? winnerJson,
    String? rankingsJson,
    String? reasoning,
    String? objective,
    String? judgeTone,
    DateTime? createdAt,
  }) => VerdictRow(
    id: id ?? this.id,
    winnerJson: winnerJson ?? this.winnerJson,
    rankingsJson: rankingsJson ?? this.rankingsJson,
    reasoning: reasoning ?? this.reasoning,
    objective: objective ?? this.objective,
    judgeTone: judgeTone ?? this.judgeTone,
    createdAt: createdAt ?? this.createdAt,
  );
  VerdictRow copyWithCompanion(VerdictsCompanion data) {
    return VerdictRow(
      id: data.id.present ? data.id.value : this.id,
      winnerJson: data.winnerJson.present
          ? data.winnerJson.value
          : this.winnerJson,
      rankingsJson: data.rankingsJson.present
          ? data.rankingsJson.value
          : this.rankingsJson,
      reasoning: data.reasoning.present ? data.reasoning.value : this.reasoning,
      objective: data.objective.present ? data.objective.value : this.objective,
      judgeTone: data.judgeTone.present ? data.judgeTone.value : this.judgeTone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerdictRow(')
          ..write('id: $id, ')
          ..write('winnerJson: $winnerJson, ')
          ..write('rankingsJson: $rankingsJson, ')
          ..write('reasoning: $reasoning, ')
          ..write('objective: $objective, ')
          ..write('judgeTone: $judgeTone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    winnerJson,
    rankingsJson,
    reasoning,
    objective,
    judgeTone,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerdictRow &&
          other.id == this.id &&
          other.winnerJson == this.winnerJson &&
          other.rankingsJson == this.rankingsJson &&
          other.reasoning == this.reasoning &&
          other.objective == this.objective &&
          other.judgeTone == this.judgeTone &&
          other.createdAt == this.createdAt);
}

class VerdictsCompanion extends UpdateCompanion<VerdictRow> {
  final Value<String> id;
  final Value<String> winnerJson;
  final Value<String> rankingsJson;
  final Value<String> reasoning;
  final Value<String> objective;
  final Value<String> judgeTone;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VerdictsCompanion({
    this.id = const Value.absent(),
    this.winnerJson = const Value.absent(),
    this.rankingsJson = const Value.absent(),
    this.reasoning = const Value.absent(),
    this.objective = const Value.absent(),
    this.judgeTone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VerdictsCompanion.insert({
    required String id,
    required String winnerJson,
    required String rankingsJson,
    required String reasoning,
    required String objective,
    required String judgeTone,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       winnerJson = Value(winnerJson),
       rankingsJson = Value(rankingsJson),
       reasoning = Value(reasoning),
       objective = Value(objective),
       judgeTone = Value(judgeTone),
       createdAt = Value(createdAt);
  static Insertable<VerdictRow> custom({
    Expression<String>? id,
    Expression<String>? winnerJson,
    Expression<String>? rankingsJson,
    Expression<String>? reasoning,
    Expression<String>? objective,
    Expression<String>? judgeTone,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (winnerJson != null) 'winner_json': winnerJson,
      if (rankingsJson != null) 'rankings_json': rankingsJson,
      if (reasoning != null) 'reasoning': reasoning,
      if (objective != null) 'objective': objective,
      if (judgeTone != null) 'judge_tone': judgeTone,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VerdictsCompanion copyWith({
    Value<String>? id,
    Value<String>? winnerJson,
    Value<String>? rankingsJson,
    Value<String>? reasoning,
    Value<String>? objective,
    Value<String>? judgeTone,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VerdictsCompanion(
      id: id ?? this.id,
      winnerJson: winnerJson ?? this.winnerJson,
      rankingsJson: rankingsJson ?? this.rankingsJson,
      reasoning: reasoning ?? this.reasoning,
      objective: objective ?? this.objective,
      judgeTone: judgeTone ?? this.judgeTone,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (winnerJson.present) {
      map['winner_json'] = Variable<String>(winnerJson.value);
    }
    if (rankingsJson.present) {
      map['rankings_json'] = Variable<String>(rankingsJson.value);
    }
    if (reasoning.present) {
      map['reasoning'] = Variable<String>(reasoning.value);
    }
    if (objective.present) {
      map['objective'] = Variable<String>(objective.value);
    }
    if (judgeTone.present) {
      map['judge_tone'] = Variable<String>(judgeTone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerdictsCompanion(')
          ..write('id: $id, ')
          ..write('winnerJson: $winnerJson, ')
          ..write('rankingsJson: $rankingsJson, ')
          ..write('reasoning: $reasoning, ')
          ..write('objective: $objective, ')
          ..write('judgeTone: $judgeTone, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VerdictsTable verdicts = $VerdictsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [verdicts];
}

typedef $$VerdictsTableCreateCompanionBuilder =
    VerdictsCompanion Function({
      required String id,
      required String winnerJson,
      required String rankingsJson,
      required String reasoning,
      required String objective,
      required String judgeTone,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VerdictsTableUpdateCompanionBuilder =
    VerdictsCompanion Function({
      Value<String> id,
      Value<String> winnerJson,
      Value<String> rankingsJson,
      Value<String> reasoning,
      Value<String> objective,
      Value<String> judgeTone,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$VerdictsTableFilterComposer
    extends Composer<_$AppDatabase, $VerdictsTable> {
  $$VerdictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerJson => $composableBuilder(
    column: $table.winnerJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rankingsJson => $composableBuilder(
    column: $table.rankingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasoning => $composableBuilder(
    column: $table.reasoning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objective => $composableBuilder(
    column: $table.objective,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judgeTone => $composableBuilder(
    column: $table.judgeTone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VerdictsTableOrderingComposer
    extends Composer<_$AppDatabase, $VerdictsTable> {
  $$VerdictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerJson => $composableBuilder(
    column: $table.winnerJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rankingsJson => $composableBuilder(
    column: $table.rankingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasoning => $composableBuilder(
    column: $table.reasoning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objective => $composableBuilder(
    column: $table.objective,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judgeTone => $composableBuilder(
    column: $table.judgeTone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VerdictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerdictsTable> {
  $$VerdictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get winnerJson => $composableBuilder(
    column: $table.winnerJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rankingsJson => $composableBuilder(
    column: $table.rankingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasoning =>
      $composableBuilder(column: $table.reasoning, builder: (column) => column);

  GeneratedColumn<String> get objective =>
      $composableBuilder(column: $table.objective, builder: (column) => column);

  GeneratedColumn<String> get judgeTone =>
      $composableBuilder(column: $table.judgeTone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VerdictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerdictsTable,
          VerdictRow,
          $$VerdictsTableFilterComposer,
          $$VerdictsTableOrderingComposer,
          $$VerdictsTableAnnotationComposer,
          $$VerdictsTableCreateCompanionBuilder,
          $$VerdictsTableUpdateCompanionBuilder,
          (
            VerdictRow,
            BaseReferences<_$AppDatabase, $VerdictsTable, VerdictRow>,
          ),
          VerdictRow,
          PrefetchHooks Function()
        > {
  $$VerdictsTableTableManager(_$AppDatabase db, $VerdictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerdictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerdictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerdictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> winnerJson = const Value.absent(),
                Value<String> rankingsJson = const Value.absent(),
                Value<String> reasoning = const Value.absent(),
                Value<String> objective = const Value.absent(),
                Value<String> judgeTone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VerdictsCompanion(
                id: id,
                winnerJson: winnerJson,
                rankingsJson: rankingsJson,
                reasoning: reasoning,
                objective: objective,
                judgeTone: judgeTone,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String winnerJson,
                required String rankingsJson,
                required String reasoning,
                required String objective,
                required String judgeTone,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VerdictsCompanion.insert(
                id: id,
                winnerJson: winnerJson,
                rankingsJson: rankingsJson,
                reasoning: reasoning,
                objective: objective,
                judgeTone: judgeTone,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VerdictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerdictsTable,
      VerdictRow,
      $$VerdictsTableFilterComposer,
      $$VerdictsTableOrderingComposer,
      $$VerdictsTableAnnotationComposer,
      $$VerdictsTableCreateCompanionBuilder,
      $$VerdictsTableUpdateCompanionBuilder,
      (VerdictRow, BaseReferences<_$AppDatabase, $VerdictsTable, VerdictRow>),
      VerdictRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VerdictsTableTableManager get verdicts =>
      $$VerdictsTableTableManager(_db, _db.verdicts);
}
