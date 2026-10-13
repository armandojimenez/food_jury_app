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
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<String> bonus = GeneratedColumn<String>(
    'bonus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bonusTypeMeta = const VerificationMeta(
    'bonusType',
  );
  @override
  late final GeneratedColumn<String> bonusType = GeneratedColumn<String>(
    'bonus_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contendersJsonMeta = const VerificationMeta(
    'contendersJson',
  );
  @override
  late final GeneratedColumn<String> contendersJson = GeneratedColumn<String>(
    'contenders_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _randomJsonMeta = const VerificationMeta(
    'randomJson',
  );
  @override
  late final GeneratedColumn<String> randomJson = GeneratedColumn<String>(
    'random_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    bonus,
    bonusType,
    contendersJson,
    randomJson,
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
    if (data.containsKey('bonus')) {
      context.handle(
        _bonusMeta,
        bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta),
      );
    }
    if (data.containsKey('bonus_type')) {
      context.handle(
        _bonusTypeMeta,
        bonusType.isAcceptableOrUnknown(data['bonus_type']!, _bonusTypeMeta),
      );
    }
    if (data.containsKey('contenders_json')) {
      context.handle(
        _contendersJsonMeta,
        contendersJson.isAcceptableOrUnknown(
          data['contenders_json']!,
          _contendersJsonMeta,
        ),
      );
    }
    if (data.containsKey('random_json')) {
      context.handle(
        _randomJsonMeta,
        randomJson.isAcceptableOrUnknown(data['random_json']!, _randomJsonMeta),
      );
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
      bonus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bonus'],
      ),
      bonusType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bonus_type'],
      ),
      contendersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contenders_json'],
      )!,
      randomJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}random_json'],
      ),
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

  /// Optional bonus content (joke, fun fact, tip, story).
  final String? bonus;

  /// Bonus type enum name (joke, funFact, tip, story).
  final String? bonusType;

  /// Original case order; old rows fall back to their stored AI ranking.
  final String contendersJson;

  /// Null means an AI verdict. Otherwise stores method and the exact offline quote.
  final String? randomJson;
  const VerdictRow({
    required this.id,
    required this.winnerJson,
    required this.rankingsJson,
    required this.reasoning,
    required this.objective,
    required this.judgeTone,
    required this.createdAt,
    this.bonus,
    this.bonusType,
    required this.contendersJson,
    this.randomJson,
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
    if (!nullToAbsent || bonus != null) {
      map['bonus'] = Variable<String>(bonus);
    }
    if (!nullToAbsent || bonusType != null) {
      map['bonus_type'] = Variable<String>(bonusType);
    }
    map['contenders_json'] = Variable<String>(contendersJson);
    if (!nullToAbsent || randomJson != null) {
      map['random_json'] = Variable<String>(randomJson);
    }
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
      bonus: bonus == null && nullToAbsent
          ? const Value.absent()
          : Value(bonus),
      bonusType: bonusType == null && nullToAbsent
          ? const Value.absent()
          : Value(bonusType),
      contendersJson: Value(contendersJson),
      randomJson: randomJson == null && nullToAbsent
          ? const Value.absent()
          : Value(randomJson),
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
      bonus: serializer.fromJson<String?>(json['bonus']),
      bonusType: serializer.fromJson<String?>(json['bonusType']),
      contendersJson: serializer.fromJson<String>(json['contendersJson']),
      randomJson: serializer.fromJson<String?>(json['randomJson']),
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
      'bonus': serializer.toJson<String?>(bonus),
      'bonusType': serializer.toJson<String?>(bonusType),
      'contendersJson': serializer.toJson<String>(contendersJson),
      'randomJson': serializer.toJson<String?>(randomJson),
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
    Value<String?> bonus = const Value.absent(),
    Value<String?> bonusType = const Value.absent(),
    String? contendersJson,
    Value<String?> randomJson = const Value.absent(),
  }) => VerdictRow(
    id: id ?? this.id,
    winnerJson: winnerJson ?? this.winnerJson,
    rankingsJson: rankingsJson ?? this.rankingsJson,
    reasoning: reasoning ?? this.reasoning,
    objective: objective ?? this.objective,
    judgeTone: judgeTone ?? this.judgeTone,
    createdAt: createdAt ?? this.createdAt,
    bonus: bonus.present ? bonus.value : this.bonus,
    bonusType: bonusType.present ? bonusType.value : this.bonusType,
    contendersJson: contendersJson ?? this.contendersJson,
    randomJson: randomJson.present ? randomJson.value : this.randomJson,
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
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
      bonusType: data.bonusType.present ? data.bonusType.value : this.bonusType,
      contendersJson: data.contendersJson.present
          ? data.contendersJson.value
          : this.contendersJson,
      randomJson: data.randomJson.present
          ? data.randomJson.value
          : this.randomJson,
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
          ..write('createdAt: $createdAt, ')
          ..write('bonus: $bonus, ')
          ..write('bonusType: $bonusType, ')
          ..write('contendersJson: $contendersJson, ')
          ..write('randomJson: $randomJson')
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
    bonus,
    bonusType,
    contendersJson,
    randomJson,
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
          other.createdAt == this.createdAt &&
          other.bonus == this.bonus &&
          other.bonusType == this.bonusType &&
          other.contendersJson == this.contendersJson &&
          other.randomJson == this.randomJson);
}

