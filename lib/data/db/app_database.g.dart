// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TripsTable extends Trips with TableInfo<$TripsTable, TripRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionLimitMeta = const VerificationMeta(
    'questionLimit',
  );
  @override
  late final GeneratedColumn<int> questionLimit = GeneratedColumn<int>(
    'question_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discussionSecondsMeta = const VerificationMeta(
    'discussionSeconds',
  );
  @override
  late final GeneratedColumn<int> discussionSeconds = GeneratedColumn<int>(
    'discussion_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alertsOnMeta = const VerificationMeta(
    'alertsOn',
  );
  @override
  late final GeneratedColumn<bool> alertsOn = GeneratedColumn<bool>(
    'alerts_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alerts_on" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastCarModeMeta = const VerificationMeta(
    'lastCarMode',
  );
  @override
  late final GeneratedColumn<bool> lastCarMode = GeneratedColumn<bool>(
    'last_car_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("last_car_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    endedAt,
    questionLimit,
    discussionSeconds,
    alertsOn,
    lastCarMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('question_limit')) {
      context.handle(
        _questionLimitMeta,
        questionLimit.isAcceptableOrUnknown(
          data['question_limit']!,
          _questionLimitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionLimitMeta);
    }
    if (data.containsKey('discussion_seconds')) {
      context.handle(
        _discussionSecondsMeta,
        discussionSeconds.isAcceptableOrUnknown(
          data['discussion_seconds']!,
          _discussionSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discussionSecondsMeta);
    }
    if (data.containsKey('alerts_on')) {
      context.handle(
        _alertsOnMeta,
        alertsOn.isAcceptableOrUnknown(data['alerts_on']!, _alertsOnMeta),
      );
    } else if (isInserting) {
      context.missing(_alertsOnMeta);
    }
    if (data.containsKey('last_car_mode')) {
      context.handle(
        _lastCarModeMeta,
        lastCarMode.isAcceptableOrUnknown(
          data['last_car_mode']!,
          _lastCarModeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      questionLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_limit'],
      )!,
      discussionSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discussion_seconds'],
      )!,
      alertsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alerts_on'],
      )!,
      lastCarMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}last_car_mode'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class TripRow extends DataClass implements Insertable<TripRow> {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime? endedAt;
  final int questionLimit;
  final int discussionSeconds;
  final bool alertsOn;
  final bool lastCarMode;
  const TripRow({
    required this.id,
    required this.name,
    required this.createdAt,
    this.endedAt,
    required this.questionLimit,
    required this.discussionSeconds,
    required this.alertsOn,
    required this.lastCarMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['question_limit'] = Variable<int>(questionLimit);
    map['discussion_seconds'] = Variable<int>(discussionSeconds);
    map['alerts_on'] = Variable<bool>(alertsOn);
    map['last_car_mode'] = Variable<bool>(lastCarMode);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      questionLimit: Value(questionLimit),
      discussionSeconds: Value(discussionSeconds),
      alertsOn: Value(alertsOn),
      lastCarMode: Value(lastCarMode),
    );
  }

  factory TripRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      questionLimit: serializer.fromJson<int>(json['questionLimit']),
      discussionSeconds: serializer.fromJson<int>(json['discussionSeconds']),
      alertsOn: serializer.fromJson<bool>(json['alertsOn']),
      lastCarMode: serializer.fromJson<bool>(json['lastCarMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'questionLimit': serializer.toJson<int>(questionLimit),
      'discussionSeconds': serializer.toJson<int>(discussionSeconds),
      'alertsOn': serializer.toJson<bool>(alertsOn),
      'lastCarMode': serializer.toJson<bool>(lastCarMode),
    };
  }

  TripRow copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? questionLimit,
    int? discussionSeconds,
    bool? alertsOn,
    bool? lastCarMode,
  }) => TripRow(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    questionLimit: questionLimit ?? this.questionLimit,
    discussionSeconds: discussionSeconds ?? this.discussionSeconds,
    alertsOn: alertsOn ?? this.alertsOn,
    lastCarMode: lastCarMode ?? this.lastCarMode,
  );
  TripRow copyWithCompanion(TripsCompanion data) {
    return TripRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      questionLimit: data.questionLimit.present
          ? data.questionLimit.value
          : this.questionLimit,
      discussionSeconds: data.discussionSeconds.present
          ? data.discussionSeconds.value
          : this.discussionSeconds,
      alertsOn: data.alertsOn.present ? data.alertsOn.value : this.alertsOn,
      lastCarMode: data.lastCarMode.present
          ? data.lastCarMode.value
          : this.lastCarMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('questionLimit: $questionLimit, ')
          ..write('discussionSeconds: $discussionSeconds, ')
          ..write('alertsOn: $alertsOn, ')
          ..write('lastCarMode: $lastCarMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    endedAt,
    questionLimit,
    discussionSeconds,
    alertsOn,
    lastCarMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.endedAt == this.endedAt &&
          other.questionLimit == this.questionLimit &&
          other.discussionSeconds == this.discussionSeconds &&
          other.alertsOn == this.alertsOn &&
          other.lastCarMode == this.lastCarMode);
}

