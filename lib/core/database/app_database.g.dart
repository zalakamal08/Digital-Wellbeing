// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'app_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AppUsageTableData extends DataClass
    implements Insertable<AppUsageTableData> {
  final int id;
  final String packageName;
  final String appName;
  final int usageTimeMs;
  final DateTime date;
  final DateTime lastUsed;
  final DateTime createdAt;

  const AppUsageTableData({
    required this.id,
    required this.packageName,
    required this.appName,
    required this.usageTimeMs,
    required this.date,
    required this.lastUsed,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['app_name'] = Variable<String>(appName);
    map['usage_time_ms'] = Variable<int>(usageTimeMs);
    map['date'] = Variable<DateTime>(date);
    map['last_used'] = Variable<DateTime>(lastUsed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppUsageTableCompanion toCompanion(bool nullToAbsent) {
    return AppUsageTableCompanion(
      id: Value(id),
      packageName: Value(packageName),
      appName: Value(appName),
      usageTimeMs: Value(usageTimeMs),
      date: Value(date),
      lastUsed: Value(lastUsed),
      createdAt: Value(createdAt),
    );
  }

  factory AppUsageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUsageTableData(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appName: serializer.fromJson<String>(json['appName']),
      usageTimeMs: serializer.fromJson<int>(json['usageTimeMs']),
      date: serializer.fromJson<DateTime>(json['date']),
      lastUsed: serializer.fromJson<DateTime>(json['lastUsed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'appName': serializer.toJson<String>(appName),
      'usageTimeMs': serializer.toJson<int>(usageTimeMs),
      'date': serializer.toJson<DateTime>(date),
      'lastUsed': serializer.toJson<DateTime>(lastUsed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppUsageTableData copyWith({
    int? id,
    String? packageName,
    String? appName,
    int? usageTimeMs,
    DateTime? date,
    DateTime? lastUsed,
    DateTime? createdAt,
  }) =>
      AppUsageTableData(
        id: id ?? this.id,
        packageName: packageName ?? this.packageName,
        appName: appName ?? this.appName,
        usageTimeMs: usageTimeMs ?? this.usageTimeMs,
        date: date ?? this.date,
        lastUsed: lastUsed ?? this.lastUsed,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() {
    return (StringBuffer('AppUsageTableData(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('usageTimeMs: $usageTimeMs, ')
          ..write('date: $date, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, packageName, appName, usageTimeMs, date, lastUsed, createdAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUsageTableData &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.appName == this.appName &&
          other.usageTimeMs == this.usageTimeMs &&
          other.date == this.date &&
          other.lastUsed == this.lastUsed &&
          other.createdAt == this.createdAt);
}

class AppUsageTableCompanion extends UpdateCompanion<AppUsageTableData> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> appName;
  final Value<int> usageTimeMs;
  final Value<DateTime> date;
  final Value<DateTime> lastUsed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;

  const AppUsageTableCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appName = const Value.absent(),
    this.usageTimeMs = const Value.absent(),
    this.date = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  AppUsageTableCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required String appName,
    required int usageTimeMs,
    required DateTime date,
    required DateTime lastUsed,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : packageName = Value(packageName),
        appName = Value(appName),
        usageTimeMs = Value(usageTimeMs),
        date = Value(date),
        lastUsed = Value(lastUsed);

  static Insertable<AppUsageTableData> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<String>? appName,
    Expression<int>? usageTimeMs,
    Expression<DateTime>? date,
    Expression<DateTime>? lastUsed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (appName != null) 'app_name': appName,
      if (usageTimeMs != null) 'usage_time_ms': usageTimeMs,
      if (date != null) 'date': date,
      if (lastUsed != null) 'last_used': lastUsed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppUsageTableCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<String>? appName,
    Value<int>? usageTimeMs,
    Value<DateTime>? date,
    Value<DateTime>? lastUsed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AppUsageTableCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      usageTimeMs: usageTimeMs ?? this.usageTimeMs,
      date: date ?? this.date,
      lastUsed: lastUsed ?? this.lastUsed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (packageName.present)
      map['package_name'] = Variable<String>(packageName.value);
    if (appName.present) map['app_name'] = Variable<String>(appName.value);
    if (usageTimeMs.present)
      map['usage_time_ms'] = Variable<int>(usageTimeMs.value);
    if (date.present) map['date'] = Variable<DateTime>(date.value);
    if (lastUsed.present)
      map['last_used'] = Variable<DateTime>(lastUsed.value);
    if (createdAt.present)
      map['created_at'] = Variable<DateTime>(createdAt.value);
    if (rowid.present) map['rowid'] = Variable<int>(rowid.value);
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUsageTableCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('usageTimeMs: $usageTimeMs, ')
          ..write('date: $date, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

// Stubs for Drift-generated code — the CI build_runner will regenerate this.
// These stubs allow the project to compile without local build_runner invocation.
class CallLogTableData extends DataClass
    implements Insertable<CallLogTableData> {
  final int id;
  final String number;
  final String? name;
  final String callType;
  final int duration;
  final DateTime timestamp;
  final DateTime createdAt;

  const CallLogTableData({
    required this.id,
    required this.number,
    this.name,
    required this.callType,
    required this.duration,
    required this.timestamp,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<String>(number);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['call_type'] = Variable<String>(callType);
    map['duration'] = Variable<int>(duration);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CallLogTableCompanion toCompanion(bool nullToAbsent) {
    return CallLogTableCompanion(
      id: Value(id),
      number: Value(number),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      callType: Value(callType),
      duration: Value(duration),
      timestamp: Value(timestamp),
      createdAt: Value(createdAt),
    );
  }

  factory CallLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallLogTableData(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      name: serializer.fromJson<String?>(json['name']),
      callType: serializer.fromJson<String>(json['callType']),
      duration: serializer.fromJson<int>(json['duration']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<String>(number),
      'name': serializer.toJson<String?>(name),
      'callType': serializer.toJson<String>(callType),
      'duration': serializer.toJson<int>(duration),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CallLogTableData copyWith({
    int? id,
    String? number,
    Object? name = const _Absent(),
    String? callType,
    int? duration,
    DateTime? timestamp,
    DateTime? createdAt,
  }) =>
      CallLogTableData(
        id: id ?? this.id,
        number: number ?? this.number,
        name: name == const _Absent() ? this.name : name as String?,
        callType: callType ?? this.callType,
        duration: duration ?? this.duration,
        timestamp: timestamp ?? this.timestamp,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() => 'CallLogTableData($id, $number, $callType)';

  @override
  int get hashCode =>
      Object.hash(id, number, name, callType, duration, timestamp, createdAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallLogTableData &&
          other.id == id &&
          other.number == number &&
          other.name == name &&
          other.callType == callType &&
          other.duration == duration &&
          other.timestamp == timestamp &&
          other.createdAt == createdAt);
}

class _Absent {
  const _Absent();
}

class CallLogTableCompanion extends UpdateCompanion<CallLogTableData> {
  final Value<int> id;
  final Value<String> number;
  final Value<String?> name;
  final Value<String> callType;
  final Value<int> duration;
  final Value<DateTime> timestamp;
  final Value<DateTime> createdAt;
  final Value<int> rowid;

  const CallLogTableCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    this.callType = const Value.absent(),
    this.duration = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  CallLogTableCompanion.insert({
    this.id = const Value.absent(),
    required String number,
    this.name = const Value.absent(),
    required String callType,
    required int duration,
    required DateTime timestamp,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : number = Value(number),
        callType = Value(callType),
        duration = Value(duration),
        timestamp = Value(timestamp);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (number.present) map['number'] = Variable<String>(number.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (callType.present)
      map['call_type'] = Variable<String>(callType.value);
    if (duration.present) map['duration'] = Variable<int>(duration.value);
    if (timestamp.present)
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    if (createdAt.present)
      map['created_at'] = Variable<DateTime>(createdAt.value);
    if (rowid.present) map['rowid'] = Variable<int>(rowid.value);
    return map;
  }

  @override
  String toString() =>
      'CallLogTableCompanion($id, $number, $name, $callType, $duration)';

  CallLogTableCompanion copyWith({
    Value<int>? id,
    Value<String>? number,
    Value<String?>? name,
    Value<String>? callType,
    Value<int>? duration,
    Value<DateTime>? timestamp,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) =>
      CallLogTableCompanion(
        id: id ?? this.id,
        number: number ?? this.number,
        name: name ?? this.name,
        callType: callType ?? this.callType,
        duration: duration ?? this.duration,
        timestamp: timestamp ?? this.timestamp,
        createdAt: createdAt ?? this.createdAt,
        rowid: rowid ?? this.rowid,
      );
}

class SmsLogTableData extends DataClass implements Insertable<SmsLogTableData> {
  final int id;
  final String address;
  final String? contactName;
  final String body;
  final String kind;
  final DateTime timestamp;
  final DateTime createdAt;

  const SmsLogTableData({
    required this.id,
    required this.address,
    this.contactName,
    required this.body,
    required this.kind,
    required this.timestamp,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    map['body'] = Variable<String>(body);
    map['kind'] = Variable<String>(kind);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SmsLogTableCompanion toCompanion(bool nullToAbsent) {
    return SmsLogTableCompanion(
      id: Value(id),
      address: Value(address),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      body: Value(body),
      kind: Value(kind),
      timestamp: Value(timestamp),
      createdAt: Value(createdAt),
    );
  }

  factory SmsLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsLogTableData(
      id: serializer.fromJson<int>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      contactName: serializer.fromJson<String?>(json['contactName']),
      body: serializer.fromJson<String>(json['body']),
      kind: serializer.fromJson<String>(json['kind']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {
      'id': serializer.toJson<int>(id),
      'address': serializer.toJson<String>(address),
      'contactName': serializer.toJson<String?>(contactName),
      'body': serializer.toJson<String>(body),
      'kind': serializer.toJson<String>(kind),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SmsLogTableData copyWith({
    int? id,
    String? address,
    Object? contactName = const _Absent(),
    String? body,
    String? kind,
    DateTime? timestamp,
    DateTime? createdAt,
  }) =>
      SmsLogTableData(
        id: id ?? this.id,
        address: address ?? this.address,
        contactName: contactName == const _Absent()
            ? this.contactName
            : contactName as String?,
        body: body ?? this.body,
        kind: kind ?? this.kind,
        timestamp: timestamp ?? this.timestamp,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() => 'SmsLogTableData($id, $address, $kind)';

  @override
  int get hashCode => Object.hash(
      id, address, contactName, body, kind, timestamp, createdAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsLogTableData &&
          other.id == id &&
          other.address == address &&
          other.contactName == contactName &&
          other.body == body &&
          other.kind == kind &&
          other.timestamp == timestamp &&
          other.createdAt == createdAt);
}

class SmsLogTableCompanion extends UpdateCompanion<SmsLogTableData> {
  final Value<int> id;
  final Value<String> address;
  final Value<String?> contactName;
  final Value<String> body;
  final Value<String> kind;
  final Value<DateTime> timestamp;
  final Value<DateTime> createdAt;
  final Value<int> rowid;

  const SmsLogTableCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.contactName = const Value.absent(),
    this.body = const Value.absent(),
    this.kind = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  SmsLogTableCompanion.insert({
    this.id = const Value.absent(),
    required String address,
    this.contactName = const Value.absent(),
    required String body,
    required String kind,
    required DateTime timestamp,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : address = Value(address),
        body = Value(body),
        kind = Value(kind),
        timestamp = Value(timestamp);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (address.present) map['address'] = Variable<String>(address.value);
    if (contactName.present)
      map['contact_name'] = Variable<String>(contactName.value);
    if (body.present) map['body'] = Variable<String>(body.value);
    if (kind.present) map['kind'] = Variable<String>(kind.value);
    if (timestamp.present)
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    if (createdAt.present)
      map['created_at'] = Variable<DateTime>(createdAt.value);
    if (rowid.present) map['rowid'] = Variable<int>(rowid.value);
    return map;
  }

  @override
  String toString() =>
      'SmsLogTableCompanion($id, $address, $contactName, $body, $kind)';

  SmsLogTableCompanion copyWith({
    Value<int>? id,
    Value<String>? address,
    Value<String?>? contactName,
    Value<String>? body,
    Value<String>? kind,
    Value<DateTime>? timestamp,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) =>
      SmsLogTableCompanion(
        id: id ?? this.id,
        address: address ?? this.address,
        contactName: contactName ?? this.contactName,
        body: body ?? this.body,
        kind: kind ?? this.kind,
        timestamp: timestamp ?? this.timestamp,
        createdAt: createdAt ?? this.createdAt,
        rowid: rowid ?? this.rowid,
      );
}

// ── Table definitions ──────────────────────────────────────────────────────

class $AppUsageTableTable extends AppUsageTable
    with TableInfo<$AppUsageTableTable, AppUsageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $AppUsageTableTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));

  static const VerificationMeta _packageNameMeta =
      VerificationMeta('packageName');
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
      'package_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _appNameMeta = VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  static const VerificationMeta _usageTimeMsMeta =
      VerificationMeta('usageTimeMs');
  @override
  late final GeneratedColumn<int> usageTimeMs = GeneratedColumn<int>(
      'usage_time_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  static const VerificationMeta _dateMeta = VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  static const VerificationMeta _lastUsedMeta = VerificationMeta('lastUsed');
  @override
  late final GeneratedColumn<DateTime> lastUsed = GeneratedColumn<DateTime>(
      'last_used', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);

  @override
  List<GeneratedColumn> get $columns =>
      [id, packageName, appName, usageTimeMs, date, lastUsed, createdAt];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'app_usage_table';

  @override
  VerificationContext validateIntegrity(
      Insertable<AppUsageTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
          _packageNameMeta,
          packageName.isAcceptableOrUnknown(
              data['package_name']!, _packageNameMeta));
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('usage_time_ms')) {
      context.handle(
          _usageTimeMsMeta,
          usageTimeMs.isAcceptableOrUnknown(
              data['usage_time_ms']!, _usageTimeMsMeta));
    } else if (isInserting) {
      context.missing(_usageTimeMsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('last_used')) {
      context.handle(_lastUsedMeta,
          lastUsed.isAcceptableOrUnknown(data['last_used']!, _lastUsedMeta));
    } else if (isInserting) {
      context.missing(_lastUsedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
          _createdAtMeta,
          createdAt.isAcceptableOrUnknown(
              data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  AppUsageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUsageTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      packageName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}package_name'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      usageTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_time_ms'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      lastUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AppUsageTableTable createAlias(String alias) {
    return $AppUsageTableTable(attachedDatabase, alias);
  }
}

class $CallLogTableTable extends CallLogTable
    with TableInfo<$CallLogTableTable, CallLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $CallLogTableTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));

  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);

  @override
  late final GeneratedColumn<String> callType = GeneratedColumn<String>(
      'call_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);

  @override
  List<GeneratedColumn> get $columns =>
      [id, number, name, callType, duration, timestamp, createdAt];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'call_log_table';

  @override
  VerificationContext validateIntegrity(
      Insertable<CallLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  CallLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      callType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}call_type'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CallLogTableTable createAlias(String alias) {
    return $CallLogTableTable(attachedDatabase, alias);
  }
}

class $SmsLogTableTable extends SmsLogTable
    with TableInfo<$SmsLogTableTable, SmsLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $SmsLogTableTable(this.attachedDatabase, [this._alias]);

  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));

  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
      'contact_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);

  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);

  @override
  List<GeneratedColumn> get $columns =>
      [id, address, contactName, body, kind, timestamp, createdAt];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'sms_log_table';

  @override
  VerificationContext validateIntegrity(
      Insertable<SmsLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  SmsLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      contactName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_name']),
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SmsLogTableTable createAlias(String alias) {
    return $SmsLogTableTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final $AppUsageTableTable appUsageTable =
      $AppUsageTableTable(this);
  late final $CallLogTableTable callLogTable = $CallLogTableTable(this);
  late final $SmsLogTableTable smsLogTable = $SmsLogTableTable(this);
  late final AppUsageDao appUsageDao = AppUsageDao(this as AppDatabase);
  late final CallLogDao callLogDao = CallLogDao(this as AppDatabase);
  late final SmsLogDao smsLogDao = SmsLogDao(this as AppDatabase);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [appUsageTable, callLogTable, smsLogTable];
}