class VerdictsCompanion extends UpdateCompanion<VerdictRow> {
  final Value<String> id;
  final Value<String> winnerJson;
  final Value<String> rankingsJson;
  final Value<String> reasoning;
  final Value<String> objective;
  final Value<String> judgeTone;
  final Value<DateTime> createdAt;
  final Value<String?> bonus;
  final Value<String?> bonusType;
  final Value<String> contendersJson;
  final Value<String?> randomJson;
  final Value<int> rowid;
  const VerdictsCompanion({
    this.id = const Value.absent(),
    this.winnerJson = const Value.absent(),
    this.rankingsJson = const Value.absent(),
    this.reasoning = const Value.absent(),
    this.objective = const Value.absent(),
    this.judgeTone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.bonus = const Value.absent(),
    this.bonusType = const Value.absent(),
    this.contendersJson = const Value.absent(),
    this.randomJson = const Value.absent(),
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
    this.bonus = const Value.absent(),
    this.bonusType = const Value.absent(),
    this.contendersJson = const Value.absent(),
    this.randomJson = const Value.absent(),
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
    Expression<String>? bonus,
    Expression<String>? bonusType,
    Expression<String>? contendersJson,
    Expression<String>? randomJson,
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
      if (bonus != null) 'bonus': bonus,
      if (bonusType != null) 'bonus_type': bonusType,
      if (contendersJson != null) 'contenders_json': contendersJson,
      if (randomJson != null) 'random_json': randomJson,
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
    Value<String?>? bonus,
    Value<String?>? bonusType,
    Value<String>? contendersJson,
    Value<String?>? randomJson,
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
      bonus: bonus ?? this.bonus,
      bonusType: bonusType ?? this.bonusType,
      contendersJson: contendersJson ?? this.contendersJson,
      randomJson: randomJson ?? this.randomJson,
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
    if (bonus.present) {
      map['bonus'] = Variable<String>(bonus.value);
    }
    if (bonusType.present) {
      map['bonus_type'] = Variable<String>(bonusType.value);
    }
    if (contendersJson.present) {
      map['contenders_json'] = Variable<String>(contendersJson.value);
    }
    if (randomJson.present) {
      map['random_json'] = Variable<String>(randomJson.value);
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
          ..write('bonus: $bonus, ')
          ..write('bonusType: $bonusType, ')
          ..write('contendersJson: $contendersJson, ')
          ..write('randomJson: $randomJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiUsesTable extends AiUses with TableInfo<$AiUsesTable, AiUse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiUsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chargedFreeMeta = const VerificationMeta(
    'chargedFree',
  );
  @override
  late final GeneratedColumn<bool> chargedFree = GeneratedColumn<bool>(
    'charged_free',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("charged_free" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [operationId, chargedFree];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_uses';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiUse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('charged_free')) {
      context.handle(
        _chargedFreeMeta,
        chargedFree.isAcceptableOrUnknown(
          data['charged_free']!,
          _chargedFreeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  AiUse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiUse(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      chargedFree: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}charged_free'],
      )!,
    );
  }

  @override
  $AiUsesTable createAlias(String alias) {
    return $AiUsesTable(attachedDatabase, alias);
  }
}

class AiUse extends DataClass implements Insertable<AiUse> {
  final String operationId;
  final bool chargedFree;
  const AiUse({required this.operationId, required this.chargedFree});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['charged_free'] = Variable<bool>(chargedFree);
    return map;
  }

  AiUsesCompanion toCompanion(bool nullToAbsent) {
    return AiUsesCompanion(
      operationId: Value(operationId),
      chargedFree: Value(chargedFree),
    );
  }

  factory AiUse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiUse(
      operationId: serializer.fromJson<String>(json['operationId']),
      chargedFree: serializer.fromJson<bool>(json['chargedFree']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'chargedFree': serializer.toJson<bool>(chargedFree),
    };
  }

  AiUse copyWith({String? operationId, bool? chargedFree}) => AiUse(
    operationId: operationId ?? this.operationId,
    chargedFree: chargedFree ?? this.chargedFree,
  );
  AiUse copyWithCompanion(AiUsesCompanion data) {
    return AiUse(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      chargedFree: data.chargedFree.present
          ? data.chargedFree.value
          : this.chargedFree,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiUse(')
          ..write('operationId: $operationId, ')
          ..write('chargedFree: $chargedFree')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(operationId, chargedFree);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiUse &&
          other.operationId == this.operationId &&
          other.chargedFree == this.chargedFree);
}

class AiUsesCompanion extends UpdateCompanion<AiUse> {
  final Value<String> operationId;
  final Value<bool> chargedFree;
  final Value<int> rowid;
  const AiUsesCompanion({
    this.operationId = const Value.absent(),
    this.chargedFree = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiUsesCompanion.insert({
    required String operationId,
    this.chargedFree = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId);
  static Insertable<AiUse> custom({
    Expression<String>? operationId,
    Expression<bool>? chargedFree,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (chargedFree != null) 'charged_free': chargedFree,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiUsesCompanion copyWith({
    Value<String>? operationId,
    Value<bool>? chargedFree,
    Value<int>? rowid,
  }) {
    return AiUsesCompanion(
      operationId: operationId ?? this.operationId,
      chargedFree: chargedFree ?? this.chargedFree,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (chargedFree.present) {
      map['charged_free'] = Variable<bool>(chargedFree.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiUsesCompanion(')
          ..write('operationId: $operationId, ')
          ..write('chargedFree: $chargedFree, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CaseShelfEntriesTable extends CaseShelfEntries
    with TableInfo<$CaseShelfEntriesTable, CaseShelfEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaseShelfEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    optionsJson,
    objective,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'case_shelf_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaseShelfEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('objective')) {
      context.handle(
        _objectiveMeta,
        objective.isAcceptableOrUnknown(data['objective']!, _objectiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaseShelfEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseShelfEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      )!,
      objective: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CaseShelfEntriesTable createAlias(String alias) {
    return $CaseShelfEntriesTable(attachedDatabase, alias);
  }
}

class CaseShelfEntry extends DataClass implements Insertable<CaseShelfEntry> {
  final String id;
  final String? name;
  final String optionsJson;
  final String? objective;
  final DateTime updatedAt;
  const CaseShelfEntry({
    required this.id,
    this.name,
    required this.optionsJson,
    this.objective,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['options_json'] = Variable<String>(optionsJson);
    if (!nullToAbsent || objective != null) {
      map['objective'] = Variable<String>(objective);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CaseShelfEntriesCompanion toCompanion(bool nullToAbsent) {
    return CaseShelfEntriesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      optionsJson: Value(optionsJson),
      objective: objective == null && nullToAbsent
          ? const Value.absent()
          : Value(objective),
      updatedAt: Value(updatedAt),
    );
  }

  factory CaseShelfEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseShelfEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      objective: serializer.fromJson<String?>(json['objective']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'objective': serializer.toJson<String?>(objective),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CaseShelfEntry copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    String? optionsJson,
    Value<String?> objective = const Value.absent(),
    DateTime? updatedAt,
  }) => CaseShelfEntry(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    optionsJson: optionsJson ?? this.optionsJson,
    objective: objective.present ? objective.value : this.objective,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CaseShelfEntry copyWithCompanion(CaseShelfEntriesCompanion data) {
    return CaseShelfEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      objective: data.objective.present ? data.objective.value : this.objective,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseShelfEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('objective: $objective, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, optionsJson, objective, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseShelfEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.optionsJson == this.optionsJson &&
          other.objective == this.objective &&
          other.updatedAt == this.updatedAt);
}

class CaseShelfEntriesCompanion extends UpdateCompanion<CaseShelfEntry> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String> optionsJson;
  final Value<String?> objective;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CaseShelfEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.objective = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaseShelfEntriesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required String optionsJson,
    this.objective = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       optionsJson = Value(optionsJson),
       updatedAt = Value(updatedAt);
  static Insertable<CaseShelfEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? optionsJson,
    Expression<String>? objective,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (optionsJson != null) 'options_json': optionsJson,
      if (objective != null) 'objective': objective,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaseShelfEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String>? optionsJson,
    Value<String?>? objective,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CaseShelfEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      optionsJson: optionsJson ?? this.optionsJson,
      objective: objective ?? this.objective,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (objective.present) {
      map['objective'] = Variable<String>(objective.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaseShelfEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('objective: $objective, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealFeedbackTable extends MealFeedback
    with TableInfo<$MealFeedbackTable, MealFeedbackEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealFeedbackTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _verdictIdMeta = const VerificationMeta(
    'verdictId',
  );
  @override
  late final GeneratedColumn<String> verdictId = GeneratedColumn<String>(
    'verdict_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES verdicts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ateMeta = const VerificationMeta('ate');
  @override
  late final GeneratedColumn<bool> ate = GeneratedColumn<bool>(
    'ate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ate" IN (0, 1))',
    ),
  );
  static const VerificationMeta _wouldAgainMeta = const VerificationMeta(
    'wouldAgain',
  );
  @override
  late final GeneratedColumn<bool> wouldAgain = GeneratedColumn<bool>(
    'would_again',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("would_again" IN (0, 1))',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [verdictId, ate, wouldAgain, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_feedback';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealFeedbackEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('verdict_id')) {
      context.handle(
        _verdictIdMeta,
        verdictId.isAcceptableOrUnknown(data['verdict_id']!, _verdictIdMeta),
      );
    } else if (isInserting) {
      context.missing(_verdictIdMeta);
    }
    if (data.containsKey('ate')) {
      context.handle(
        _ateMeta,
        ate.isAcceptableOrUnknown(data['ate']!, _ateMeta),
      );
    } else if (isInserting) {
      context.missing(_ateMeta);
    }
    if (data.containsKey('would_again')) {
      context.handle(
        _wouldAgainMeta,
        wouldAgain.isAcceptableOrUnknown(data['would_again']!, _wouldAgainMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {verdictId};
  @override
  MealFeedbackEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealFeedbackEntry(
      verdictId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verdict_id'],
      )!,
      ate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ate'],
      )!,
      wouldAgain: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}would_again'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MealFeedbackTable createAlias(String alias) {
    return $MealFeedbackTable(attachedDatabase, alias);
  }
}

class MealFeedbackEntry extends DataClass
    implements Insertable<MealFeedbackEntry> {
  /// Feedback belongs to one saved verdict; database APIs also clean up on delete.
  final String verdictId;

  /// Whether the user actually ate the winning dish.
  final bool ate;

  /// An optional preference, meaningful only after the meal was tried.
  final bool? wouldAgain;

  /// Last time the user changed their answer.
  final DateTime updatedAt;
  const MealFeedbackEntry({
    required this.verdictId,
    required this.ate,
    this.wouldAgain,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['verdict_id'] = Variable<String>(verdictId);
    map['ate'] = Variable<bool>(ate);
    if (!nullToAbsent || wouldAgain != null) {
      map['would_again'] = Variable<bool>(wouldAgain);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MealFeedbackCompanion toCompanion(bool nullToAbsent) {
    return MealFeedbackCompanion(
      verdictId: Value(verdictId),
      ate: Value(ate),
      wouldAgain: wouldAgain == null && nullToAbsent
          ? const Value.absent()
          : Value(wouldAgain),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealFeedbackEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealFeedbackEntry(
      verdictId: serializer.fromJson<String>(json['verdictId']),
      ate: serializer.fromJson<bool>(json['ate']),
      wouldAgain: serializer.fromJson<bool?>(json['wouldAgain']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'verdictId': serializer.toJson<String>(verdictId),
      'ate': serializer.toJson<bool>(ate),
      'wouldAgain': serializer.toJson<bool?>(wouldAgain),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MealFeedbackEntry copyWith({
    String? verdictId,
    bool? ate,
    Value<bool?> wouldAgain = const Value.absent(),
    DateTime? updatedAt,
  }) => MealFeedbackEntry(
    verdictId: verdictId ?? this.verdictId,
    ate: ate ?? this.ate,
    wouldAgain: wouldAgain.present ? wouldAgain.value : this.wouldAgain,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MealFeedbackEntry copyWithCompanion(MealFeedbackCompanion data) {
    return MealFeedbackEntry(
      verdictId: data.verdictId.present ? data.verdictId.value : this.verdictId,
      ate: data.ate.present ? data.ate.value : this.ate,
      wouldAgain: data.wouldAgain.present
          ? data.wouldAgain.value
          : this.wouldAgain,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealFeedbackEntry(')
          ..write('verdictId: $verdictId, ')
          ..write('ate: $ate, ')
          ..write('wouldAgain: $wouldAgain, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(verdictId, ate, wouldAgain, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealFeedbackEntry &&
          other.verdictId == this.verdictId &&
          other.ate == this.ate &&
          other.wouldAgain == this.wouldAgain &&
          other.updatedAt == this.updatedAt);
}

class MealFeedbackCompanion extends UpdateCompanion<MealFeedbackEntry> {
  final Value<String> verdictId;
  final Value<bool> ate;
  final Value<bool?> wouldAgain;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MealFeedbackCompanion({
    this.verdictId = const Value.absent(),
    this.ate = const Value.absent(),
    this.wouldAgain = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealFeedbackCompanion.insert({
    required String verdictId,
    required bool ate,
    this.wouldAgain = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : verdictId = Value(verdictId),
       ate = Value(ate),
       updatedAt = Value(updatedAt);
  static Insertable<MealFeedbackEntry> custom({
    Expression<String>? verdictId,
    Expression<bool>? ate,
    Expression<bool>? wouldAgain,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (verdictId != null) 'verdict_id': verdictId,
      if (ate != null) 'ate': ate,
      if (wouldAgain != null) 'would_again': wouldAgain,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealFeedbackCompanion copyWith({
    Value<String>? verdictId,
    Value<bool>? ate,
    Value<bool?>? wouldAgain,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealFeedbackCompanion(
      verdictId: verdictId ?? this.verdictId,
      ate: ate ?? this.ate,
      wouldAgain: wouldAgain ?? this.wouldAgain,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (verdictId.present) {
      map['verdict_id'] = Variable<String>(verdictId.value);
    }
    if (ate.present) {
      map['ate'] = Variable<bool>(ate.value);
    }
    if (wouldAgain.present) {
      map['would_again'] = Variable<bool>(wouldAgain.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealFeedbackCompanion(')
          ..write('verdictId: $verdictId, ')
          ..write('ate: $ate, ')
          ..write('wouldAgain: $wouldAgain, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VerdictsTable verdicts = $VerdictsTable(this);
  late final $AiUsesTable aiUses = $AiUsesTable(this);
  late final $CaseShelfEntriesTable caseShelfEntries = $CaseShelfEntriesTable(
    this,
  );
  late final $MealFeedbackTable mealFeedback = $MealFeedbackTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    verdicts,
    aiUses,
    caseShelfEntries,
    mealFeedback,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'verdicts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_feedback', kind: UpdateKind.delete)],
    ),
  ]);
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
      Value<String?> bonus,
      Value<String?> bonusType,
      Value<String> contendersJson,
      Value<String?> randomJson,
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
      Value<String?> bonus,
      Value<String?> bonusType,
      Value<String> contendersJson,
      Value<String?> randomJson,
      Value<int> rowid,
    });

final class $$VerdictsTableReferences
    extends BaseReferences<_$AppDatabase, $VerdictsTable, VerdictRow> {
  $$VerdictsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealFeedbackTable, List<MealFeedbackEntry>>
  _mealFeedbackRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealFeedback,
    aliasName: $_aliasNameGenerator(db.verdicts.id, db.mealFeedback.verdictId),
  );

  $$MealFeedbackTableProcessedTableManager get mealFeedbackRefs {
    final manager = $$MealFeedbackTableTableManager(
      $_db,
      $_db.mealFeedback,
    ).filter((f) => f.verdictId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealFeedbackRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bonusType => $composableBuilder(
    column: $table.bonusType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contendersJson => $composableBuilder(
    column: $table.contendersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get randomJson => $composableBuilder(
    column: $table.randomJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealFeedbackRefs(
    Expression<bool> Function($$MealFeedbackTableFilterComposer f) f,
  ) {
    final $$MealFeedbackTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealFeedback,
      getReferencedColumn: (t) => t.verdictId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealFeedbackTableFilterComposer(
            $db: $db,
            $table: $db.mealFeedback,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bonusType => $composableBuilder(
    column: $table.bonusType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contendersJson => $composableBuilder(
    column: $table.contendersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get randomJson => $composableBuilder(
    column: $table.randomJson,
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

  GeneratedColumn<String> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  GeneratedColumn<String> get bonusType =>
      $composableBuilder(column: $table.bonusType, builder: (column) => column);

  GeneratedColumn<String> get contendersJson => $composableBuilder(
    column: $table.contendersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get randomJson => $composableBuilder(
    column: $table.randomJson,
    builder: (column) => column,
  );

  Expression<T> mealFeedbackRefs<T extends Object>(
    Expression<T> Function($$MealFeedbackTableAnnotationComposer a) f,
  ) {
    final $$MealFeedbackTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealFeedback,
      getReferencedColumn: (t) => t.verdictId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealFeedbackTableAnnotationComposer(
            $db: $db,
            $table: $db.mealFeedback,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (VerdictRow, $$VerdictsTableReferences),
          VerdictRow,
          PrefetchHooks Function({bool mealFeedbackRefs})
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
                Value<String?> bonus = const Value.absent(),
                Value<String?> bonusType = const Value.absent(),
                Value<String> contendersJson = const Value.absent(),
                Value<String?> randomJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VerdictsCompanion(
                id: id,
                winnerJson: winnerJson,
                rankingsJson: rankingsJson,
                reasoning: reasoning,
                objective: objective,
                judgeTone: judgeTone,
                createdAt: createdAt,
                bonus: bonus,
                bonusType: bonusType,
                contendersJson: contendersJson,
                randomJson: randomJson,
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
                Value<String?> bonus = const Value.absent(),
                Value<String?> bonusType = const Value.absent(),
                Value<String> contendersJson = const Value.absent(),
                Value<String?> randomJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VerdictsCompanion.insert(
                id: id,
                winnerJson: winnerJson,
                rankingsJson: rankingsJson,
                reasoning: reasoning,
                objective: objective,
                judgeTone: judgeTone,
                createdAt: createdAt,
                bonus: bonus,
                bonusType: bonusType,
                contendersJson: contendersJson,
                randomJson: randomJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VerdictsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealFeedbackRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealFeedbackRefs) db.mealFeedback],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealFeedbackRefs)
                    await $_getPrefetchedData<
                      VerdictRow,
                      $VerdictsTable,
                      MealFeedbackEntry
                    >(
                      currentTable: table,
                      referencedTable: $$VerdictsTableReferences
                          ._mealFeedbackRefsTable(db),
                      managerFromTypedResult: (p0) => $$VerdictsTableReferences(
                        db,
                        table,
                        p0,
                      ).mealFeedbackRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.verdictId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (VerdictRow, $$VerdictsTableReferences),
      VerdictRow,
      PrefetchHooks Function({bool mealFeedbackRefs})
    >;
typedef $$AiUsesTableCreateCompanionBuilder =
    AiUsesCompanion Function({
      required String operationId,
      Value<bool> chargedFree,
      Value<int> rowid,
    });
typedef $$AiUsesTableUpdateCompanionBuilder =
    AiUsesCompanion Function({
      Value<String> operationId,
      Value<bool> chargedFree,
      Value<int> rowid,
    });

class $$AiUsesTableFilterComposer
    extends Composer<_$AppDatabase, $AiUsesTable> {
  $$AiUsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get chargedFree => $composableBuilder(
    column: $table.chargedFree,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiUsesTableOrderingComposer
    extends Composer<_$AppDatabase, $AiUsesTable> {
  $$AiUsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get chargedFree => $composableBuilder(
    column: $table.chargedFree,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiUsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiUsesTable> {
  $$AiUsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get chargedFree => $composableBuilder(
    column: $table.chargedFree,
    builder: (column) => column,
  );
}

class $$AiUsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiUsesTable,
          AiUse,
          $$AiUsesTableFilterComposer,
          $$AiUsesTableOrderingComposer,
          $$AiUsesTableAnnotationComposer,
          $$AiUsesTableCreateCompanionBuilder,
          $$AiUsesTableUpdateCompanionBuilder,
          (AiUse, BaseReferences<_$AppDatabase, $AiUsesTable, AiUse>),
          AiUse,
          PrefetchHooks Function()
        > {
  $$AiUsesTableTableManager(_$AppDatabase db, $AiUsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiUsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiUsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiUsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<bool> chargedFree = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiUsesCompanion(
                operationId: operationId,
                chargedFree: chargedFree,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                Value<bool> chargedFree = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiUsesCompanion.insert(
                operationId: operationId,
                chargedFree: chargedFree,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiUsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiUsesTable,
      AiUse,
      $$AiUsesTableFilterComposer,
      $$AiUsesTableOrderingComposer,
      $$AiUsesTableAnnotationComposer,
      $$AiUsesTableCreateCompanionBuilder,
      $$AiUsesTableUpdateCompanionBuilder,
      (AiUse, BaseReferences<_$AppDatabase, $AiUsesTable, AiUse>),
      AiUse,
      PrefetchHooks Function()
    >;
typedef $$CaseShelfEntriesTableCreateCompanionBuilder =
    CaseShelfEntriesCompanion Function({
      required String id,
      Value<String?> name,
      required String optionsJson,
      Value<String?> objective,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CaseShelfEntriesTableUpdateCompanionBuilder =
    CaseShelfEntriesCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String> optionsJson,
      Value<String?> objective,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CaseShelfEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CaseShelfEntriesTable> {
  $$CaseShelfEntriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objective => $composableBuilder(
    column: $table.objective,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaseShelfEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CaseShelfEntriesTable> {
  $$CaseShelfEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objective => $composableBuilder(
    column: $table.objective,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaseShelfEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaseShelfEntriesTable> {
  $$CaseShelfEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objective =>
      $composableBuilder(column: $table.objective, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CaseShelfEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaseShelfEntriesTable,
          CaseShelfEntry,
          $$CaseShelfEntriesTableFilterComposer,
          $$CaseShelfEntriesTableOrderingComposer,
          $$CaseShelfEntriesTableAnnotationComposer,
          $$CaseShelfEntriesTableCreateCompanionBuilder,
          $$CaseShelfEntriesTableUpdateCompanionBuilder,
          (
            CaseShelfEntry,
            BaseReferences<
              _$AppDatabase,
              $CaseShelfEntriesTable,
              CaseShelfEntry
            >,
          ),
          CaseShelfEntry,
          PrefetchHooks Function()
        > {
  $$CaseShelfEntriesTableTableManager(
    _$AppDatabase db,
    $CaseShelfEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaseShelfEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaseShelfEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaseShelfEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> optionsJson = const Value.absent(),
                Value<String?> objective = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaseShelfEntriesCompanion(
                id: id,
                name: name,
                optionsJson: optionsJson,
                objective: objective,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                required String optionsJson,
                Value<String?> objective = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CaseShelfEntriesCompanion.insert(
                id: id,
                name: name,
                optionsJson: optionsJson,
                objective: objective,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaseShelfEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaseShelfEntriesTable,
      CaseShelfEntry,
      $$CaseShelfEntriesTableFilterComposer,
      $$CaseShelfEntriesTableOrderingComposer,
      $$CaseShelfEntriesTableAnnotationComposer,
      $$CaseShelfEntriesTableCreateCompanionBuilder,
      $$CaseShelfEntriesTableUpdateCompanionBuilder,
      (
        CaseShelfEntry,
        BaseReferences<_$AppDatabase, $CaseShelfEntriesTable, CaseShelfEntry>,
      ),
      CaseShelfEntry,
      PrefetchHooks Function()
    >;
typedef $$MealFeedbackTableCreateCompanionBuilder =
    MealFeedbackCompanion Function({
      required String verdictId,
      required bool ate,
      Value<bool?> wouldAgain,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MealFeedbackTableUpdateCompanionBuilder =
    MealFeedbackCompanion Function({
      Value<String> verdictId,
      Value<bool> ate,
      Value<bool?> wouldAgain,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MealFeedbackTableReferences
    extends
        BaseReferences<_$AppDatabase, $MealFeedbackTable, MealFeedbackEntry> {
  $$MealFeedbackTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VerdictsTable _verdictIdTable(_$AppDatabase db) =>
      db.verdicts.createAlias(
        $_aliasNameGenerator(db.mealFeedback.verdictId, db.verdicts.id),
      );

  $$VerdictsTableProcessedTableManager get verdictId {
    final $_column = $_itemColumn<String>('verdict_id')!;

    final manager = $$VerdictsTableTableManager(
      $_db,
      $_db.verdicts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_verdictIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealFeedbackTableFilterComposer
    extends Composer<_$AppDatabase, $MealFeedbackTable> {
  $$MealFeedbackTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get ate => $composableBuilder(
    column: $table.ate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wouldAgain => $composableBuilder(
    column: $table.wouldAgain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VerdictsTableFilterComposer get verdictId {
    final $$VerdictsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verdictId,
      referencedTable: $db.verdicts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerdictsTableFilterComposer(
            $db: $db,
            $table: $db.verdicts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealFeedbackTableOrderingComposer
    extends Composer<_$AppDatabase, $MealFeedbackTable> {
  $$MealFeedbackTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get ate => $composableBuilder(
    column: $table.ate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wouldAgain => $composableBuilder(
    column: $table.wouldAgain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VerdictsTableOrderingComposer get verdictId {
    final $$VerdictsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verdictId,
      referencedTable: $db.verdicts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerdictsTableOrderingComposer(
            $db: $db,
            $table: $db.verdicts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealFeedbackTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealFeedbackTable> {
  $$MealFeedbackTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get ate =>
      $composableBuilder(column: $table.ate, builder: (column) => column);

  GeneratedColumn<bool> get wouldAgain => $composableBuilder(
    column: $table.wouldAgain,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$VerdictsTableAnnotationComposer get verdictId {
    final $$VerdictsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verdictId,
      referencedTable: $db.verdicts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerdictsTableAnnotationComposer(
            $db: $db,
            $table: $db.verdicts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealFeedbackTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealFeedbackTable,
          MealFeedbackEntry,
          $$MealFeedbackTableFilterComposer,
          $$MealFeedbackTableOrderingComposer,
          $$MealFeedbackTableAnnotationComposer,
          $$MealFeedbackTableCreateCompanionBuilder,
          $$MealFeedbackTableUpdateCompanionBuilder,
          (MealFeedbackEntry, $$MealFeedbackTableReferences),
          MealFeedbackEntry,
          PrefetchHooks Function({bool verdictId})
        > {
  $$MealFeedbackTableTableManager(_$AppDatabase db, $MealFeedbackTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealFeedbackTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealFeedbackTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealFeedbackTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> verdictId = const Value.absent(),
                Value<bool> ate = const Value.absent(),
                Value<bool?> wouldAgain = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealFeedbackCompanion(
                verdictId: verdictId,
                ate: ate,
                wouldAgain: wouldAgain,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String verdictId,
                required bool ate,
                Value<bool?> wouldAgain = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealFeedbackCompanion.insert(
                verdictId: verdictId,
                ate: ate,
                wouldAgain: wouldAgain,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealFeedbackTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({verdictId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (verdictId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.verdictId,
                                referencedTable: $$MealFeedbackTableReferences
                                    ._verdictIdTable(db),
                                referencedColumn: $$MealFeedbackTableReferences
                                    ._verdictIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealFeedbackTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealFeedbackTable,
      MealFeedbackEntry,
      $$MealFeedbackTableFilterComposer,
      $$MealFeedbackTableOrderingComposer,
      $$MealFeedbackTableAnnotationComposer,
      $$MealFeedbackTableCreateCompanionBuilder,
      $$MealFeedbackTableUpdateCompanionBuilder,
      (MealFeedbackEntry, $$MealFeedbackTableReferences),
      MealFeedbackEntry,
      PrefetchHooks Function({bool verdictId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VerdictsTableTableManager get verdicts =>
      $$VerdictsTableTableManager(_db, _db.verdicts);
  $$AiUsesTableTableManager get aiUses =>
      $$AiUsesTableTableManager(_db, _db.aiUses);
  $$CaseShelfEntriesTableTableManager get caseShelfEntries =>
      $$CaseShelfEntriesTableTableManager(_db, _db.caseShelfEntries);
  $$MealFeedbackTableTableManager get mealFeedback =>
      $$MealFeedbackTableTableManager(_db, _db.mealFeedback);
}