class TripsCompanion extends UpdateCompanion<TripRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime?> endedAt;
  final Value<int> questionLimit;
  final Value<int> discussionSeconds;
  final Value<bool> alertsOn;
  final Value<bool> lastCarMode;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.questionLimit = const Value.absent(),
    this.discussionSeconds = const Value.absent(),
    this.alertsOn = const Value.absent(),
    this.lastCarMode = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    this.endedAt = const Value.absent(),
    required int questionLimit,
    required int discussionSeconds,
    required bool alertsOn,
    this.lastCarMode = const Value.absent(),
  }) : name = Value(name),
       createdAt = Value(createdAt),
       questionLimit = Value(questionLimit),
       discussionSeconds = Value(discussionSeconds),
       alertsOn = Value(alertsOn);
  static Insertable<TripRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? endedAt,
    Expression<int>? questionLimit,
    Expression<int>? discussionSeconds,
    Expression<bool>? alertsOn,
    Expression<bool>? lastCarMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (questionLimit != null) 'question_limit': questionLimit,
      if (discussionSeconds != null) 'discussion_seconds': discussionSeconds,
      if (alertsOn != null) 'alerts_on': alertsOn,
      if (lastCarMode != null) 'last_car_mode': lastCarMode,
    });
  }

  TripsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime?>? endedAt,
    Value<int>? questionLimit,
    Value<int>? discussionSeconds,
    Value<bool>? alertsOn,
    Value<bool>? lastCarMode,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      questionLimit: questionLimit ?? this.questionLimit,
      discussionSeconds: discussionSeconds ?? this.discussionSeconds,
      alertsOn: alertsOn ?? this.alertsOn,
      lastCarMode: lastCarMode ?? this.lastCarMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (questionLimit.present) {
      map['question_limit'] = Variable<int>(questionLimit.value);
    }
    if (discussionSeconds.present) {
      map['discussion_seconds'] = Variable<int>(discussionSeconds.value);
    }
    if (alertsOn.present) {
      map['alerts_on'] = Variable<bool>(alertsOn.value);
    }
    if (lastCarMode.present) {
      map['last_car_mode'] = Variable<bool>(lastCarMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('questionLimit: $questionLimit, ')
          ..write('discussionSeconds: $discussionSeconds, ')
          ..write('alertsOn: $alertsOn, ')
          ..write('lastCarMode: $lastCarMode')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, PlayerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seatOrderMeta = const VerificationMeta(
    'seatOrder',
  );
  @override
  late final GeneratedColumn<int> seatOrder = GeneratedColumn<int>(
    'seat_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canDriveMeta = const VerificationMeta(
    'canDrive',
  );
  @override
  late final GeneratedColumn<bool> canDrive = GeneratedColumn<bool>(
    'can_drive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_drive" IN (0, 1))',
    ),
  );
  static const VerificationMeta _removedAtMeta = const VerificationMeta(
    'removedAt',
  );
  @override
  late final GeneratedColumn<DateTime> removedAt = GeneratedColumn<DateTime>(
    'removed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    name,
    seatOrder,
    canDrive,
    removedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('seat_order')) {
      context.handle(
        _seatOrderMeta,
        seatOrder.isAcceptableOrUnknown(data['seat_order']!, _seatOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_seatOrderMeta);
    }
    if (data.containsKey('can_drive')) {
      context.handle(
        _canDriveMeta,
        canDrive.isAcceptableOrUnknown(data['can_drive']!, _canDriveMeta),
      );
    } else if (isInserting) {
      context.missing(_canDriveMeta);
    }
    if (data.containsKey('removed_at')) {
      context.handle(
        _removedAtMeta,
        removedAt.isAcceptableOrUnknown(data['removed_at']!, _removedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      seatOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seat_order'],
      )!,
      canDrive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}can_drive'],
      )!,
      removedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}removed_at'],
      ),
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class PlayerRow extends DataClass implements Insertable<PlayerRow> {
  final int id;
  final int tripId;
  final String name;
  final int seatOrder;
  final bool canDrive;
  final DateTime? removedAt;
  const PlayerRow({
    required this.id,
    required this.tripId,
    required this.name,
    required this.seatOrder,
    required this.canDrive,
    this.removedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['name'] = Variable<String>(name);
    map['seat_order'] = Variable<int>(seatOrder);
    map['can_drive'] = Variable<bool>(canDrive);
    if (!nullToAbsent || removedAt != null) {
      map['removed_at'] = Variable<DateTime>(removedAt);
    }
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      tripId: Value(tripId),
      name: Value(name),
      seatOrder: Value(seatOrder),
      canDrive: Value(canDrive),
      removedAt: removedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(removedAt),
    );
  }

  factory PlayerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerRow(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      name: serializer.fromJson<String>(json['name']),
      seatOrder: serializer.fromJson<int>(json['seatOrder']),
      canDrive: serializer.fromJson<bool>(json['canDrive']),
      removedAt: serializer.fromJson<DateTime?>(json['removedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'name': serializer.toJson<String>(name),
      'seatOrder': serializer.toJson<int>(seatOrder),
      'canDrive': serializer.toJson<bool>(canDrive),
      'removedAt': serializer.toJson<DateTime?>(removedAt),
    };
  }

  PlayerRow copyWith({
    int? id,
    int? tripId,
    String? name,
    int? seatOrder,
    bool? canDrive,
    Value<DateTime?> removedAt = const Value.absent(),
  }) => PlayerRow(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    name: name ?? this.name,
    seatOrder: seatOrder ?? this.seatOrder,
    canDrive: canDrive ?? this.canDrive,
    removedAt: removedAt.present ? removedAt.value : this.removedAt,
  );
  PlayerRow copyWithCompanion(PlayersCompanion data) {
    return PlayerRow(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      name: data.name.present ? data.name.value : this.name,
      seatOrder: data.seatOrder.present ? data.seatOrder.value : this.seatOrder,
      canDrive: data.canDrive.present ? data.canDrive.value : this.canDrive,
      removedAt: data.removedAt.present ? data.removedAt.value : this.removedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerRow(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('name: $name, ')
          ..write('seatOrder: $seatOrder, ')
          ..write('canDrive: $canDrive, ')
          ..write('removedAt: $removedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tripId, name, seatOrder, canDrive, removedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerRow &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.name == this.name &&
          other.seatOrder == this.seatOrder &&
          other.canDrive == this.canDrive &&
          other.removedAt == this.removedAt);
}

class PlayersCompanion extends UpdateCompanion<PlayerRow> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<String> name;
  final Value<int> seatOrder;
  final Value<bool> canDrive;
  final Value<DateTime?> removedAt;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.name = const Value.absent(),
    this.seatOrder = const Value.absent(),
    this.canDrive = const Value.absent(),
    this.removedAt = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required String name,
    required int seatOrder,
    required bool canDrive,
    this.removedAt = const Value.absent(),
  }) : tripId = Value(tripId),
       name = Value(name),
       seatOrder = Value(seatOrder),
       canDrive = Value(canDrive);
  static Insertable<PlayerRow> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<String>? name,
    Expression<int>? seatOrder,
    Expression<bool>? canDrive,
    Expression<DateTime>? removedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (name != null) 'name': name,
      if (seatOrder != null) 'seat_order': seatOrder,
      if (canDrive != null) 'can_drive': canDrive,
      if (removedAt != null) 'removed_at': removedAt,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<int>? tripId,
    Value<String>? name,
    Value<int>? seatOrder,
    Value<bool>? canDrive,
    Value<DateTime?>? removedAt,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      seatOrder: seatOrder ?? this.seatOrder,
      canDrive: canDrive ?? this.canDrive,
      removedAt: removedAt ?? this.removedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (seatOrder.present) {
      map['seat_order'] = Variable<int>(seatOrder.value);
    }
    if (canDrive.present) {
      map['can_drive'] = Variable<bool>(canDrive.value);
    }
    if (removedAt.present) {
      map['removed_at'] = Variable<DateTime>(removedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('name: $name, ')
          ..write('seatOrder: $seatOrder, ')
          ..write('canDrive: $canDrive, ')
          ..write('removedAt: $removedAt')
          ..write(')'))
        .toString();
  }
}

class $RoundsTable extends Rounds with TableInfo<$RoundsTable, RoundRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carModeMeta = const VerificationMeta(
    'carMode',
  );
  @override
  late final GeneratedColumn<bool> carMode = GeneratedColumn<bool>(
    'car_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("car_mode" IN (0, 1))',
    ),
  );
  static const VerificationMeta _driverIdMeta = const VerificationMeta(
    'driverId',
  );
  @override
  late final GeneratedColumn<int> driverId = GeneratedColumn<int>(
    'driver_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _masterIdMeta = const VerificationMeta(
    'masterId',
  );
  @override
  late final GeneratedColumn<int> masterId = GeneratedColumn<int>(
    'master_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _insiderIdMeta = const VerificationMeta(
    'insiderId',
  );
  @override
  late final GeneratedColumn<int> insiderId = GeneratedColumn<int>(
    'insider_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionIdMeta = const VerificationMeta(
    'captionId',
  );
  @override
  late final GeneratedColumn<String> captionId = GeneratedColumn<String>(
    'caption_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _handoutIndexMeta = const VerificationMeta(
    'handoutIndex',
  );
  @override
  late final GeneratedColumn<int> handoutIndex = GeneratedColumn<int>(
    'handout_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _voteIndexMeta = const VerificationMeta(
    'voteIndex',
  );
  @override
  late final GeneratedColumn<int> voteIndex = GeneratedColumn<int>(
    'vote_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _questionsUsedMeta = const VerificationMeta(
    'questionsUsed',
  );
  @override
  late final GeneratedColumn<int> questionsUsed = GeneratedColumn<int>(
    'questions_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guessedByIdMeta = const VerificationMeta(
    'guessedById',
  );
  @override
  late final GeneratedColumn<int> guessedById = GeneratedColumn<int>(
    'guessed_by_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discussionEndsAtMeta = const VerificationMeta(
    'discussionEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> discussionEndsAt =
      GeneratedColumn<DateTime>(
        'discussion_ends_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    number,
    startedAt,
    endedAt,
    carMode,
    driverId,
    masterId,
    insiderId,
    wordId,
    captionId,
    phase,
    handoutIndex,
    voteIndex,
    questionsUsed,
    outcome,
    guessedById,
    discussionEndsAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoundRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('car_mode')) {
      context.handle(
        _carModeMeta,
        carMode.isAcceptableOrUnknown(data['car_mode']!, _carModeMeta),
      );
    } else if (isInserting) {
      context.missing(_carModeMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(
        _driverIdMeta,
        driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta),
      );
    }
    if (data.containsKey('master_id')) {
      context.handle(
        _masterIdMeta,
        masterId.isAcceptableOrUnknown(data['master_id']!, _masterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_masterIdMeta);
    }
    if (data.containsKey('insider_id')) {
      context.handle(
        _insiderIdMeta,
        insiderId.isAcceptableOrUnknown(data['insider_id']!, _insiderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_insiderIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('caption_id')) {
      context.handle(
        _captionIdMeta,
        captionId.isAcceptableOrUnknown(data['caption_id']!, _captionIdMeta),
      );
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('handout_index')) {
      context.handle(
        _handoutIndexMeta,
        handoutIndex.isAcceptableOrUnknown(
          data['handout_index']!,
          _handoutIndexMeta,
        ),
      );
    }
    if (data.containsKey('vote_index')) {
      context.handle(
        _voteIndexMeta,
        voteIndex.isAcceptableOrUnknown(data['vote_index']!, _voteIndexMeta),
      );
    }
    if (data.containsKey('questions_used')) {
      context.handle(
        _questionsUsedMeta,
        questionsUsed.isAcceptableOrUnknown(
          data['questions_used']!,
          _questionsUsedMeta,
        ),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('guessed_by_id')) {
      context.handle(
        _guessedByIdMeta,
        guessedById.isAcceptableOrUnknown(
          data['guessed_by_id']!,
          _guessedByIdMeta,
        ),
      );
    }
    if (data.containsKey('discussion_ends_at')) {
      context.handle(
        _discussionEndsAtMeta,
        discussionEndsAt.isAcceptableOrUnknown(
          data['discussion_ends_at']!,
          _discussionEndsAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoundRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoundRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      carMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}car_mode'],
      )!,
      driverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}driver_id'],
      ),
      masterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}master_id'],
      )!,
      insiderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}insider_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      captionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption_id'],
      ),
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      handoutIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}handout_index'],
      )!,
      voteIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vote_index'],
      )!,
      questionsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}questions_used'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
      guessedById: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guessed_by_id'],
      ),
      discussionEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}discussion_ends_at'],
      ),
    );
  }

  @override
  $RoundsTable createAlias(String alias) {
    return $RoundsTable(attachedDatabase, alias);
  }
}

class RoundRow extends DataClass implements Insertable<RoundRow> {
  final int id;
  final int tripId;
  final int number;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool carMode;

  /// Null when Car mode is off.
  final int? driverId;
  final int masterId;
  final int insiderId;
  final String wordId;
  final String? captionId;

  /// A `RoundPhase` name.
  final String phase;
  final int handoutIndex;
  final int voteIndex;
  final int questionsUsed;

  /// `caught` / `not_caught` / `not_found` / `abandoned`; null until the round ends.
  final String? outcome;
  final int? guessedById;

  /// When the discussion countdown reaches zero, so it survives an app kill.
  final DateTime? discussionEndsAt;
  const RoundRow({
    required this.id,
    required this.tripId,
    required this.number,
    required this.startedAt,
    this.endedAt,
    required this.carMode,
    this.driverId,
    required this.masterId,
    required this.insiderId,
    required this.wordId,
    this.captionId,
    required this.phase,
    required this.handoutIndex,
    required this.voteIndex,
    required this.questionsUsed,
    this.outcome,
    this.guessedById,
    this.discussionEndsAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['number'] = Variable<int>(number);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['car_mode'] = Variable<bool>(carMode);
    if (!nullToAbsent || driverId != null) {
      map['driver_id'] = Variable<int>(driverId);
    }
    map['master_id'] = Variable<int>(masterId);
    map['insider_id'] = Variable<int>(insiderId);
    map['word_id'] = Variable<String>(wordId);
    if (!nullToAbsent || captionId != null) {
      map['caption_id'] = Variable<String>(captionId);
    }
    map['phase'] = Variable<String>(phase);
    map['handout_index'] = Variable<int>(handoutIndex);
    map['vote_index'] = Variable<int>(voteIndex);
    map['questions_used'] = Variable<int>(questionsUsed);
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    if (!nullToAbsent || guessedById != null) {
      map['guessed_by_id'] = Variable<int>(guessedById);
    }
    if (!nullToAbsent || discussionEndsAt != null) {
      map['discussion_ends_at'] = Variable<DateTime>(discussionEndsAt);
    }
    return map;
  }

  RoundsCompanion toCompanion(bool nullToAbsent) {
    return RoundsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      number: Value(number),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      carMode: Value(carMode),
      driverId: driverId == null && nullToAbsent
          ? const Value.absent()
          : Value(driverId),
      masterId: Value(masterId),
      insiderId: Value(insiderId),
      wordId: Value(wordId),
      captionId: captionId == null && nullToAbsent
          ? const Value.absent()
          : Value(captionId),
      phase: Value(phase),
      handoutIndex: Value(handoutIndex),
      voteIndex: Value(voteIndex),
      questionsUsed: Value(questionsUsed),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
      guessedById: guessedById == null && nullToAbsent
          ? const Value.absent()
          : Value(guessedById),
      discussionEndsAt: discussionEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(discussionEndsAt),
    );
  }

  factory RoundRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoundRow(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      number: serializer.fromJson<int>(json['number']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      carMode: serializer.fromJson<bool>(json['carMode']),
      driverId: serializer.fromJson<int?>(json['driverId']),
      masterId: serializer.fromJson<int>(json['masterId']),
      insiderId: serializer.fromJson<int>(json['insiderId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      captionId: serializer.fromJson<String?>(json['captionId']),
      phase: serializer.fromJson<String>(json['phase']),
      handoutIndex: serializer.fromJson<int>(json['handoutIndex']),
      voteIndex: serializer.fromJson<int>(json['voteIndex']),
      questionsUsed: serializer.fromJson<int>(json['questionsUsed']),
      outcome: serializer.fromJson<String?>(json['outcome']),
      guessedById: serializer.fromJson<int?>(json['guessedById']),
      discussionEndsAt: serializer.fromJson<DateTime?>(
        json['discussionEndsAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'number': serializer.toJson<int>(number),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'carMode': serializer.toJson<bool>(carMode),
      'driverId': serializer.toJson<int?>(driverId),
      'masterId': serializer.toJson<int>(masterId),
      'insiderId': serializer.toJson<int>(insiderId),
      'wordId': serializer.toJson<String>(wordId),
      'captionId': serializer.toJson<String?>(captionId),
      'phase': serializer.toJson<String>(phase),
      'handoutIndex': serializer.toJson<int>(handoutIndex),
      'voteIndex': serializer.toJson<int>(voteIndex),
      'questionsUsed': serializer.toJson<int>(questionsUsed),
      'outcome': serializer.toJson<String?>(outcome),
      'guessedById': serializer.toJson<int?>(guessedById),
      'discussionEndsAt': serializer.toJson<DateTime?>(discussionEndsAt),
    };
  }

  RoundRow copyWith({
    int? id,
    int? tripId,
    int? number,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    bool? carMode,
    Value<int?> driverId = const Value.absent(),
    int? masterId,
    int? insiderId,
    String? wordId,
    Value<String?> captionId = const Value.absent(),
    String? phase,
    int? handoutIndex,
    int? voteIndex,
    int? questionsUsed,
    Value<String?> outcome = const Value.absent(),
    Value<int?> guessedById = const Value.absent(),
    Value<DateTime?> discussionEndsAt = const Value.absent(),
  }) => RoundRow(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    number: number ?? this.number,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    carMode: carMode ?? this.carMode,
    driverId: driverId.present ? driverId.value : this.driverId,
    masterId: masterId ?? this.masterId,
    insiderId: insiderId ?? this.insiderId,
    wordId: wordId ?? this.wordId,
    captionId: captionId.present ? captionId.value : this.captionId,
    phase: phase ?? this.phase,
    handoutIndex: handoutIndex ?? this.handoutIndex,
    voteIndex: voteIndex ?? this.voteIndex,
    questionsUsed: questionsUsed ?? this.questionsUsed,
    outcome: outcome.present ? outcome.value : this.outcome,
    guessedById: guessedById.present ? guessedById.value : this.guessedById,
    discussionEndsAt: discussionEndsAt.present
        ? discussionEndsAt.value
        : this.discussionEndsAt,
  );
  RoundRow copyWithCompanion(RoundsCompanion data) {
    return RoundRow(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      number: data.number.present ? data.number.value : this.number,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      carMode: data.carMode.present ? data.carMode.value : this.carMode,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      masterId: data.masterId.present ? data.masterId.value : this.masterId,
      insiderId: data.insiderId.present ? data.insiderId.value : this.insiderId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      captionId: data.captionId.present ? data.captionId.value : this.captionId,
      phase: data.phase.present ? data.phase.value : this.phase,
      handoutIndex: data.handoutIndex.present
          ? data.handoutIndex.value
          : this.handoutIndex,
      voteIndex: data.voteIndex.present ? data.voteIndex.value : this.voteIndex,
      questionsUsed: data.questionsUsed.present
          ? data.questionsUsed.value
          : this.questionsUsed,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      guessedById: data.guessedById.present
          ? data.guessedById.value
          : this.guessedById,
      discussionEndsAt: data.discussionEndsAt.present
          ? data.discussionEndsAt.value
          : this.discussionEndsAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoundRow(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('number: $number, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('carMode: $carMode, ')
          ..write('driverId: $driverId, ')
          ..write('masterId: $masterId, ')
          ..write('insiderId: $insiderId, ')
          ..write('wordId: $wordId, ')
          ..write('captionId: $captionId, ')
          ..write('phase: $phase, ')
          ..write('handoutIndex: $handoutIndex, ')
          ..write('voteIndex: $voteIndex, ')
          ..write('questionsUsed: $questionsUsed, ')
          ..write('outcome: $outcome, ')
          ..write('guessedById: $guessedById, ')
          ..write('discussionEndsAt: $discussionEndsAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    number,
    startedAt,
    endedAt,
    carMode,
    driverId,
    masterId,
    insiderId,
    wordId,
    captionId,
    phase,
    handoutIndex,
    voteIndex,
    questionsUsed,
    outcome,
    guessedById,
    discussionEndsAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoundRow &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.number == this.number &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.carMode == this.carMode &&
          other.driverId == this.driverId &&
          other.masterId == this.masterId &&
          other.insiderId == this.insiderId &&
          other.wordId == this.wordId &&
          other.captionId == this.captionId &&
          other.phase == this.phase &&
          other.handoutIndex == this.handoutIndex &&
          other.voteIndex == this.voteIndex &&
          other.questionsUsed == this.questionsUsed &&
          other.outcome == this.outcome &&
          other.guessedById == this.guessedById &&
          other.discussionEndsAt == this.discussionEndsAt);
}

class RoundsCompanion extends UpdateCompanion<RoundRow> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<int> number;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<bool> carMode;
  final Value<int?> driverId;
  final Value<int> masterId;
  final Value<int> insiderId;
  final Value<String> wordId;
  final Value<String?> captionId;
  final Value<String> phase;
  final Value<int> handoutIndex;
  final Value<int> voteIndex;
  final Value<int> questionsUsed;
  final Value<String?> outcome;
  final Value<int?> guessedById;
  final Value<DateTime?> discussionEndsAt;
  const RoundsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.number = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.carMode = const Value.absent(),
    this.driverId = const Value.absent(),
    this.masterId = const Value.absent(),
    this.insiderId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.captionId = const Value.absent(),
    this.phase = const Value.absent(),
    this.handoutIndex = const Value.absent(),
    this.voteIndex = const Value.absent(),
    this.questionsUsed = const Value.absent(),
    this.outcome = const Value.absent(),
    this.guessedById = const Value.absent(),
    this.discussionEndsAt = const Value.absent(),
  });
  RoundsCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required int number,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required bool carMode,
    this.driverId = const Value.absent(),
    required int masterId,
    required int insiderId,
    required String wordId,
    this.captionId = const Value.absent(),
    required String phase,
    this.handoutIndex = const Value.absent(),
    this.voteIndex = const Value.absent(),
    this.questionsUsed = const Value.absent(),
    this.outcome = const Value.absent(),
    this.guessedById = const Value.absent(),
    this.discussionEndsAt = const Value.absent(),
  }) : tripId = Value(tripId),
       number = Value(number),
       startedAt = Value(startedAt),
       carMode = Value(carMode),
       masterId = Value(masterId),
       insiderId = Value(insiderId),
       wordId = Value(wordId),
       phase = Value(phase);
  static Insertable<RoundRow> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<int>? number,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<bool>? carMode,
    Expression<int>? driverId,
    Expression<int>? masterId,
    Expression<int>? insiderId,
    Expression<String>? wordId,
    Expression<String>? captionId,
    Expression<String>? phase,
    Expression<int>? handoutIndex,
    Expression<int>? voteIndex,
    Expression<int>? questionsUsed,
    Expression<String>? outcome,
    Expression<int>? guessedById,
    Expression<DateTime>? discussionEndsAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (number != null) 'number': number,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (carMode != null) 'car_mode': carMode,
      if (driverId != null) 'driver_id': driverId,
      if (masterId != null) 'master_id': masterId,
      if (insiderId != null) 'insider_id': insiderId,
      if (wordId != null) 'word_id': wordId,
      if (captionId != null) 'caption_id': captionId,
      if (phase != null) 'phase': phase,
      if (handoutIndex != null) 'handout_index': handoutIndex,
      if (voteIndex != null) 'vote_index': voteIndex,
      if (questionsUsed != null) 'questions_used': questionsUsed,
      if (outcome != null) 'outcome': outcome,
      if (guessedById != null) 'guessed_by_id': guessedById,
      if (discussionEndsAt != null) 'discussion_ends_at': discussionEndsAt,
    });
  }

  RoundsCompanion copyWith({
    Value<int>? id,
    Value<int>? tripId,
    Value<int>? number,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<bool>? carMode,
    Value<int?>? driverId,
    Value<int>? masterId,
    Value<int>? insiderId,
    Value<String>? wordId,
    Value<String?>? captionId,
    Value<String>? phase,
    Value<int>? handoutIndex,
    Value<int>? voteIndex,
    Value<int>? questionsUsed,
    Value<String?>? outcome,
    Value<int?>? guessedById,
    Value<DateTime?>? discussionEndsAt,
  }) {
    return RoundsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      number: number ?? this.number,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      carMode: carMode ?? this.carMode,
      driverId: driverId ?? this.driverId,
      masterId: masterId ?? this.masterId,
      insiderId: insiderId ?? this.insiderId,
      wordId: wordId ?? this.wordId,
      captionId: captionId ?? this.captionId,
      phase: phase ?? this.phase,
      handoutIndex: handoutIndex ?? this.handoutIndex,
      voteIndex: voteIndex ?? this.voteIndex,
      questionsUsed: questionsUsed ?? this.questionsUsed,
      outcome: outcome ?? this.outcome,
      guessedById: guessedById ?? this.guessedById,
      discussionEndsAt: discussionEndsAt ?? this.discussionEndsAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (carMode.present) {
      map['car_mode'] = Variable<bool>(carMode.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<int>(driverId.value);
    }
    if (masterId.present) {
      map['master_id'] = Variable<int>(masterId.value);
    }
    if (insiderId.present) {
      map['insider_id'] = Variable<int>(insiderId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (captionId.present) {
      map['caption_id'] = Variable<String>(captionId.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (handoutIndex.present) {
      map['handout_index'] = Variable<int>(handoutIndex.value);
    }
    if (voteIndex.present) {
      map['vote_index'] = Variable<int>(voteIndex.value);
    }
    if (questionsUsed.present) {
      map['questions_used'] = Variable<int>(questionsUsed.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (guessedById.present) {
      map['guessed_by_id'] = Variable<int>(guessedById.value);
    }
    if (discussionEndsAt.present) {
      map['discussion_ends_at'] = Variable<DateTime>(discussionEndsAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('number: $number, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('carMode: $carMode, ')
          ..write('driverId: $driverId, ')
          ..write('masterId: $masterId, ')
          ..write('insiderId: $insiderId, ')
          ..write('wordId: $wordId, ')
          ..write('captionId: $captionId, ')
          ..write('phase: $phase, ')
          ..write('handoutIndex: $handoutIndex, ')
          ..write('voteIndex: $voteIndex, ')
          ..write('questionsUsed: $questionsUsed, ')
          ..write('outcome: $outcome, ')
          ..write('guessedById: $guessedById, ')
          ..write('discussionEndsAt: $discussionEndsAt')
          ..write(')'))
        .toString();
  }
}

class $VotesTable extends Votes with TableInfo<$VotesTable, VoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roundIdMeta = const VerificationMeta(
    'roundId',
  );
  @override
  late final GeneratedColumn<int> roundId = GeneratedColumn<int>(
    'round_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rounds (id)',
    ),
  );
  static const VerificationMeta _voterIdMeta = const VerificationMeta(
    'voterId',
  );
  @override
  late final GeneratedColumn<int> voterId = GeneratedColumn<int>(
    'voter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<int> targetId = GeneratedColumn<int>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, roundId, voterId, targetId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'votes';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('round_id')) {
      context.handle(
        _roundIdMeta,
        roundId.isAcceptableOrUnknown(data['round_id']!, _roundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roundIdMeta);
    }
    if (data.containsKey('voter_id')) {
      context.handle(
        _voterIdMeta,
        voterId.isAcceptableOrUnknown(data['voter_id']!, _voterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_voterIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {roundId, voterId},
  ];
  @override
  VoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_id'],
      )!,
      voterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voter_id'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_id'],
      )!,
    );
  }

  @override
  $VotesTable createAlias(String alias) {
    return $VotesTable(attachedDatabase, alias);
  }
}

class VoteRow extends DataClass implements Insertable<VoteRow> {
  final int id;
  final int roundId;
  final int voterId;
  final int targetId;
  const VoteRow({
    required this.id,
    required this.roundId,
    required this.voterId,
    required this.targetId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['round_id'] = Variable<int>(roundId);
    map['voter_id'] = Variable<int>(voterId);
    map['target_id'] = Variable<int>(targetId);
    return map;
  }

  VotesCompanion toCompanion(bool nullToAbsent) {
    return VotesCompanion(
      id: Value(id),
      roundId: Value(roundId),
      voterId: Value(voterId),
      targetId: Value(targetId),
    );
  }

  factory VoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoteRow(
      id: serializer.fromJson<int>(json['id']),
      roundId: serializer.fromJson<int>(json['roundId']),
      voterId: serializer.fromJson<int>(json['voterId']),
      targetId: serializer.fromJson<int>(json['targetId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roundId': serializer.toJson<int>(roundId),
      'voterId': serializer.toJson<int>(voterId),
      'targetId': serializer.toJson<int>(targetId),
    };
  }

  VoteRow copyWith({int? id, int? roundId, int? voterId, int? targetId}) =>
      VoteRow(
        id: id ?? this.id,
        roundId: roundId ?? this.roundId,
        voterId: voterId ?? this.voterId,
        targetId: targetId ?? this.targetId,
      );
  VoteRow copyWithCompanion(VotesCompanion data) {
    return VoteRow(
      id: data.id.present ? data.id.value : this.id,
      roundId: data.roundId.present ? data.roundId.value : this.roundId,
      voterId: data.voterId.present ? data.voterId.value : this.voterId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoteRow(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('voterId: $voterId, ')
          ..write('targetId: $targetId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, roundId, voterId, targetId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoteRow &&
          other.id == this.id &&
          other.roundId == this.roundId &&
          other.voterId == this.voterId &&
          other.targetId == this.targetId);
}

class VotesCompanion extends UpdateCompanion<VoteRow> {
  final Value<int> id;
  final Value<int> roundId;
  final Value<int> voterId;
  final Value<int> targetId;
  const VotesCompanion({
    this.id = const Value.absent(),
    this.roundId = const Value.absent(),
    this.voterId = const Value.absent(),
    this.targetId = const Value.absent(),
  });
  VotesCompanion.insert({
    this.id = const Value.absent(),
    required int roundId,
    required int voterId,
    required int targetId,
  }) : roundId = Value(roundId),
       voterId = Value(voterId),
       targetId = Value(targetId);
  static Insertable<VoteRow> custom({
    Expression<int>? id,
    Expression<int>? roundId,
    Expression<int>? voterId,
    Expression<int>? targetId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roundId != null) 'round_id': roundId,
      if (voterId != null) 'voter_id': voterId,
      if (targetId != null) 'target_id': targetId,
    });
  }

  VotesCompanion copyWith({
    Value<int>? id,
    Value<int>? roundId,
    Value<int>? voterId,
    Value<int>? targetId,
  }) {
    return VotesCompanion(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      voterId: voterId ?? this.voterId,
      targetId: targetId ?? this.targetId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roundId.present) {
      map['round_id'] = Variable<int>(roundId.value);
    }
    if (voterId.present) {
      map['voter_id'] = Variable<int>(voterId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<int>(targetId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VotesCompanion(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('voterId: $voterId, ')
          ..write('targetId: $targetId')
          ..write(')'))
        .toString();
  }
}

class $RoundScoresTable extends RoundScores
    with TableInfo<$RoundScoresTable, RoundScoreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _roundIdMeta = const VerificationMeta(
    'roundId',
  );
  @override
  late final GeneratedColumn<int> roundId = GeneratedColumn<int>(
    'round_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rounds (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [roundId, playerId, points];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'round_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoundScoreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('round_id')) {
      context.handle(
        _roundIdMeta,
        roundId.isAcceptableOrUnknown(data['round_id']!, _roundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roundIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {roundId, playerId};
  @override
  RoundScoreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoundScoreRow(
      roundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
    );
  }

  @override
  $RoundScoresTable createAlias(String alias) {
    return $RoundScoresTable(attachedDatabase, alias);
  }
}

class RoundScoreRow extends DataClass implements Insertable<RoundScoreRow> {
  final int roundId;
  final int playerId;
  final int points;
  const RoundScoreRow({
    required this.roundId,
    required this.playerId,
    required this.points,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['round_id'] = Variable<int>(roundId);
    map['player_id'] = Variable<int>(playerId);
    map['points'] = Variable<int>(points);
    return map;
  }

  RoundScoresCompanion toCompanion(bool nullToAbsent) {
    return RoundScoresCompanion(
      roundId: Value(roundId),
      playerId: Value(playerId),
      points: Value(points),
    );
  }

  factory RoundScoreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoundScoreRow(
      roundId: serializer.fromJson<int>(json['roundId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      points: serializer.fromJson<int>(json['points']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'roundId': serializer.toJson<int>(roundId),
      'playerId': serializer.toJson<int>(playerId),
      'points': serializer.toJson<int>(points),
    };
  }

  RoundScoreRow copyWith({int? roundId, int? playerId, int? points}) =>
      RoundScoreRow(
        roundId: roundId ?? this.roundId,
        playerId: playerId ?? this.playerId,
        points: points ?? this.points,
      );
  RoundScoreRow copyWithCompanion(RoundScoresCompanion data) {
    return RoundScoreRow(
      roundId: data.roundId.present ? data.roundId.value : this.roundId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      points: data.points.present ? data.points.value : this.points,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoundScoreRow(')
          ..write('roundId: $roundId, ')
          ..write('playerId: $playerId, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(roundId, playerId, points);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoundScoreRow &&
          other.roundId == this.roundId &&
          other.playerId == this.playerId &&
          other.points == this.points);
}

class RoundScoresCompanion extends UpdateCompanion<RoundScoreRow> {
  final Value<int> roundId;
  final Value<int> playerId;
  final Value<int> points;
  final Value<int> rowid;
  const RoundScoresCompanion({
    this.roundId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.points = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoundScoresCompanion.insert({
    required int roundId,
    required int playerId,
    this.points = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : roundId = Value(roundId),
       playerId = Value(playerId);
  static Insertable<RoundScoreRow> custom({
    Expression<int>? roundId,
    Expression<int>? playerId,
    Expression<int>? points,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (roundId != null) 'round_id': roundId,
      if (playerId != null) 'player_id': playerId,
      if (points != null) 'points': points,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoundScoresCompanion copyWith({
    Value<int>? roundId,
    Value<int>? playerId,
    Value<int>? points,
    Value<int>? rowid,
  }) {
    return RoundScoresCompanion(
      roundId: roundId ?? this.roundId,
      playerId: playerId ?? this.playerId,
      points: points ?? this.points,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (roundId.present) {
      map['round_id'] = Variable<int>(roundId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundScoresCompanion(')
          ..write('roundId: $roundId, ')
          ..write('playerId: $playerId, ')
          ..write('points: $points, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsedWordsTable extends UsedWords
    with TableInfo<$UsedWordsTable, UsedWordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsedWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tripId, wordId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'used_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsedWordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tripId, wordId};
  @override
  UsedWordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsedWordRow(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
    );
  }

  @override
  $UsedWordsTable createAlias(String alias) {
    return $UsedWordsTable(attachedDatabase, alias);
  }
}

class UsedWordRow extends DataClass implements Insertable<UsedWordRow> {
  final int tripId;
  final String wordId;
  const UsedWordRow({required this.tripId, required this.wordId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['word_id'] = Variable<String>(wordId);
    return map;
  }

  UsedWordsCompanion toCompanion(bool nullToAbsent) {
    return UsedWordsCompanion(tripId: Value(tripId), wordId: Value(wordId));
  }

  factory UsedWordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsedWordRow(
      tripId: serializer.fromJson<int>(json['tripId']),
      wordId: serializer.fromJson<String>(json['wordId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'wordId': serializer.toJson<String>(wordId),
    };
  }

  UsedWordRow copyWith({int? tripId, String? wordId}) =>
      UsedWordRow(tripId: tripId ?? this.tripId, wordId: wordId ?? this.wordId);
  UsedWordRow copyWithCompanion(UsedWordsCompanion data) {
    return UsedWordRow(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsedWordRow(')
          ..write('tripId: $tripId, ')
          ..write('wordId: $wordId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tripId, wordId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsedWordRow &&
          other.tripId == this.tripId &&
          other.wordId == this.wordId);
}

class UsedWordsCompanion extends UpdateCompanion<UsedWordRow> {
  final Value<int> tripId;
  final Value<String> wordId;
  final Value<int> rowid;
  const UsedWordsCompanion({
    this.tripId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsedWordsCompanion.insert({
    required int tripId,
    required String wordId,
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       wordId = Value(wordId);
  static Insertable<UsedWordRow> custom({
    Expression<int>? tripId,
    Expression<String>? wordId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (wordId != null) 'word_id': wordId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsedWordsCompanion copyWith({
    Value<int>? tripId,
    Value<String>? wordId,
    Value<int>? rowid,
  }) {
    return UsedWordsCompanion(
      tripId: tripId ?? this.tripId,
      wordId: wordId ?? this.wordId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsedWordsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('wordId: $wordId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsedCaptionsTable extends UsedCaptions
    with TableInfo<$UsedCaptionsTable, UsedCaptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsedCaptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _captionIdMeta = const VerificationMeta(
    'captionId',
  );
  @override
  late final GeneratedColumn<String> captionId = GeneratedColumn<String>(
    'caption_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tripId, captionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'used_captions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsedCaptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('caption_id')) {
      context.handle(
        _captionIdMeta,
        captionId.isAcceptableOrUnknown(data['caption_id']!, _captionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_captionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tripId, captionId};
  @override
  UsedCaptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsedCaptionRow(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_id'],
      )!,
      captionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption_id'],
      )!,
    );
  }

  @override
  $UsedCaptionsTable createAlias(String alias) {
    return $UsedCaptionsTable(attachedDatabase, alias);
  }
}

class UsedCaptionRow extends DataClass implements Insertable<UsedCaptionRow> {
  final int tripId;
  final String captionId;
  const UsedCaptionRow({required this.tripId, required this.captionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<int>(tripId);
    map['caption_id'] = Variable<String>(captionId);
    return map;
  }

  UsedCaptionsCompanion toCompanion(bool nullToAbsent) {
    return UsedCaptionsCompanion(
      tripId: Value(tripId),
      captionId: Value(captionId),
    );
  }

  factory UsedCaptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsedCaptionRow(
      tripId: serializer.fromJson<int>(json['tripId']),
      captionId: serializer.fromJson<String>(json['captionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<int>(tripId),
      'captionId': serializer.toJson<String>(captionId),
    };
  }

  UsedCaptionRow copyWith({int? tripId, String? captionId}) => UsedCaptionRow(
    tripId: tripId ?? this.tripId,
    captionId: captionId ?? this.captionId,
  );
  UsedCaptionRow copyWithCompanion(UsedCaptionsCompanion data) {
    return UsedCaptionRow(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      captionId: data.captionId.present ? data.captionId.value : this.captionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsedCaptionRow(')
          ..write('tripId: $tripId, ')
          ..write('captionId: $captionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tripId, captionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsedCaptionRow &&
          other.tripId == this.tripId &&
          other.captionId == this.captionId);
}

class UsedCaptionsCompanion extends UpdateCompanion<UsedCaptionRow> {
  final Value<int> tripId;
  final Value<String> captionId;
  final Value<int> rowid;
  const UsedCaptionsCompanion({
    this.tripId = const Value.absent(),
    this.captionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsedCaptionsCompanion.insert({
    required int tripId,
    required String captionId,
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       captionId = Value(captionId);
  static Insertable<UsedCaptionRow> custom({
    Expression<int>? tripId,
    Expression<String>? captionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (captionId != null) 'caption_id': captionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsedCaptionsCompanion copyWith({
    Value<int>? tripId,
    Value<String>? captionId,
    Value<int>? rowid,
  }) {
    return UsedCaptionsCompanion(
      tripId: tripId ?? this.tripId,
      captionId: captionId ?? this.captionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (captionId.present) {
      map['caption_id'] = Variable<String>(captionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsedCaptionsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('captionId: $captionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $RoundsTable rounds = $RoundsTable(this);
  late final $VotesTable votes = $VotesTable(this);
  late final $RoundScoresTable roundScores = $RoundScoresTable(this);
  late final $UsedWordsTable usedWords = $UsedWordsTable(this);
  late final $UsedCaptionsTable usedCaptions = $UsedCaptionsTable(this);
  late final TripDao tripDao = TripDao(this as AppDatabase);
  late final RoundDao roundDao = RoundDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trips,
    players,
    rounds,
    votes,
    roundScores,
    usedWords,
    usedCaptions,
  ];
}

typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
      Value<DateTime?> endedAt,
      required int questionLimit,
      required int discussionSeconds,
      required bool alertsOn,
      Value<bool> lastCarMode,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime?> endedAt,
      Value<int> questionLimit,
      Value<int> discussionSeconds,
      Value<bool> alertsOn,
      Value<bool> lastCarMode,
    });

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, TripRow> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayersTable, List<PlayerRow>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: 'trips__id__players__trip_id',
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoundsTable, List<RoundRow>> _roundsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rounds,
    aliasName: 'trips__id__rounds__trip_id',
  );

  $$RoundsTableProcessedTableManager get roundsRefs {
    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UsedWordsTable, List<UsedWordRow>>
  _usedWordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usedWords,
    aliasName: 'trips__id__used_words__trip_id',
  );

  $$UsedWordsTableProcessedTableManager get usedWordsRefs {
    final manager = $$UsedWordsTableTableManager(
      $_db,
      $_db.usedWords,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usedWordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UsedCaptionsTable, List<UsedCaptionRow>>
  _usedCaptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usedCaptions,
    aliasName: 'trips__id__used_captions__trip_id',
  );

  $$UsedCaptionsTableProcessedTableManager get usedCaptionsRefs {
    final manager = $$UsedCaptionsTableTableManager(
      $_db,
      $_db.usedCaptions,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usedCaptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionLimit => $composableBuilder(
    column: $table.questionLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discussionSeconds => $composableBuilder(
    column: $table.discussionSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alertsOn => $composableBuilder(
    column: $table.alertsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lastCarMode => $composableBuilder(
    column: $table.lastCarMode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roundsRefs(
    Expression<bool> Function($$RoundsTableFilterComposer f) f,
  ) {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> usedWordsRefs(
    Expression<bool> Function($$UsedWordsTableFilterComposer f) f,
  ) {
    final $$UsedWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usedWords,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsedWordsTableFilterComposer(
            $db: $db,
            $table: $db.usedWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> usedCaptionsRefs(
    Expression<bool> Function($$UsedCaptionsTableFilterComposer f) f,
  ) {
    final $$UsedCaptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usedCaptions,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsedCaptionsTableFilterComposer(
            $db: $db,
            $table: $db.usedCaptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionLimit => $composableBuilder(
    column: $table.questionLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discussionSeconds => $composableBuilder(
    column: $table.discussionSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alertsOn => $composableBuilder(
    column: $table.alertsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lastCarMode => $composableBuilder(
    column: $table.lastCarMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get questionLimit => $composableBuilder(
    column: $table.questionLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discussionSeconds => $composableBuilder(
    column: $table.discussionSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alertsOn =>
      $composableBuilder(column: $table.alertsOn, builder: (column) => column);

  GeneratedColumn<bool> get lastCarMode => $composableBuilder(
    column: $table.lastCarMode,
    builder: (column) => column,
  );

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roundsRefs<T extends Object>(
    Expression<T> Function($$RoundsTableAnnotationComposer a) f,
  ) {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> usedWordsRefs<T extends Object>(
    Expression<T> Function($$UsedWordsTableAnnotationComposer a) f,
  ) {
    final $$UsedWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usedWords,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsedWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.usedWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> usedCaptionsRefs<T extends Object>(
    Expression<T> Function($$UsedCaptionsTableAnnotationComposer a) f,
  ) {
    final $$UsedCaptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usedCaptions,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsedCaptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.usedCaptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          TripRow,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (TripRow, $$TripsTableReferences),
          TripRow,
          PrefetchHooks Function({
            bool playersRefs,
            bool roundsRefs,
            bool usedWordsRefs,
            bool usedCaptionsRefs,
          })
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> questionLimit = const Value.absent(),
                Value<int> discussionSeconds = const Value.absent(),
                Value<bool> alertsOn = const Value.absent(),
                Value<bool> lastCarMode = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                endedAt: endedAt,
                questionLimit: questionLimit,
                discussionSeconds: discussionSeconds,
                alertsOn: alertsOn,
                lastCarMode: lastCarMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required int questionLimit,
                required int discussionSeconds,
                required bool alertsOn,
                Value<bool> lastCarMode = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                endedAt: endedAt,
                questionLimit: questionLimit,
                discussionSeconds: discussionSeconds,
                alertsOn: alertsOn,
                lastCarMode: lastCarMode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripsTable, TripRow>(table),
                  $$TripsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                playersRefs = false,
                roundsRefs = false,
                usedWordsRefs = false,
                usedCaptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playersRefs) db.players,
                    if (roundsRefs) db.rounds,
                    if (usedWordsRefs) db.usedWords,
                    if (usedCaptionsRefs) db.usedCaptions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playersRefs)
                        await $_getPrefetchedDataByColumns<
                          TripRow,
                          $TripsTable,
                          PlayerRow,
                          $PlayersTable
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._playersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).playersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'trip_id',
                          typedResults: items,
                        ),
                      if (roundsRefs)
                        await $_getPrefetchedDataByColumns<
                          TripRow,
                          $TripsTable,
                          RoundRow,
                          $RoundsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._roundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).roundsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'trip_id',
                          typedResults: items,
                        ),
                      if (usedWordsRefs)
                        await $_getPrefetchedDataByColumns<
                          TripRow,
                          $TripsTable,
                          UsedWordRow,
                          $UsedWordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._usedWordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).usedWordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'trip_id',
                          typedResults: items,
                        ),
                      if (usedCaptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          TripRow,
                          $TripsTable,
                          UsedCaptionRow,
                          $UsedCaptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._usedCaptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).usedCaptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'trip_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      TripRow,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (TripRow, $$TripsTableReferences),
      TripRow,
      PrefetchHooks Function({
        bool playersRefs,
        bool roundsRefs,
        bool usedWordsRefs,
        bool usedCaptionsRefs,
      })
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required int tripId,
      required String name,
      required int seatOrder,
      required bool canDrive,
      Value<DateTime?> removedAt,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<int> tripId,
      Value<String> name,
      Value<int> seatOrder,
      Value<bool> canDrive,
      Value<DateTime?> removedAt,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, PlayerRow> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('players__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seatOrder => $composableBuilder(
    column: $table.seatOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canDrive => $composableBuilder(
    column: $table.canDrive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get removedAt => $composableBuilder(
    column: $table.removedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seatOrder => $composableBuilder(
    column: $table.seatOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canDrive => $composableBuilder(
    column: $table.canDrive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get removedAt => $composableBuilder(
    column: $table.removedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get seatOrder =>
      $composableBuilder(column: $table.seatOrder, builder: (column) => column);

  GeneratedColumn<bool> get canDrive =>
      $composableBuilder(column: $table.canDrive, builder: (column) => column);

  GeneratedColumn<DateTime> get removedAt =>
      $composableBuilder(column: $table.removedAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          PlayerRow,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (PlayerRow, $$PlayersTableReferences),
          PlayerRow,
          PrefetchHooks Function({bool tripId})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tripId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> seatOrder = const Value.absent(),
                Value<bool> canDrive = const Value.absent(),
                Value<DateTime?> removedAt = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                tripId: tripId,
                name: name,
                seatOrder: seatOrder,
                canDrive: canDrive,
                removedAt: removedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tripId,
                required String name,
                required int seatOrder,
                required bool canDrive,
                Value<DateTime?> removedAt = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                tripId: tripId,
                name: name,
                seatOrder: seatOrder,
                canDrive: canDrive,
                removedAt: removedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlayersTable, PlayerRow>(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$PlayersTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$PlayersTableReferences
                                    ._tripIdTable(db)
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

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      PlayerRow,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (PlayerRow, $$PlayersTableReferences),
      PlayerRow,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$RoundsTableCreateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      required int tripId,
      required int number,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required bool carMode,
      Value<int?> driverId,
      required int masterId,
      required int insiderId,
      required String wordId,
      Value<String?> captionId,
      required String phase,
      Value<int> handoutIndex,
      Value<int> voteIndex,
      Value<int> questionsUsed,
      Value<String?> outcome,
      Value<int?> guessedById,
      Value<DateTime?> discussionEndsAt,
    });
typedef $$RoundsTableUpdateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      Value<int> tripId,
      Value<int> number,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<bool> carMode,
      Value<int?> driverId,
      Value<int> masterId,
      Value<int> insiderId,
      Value<String> wordId,
      Value<String?> captionId,
      Value<String> phase,
      Value<int> handoutIndex,
      Value<int> voteIndex,
      Value<int> questionsUsed,
      Value<String?> outcome,
      Value<int?> guessedById,
      Value<DateTime?> discussionEndsAt,
    });

final class $$RoundsTableReferences
    extends BaseReferences<_$AppDatabase, $RoundsTable, RoundRow> {
  $$RoundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('rounds__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VotesTable, List<VoteRow>> _votesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.votes,
    aliasName: 'rounds__id__votes__round_id',
  );

  $$VotesTableProcessedTableManager get votesRefs {
    final manager = $$VotesTableTableManager(
      $_db,
      $_db.votes,
    ).filter((f) => f.roundId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_votesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoundScoresTable, List<RoundScoreRow>>
  _roundScoresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roundScores,
    aliasName: 'rounds__id__round_scores__round_id',
  );

  $$RoundScoresTableProcessedTableManager get roundScoresRefs {
    final manager = $$RoundScoresTableTableManager(
      $_db,
      $_db.roundScores,
    ).filter((f) => f.roundId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roundScoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoundsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carMode => $composableBuilder(
    column: $table.carMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masterId => $composableBuilder(
    column: $table.masterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get insiderId => $composableBuilder(
    column: $table.insiderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get captionId => $composableBuilder(
    column: $table.captionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get handoutIndex => $composableBuilder(
    column: $table.handoutIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voteIndex => $composableBuilder(
    column: $table.voteIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionsUsed => $composableBuilder(
    column: $table.questionsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guessedById => $composableBuilder(
    column: $table.guessedById,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get discussionEndsAt => $composableBuilder(
    column: $table.discussionEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> votesRefs(
    Expression<bool> Function($$VotesTableFilterComposer f) f,
  ) {
    final $$VotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.votes,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotesTableFilterComposer(
            $db: $db,
            $table: $db.votes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roundScoresRefs(
    Expression<bool> Function($$RoundScoresTableFilterComposer f) f,
  ) {
    final $$RoundScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roundScores,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundScoresTableFilterComposer(
            $db: $db,
            $table: $db.roundScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carMode => $composableBuilder(
    column: $table.carMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get driverId => $composableBuilder(
    column: $table.driverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masterId => $composableBuilder(
    column: $table.masterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get insiderId => $composableBuilder(
    column: $table.insiderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get captionId => $composableBuilder(
    column: $table.captionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get handoutIndex => $composableBuilder(
    column: $table.handoutIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voteIndex => $composableBuilder(
    column: $table.voteIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionsUsed => $composableBuilder(
    column: $table.questionsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guessedById => $composableBuilder(
    column: $table.guessedById,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get discussionEndsAt => $composableBuilder(
    column: $table.discussionEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<bool> get carMode =>
      $composableBuilder(column: $table.carMode, builder: (column) => column);

  GeneratedColumn<int> get driverId =>
      $composableBuilder(column: $table.driverId, builder: (column) => column);

  GeneratedColumn<int> get masterId =>
      $composableBuilder(column: $table.masterId, builder: (column) => column);

  GeneratedColumn<int> get insiderId =>
      $composableBuilder(column: $table.insiderId, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get captionId =>
      $composableBuilder(column: $table.captionId, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get handoutIndex => $composableBuilder(
    column: $table.handoutIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get voteIndex =>
      $composableBuilder(column: $table.voteIndex, builder: (column) => column);

  GeneratedColumn<int> get questionsUsed => $composableBuilder(
    column: $table.questionsUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<int> get guessedById => $composableBuilder(
    column: $table.guessedById,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get discussionEndsAt => $composableBuilder(
    column: $table.discussionEndsAt,
    builder: (column) => column,
  );

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> votesRefs<T extends Object>(
    Expression<T> Function($$VotesTableAnnotationComposer a) f,
  ) {
    final $$VotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.votes,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VotesTableAnnotationComposer(
            $db: $db,
            $table: $db.votes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roundScoresRefs<T extends Object>(
    Expression<T> Function($$RoundScoresTableAnnotationComposer a) f,
  ) {
    final $$RoundScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roundScores,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.roundScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundsTable,
          RoundRow,
          $$RoundsTableFilterComposer,
          $$RoundsTableOrderingComposer,
          $$RoundsTableAnnotationComposer,
          $$RoundsTableCreateCompanionBuilder,
          $$RoundsTableUpdateCompanionBuilder,
          (RoundRow, $$RoundsTableReferences),
          RoundRow,
          PrefetchHooks Function({
            bool tripId,
            bool votesRefs,
            bool roundScoresRefs,
          })
        > {
  $$RoundsTableTableManager(_$AppDatabase db, $RoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tripId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<bool> carMode = const Value.absent(),
                Value<int?> driverId = const Value.absent(),
                Value<int> masterId = const Value.absent(),
                Value<int> insiderId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String?> captionId = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<int> handoutIndex = const Value.absent(),
                Value<int> voteIndex = const Value.absent(),
                Value<int> questionsUsed = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<int?> guessedById = const Value.absent(),
                Value<DateTime?> discussionEndsAt = const Value.absent(),
              }) => RoundsCompanion(
                id: id,
                tripId: tripId,
                number: number,
                startedAt: startedAt,
                endedAt: endedAt,
                carMode: carMode,
                driverId: driverId,
                masterId: masterId,
                insiderId: insiderId,
                wordId: wordId,
                captionId: captionId,
                phase: phase,
                handoutIndex: handoutIndex,
                voteIndex: voteIndex,
                questionsUsed: questionsUsed,
                outcome: outcome,
                guessedById: guessedById,
                discussionEndsAt: discussionEndsAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tripId,
                required int number,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required bool carMode,
                Value<int?> driverId = const Value.absent(),
                required int masterId,
                required int insiderId,
                required String wordId,
                Value<String?> captionId = const Value.absent(),
                required String phase,
                Value<int> handoutIndex = const Value.absent(),
                Value<int> voteIndex = const Value.absent(),
                Value<int> questionsUsed = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<int?> guessedById = const Value.absent(),
                Value<DateTime?> discussionEndsAt = const Value.absent(),
              }) => RoundsCompanion.insert(
                id: id,
                tripId: tripId,
                number: number,
                startedAt: startedAt,
                endedAt: endedAt,
                carMode: carMode,
                driverId: driverId,
                masterId: masterId,
                insiderId: insiderId,
                wordId: wordId,
                captionId: captionId,
                phase: phase,
                handoutIndex: handoutIndex,
                voteIndex: voteIndex,
                questionsUsed: questionsUsed,
                outcome: outcome,
                guessedById: guessedById,
                discussionEndsAt: discussionEndsAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoundsTable, RoundRow>(table),
                  $$RoundsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tripId = false, votesRefs = false, roundScoresRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (votesRefs) db.votes,
                    if (roundScoresRefs) db.roundScores,
                  ],
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
                        if (tripId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tripId,
                                    referencedTable: $$RoundsTableReferences
                                        ._tripIdTable(db),
                                    referencedColumn: $$RoundsTableReferences
                                        ._tripIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (votesRefs)
                        await $_getPrefetchedDataByColumns<
                          RoundRow,
                          $RoundsTable,
                          VoteRow,
                          $VotesTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoundsTableReferences
                              ._votesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoundsTableReferences(db, table, p0).votesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'round_id',
                          typedResults: items,
                        ),
                      if (roundScoresRefs)
                        await $_getPrefetchedDataByColumns<
                          RoundRow,
                          $RoundsTable,
                          RoundScoreRow,
                          $RoundScoresTable
                        >(
                          currentTable: table,
                          referencedTable: $$RoundsTableReferences
                              ._roundScoresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoundsTableReferences(
                                db,
                                table,
                                p0,
                              ).roundScoresRefs,
                          currentColumn: 'id',
                          referencedColumn: 'round_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundsTable,
      RoundRow,
      $$RoundsTableFilterComposer,
      $$RoundsTableOrderingComposer,
      $$RoundsTableAnnotationComposer,
      $$RoundsTableCreateCompanionBuilder,
      $$RoundsTableUpdateCompanionBuilder,
      (RoundRow, $$RoundsTableReferences),
      RoundRow,
      PrefetchHooks Function({
        bool tripId,
        bool votesRefs,
        bool roundScoresRefs,
      })
    >;
typedef $$VotesTableCreateCompanionBuilder =
    VotesCompanion Function({
      Value<int> id,
      required int roundId,
      required int voterId,
      required int targetId,
    });
typedef $$VotesTableUpdateCompanionBuilder =
    VotesCompanion Function({
      Value<int> id,
      Value<int> roundId,
      Value<int> voterId,
      Value<int> targetId,
    });

final class $$VotesTableReferences
    extends BaseReferences<_$AppDatabase, $VotesTable, VoteRow> {
  $$VotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoundsTable _roundIdTable(_$AppDatabase db) =>
      db.rounds.createAlias('votes__round_id__rounds__id');

  $$RoundsTableProcessedTableManager get roundId {
    final $_column = $_itemColumn<int>('round_id')!;

    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VotesTableFilterComposer extends Composer<_$AppDatabase, $VotesTable> {
  $$VotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voterId => $composableBuilder(
    column: $table.voterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  $$RoundsTableFilterComposer get roundId {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VotesTableOrderingComposer
    extends Composer<_$AppDatabase, $VotesTable> {
  $$VotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voterId => $composableBuilder(
    column: $table.voterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoundsTableOrderingComposer get roundId {
    final $$RoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableOrderingComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VotesTable> {
  $$VotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get voterId =>
      $composableBuilder(column: $table.voterId, builder: (column) => column);

  GeneratedColumn<int> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  $$RoundsTableAnnotationComposer get roundId {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VotesTable,
          VoteRow,
          $$VotesTableFilterComposer,
          $$VotesTableOrderingComposer,
          $$VotesTableAnnotationComposer,
          $$VotesTableCreateCompanionBuilder,
          $$VotesTableUpdateCompanionBuilder,
          (VoteRow, $$VotesTableReferences),
          VoteRow,
          PrefetchHooks Function({bool roundId})
        > {
  $$VotesTableTableManager(_$AppDatabase db, $VotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roundId = const Value.absent(),
                Value<int> voterId = const Value.absent(),
                Value<int> targetId = const Value.absent(),
              }) => VotesCompanion(
                id: id,
                roundId: roundId,
                voterId: voterId,
                targetId: targetId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roundId,
                required int voterId,
                required int targetId,
              }) => VotesCompanion.insert(
                id: id,
                roundId: roundId,
                voterId: voterId,
                targetId: targetId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VotesTable, VoteRow>(table),
                  $$VotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roundId = false}) {
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
                    if (roundId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.roundId,
                                referencedTable: $$VotesTableReferences
                                    ._roundIdTable(db),
                                referencedColumn: $$VotesTableReferences
                                    ._roundIdTable(db)
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

typedef $$VotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VotesTable,
      VoteRow,
      $$VotesTableFilterComposer,
      $$VotesTableOrderingComposer,
      $$VotesTableAnnotationComposer,
      $$VotesTableCreateCompanionBuilder,
      $$VotesTableUpdateCompanionBuilder,
      (VoteRow, $$VotesTableReferences),
      VoteRow,
      PrefetchHooks Function({bool roundId})
    >;
typedef $$RoundScoresTableCreateCompanionBuilder =
    RoundScoresCompanion Function({
      required int roundId,
      required int playerId,
      Value<int> points,
      Value<int> rowid,
    });
typedef $$RoundScoresTableUpdateCompanionBuilder =
    RoundScoresCompanion Function({
      Value<int> roundId,
      Value<int> playerId,
      Value<int> points,
      Value<int> rowid,
    });

final class $$RoundScoresTableReferences
    extends BaseReferences<_$AppDatabase, $RoundScoresTable, RoundScoreRow> {
  $$RoundScoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoundsTable _roundIdTable(_$AppDatabase db) =>
      db.rounds.createAlias('round_scores__round_id__rounds__id');

  $$RoundsTableProcessedTableManager get roundId {
    final $_column = $_itemColumn<int>('round_id')!;

    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoundScoresTableFilterComposer
    extends Composer<_$AppDatabase, $RoundScoresTable> {
  $$RoundScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  $$RoundsTableFilterComposer get roundId {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundScoresTable> {
  $$RoundScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoundsTableOrderingComposer get roundId {
    final $$RoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableOrderingComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundScoresTable> {
  $$RoundScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  $$RoundsTableAnnotationComposer get roundId {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundScoresTable,
          RoundScoreRow,
          $$RoundScoresTableFilterComposer,
          $$RoundScoresTableOrderingComposer,
          $$RoundScoresTableAnnotationComposer,
          $$RoundScoresTableCreateCompanionBuilder,
          $$RoundScoresTableUpdateCompanionBuilder,
          (RoundScoreRow, $$RoundScoresTableReferences),
          RoundScoreRow,
          PrefetchHooks Function({bool roundId})
        > {
  $$RoundScoresTableTableManager(_$AppDatabase db, $RoundScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> roundId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoundScoresCompanion(
                roundId: roundId,
                playerId: playerId,
                points: points,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int roundId,
                required int playerId,
                Value<int> points = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoundScoresCompanion.insert(
                roundId: roundId,
                playerId: playerId,
                points: points,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoundScoresTable, RoundScoreRow>(table),
                  $$RoundScoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roundId = false}) {
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
                    if (roundId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.roundId,
                                referencedTable: $$RoundScoresTableReferences
                                    ._roundIdTable(db),
                                referencedColumn: $$RoundScoresTableReferences
                                    ._roundIdTable(db)
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

typedef $$RoundScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundScoresTable,
      RoundScoreRow,
      $$RoundScoresTableFilterComposer,
      $$RoundScoresTableOrderingComposer,
      $$RoundScoresTableAnnotationComposer,
      $$RoundScoresTableCreateCompanionBuilder,
      $$RoundScoresTableUpdateCompanionBuilder,
      (RoundScoreRow, $$RoundScoresTableReferences),
      RoundScoreRow,
      PrefetchHooks Function({bool roundId})
    >;
typedef $$UsedWordsTableCreateCompanionBuilder =
    UsedWordsCompanion Function({
      required int tripId,
      required String wordId,
      Value<int> rowid,
    });
typedef $$UsedWordsTableUpdateCompanionBuilder =
    UsedWordsCompanion Function({
      Value<int> tripId,
      Value<String> wordId,
      Value<int> rowid,
    });

final class $$UsedWordsTableReferences
    extends BaseReferences<_$AppDatabase, $UsedWordsTable, UsedWordRow> {
  $$UsedWordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('used_words__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UsedWordsTableFilterComposer
    extends Composer<_$AppDatabase, $UsedWordsTable> {
  $$UsedWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsedWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsedWordsTable> {
  $$UsedWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsedWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsedWordsTable> {
  $$UsedWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsedWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsedWordsTable,
          UsedWordRow,
          $$UsedWordsTableFilterComposer,
          $$UsedWordsTableOrderingComposer,
          $$UsedWordsTableAnnotationComposer,
          $$UsedWordsTableCreateCompanionBuilder,
          $$UsedWordsTableUpdateCompanionBuilder,
          (UsedWordRow, $$UsedWordsTableReferences),
          UsedWordRow,
          PrefetchHooks Function({bool tripId})
        > {
  $$UsedWordsTableTableManager(_$AppDatabase db, $UsedWordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsedWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsedWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsedWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsedWordsCompanion(
                tripId: tripId,
                wordId: wordId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                required String wordId,
                Value<int> rowid = const Value.absent(),
              }) => UsedWordsCompanion.insert(
                tripId: tripId,
                wordId: wordId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsedWordsTable, UsedWordRow>(table),
                  $$UsedWordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$UsedWordsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$UsedWordsTableReferences
                                    ._tripIdTable(db)
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

typedef $$UsedWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsedWordsTable,
      UsedWordRow,
      $$UsedWordsTableFilterComposer,
      $$UsedWordsTableOrderingComposer,
      $$UsedWordsTableAnnotationComposer,
      $$UsedWordsTableCreateCompanionBuilder,
      $$UsedWordsTableUpdateCompanionBuilder,
      (UsedWordRow, $$UsedWordsTableReferences),
      UsedWordRow,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$UsedCaptionsTableCreateCompanionBuilder =
    UsedCaptionsCompanion Function({
      required int tripId,
      required String captionId,
      Value<int> rowid,
    });
typedef $$UsedCaptionsTableUpdateCompanionBuilder =
    UsedCaptionsCompanion Function({
      Value<int> tripId,
      Value<String> captionId,
      Value<int> rowid,
    });

final class $$UsedCaptionsTableReferences
    extends BaseReferences<_$AppDatabase, $UsedCaptionsTable, UsedCaptionRow> {
  $$UsedCaptionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) =>
      db.trips.createAlias('used_captions__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UsedCaptionsTableFilterComposer
    extends Composer<_$AppDatabase, $UsedCaptionsTable> {
  $$UsedCaptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get captionId => $composableBuilder(
    column: $table.captionId,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsedCaptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsedCaptionsTable> {
  $$UsedCaptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get captionId => $composableBuilder(
    column: $table.captionId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsedCaptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsedCaptionsTable> {
  $$UsedCaptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get captionId =>
      $composableBuilder(column: $table.captionId, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsedCaptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsedCaptionsTable,
          UsedCaptionRow,
          $$UsedCaptionsTableFilterComposer,
          $$UsedCaptionsTableOrderingComposer,
          $$UsedCaptionsTableAnnotationComposer,
          $$UsedCaptionsTableCreateCompanionBuilder,
          $$UsedCaptionsTableUpdateCompanionBuilder,
          (UsedCaptionRow, $$UsedCaptionsTableReferences),
          UsedCaptionRow,
          PrefetchHooks Function({bool tripId})
        > {
  $$UsedCaptionsTableTableManager(_$AppDatabase db, $UsedCaptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsedCaptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsedCaptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsedCaptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tripId = const Value.absent(),
                Value<String> captionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsedCaptionsCompanion(
                tripId: tripId,
                captionId: captionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int tripId,
                required String captionId,
                Value<int> rowid = const Value.absent(),
              }) => UsedCaptionsCompanion.insert(
                tripId: tripId,
                captionId: captionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsedCaptionsTable, UsedCaptionRow>(table),
                  $$UsedCaptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$UsedCaptionsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$UsedCaptionsTableReferences
                                    ._tripIdTable(db)
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

typedef $$UsedCaptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsedCaptionsTable,
      UsedCaptionRow,
      $$UsedCaptionsTableFilterComposer,
      $$UsedCaptionsTableOrderingComposer,
      $$UsedCaptionsTableAnnotationComposer,
      $$UsedCaptionsTableCreateCompanionBuilder,
      $$UsedCaptionsTableUpdateCompanionBuilder,
      (UsedCaptionRow, $$UsedCaptionsTableReferences),
      UsedCaptionRow,
      PrefetchHooks Function({bool tripId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db, _db.rounds);
  $$VotesTableTableManager get votes =>
      $$VotesTableTableManager(_db, _db.votes);
  $$RoundScoresTableTableManager get roundScores =>
      $$RoundScoresTableTableManager(_db, _db.roundScores);
  $$UsedWordsTableTableManager get usedWords =>
      $$UsedWordsTableTableManager(_db, _db.usedWords);
  $$UsedCaptionsTableTableManager get usedCaptions =>
      $$UsedCaptionsTableTableManager(_db, _db.usedCaptions);
}
