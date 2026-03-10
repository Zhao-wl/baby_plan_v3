// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_database.dart';

// ignore_for_file: type=lint
class $TestRecordsTable extends TestRecords
    with TableInfo<$TestRecordsTable, TestRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestRecordsTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestRecord> instance, {
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestRecord(
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
    );
  }

  @override
  $TestRecordsTable createAlias(String alias) {
    return $TestRecordsTable(attachedDatabase, alias);
  }
}

class TestRecord extends DataClass implements Insertable<TestRecord> {
  final int id;
  final String name;
  final DateTime createdAt;
  const TestRecord({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TestRecordsCompanion toCompanion(bool nullToAbsent) {
    return TestRecordsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory TestRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestRecord(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TestRecord copyWith({int? id, String? name, DateTime? createdAt}) =>
      TestRecord(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  TestRecord copyWithCompanion(TestRecordsCompanion data) {
    return TestRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TestRecordsCompanion extends UpdateCompanion<TestRecord> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const TestRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TestRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TestRecord> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TestRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return TestRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isGuestMeta = const VerificationMeta(
    'isGuest',
  );
  @override
  late final GeneratedColumn<bool> isGuest = GeneratedColumn<bool>(
    'is_guest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_guest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phone,
    email,
    nickname,
    avatarUrl,
    serverId,
    lastSyncAt,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
    isGuest,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_guest')) {
      context.handle(
        _isGuestMeta,
        isGuest.isAcceptableOrUnknown(data['is_guest']!, _isGuestMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isGuest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_guest'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// 主键ID
  final int id;

  /// 手机号
  final String? phone;

  /// 邮箱
  final String? email;

  /// 昵称
  final String nickname;

  /// 头像URL
  final String? avatarUrl;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 最后同步时间
  final DateTime? lastSyncAt;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 是否为游客用户
  final bool isGuest;
  const User({
    required this.id,
    this.phone,
    this.email,
    required this.nickname,
    this.avatarUrl,
    this.serverId,
    this.lastSyncAt,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isGuest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_guest'] = Variable<bool>(isGuest);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      nickname: Value(nickname),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isGuest: Value(isGuest),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isGuest: serializer.fromJson<bool>(json['isGuest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'nickname': serializer.toJson<String>(nickname),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'serverId': serializer.toJson<String?>(serverId),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isGuest': serializer.toJson<bool>(isGuest),
    };
  }

  User copyWith({
    int? id,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    String? nickname,
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGuest,
  }) => User(
    id: id ?? this.id,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    nickname: nickname ?? this.nickname,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    serverId: serverId.present ? serverId.value : this.serverId,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isGuest: isGuest ?? this.isGuest,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isGuest: data.isGuest.present ? data.isGuest.value : this.isGuest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('nickname: $nickname, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('serverId: $serverId, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isGuest: $isGuest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phone,
    email,
    nickname,
    avatarUrl,
    serverId,
    lastSyncAt,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
    isGuest,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.nickname == this.nickname &&
          other.avatarUrl == this.avatarUrl &&
          other.serverId == this.serverId &&
          other.lastSyncAt == this.lastSyncAt &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isGuest == this.isGuest);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String> nickname;
  final Value<String?> avatarUrl;
  final Value<String?> serverId;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isGuest;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isGuest = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required String nickname,
    this.avatarUrl = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isGuest = const Value.absent(),
  }) : nickname = Value(nickname);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? nickname,
    Expression<String>? avatarUrl,
    Expression<String>? serverId,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isGuest,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (nickname != null) 'nickname': nickname,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (serverId != null) 'server_id': serverId,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isGuest != null) 'is_guest': isGuest,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String>? nickname,
    Value<String?>? avatarUrl,
    Value<String?>? serverId,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isGuest,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      serverId: serverId ?? this.serverId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isGuest.present) {
      map['is_guest'] = Variable<bool>(isGuest.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('nickname: $nickname, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('serverId: $serverId, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isGuest: $isGuest')
          ..write(')'))
        .toString();
  }
}

class $FamiliesTable extends Families with TableInfo<$FamiliesTable, Family> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliesTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inviteCodeMeta = const VerificationMeta(
    'inviteCode',
  );
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
    'invite_code',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 6,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    inviteCode,
    ownerId,
    serverId,
    lastSyncAt,
    isDeleted,
    deletedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'families';
  @override
  VerificationContext validateIntegrity(
    Insertable<Family> instance, {
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
    if (data.containsKey('invite_code')) {
      context.handle(
        _inviteCodeMeta,
        inviteCode.isAcceptableOrUnknown(data['invite_code']!, _inviteCodeMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Family map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Family(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      inviteCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invite_code'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FamiliesTable createAlias(String alias) {
    return $FamiliesTable(attachedDatabase, alias);
  }
}

class Family extends DataClass implements Insertable<Family> {
  /// 主键ID
  final int id;

  /// 家庭名称
  final String name;

  /// 邀请码（用于加入家庭）
  final String? inviteCode;

  /// 创建者用户ID
  final int? ownerId;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 最后同步时间
  final DateTime? lastSyncAt;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;

  /// 创建时间
  final DateTime createdAt;
  const Family({
    required this.id,
    required this.name,
    this.inviteCode,
    this.ownerId,
    this.serverId,
    this.lastSyncAt,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || inviteCode != null) {
      map['invite_code'] = Variable<String>(inviteCode);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<int>(ownerId);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FamiliesCompanion toCompanion(bool nullToAbsent) {
    return FamiliesCompanion(
      id: Value(id),
      name: Value(name),
      inviteCode: inviteCode == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteCode),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Family.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Family(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      inviteCode: serializer.fromJson<String?>(json['inviteCode']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'inviteCode': serializer.toJson<String?>(inviteCode),
      'ownerId': serializer.toJson<int?>(ownerId),
      'serverId': serializer.toJson<String?>(serverId),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Family copyWith({
    int? id,
    String? name,
    Value<String?> inviteCode = const Value.absent(),
    Value<int?> ownerId = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
    Value<DateTime?> lastSyncAt = const Value.absent(),
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
  }) => Family(
    id: id ?? this.id,
    name: name ?? this.name,
    inviteCode: inviteCode.present ? inviteCode.value : this.inviteCode,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    serverId: serverId.present ? serverId.value : this.serverId,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Family copyWithCompanion(FamiliesCompanion data) {
    return Family(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      inviteCode: data.inviteCode.present
          ? data.inviteCode.value
          : this.inviteCode,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Family(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('ownerId: $ownerId, ')
          ..write('serverId: $serverId, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    inviteCode,
    ownerId,
    serverId,
    lastSyncAt,
    isDeleted,
    deletedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Family &&
          other.id == this.id &&
          other.name == this.name &&
          other.inviteCode == this.inviteCode &&
          other.ownerId == this.ownerId &&
          other.serverId == this.serverId &&
          other.lastSyncAt == this.lastSyncAt &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt);
}

class FamiliesCompanion extends UpdateCompanion<Family> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> inviteCode;
  final Value<int?> ownerId;
  final Value<String?> serverId;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  const FamiliesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FamiliesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.inviteCode = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Family> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? inviteCode,
    Expression<int>? ownerId,
    Expression<String>? serverId,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (ownerId != null) 'owner_id': ownerId,
      if (serverId != null) 'server_id': serverId,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FamiliesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? inviteCode,
    Value<int?>? ownerId,
    Value<String?>? serverId,
    Value<DateTime?>? lastSyncAt,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
  }) {
    return FamiliesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      ownerId: ownerId ?? this.ownerId,
      serverId: serverId ?? this.serverId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
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
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('ownerId: $ownerId, ')
          ..write('serverId: $serverId, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FamilyMembersTable extends FamilyMembers
    with TableInfo<$FamilyMembersTable, FamilyMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<int> familyId = GeneratedColumn<int>(
    'family_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<int> role = GeneratedColumn<int>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    userId,
    role,
    serverId,
    joinedAt,
    isDeleted,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {familyId, userId},
  ];
  @override
  FamilyMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}family_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $FamilyMembersTable createAlias(String alias) {
    return $FamilyMembersTable(attachedDatabase, alias);
  }
}

class FamilyMember extends DataClass implements Insertable<FamilyMember> {
  /// 主键ID
  final int id;

  /// 家庭组ID
  final int familyId;

  /// 用户ID
  final int userId;

  /// 角色：0=创建者、1=管理员、2=成员
  final int role;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 加入时间
  final DateTime joinedAt;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;
  const FamilyMember({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.role,
    this.serverId,
    required this.joinedAt,
    required this.isDeleted,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['family_id'] = Variable<int>(familyId);
    map['user_id'] = Variable<int>(userId);
    map['role'] = Variable<int>(role);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  FamilyMembersCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersCompanion(
      id: Value(id),
      familyId: Value(familyId),
      userId: Value(userId),
      role: Value(role),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      joinedAt: Value(joinedAt),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory FamilyMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMember(
      id: serializer.fromJson<int>(json['id']),
      familyId: serializer.fromJson<int>(json['familyId']),
      userId: serializer.fromJson<int>(json['userId']),
      role: serializer.fromJson<int>(json['role']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'familyId': serializer.toJson<int>(familyId),
      'userId': serializer.toJson<int>(userId),
      'role': serializer.toJson<int>(role),
      'serverId': serializer.toJson<String?>(serverId),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  FamilyMember copyWith({
    int? id,
    int? familyId,
    int? userId,
    int? role,
    Value<String?> serverId = const Value.absent(),
    DateTime? joinedAt,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => FamilyMember(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    serverId: serverId.present ? serverId.value : this.serverId,
    joinedAt: joinedAt ?? this.joinedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  FamilyMember copyWithCompanion(FamilyMembersCompanion data) {
    return FamilyMember(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMember(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('serverId: $serverId, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    userId,
    role,
    serverId,
    joinedAt,
    isDeleted,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMember &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.serverId == this.serverId &&
          other.joinedAt == this.joinedAt &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt);
}

class FamilyMembersCompanion extends UpdateCompanion<FamilyMember> {
  final Value<int> id;
  final Value<int> familyId;
  final Value<int> userId;
  final Value<int> role;
  final Value<String?> serverId;
  final Value<DateTime> joinedAt;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  const FamilyMembersCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.serverId = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  FamilyMembersCompanion.insert({
    this.id = const Value.absent(),
    required int familyId,
    required int userId,
    this.role = const Value.absent(),
    this.serverId = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : familyId = Value(familyId),
       userId = Value(userId);
  static Insertable<FamilyMember> custom({
    Expression<int>? id,
    Expression<int>? familyId,
    Expression<int>? userId,
    Expression<int>? role,
    Expression<String>? serverId,
    Expression<DateTime>? joinedAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (serverId != null) 'server_id': serverId,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  FamilyMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? familyId,
    Value<int>? userId,
    Value<int>? role,
    Value<String?>? serverId,
    Value<DateTime>? joinedAt,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
  }) {
    return FamilyMembersCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      serverId: serverId ?? this.serverId,
      joinedAt: joinedAt ?? this.joinedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<int>(familyId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<int>(role.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('serverId: $serverId, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $BabiesTable extends Babies with TableInfo<$BabiesTable, Baby> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BabiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<int> familyId = GeneratedColumn<int>(
    'family_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthWeightMeta = const VerificationMeta(
    'birthWeight',
  );
  @override
  late final GeneratedColumn<double> birthWeight = GeneratedColumn<double>(
    'birth_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthHeightMeta = const VerificationMeta(
    'birthHeight',
  );
  @override
  late final GeneratedColumn<double> birthHeight = GeneratedColumn<double>(
    'birth_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthHeadCircumferenceMeta =
      const VerificationMeta('birthHeadCircumference');
  @override
  late final GeneratedColumn<double> birthHeadCircumference =
      GeneratedColumn<double>(
        'birth_head_circumference',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    name,
    birthDate,
    gender,
    avatarUrl,
    birthWeight,
    birthHeight,
    birthHeadCircumference,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'babies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Baby> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('birth_weight')) {
      context.handle(
        _birthWeightMeta,
        birthWeight.isAcceptableOrUnknown(
          data['birth_weight']!,
          _birthWeightMeta,
        ),
      );
    }
    if (data.containsKey('birth_height')) {
      context.handle(
        _birthHeightMeta,
        birthHeight.isAcceptableOrUnknown(
          data['birth_height']!,
          _birthHeightMeta,
        ),
      );
    }
    if (data.containsKey('birth_head_circumference')) {
      context.handle(
        _birthHeadCircumferenceMeta,
        birthHeadCircumference.isAcceptableOrUnknown(
          data['birth_head_circumference']!,
          _birthHeadCircumferenceMeta,
        ),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Baby map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Baby(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}family_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gender'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      birthWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_weight'],
      ),
      birthHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_height'],
      ),
      birthHeadCircumference: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_head_circumference'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BabiesTable createAlias(String alias) {
    return $BabiesTable(attachedDatabase, alias);
  }
}

class Baby extends DataClass implements Insertable<Baby> {
  /// 主键ID
  final int id;

  /// 家庭组ID
  final int? familyId;

  /// 宝宝姓名
  final String name;

  /// 出生日期
  final DateTime birthDate;

  /// 性别：0=男、1=女
  final int gender;

  /// 头像URL
  final String? avatarUrl;

  /// 出生体重（kg）
  final double? birthWeight;

  /// 出生身高（cm）
  final double? birthHeight;

  /// 出生头围（cm）
  final double? birthHeadCircumference;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 设备ID（创建设备标识）
  final String? deviceId;

  /// 同步状态：0=已同步、1=待上传、2=待下载、3=冲突
  final int syncStatus;

  /// 数据版本号
  final int version;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const Baby({
    required this.id,
    this.familyId,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.avatarUrl,
    this.birthWeight,
    this.birthHeight,
    this.birthHeadCircumference,
    this.serverId,
    this.deviceId,
    required this.syncStatus,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<int>(familyId);
    }
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['gender'] = Variable<int>(gender);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || birthWeight != null) {
      map['birth_weight'] = Variable<double>(birthWeight);
    }
    if (!nullToAbsent || birthHeight != null) {
      map['birth_height'] = Variable<double>(birthHeight);
    }
    if (!nullToAbsent || birthHeadCircumference != null) {
      map['birth_head_circumference'] = Variable<double>(
        birthHeadCircumference,
      );
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BabiesCompanion toCompanion(bool nullToAbsent) {
    return BabiesCompanion(
      id: Value(id),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      name: Value(name),
      birthDate: Value(birthDate),
      gender: Value(gender),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      birthWeight: birthWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(birthWeight),
      birthHeight: birthHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(birthHeight),
      birthHeadCircumference: birthHeadCircumference == null && nullToAbsent
          ? const Value.absent()
          : Value(birthHeadCircumference),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      syncStatus: Value(syncStatus),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Baby.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Baby(
      id: serializer.fromJson<int>(json['id']),
      familyId: serializer.fromJson<int?>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      gender: serializer.fromJson<int>(json['gender']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      birthWeight: serializer.fromJson<double?>(json['birthWeight']),
      birthHeight: serializer.fromJson<double?>(json['birthHeight']),
      birthHeadCircumference: serializer.fromJson<double?>(
        json['birthHeadCircumference'],
      ),
      serverId: serializer.fromJson<String?>(json['serverId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'familyId': serializer.toJson<int?>(familyId),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'gender': serializer.toJson<int>(gender),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'birthWeight': serializer.toJson<double?>(birthWeight),
      'birthHeight': serializer.toJson<double?>(birthHeight),
      'birthHeadCircumference': serializer.toJson<double?>(
        birthHeadCircumference,
      ),
      'serverId': serializer.toJson<String?>(serverId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Baby copyWith({
    int? id,
    Value<int?> familyId = const Value.absent(),
    String? name,
    DateTime? birthDate,
    int? gender,
    Value<String?> avatarUrl = const Value.absent(),
    Value<double?> birthWeight = const Value.absent(),
    Value<double?> birthHeight = const Value.absent(),
    Value<double?> birthHeadCircumference = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    int? syncStatus,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Baby(
    id: id ?? this.id,
    familyId: familyId.present ? familyId.value : this.familyId,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    gender: gender ?? this.gender,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    birthWeight: birthWeight.present ? birthWeight.value : this.birthWeight,
    birthHeight: birthHeight.present ? birthHeight.value : this.birthHeight,
    birthHeadCircumference: birthHeadCircumference.present
        ? birthHeadCircumference.value
        : this.birthHeadCircumference,
    serverId: serverId.present ? serverId.value : this.serverId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Baby copyWithCompanion(BabiesCompanion data) {
    return Baby(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      birthWeight: data.birthWeight.present
          ? data.birthWeight.value
          : this.birthWeight,
      birthHeight: data.birthHeight.present
          ? data.birthHeight.value
          : this.birthHeight,
      birthHeadCircumference: data.birthHeadCircumference.present
          ? data.birthHeadCircumference.value
          : this.birthHeadCircumference,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Baby(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('birthHeadCircumference: $birthHeadCircumference, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    name,
    birthDate,
    gender,
    avatarUrl,
    birthWeight,
    birthHeight,
    birthHeadCircumference,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Baby &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.avatarUrl == this.avatarUrl &&
          other.birthWeight == this.birthWeight &&
          other.birthHeight == this.birthHeight &&
          other.birthHeadCircumference == this.birthHeadCircumference &&
          other.serverId == this.serverId &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BabiesCompanion extends UpdateCompanion<Baby> {
  final Value<int> id;
  final Value<int?> familyId;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<int> gender;
  final Value<String?> avatarUrl;
  final Value<double?> birthWeight;
  final Value<double?> birthHeight;
  final Value<double?> birthHeadCircumference;
  final Value<String?> serverId;
  final Value<String?> deviceId;
  final Value<int> syncStatus;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BabiesCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.birthHeadCircumference = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BabiesCompanion.insert({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    required String name,
    required DateTime birthDate,
    this.gender = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.birthHeadCircumference = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       birthDate = Value(birthDate);
  static Insertable<Baby> custom({
    Expression<int>? id,
    Expression<int>? familyId,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<int>? gender,
    Expression<String>? avatarUrl,
    Expression<double>? birthWeight,
    Expression<double>? birthHeight,
    Expression<double>? birthHeadCircumference,
    Expression<String>? serverId,
    Expression<String>? deviceId,
    Expression<int>? syncStatus,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (birthWeight != null) 'birth_weight': birthWeight,
      if (birthHeight != null) 'birth_height': birthHeight,
      if (birthHeadCircumference != null)
        'birth_head_circumference': birthHeadCircumference,
      if (serverId != null) 'server_id': serverId,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BabiesCompanion copyWith({
    Value<int>? id,
    Value<int?>? familyId,
    Value<String>? name,
    Value<DateTime>? birthDate,
    Value<int>? gender,
    Value<String?>? avatarUrl,
    Value<double?>? birthWeight,
    Value<double?>? birthHeight,
    Value<double?>? birthHeadCircumference,
    Value<String?>? serverId,
    Value<String?>? deviceId,
    Value<int>? syncStatus,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BabiesCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      birthHeadCircumference:
          birthHeadCircumference ?? this.birthHeadCircumference,
      serverId: serverId ?? this.serverId,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<int>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (birthWeight.present) {
      map['birth_weight'] = Variable<double>(birthWeight.value);
    }
    if (birthHeight.present) {
      map['birth_height'] = Variable<double>(birthHeight.value);
    }
    if (birthHeadCircumference.present) {
      map['birth_head_circumference'] = Variable<double>(
        birthHeadCircumference.value,
      );
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BabiesCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('birthHeadCircumference: $birthHeadCircumference, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ActivityRecordsTable extends ActivityRecords
    with TableInfo<$ActivityRecordsTable, ActivityRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _eatingMethodMeta = const VerificationMeta(
    'eatingMethod',
  );
  @override
  late final GeneratedColumn<int> eatingMethod = GeneratedColumn<int>(
    'eating_method',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breastSideMeta = const VerificationMeta(
    'breastSide',
  );
  @override
  late final GeneratedColumn<int> breastSide = GeneratedColumn<int>(
    'breast_side',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breastDurationMinutesMeta =
      const VerificationMeta('breastDurationMinutes');
  @override
  late final GeneratedColumn<int> breastDurationMinutes = GeneratedColumn<int>(
    'breast_duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formulaAmountMlMeta = const VerificationMeta(
    'formulaAmountMl',
  );
  @override
  late final GeneratedColumn<int> formulaAmountMl = GeneratedColumn<int>(
    'formula_amount_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodTypeMeta = const VerificationMeta(
    'foodType',
  );
  @override
  late final GeneratedColumn<String> foodType = GeneratedColumn<String>(
    'food_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepLocationMeta = const VerificationMeta(
    'sleepLocation',
  );
  @override
  late final GeneratedColumn<int> sleepLocation = GeneratedColumn<int>(
    'sleep_location',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepAssistMethodMeta = const VerificationMeta(
    'sleepAssistMethod',
  );
  @override
  late final GeneratedColumn<int> sleepAssistMethod = GeneratedColumn<int>(
    'sleep_assist_method',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<int> activityType = GeneratedColumn<int>(
    'activity_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaperTypeMeta = const VerificationMeta(
    'diaperType',
  );
  @override
  late final GeneratedColumn<int> diaperType = GeneratedColumn<int>(
    'diaper_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stoolColorMeta = const VerificationMeta(
    'stoolColor',
  );
  @override
  late final GeneratedColumn<int> stoolColor = GeneratedColumn<int>(
    'stool_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stoolTextureMeta = const VerificationMeta(
    'stoolTexture',
  );
  @override
  late final GeneratedColumn<int> stoolTexture = GeneratedColumn<int>(
    'stool_texture',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    babyId,
    type,
    startTime,
    endTime,
    durationSeconds,
    notes,
    isVerified,
    eatingMethod,
    breastSide,
    breastDurationMinutes,
    formulaAmountMl,
    foodType,
    sleepQuality,
    sleepLocation,
    sleepAssistMethod,
    activityType,
    mood,
    diaperType,
    stoolColor,
    stoolTexture,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('eating_method')) {
      context.handle(
        _eatingMethodMeta,
        eatingMethod.isAcceptableOrUnknown(
          data['eating_method']!,
          _eatingMethodMeta,
        ),
      );
    }
    if (data.containsKey('breast_side')) {
      context.handle(
        _breastSideMeta,
        breastSide.isAcceptableOrUnknown(data['breast_side']!, _breastSideMeta),
      );
    }
    if (data.containsKey('breast_duration_minutes')) {
      context.handle(
        _breastDurationMinutesMeta,
        breastDurationMinutes.isAcceptableOrUnknown(
          data['breast_duration_minutes']!,
          _breastDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('formula_amount_ml')) {
      context.handle(
        _formulaAmountMlMeta,
        formulaAmountMl.isAcceptableOrUnknown(
          data['formula_amount_ml']!,
          _formulaAmountMlMeta,
        ),
      );
    }
    if (data.containsKey('food_type')) {
      context.handle(
        _foodTypeMeta,
        foodType.isAcceptableOrUnknown(data['food_type']!, _foodTypeMeta),
      );
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    }
    if (data.containsKey('sleep_location')) {
      context.handle(
        _sleepLocationMeta,
        sleepLocation.isAcceptableOrUnknown(
          data['sleep_location']!,
          _sleepLocationMeta,
        ),
      );
    }
    if (data.containsKey('sleep_assist_method')) {
      context.handle(
        _sleepAssistMethodMeta,
        sleepAssistMethod.isAcceptableOrUnknown(
          data['sleep_assist_method']!,
          _sleepAssistMethodMeta,
        ),
      );
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('diaper_type')) {
      context.handle(
        _diaperTypeMeta,
        diaperType.isAcceptableOrUnknown(data['diaper_type']!, _diaperTypeMeta),
      );
    }
    if (data.containsKey('stool_color')) {
      context.handle(
        _stoolColorMeta,
        stoolColor.isAcceptableOrUnknown(data['stool_color']!, _stoolColorMeta),
      );
    }
    if (data.containsKey('stool_texture')) {
      context.handle(
        _stoolTextureMeta,
        stoolTexture.isAcceptableOrUnknown(
          data['stool_texture']!,
          _stoolTextureMeta,
        ),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baby_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      eatingMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eating_method'],
      ),
      breastSide: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breast_side'],
      ),
      breastDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breast_duration_minutes'],
      ),
      formulaAmountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}formula_amount_ml'],
      ),
      foodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_type'],
      ),
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      ),
      sleepLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_location'],
      ),
      sleepAssistMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_assist_method'],
      ),
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_type'],
      ),
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      ),
      diaperType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diaper_type'],
      ),
      stoolColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stool_color'],
      ),
      stoolTexture: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stool_texture'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActivityRecordsTable createAlias(String alias) {
    return $ActivityRecordsTable(attachedDatabase, alias);
  }
}

class ActivityRecord extends DataClass implements Insertable<ActivityRecord> {
  /// 主键ID
  final int id;

  /// 宝宝ID
  final int babyId;

  /// 活动类型：0=E吃、1=A玩、2=S睡、3=P排泄
  final int type;

  /// 开始时间
  final DateTime startTime;

  /// 结束时间
  final DateTime? endTime;

  /// 时长（秒）
  final int? durationSeconds;

  /// 备注
  final String? notes;

  /// 是否已校对（用户编辑过）
  final bool isVerified;

  /// 喂养方式：0=母乳、1=奶粉、2=辅食
  final int? eatingMethod;

  /// 母乳喂养侧：0=左、1=右、2=双侧
  final int? breastSide;

  /// 母乳喂养时长（分钟）
  final int? breastDurationMinutes;

  /// 奶粉量（ml）
  final int? formulaAmountMl;

  /// 辅食类型
  final String? foodType;

  /// 睡眠质量：0=差、1=一般、2=好
  final int? sleepQuality;

  /// 睡眠地点：0=婴儿床、1=父母床、2=推车、3=其他
  final int? sleepLocation;

  /// 入睡辅助方式：0=无、1=安抚奶嘴、2=摇篮、3=怀抱
  final int? sleepAssistMethod;

  /// 活动类型：0=趴着、1=翻身、2=坐、3=爬、4=站、5=走、6=户外、7=游泳、8=其他
  final int? activityType;

  /// 心情：0=开心、1=一般、2=不开心
  final int? mood;

  /// 尿布类型：0=尿、1=屎、2=混合
  final int? diaperType;

  /// 大便颜色：0=黄色、1=绿色、2=棕色、3=黑色、4=其他
  final int? stoolColor;

  /// 大便质地：0=正常、1=稀、2=干硬
  final int? stoolTexture;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 设备ID（创建设备标识）
  final String? deviceId;

  /// 同步状态：0=已同步、1=待上传、2=待下载、3=冲突
  final int syncStatus;

  /// 数据版本号
  final int version;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const ActivityRecord({
    required this.id,
    required this.babyId,
    required this.type,
    required this.startTime,
    this.endTime,
    this.durationSeconds,
    this.notes,
    required this.isVerified,
    this.eatingMethod,
    this.breastSide,
    this.breastDurationMinutes,
    this.formulaAmountMl,
    this.foodType,
    this.sleepQuality,
    this.sleepLocation,
    this.sleepAssistMethod,
    this.activityType,
    this.mood,
    this.diaperType,
    this.stoolColor,
    this.stoolTexture,
    this.serverId,
    this.deviceId,
    required this.syncStatus,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baby_id'] = Variable<int>(babyId);
    map['type'] = Variable<int>(type);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_verified'] = Variable<bool>(isVerified);
    if (!nullToAbsent || eatingMethod != null) {
      map['eating_method'] = Variable<int>(eatingMethod);
    }
    if (!nullToAbsent || breastSide != null) {
      map['breast_side'] = Variable<int>(breastSide);
    }
    if (!nullToAbsent || breastDurationMinutes != null) {
      map['breast_duration_minutes'] = Variable<int>(breastDurationMinutes);
    }
    if (!nullToAbsent || formulaAmountMl != null) {
      map['formula_amount_ml'] = Variable<int>(formulaAmountMl);
    }
    if (!nullToAbsent || foodType != null) {
      map['food_type'] = Variable<String>(foodType);
    }
    if (!nullToAbsent || sleepQuality != null) {
      map['sleep_quality'] = Variable<int>(sleepQuality);
    }
    if (!nullToAbsent || sleepLocation != null) {
      map['sleep_location'] = Variable<int>(sleepLocation);
    }
    if (!nullToAbsent || sleepAssistMethod != null) {
      map['sleep_assist_method'] = Variable<int>(sleepAssistMethod);
    }
    if (!nullToAbsent || activityType != null) {
      map['activity_type'] = Variable<int>(activityType);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    if (!nullToAbsent || diaperType != null) {
      map['diaper_type'] = Variable<int>(diaperType);
    }
    if (!nullToAbsent || stoolColor != null) {
      map['stool_color'] = Variable<int>(stoolColor);
    }
    if (!nullToAbsent || stoolTexture != null) {
      map['stool_texture'] = Variable<int>(stoolTexture);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActivityRecordsCompanion toCompanion(bool nullToAbsent) {
    return ActivityRecordsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      type: Value(type),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isVerified: Value(isVerified),
      eatingMethod: eatingMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(eatingMethod),
      breastSide: breastSide == null && nullToAbsent
          ? const Value.absent()
          : Value(breastSide),
      breastDurationMinutes: breastDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(breastDurationMinutes),
      formulaAmountMl: formulaAmountMl == null && nullToAbsent
          ? const Value.absent()
          : Value(formulaAmountMl),
      foodType: foodType == null && nullToAbsent
          ? const Value.absent()
          : Value(foodType),
      sleepQuality: sleepQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepQuality),
      sleepLocation: sleepLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepLocation),
      sleepAssistMethod: sleepAssistMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepAssistMethod),
      activityType: activityType == null && nullToAbsent
          ? const Value.absent()
          : Value(activityType),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      diaperType: diaperType == null && nullToAbsent
          ? const Value.absent()
          : Value(diaperType),
      stoolColor: stoolColor == null && nullToAbsent
          ? const Value.absent()
          : Value(stoolColor),
      stoolTexture: stoolTexture == null && nullToAbsent
          ? const Value.absent()
          : Value(stoolTexture),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      syncStatus: Value(syncStatus),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActivityRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRecord(
      id: serializer.fromJson<int>(json['id']),
      babyId: serializer.fromJson<int>(json['babyId']),
      type: serializer.fromJson<int>(json['type']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      notes: serializer.fromJson<String?>(json['notes']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      eatingMethod: serializer.fromJson<int?>(json['eatingMethod']),
      breastSide: serializer.fromJson<int?>(json['breastSide']),
      breastDurationMinutes: serializer.fromJson<int?>(
        json['breastDurationMinutes'],
      ),
      formulaAmountMl: serializer.fromJson<int?>(json['formulaAmountMl']),
      foodType: serializer.fromJson<String?>(json['foodType']),
      sleepQuality: serializer.fromJson<int?>(json['sleepQuality']),
      sleepLocation: serializer.fromJson<int?>(json['sleepLocation']),
      sleepAssistMethod: serializer.fromJson<int?>(json['sleepAssistMethod']),
      activityType: serializer.fromJson<int?>(json['activityType']),
      mood: serializer.fromJson<int?>(json['mood']),
      diaperType: serializer.fromJson<int?>(json['diaperType']),
      stoolColor: serializer.fromJson<int?>(json['stoolColor']),
      stoolTexture: serializer.fromJson<int?>(json['stoolTexture']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'babyId': serializer.toJson<int>(babyId),
      'type': serializer.toJson<int>(type),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'notes': serializer.toJson<String?>(notes),
      'isVerified': serializer.toJson<bool>(isVerified),
      'eatingMethod': serializer.toJson<int?>(eatingMethod),
      'breastSide': serializer.toJson<int?>(breastSide),
      'breastDurationMinutes': serializer.toJson<int?>(breastDurationMinutes),
      'formulaAmountMl': serializer.toJson<int?>(formulaAmountMl),
      'foodType': serializer.toJson<String?>(foodType),
      'sleepQuality': serializer.toJson<int?>(sleepQuality),
      'sleepLocation': serializer.toJson<int?>(sleepLocation),
      'sleepAssistMethod': serializer.toJson<int?>(sleepAssistMethod),
      'activityType': serializer.toJson<int?>(activityType),
      'mood': serializer.toJson<int?>(mood),
      'diaperType': serializer.toJson<int?>(diaperType),
      'stoolColor': serializer.toJson<int?>(stoolColor),
      'stoolTexture': serializer.toJson<int?>(stoolTexture),
      'serverId': serializer.toJson<String?>(serverId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActivityRecord copyWith({
    int? id,
    int? babyId,
    int? type,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isVerified,
    Value<int?> eatingMethod = const Value.absent(),
    Value<int?> breastSide = const Value.absent(),
    Value<int?> breastDurationMinutes = const Value.absent(),
    Value<int?> formulaAmountMl = const Value.absent(),
    Value<String?> foodType = const Value.absent(),
    Value<int?> sleepQuality = const Value.absent(),
    Value<int?> sleepLocation = const Value.absent(),
    Value<int?> sleepAssistMethod = const Value.absent(),
    Value<int?> activityType = const Value.absent(),
    Value<int?> mood = const Value.absent(),
    Value<int?> diaperType = const Value.absent(),
    Value<int?> stoolColor = const Value.absent(),
    Value<int?> stoolTexture = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    int? syncStatus,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ActivityRecord(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    type: type ?? this.type,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    notes: notes.present ? notes.value : this.notes,
    isVerified: isVerified ?? this.isVerified,
    eatingMethod: eatingMethod.present ? eatingMethod.value : this.eatingMethod,
    breastSide: breastSide.present ? breastSide.value : this.breastSide,
    breastDurationMinutes: breastDurationMinutes.present
        ? breastDurationMinutes.value
        : this.breastDurationMinutes,
    formulaAmountMl: formulaAmountMl.present
        ? formulaAmountMl.value
        : this.formulaAmountMl,
    foodType: foodType.present ? foodType.value : this.foodType,
    sleepQuality: sleepQuality.present ? sleepQuality.value : this.sleepQuality,
    sleepLocation: sleepLocation.present
        ? sleepLocation.value
        : this.sleepLocation,
    sleepAssistMethod: sleepAssistMethod.present
        ? sleepAssistMethod.value
        : this.sleepAssistMethod,
    activityType: activityType.present ? activityType.value : this.activityType,
    mood: mood.present ? mood.value : this.mood,
    diaperType: diaperType.present ? diaperType.value : this.diaperType,
    stoolColor: stoolColor.present ? stoolColor.value : this.stoolColor,
    stoolTexture: stoolTexture.present ? stoolTexture.value : this.stoolTexture,
    serverId: serverId.present ? serverId.value : this.serverId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActivityRecord copyWithCompanion(ActivityRecordsCompanion data) {
    return ActivityRecord(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      type: data.type.present ? data.type.value : this.type,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      eatingMethod: data.eatingMethod.present
          ? data.eatingMethod.value
          : this.eatingMethod,
      breastSide: data.breastSide.present
          ? data.breastSide.value
          : this.breastSide,
      breastDurationMinutes: data.breastDurationMinutes.present
          ? data.breastDurationMinutes.value
          : this.breastDurationMinutes,
      formulaAmountMl: data.formulaAmountMl.present
          ? data.formulaAmountMl.value
          : this.formulaAmountMl,
      foodType: data.foodType.present ? data.foodType.value : this.foodType,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      sleepLocation: data.sleepLocation.present
          ? data.sleepLocation.value
          : this.sleepLocation,
      sleepAssistMethod: data.sleepAssistMethod.present
          ? data.sleepAssistMethod.value
          : this.sleepAssistMethod,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      mood: data.mood.present ? data.mood.value : this.mood,
      diaperType: data.diaperType.present
          ? data.diaperType.value
          : this.diaperType,
      stoolColor: data.stoolColor.present
          ? data.stoolColor.value
          : this.stoolColor,
      stoolTexture: data.stoolTexture.present
          ? data.stoolTexture.value
          : this.stoolTexture,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRecord(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('type: $type, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('notes: $notes, ')
          ..write('isVerified: $isVerified, ')
          ..write('eatingMethod: $eatingMethod, ')
          ..write('breastSide: $breastSide, ')
          ..write('breastDurationMinutes: $breastDurationMinutes, ')
          ..write('formulaAmountMl: $formulaAmountMl, ')
          ..write('foodType: $foodType, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('sleepLocation: $sleepLocation, ')
          ..write('sleepAssistMethod: $sleepAssistMethod, ')
          ..write('activityType: $activityType, ')
          ..write('mood: $mood, ')
          ..write('diaperType: $diaperType, ')
          ..write('stoolColor: $stoolColor, ')
          ..write('stoolTexture: $stoolTexture, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    babyId,
    type,
    startTime,
    endTime,
    durationSeconds,
    notes,
    isVerified,
    eatingMethod,
    breastSide,
    breastDurationMinutes,
    formulaAmountMl,
    foodType,
    sleepQuality,
    sleepLocation,
    sleepAssistMethod,
    activityType,
    mood,
    diaperType,
    stoolColor,
    stoolTexture,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRecord &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.type == this.type &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationSeconds == this.durationSeconds &&
          other.notes == this.notes &&
          other.isVerified == this.isVerified &&
          other.eatingMethod == this.eatingMethod &&
          other.breastSide == this.breastSide &&
          other.breastDurationMinutes == this.breastDurationMinutes &&
          other.formulaAmountMl == this.formulaAmountMl &&
          other.foodType == this.foodType &&
          other.sleepQuality == this.sleepQuality &&
          other.sleepLocation == this.sleepLocation &&
          other.sleepAssistMethod == this.sleepAssistMethod &&
          other.activityType == this.activityType &&
          other.mood == this.mood &&
          other.diaperType == this.diaperType &&
          other.stoolColor == this.stoolColor &&
          other.stoolTexture == this.stoolTexture &&
          other.serverId == this.serverId &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActivityRecordsCompanion extends UpdateCompanion<ActivityRecord> {
  final Value<int> id;
  final Value<int> babyId;
  final Value<int> type;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int?> durationSeconds;
  final Value<String?> notes;
  final Value<bool> isVerified;
  final Value<int?> eatingMethod;
  final Value<int?> breastSide;
  final Value<int?> breastDurationMinutes;
  final Value<int?> formulaAmountMl;
  final Value<String?> foodType;
  final Value<int?> sleepQuality;
  final Value<int?> sleepLocation;
  final Value<int?> sleepAssistMethod;
  final Value<int?> activityType;
  final Value<int?> mood;
  final Value<int?> diaperType;
  final Value<int?> stoolColor;
  final Value<int?> stoolTexture;
  final Value<String?> serverId;
  final Value<String?> deviceId;
  final Value<int> syncStatus;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ActivityRecordsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.type = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.eatingMethod = const Value.absent(),
    this.breastSide = const Value.absent(),
    this.breastDurationMinutes = const Value.absent(),
    this.formulaAmountMl = const Value.absent(),
    this.foodType = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.sleepLocation = const Value.absent(),
    this.sleepAssistMethod = const Value.absent(),
    this.activityType = const Value.absent(),
    this.mood = const Value.absent(),
    this.diaperType = const Value.absent(),
    this.stoolColor = const Value.absent(),
    this.stoolTexture = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ActivityRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int babyId,
    required int type,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.eatingMethod = const Value.absent(),
    this.breastSide = const Value.absent(),
    this.breastDurationMinutes = const Value.absent(),
    this.formulaAmountMl = const Value.absent(),
    this.foodType = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.sleepLocation = const Value.absent(),
    this.sleepAssistMethod = const Value.absent(),
    this.activityType = const Value.absent(),
    this.mood = const Value.absent(),
    this.diaperType = const Value.absent(),
    this.stoolColor = const Value.absent(),
    this.stoolTexture = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : babyId = Value(babyId),
       type = Value(type),
       startTime = Value(startTime);
  static Insertable<ActivityRecord> custom({
    Expression<int>? id,
    Expression<int>? babyId,
    Expression<int>? type,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationSeconds,
    Expression<String>? notes,
    Expression<bool>? isVerified,
    Expression<int>? eatingMethod,
    Expression<int>? breastSide,
    Expression<int>? breastDurationMinutes,
    Expression<int>? formulaAmountMl,
    Expression<String>? foodType,
    Expression<int>? sleepQuality,
    Expression<int>? sleepLocation,
    Expression<int>? sleepAssistMethod,
    Expression<int>? activityType,
    Expression<int>? mood,
    Expression<int>? diaperType,
    Expression<int>? stoolColor,
    Expression<int>? stoolTexture,
    Expression<String>? serverId,
    Expression<String>? deviceId,
    Expression<int>? syncStatus,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (type != null) 'type': type,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (notes != null) 'notes': notes,
      if (isVerified != null) 'is_verified': isVerified,
      if (eatingMethod != null) 'eating_method': eatingMethod,
      if (breastSide != null) 'breast_side': breastSide,
      if (breastDurationMinutes != null)
        'breast_duration_minutes': breastDurationMinutes,
      if (formulaAmountMl != null) 'formula_amount_ml': formulaAmountMl,
      if (foodType != null) 'food_type': foodType,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (sleepLocation != null) 'sleep_location': sleepLocation,
      if (sleepAssistMethod != null) 'sleep_assist_method': sleepAssistMethod,
      if (activityType != null) 'activity_type': activityType,
      if (mood != null) 'mood': mood,
      if (diaperType != null) 'diaper_type': diaperType,
      if (stoolColor != null) 'stool_color': stoolColor,
      if (stoolTexture != null) 'stool_texture': stoolTexture,
      if (serverId != null) 'server_id': serverId,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ActivityRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? babyId,
    Value<int>? type,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<int?>? durationSeconds,
    Value<String?>? notes,
    Value<bool>? isVerified,
    Value<int?>? eatingMethod,
    Value<int?>? breastSide,
    Value<int?>? breastDurationMinutes,
    Value<int?>? formulaAmountMl,
    Value<String?>? foodType,
    Value<int?>? sleepQuality,
    Value<int?>? sleepLocation,
    Value<int?>? sleepAssistMethod,
    Value<int?>? activityType,
    Value<int?>? mood,
    Value<int?>? diaperType,
    Value<int?>? stoolColor,
    Value<int?>? stoolTexture,
    Value<String?>? serverId,
    Value<String?>? deviceId,
    Value<int>? syncStatus,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ActivityRecordsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
      isVerified: isVerified ?? this.isVerified,
      eatingMethod: eatingMethod ?? this.eatingMethod,
      breastSide: breastSide ?? this.breastSide,
      breastDurationMinutes:
          breastDurationMinutes ?? this.breastDurationMinutes,
      formulaAmountMl: formulaAmountMl ?? this.formulaAmountMl,
      foodType: foodType ?? this.foodType,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepLocation: sleepLocation ?? this.sleepLocation,
      sleepAssistMethod: sleepAssistMethod ?? this.sleepAssistMethod,
      activityType: activityType ?? this.activityType,
      mood: mood ?? this.mood,
      diaperType: diaperType ?? this.diaperType,
      stoolColor: stoolColor ?? this.stoolColor,
      stoolTexture: stoolTexture ?? this.stoolTexture,
      serverId: serverId ?? this.serverId,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (eatingMethod.present) {
      map['eating_method'] = Variable<int>(eatingMethod.value);
    }
    if (breastSide.present) {
      map['breast_side'] = Variable<int>(breastSide.value);
    }
    if (breastDurationMinutes.present) {
      map['breast_duration_minutes'] = Variable<int>(
        breastDurationMinutes.value,
      );
    }
    if (formulaAmountMl.present) {
      map['formula_amount_ml'] = Variable<int>(formulaAmountMl.value);
    }
    if (foodType.present) {
      map['food_type'] = Variable<String>(foodType.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (sleepLocation.present) {
      map['sleep_location'] = Variable<int>(sleepLocation.value);
    }
    if (sleepAssistMethod.present) {
      map['sleep_assist_method'] = Variable<int>(sleepAssistMethod.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<int>(activityType.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (diaperType.present) {
      map['diaper_type'] = Variable<int>(diaperType.value);
    }
    if (stoolColor.present) {
      map['stool_color'] = Variable<int>(stoolColor.value);
    }
    if (stoolTexture.present) {
      map['stool_texture'] = Variable<int>(stoolTexture.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRecordsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('type: $type, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('notes: $notes, ')
          ..write('isVerified: $isVerified, ')
          ..write('eatingMethod: $eatingMethod, ')
          ..write('breastSide: $breastSide, ')
          ..write('breastDurationMinutes: $breastDurationMinutes, ')
          ..write('formulaAmountMl: $formulaAmountMl, ')
          ..write('foodType: $foodType, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('sleepLocation: $sleepLocation, ')
          ..write('sleepAssistMethod: $sleepAssistMethod, ')
          ..write('activityType: $activityType, ')
          ..write('mood: $mood, ')
          ..write('diaperType: $diaperType, ')
          ..write('stoolColor: $stoolColor, ')
          ..write('stoolTexture: $stoolTexture, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GrowthRecordsTable extends GrowthRecords
    with TableInfo<$GrowthRecordsTable, GrowthRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrowthRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordDateMeta = const VerificationMeta(
    'recordDate',
  );
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
    'record_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headCircumferenceMeta = const VerificationMeta(
    'headCircumference',
  );
  @override
  late final GeneratedColumn<double> headCircumference =
      GeneratedColumn<double>(
        'head_circumference',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedActivityIdMeta = const VerificationMeta(
    'relatedActivityId',
  );
  @override
  late final GeneratedColumn<int> relatedActivityId = GeneratedColumn<int>(
    'related_activity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextMeta = const VerificationMeta(
    'context',
  );
  @override
  late final GeneratedColumn<int> context = GeneratedColumn<int>(
    'context',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    babyId,
    recordDate,
    weight,
    height,
    headCircumference,
    notes,
    relatedActivityId,
    context,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'growth_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrowthRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('record_date')) {
      context.handle(
        _recordDateMeta,
        recordDate.isAcceptableOrUnknown(data['record_date']!, _recordDateMeta),
      );
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('head_circumference')) {
      context.handle(
        _headCircumferenceMeta,
        headCircumference.isAcceptableOrUnknown(
          data['head_circumference']!,
          _headCircumferenceMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('related_activity_id')) {
      context.handle(
        _relatedActivityIdMeta,
        relatedActivityId.isAcceptableOrUnknown(
          data['related_activity_id']!,
          _relatedActivityIdMeta,
        ),
      );
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrowthRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrowthRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baby_id'],
      )!,
      recordDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_date'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      ),
      headCircumference: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}head_circumference'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      relatedActivityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_activity_id'],
      ),
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}context'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GrowthRecordsTable createAlias(String alias) {
    return $GrowthRecordsTable(attachedDatabase, alias);
  }
}

class GrowthRecord extends DataClass implements Insertable<GrowthRecord> {
  /// 主键ID
  final int id;

  /// 宝宝ID
  final int babyId;

  /// 记录日期
  final DateTime recordDate;

  /// 体重（kg）
  final double? weight;

  /// 身高（cm）
  final double? height;

  /// 头围（cm）
  final double? headCircumference;

  /// 备注
  final String? notes;

  /// 关联活动记录ID
  final int? relatedActivityId;

  /// 测量上下文：0=饭前、1=饭后、2=便前、3=便后
  final int? context;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 设备ID（创建设备标识）
  final String? deviceId;

  /// 同步状态：0=已同步、1=待上传、2=待下载、3=冲突
  final int syncStatus;

  /// 数据版本号
  final int version;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const GrowthRecord({
    required this.id,
    required this.babyId,
    required this.recordDate,
    this.weight,
    this.height,
    this.headCircumference,
    this.notes,
    this.relatedActivityId,
    this.context,
    this.serverId,
    this.deviceId,
    required this.syncStatus,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baby_id'] = Variable<int>(babyId);
    map['record_date'] = Variable<DateTime>(recordDate);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    if (!nullToAbsent || headCircumference != null) {
      map['head_circumference'] = Variable<double>(headCircumference);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || relatedActivityId != null) {
      map['related_activity_id'] = Variable<int>(relatedActivityId);
    }
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<int>(context);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GrowthRecordsCompanion toCompanion(bool nullToAbsent) {
    return GrowthRecordsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      recordDate: Value(recordDate),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      headCircumference: headCircumference == null && nullToAbsent
          ? const Value.absent()
          : Value(headCircumference),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      relatedActivityId: relatedActivityId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedActivityId),
      context: context == null && nullToAbsent
          ? const Value.absent()
          : Value(context),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      syncStatus: Value(syncStatus),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GrowthRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrowthRecord(
      id: serializer.fromJson<int>(json['id']),
      babyId: serializer.fromJson<int>(json['babyId']),
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      weight: serializer.fromJson<double?>(json['weight']),
      height: serializer.fromJson<double?>(json['height']),
      headCircumference: serializer.fromJson<double?>(
        json['headCircumference'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      relatedActivityId: serializer.fromJson<int?>(json['relatedActivityId']),
      context: serializer.fromJson<int?>(json['context']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'babyId': serializer.toJson<int>(babyId),
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'weight': serializer.toJson<double?>(weight),
      'height': serializer.toJson<double?>(height),
      'headCircumference': serializer.toJson<double?>(headCircumference),
      'notes': serializer.toJson<String?>(notes),
      'relatedActivityId': serializer.toJson<int?>(relatedActivityId),
      'context': serializer.toJson<int?>(context),
      'serverId': serializer.toJson<String?>(serverId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GrowthRecord copyWith({
    int? id,
    int? babyId,
    DateTime? recordDate,
    Value<double?> weight = const Value.absent(),
    Value<double?> height = const Value.absent(),
    Value<double?> headCircumference = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> relatedActivityId = const Value.absent(),
    Value<int?> context = const Value.absent(),
    Value<String?> serverId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    int? syncStatus,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GrowthRecord(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    recordDate: recordDate ?? this.recordDate,
    weight: weight.present ? weight.value : this.weight,
    height: height.present ? height.value : this.height,
    headCircumference: headCircumference.present
        ? headCircumference.value
        : this.headCircumference,
    notes: notes.present ? notes.value : this.notes,
    relatedActivityId: relatedActivityId.present
        ? relatedActivityId.value
        : this.relatedActivityId,
    context: context.present ? context.value : this.context,
    serverId: serverId.present ? serverId.value : this.serverId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GrowthRecord copyWithCompanion(GrowthRecordsCompanion data) {
    return GrowthRecord(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      recordDate: data.recordDate.present
          ? data.recordDate.value
          : this.recordDate,
      weight: data.weight.present ? data.weight.value : this.weight,
      height: data.height.present ? data.height.value : this.height,
      headCircumference: data.headCircumference.present
          ? data.headCircumference.value
          : this.headCircumference,
      notes: data.notes.present ? data.notes.value : this.notes,
      relatedActivityId: data.relatedActivityId.present
          ? data.relatedActivityId.value
          : this.relatedActivityId,
      context: data.context.present ? data.context.value : this.context,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrowthRecord(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('recordDate: $recordDate, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('headCircumference: $headCircumference, ')
          ..write('notes: $notes, ')
          ..write('relatedActivityId: $relatedActivityId, ')
          ..write('context: $context, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    babyId,
    recordDate,
    weight,
    height,
    headCircumference,
    notes,
    relatedActivityId,
    context,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrowthRecord &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.recordDate == this.recordDate &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.headCircumference == this.headCircumference &&
          other.notes == this.notes &&
          other.relatedActivityId == this.relatedActivityId &&
          other.context == this.context &&
          other.serverId == this.serverId &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GrowthRecordsCompanion extends UpdateCompanion<GrowthRecord> {
  final Value<int> id;
  final Value<int> babyId;
  final Value<DateTime> recordDate;
  final Value<double?> weight;
  final Value<double?> height;
  final Value<double?> headCircumference;
  final Value<String?> notes;
  final Value<int?> relatedActivityId;
  final Value<int?> context;
  final Value<String?> serverId;
  final Value<String?> deviceId;
  final Value<int> syncStatus;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const GrowthRecordsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.recordDate = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.headCircumference = const Value.absent(),
    this.notes = const Value.absent(),
    this.relatedActivityId = const Value.absent(),
    this.context = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GrowthRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int babyId,
    required DateTime recordDate,
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.headCircumference = const Value.absent(),
    this.notes = const Value.absent(),
    this.relatedActivityId = const Value.absent(),
    this.context = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : babyId = Value(babyId),
       recordDate = Value(recordDate);
  static Insertable<GrowthRecord> custom({
    Expression<int>? id,
    Expression<int>? babyId,
    Expression<DateTime>? recordDate,
    Expression<double>? weight,
    Expression<double>? height,
    Expression<double>? headCircumference,
    Expression<String>? notes,
    Expression<int>? relatedActivityId,
    Expression<int>? context,
    Expression<String>? serverId,
    Expression<String>? deviceId,
    Expression<int>? syncStatus,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (recordDate != null) 'record_date': recordDate,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (headCircumference != null) 'head_circumference': headCircumference,
      if (notes != null) 'notes': notes,
      if (relatedActivityId != null) 'related_activity_id': relatedActivityId,
      if (context != null) 'context': context,
      if (serverId != null) 'server_id': serverId,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GrowthRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? babyId,
    Value<DateTime>? recordDate,
    Value<double?>? weight,
    Value<double?>? height,
    Value<double?>? headCircumference,
    Value<String?>? notes,
    Value<int?>? relatedActivityId,
    Value<int?>? context,
    Value<String?>? serverId,
    Value<String?>? deviceId,
    Value<int>? syncStatus,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return GrowthRecordsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      recordDate: recordDate ?? this.recordDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      headCircumference: headCircumference ?? this.headCircumference,
      notes: notes ?? this.notes,
      relatedActivityId: relatedActivityId ?? this.relatedActivityId,
      context: context ?? this.context,
      serverId: serverId ?? this.serverId,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (headCircumference.present) {
      map['head_circumference'] = Variable<double>(headCircumference.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (relatedActivityId.present) {
      map['related_activity_id'] = Variable<int>(relatedActivityId.value);
    }
    if (context.present) {
      map['context'] = Variable<int>(context.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrowthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('recordDate: $recordDate, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('headCircumference: $headCircumference, ')
          ..write('notes: $notes, ')
          ..write('relatedActivityId: $relatedActivityId, ')
          ..write('context: $context, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $VaccineLibraryTable extends VaccineLibrary
    with TableInfo<$VaccineLibraryTable, VaccineLibraryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccineLibraryTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseIndexMeta = const VerificationMeta(
    'doseIndex',
  );
  @override
  late final GeneratedColumn<int> doseIndex = GeneratedColumn<int>(
    'dose_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDosesMeta = const VerificationMeta(
    'totalDoses',
  );
  @override
  late final GeneratedColumn<int> totalDoses = GeneratedColumn<int>(
    'total_doses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recommendedAgeDaysMeta =
      const VerificationMeta('recommendedAgeDays');
  @override
  late final GeneratedColumn<int> recommendedAgeDays = GeneratedColumn<int>(
    'recommended_age_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minIntervalDaysMeta = const VerificationMeta(
    'minIntervalDays',
  );
  @override
  late final GeneratedColumn<int> minIntervalDays = GeneratedColumn<int>(
    'min_interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageDescriptionMeta = const VerificationMeta(
    'ageDescription',
  );
  @override
  late final GeneratedColumn<String> ageDescription = GeneratedColumn<String>(
    'age_description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vaccineTypeMeta = const VerificationMeta(
    'vaccineType',
  );
  @override
  late final GeneratedColumn<int> vaccineType = GeneratedColumn<int>(
    'vaccine_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCombinedMeta = const VerificationMeta(
    'isCombined',
  );
  @override
  late final GeneratedColumn<bool> isCombined = GeneratedColumn<bool>(
    'is_combined',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_combined" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contraindicationsMeta = const VerificationMeta(
    'contraindications',
  );
  @override
  late final GeneratedColumn<String> contraindications =
      GeneratedColumn<String>(
        'contraindications',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sideEffectsMeta = const VerificationMeta(
    'sideEffects',
  );
  @override
  late final GeneratedColumn<String> sideEffects = GeneratedColumn<String>(
    'side_effects',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataVersionMeta = const VerificationMeta(
    'dataVersion',
  );
  @override
  late final GeneratedColumn<int> dataVersion = GeneratedColumn<int>(
    'data_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    fullName,
    code,
    doseIndex,
    totalDoses,
    recommendedAgeDays,
    minIntervalDays,
    ageDescription,
    vaccineType,
    isCombined,
    description,
    contraindications,
    sideEffects,
    dataVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccine_library';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaccineLibraryData> instance, {
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
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('dose_index')) {
      context.handle(
        _doseIndexMeta,
        doseIndex.isAcceptableOrUnknown(data['dose_index']!, _doseIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_doseIndexMeta);
    }
    if (data.containsKey('total_doses')) {
      context.handle(
        _totalDosesMeta,
        totalDoses.isAcceptableOrUnknown(data['total_doses']!, _totalDosesMeta),
      );
    } else if (isInserting) {
      context.missing(_totalDosesMeta);
    }
    if (data.containsKey('recommended_age_days')) {
      context.handle(
        _recommendedAgeDaysMeta,
        recommendedAgeDays.isAcceptableOrUnknown(
          data['recommended_age_days']!,
          _recommendedAgeDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendedAgeDaysMeta);
    }
    if (data.containsKey('min_interval_days')) {
      context.handle(
        _minIntervalDaysMeta,
        minIntervalDays.isAcceptableOrUnknown(
          data['min_interval_days']!,
          _minIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('age_description')) {
      context.handle(
        _ageDescriptionMeta,
        ageDescription.isAcceptableOrUnknown(
          data['age_description']!,
          _ageDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ageDescriptionMeta);
    }
    if (data.containsKey('vaccine_type')) {
      context.handle(
        _vaccineTypeMeta,
        vaccineType.isAcceptableOrUnknown(
          data['vaccine_type']!,
          _vaccineTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_combined')) {
      context.handle(
        _isCombinedMeta,
        isCombined.isAcceptableOrUnknown(data['is_combined']!, _isCombinedMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('contraindications')) {
      context.handle(
        _contraindicationsMeta,
        contraindications.isAcceptableOrUnknown(
          data['contraindications']!,
          _contraindicationsMeta,
        ),
      );
    }
    if (data.containsKey('side_effects')) {
      context.handle(
        _sideEffectsMeta,
        sideEffects.isAcceptableOrUnknown(
          data['side_effects']!,
          _sideEffectsMeta,
        ),
      );
    }
    if (data.containsKey('data_version')) {
      context.handle(
        _dataVersionMeta,
        dataVersion.isAcceptableOrUnknown(
          data['data_version']!,
          _dataVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccineLibraryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccineLibraryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      doseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dose_index'],
      )!,
      totalDoses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_doses'],
      )!,
      recommendedAgeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recommended_age_days'],
      )!,
      minIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_interval_days'],
      ),
      ageDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_description'],
      )!,
      vaccineType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vaccine_type'],
      )!,
      isCombined: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_combined'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      contraindications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contraindications'],
      ),
      sideEffects: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}side_effects'],
      ),
      dataVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}data_version'],
      )!,
    );
  }

  @override
  $VaccineLibraryTable createAlias(String alias) {
    return $VaccineLibraryTable(attachedDatabase, alias);
  }
}

class VaccineLibraryData extends DataClass
    implements Insertable<VaccineLibraryData> {
  /// 主键ID
  final int id;

  /// 疫苗简称（如：乙肝疫苗）
  final String name;

  /// 疫苗全称（如：乙型肝炎疫苗）
  final String fullName;

  /// 疫苗编码（如：HepB）
  final String code;

  /// 剂次序号（第几针，如：1、2、3）
  final int doseIndex;

  /// 总剂次数
  final int totalDoses;

  /// 推荐接种年龄（天数，如：0=出生当天、30=满月）
  final int recommendedAgeDays;

  /// 最小间隔天数（与上一针的间隔）
  final int? minIntervalDays;

  /// 年龄描述（如："出生时"、"1月龄"、"6月龄"）
  final String ageDescription;

  /// 疫苗类型：0=一类（免费）、1=二类（自费）
  final int vaccineType;

  /// 是否为联合疫苗
  final bool isCombined;

  /// 疫苗说明
  final String? description;

  /// 禁忌症
  final String? contraindications;

  /// 常见不良反应
  final String? sideEffects;

  /// 数据版本号（用于判断是否需要更新内置数据）
  final int dataVersion;
  const VaccineLibraryData({
    required this.id,
    required this.name,
    required this.fullName,
    required this.code,
    required this.doseIndex,
    required this.totalDoses,
    required this.recommendedAgeDays,
    this.minIntervalDays,
    required this.ageDescription,
    required this.vaccineType,
    required this.isCombined,
    this.description,
    this.contraindications,
    this.sideEffects,
    required this.dataVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['full_name'] = Variable<String>(fullName);
    map['code'] = Variable<String>(code);
    map['dose_index'] = Variable<int>(doseIndex);
    map['total_doses'] = Variable<int>(totalDoses);
    map['recommended_age_days'] = Variable<int>(recommendedAgeDays);
    if (!nullToAbsent || minIntervalDays != null) {
      map['min_interval_days'] = Variable<int>(minIntervalDays);
    }
    map['age_description'] = Variable<String>(ageDescription);
    map['vaccine_type'] = Variable<int>(vaccineType);
    map['is_combined'] = Variable<bool>(isCombined);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || contraindications != null) {
      map['contraindications'] = Variable<String>(contraindications);
    }
    if (!nullToAbsent || sideEffects != null) {
      map['side_effects'] = Variable<String>(sideEffects);
    }
    map['data_version'] = Variable<int>(dataVersion);
    return map;
  }

  VaccineLibraryCompanion toCompanion(bool nullToAbsent) {
    return VaccineLibraryCompanion(
      id: Value(id),
      name: Value(name),
      fullName: Value(fullName),
      code: Value(code),
      doseIndex: Value(doseIndex),
      totalDoses: Value(totalDoses),
      recommendedAgeDays: Value(recommendedAgeDays),
      minIntervalDays: minIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(minIntervalDays),
      ageDescription: Value(ageDescription),
      vaccineType: Value(vaccineType),
      isCombined: Value(isCombined),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      contraindications: contraindications == null && nullToAbsent
          ? const Value.absent()
          : Value(contraindications),
      sideEffects: sideEffects == null && nullToAbsent
          ? const Value.absent()
          : Value(sideEffects),
      dataVersion: Value(dataVersion),
    );
  }

  factory VaccineLibraryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccineLibraryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fullName: serializer.fromJson<String>(json['fullName']),
      code: serializer.fromJson<String>(json['code']),
      doseIndex: serializer.fromJson<int>(json['doseIndex']),
      totalDoses: serializer.fromJson<int>(json['totalDoses']),
      recommendedAgeDays: serializer.fromJson<int>(json['recommendedAgeDays']),
      minIntervalDays: serializer.fromJson<int?>(json['minIntervalDays']),
      ageDescription: serializer.fromJson<String>(json['ageDescription']),
      vaccineType: serializer.fromJson<int>(json['vaccineType']),
      isCombined: serializer.fromJson<bool>(json['isCombined']),
      description: serializer.fromJson<String?>(json['description']),
      contraindications: serializer.fromJson<String?>(
        json['contraindications'],
      ),
      sideEffects: serializer.fromJson<String?>(json['sideEffects']),
      dataVersion: serializer.fromJson<int>(json['dataVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'fullName': serializer.toJson<String>(fullName),
      'code': serializer.toJson<String>(code),
      'doseIndex': serializer.toJson<int>(doseIndex),
      'totalDoses': serializer.toJson<int>(totalDoses),
      'recommendedAgeDays': serializer.toJson<int>(recommendedAgeDays),
      'minIntervalDays': serializer.toJson<int?>(minIntervalDays),
      'ageDescription': serializer.toJson<String>(ageDescription),
      'vaccineType': serializer.toJson<int>(vaccineType),
      'isCombined': serializer.toJson<bool>(isCombined),
      'description': serializer.toJson<String?>(description),
      'contraindications': serializer.toJson<String?>(contraindications),
      'sideEffects': serializer.toJson<String?>(sideEffects),
      'dataVersion': serializer.toJson<int>(dataVersion),
    };
  }

  VaccineLibraryData copyWith({
    int? id,
    String? name,
    String? fullName,
    String? code,
    int? doseIndex,
    int? totalDoses,
    int? recommendedAgeDays,
    Value<int?> minIntervalDays = const Value.absent(),
    String? ageDescription,
    int? vaccineType,
    bool? isCombined,
    Value<String?> description = const Value.absent(),
    Value<String?> contraindications = const Value.absent(),
    Value<String?> sideEffects = const Value.absent(),
    int? dataVersion,
  }) => VaccineLibraryData(
    id: id ?? this.id,
    name: name ?? this.name,
    fullName: fullName ?? this.fullName,
    code: code ?? this.code,
    doseIndex: doseIndex ?? this.doseIndex,
    totalDoses: totalDoses ?? this.totalDoses,
    recommendedAgeDays: recommendedAgeDays ?? this.recommendedAgeDays,
    minIntervalDays: minIntervalDays.present
        ? minIntervalDays.value
        : this.minIntervalDays,
    ageDescription: ageDescription ?? this.ageDescription,
    vaccineType: vaccineType ?? this.vaccineType,
    isCombined: isCombined ?? this.isCombined,
    description: description.present ? description.value : this.description,
    contraindications: contraindications.present
        ? contraindications.value
        : this.contraindications,
    sideEffects: sideEffects.present ? sideEffects.value : this.sideEffects,
    dataVersion: dataVersion ?? this.dataVersion,
  );
  VaccineLibraryData copyWithCompanion(VaccineLibraryCompanion data) {
    return VaccineLibraryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      code: data.code.present ? data.code.value : this.code,
      doseIndex: data.doseIndex.present ? data.doseIndex.value : this.doseIndex,
      totalDoses: data.totalDoses.present
          ? data.totalDoses.value
          : this.totalDoses,
      recommendedAgeDays: data.recommendedAgeDays.present
          ? data.recommendedAgeDays.value
          : this.recommendedAgeDays,
      minIntervalDays: data.minIntervalDays.present
          ? data.minIntervalDays.value
          : this.minIntervalDays,
      ageDescription: data.ageDescription.present
          ? data.ageDescription.value
          : this.ageDescription,
      vaccineType: data.vaccineType.present
          ? data.vaccineType.value
          : this.vaccineType,
      isCombined: data.isCombined.present
          ? data.isCombined.value
          : this.isCombined,
      description: data.description.present
          ? data.description.value
          : this.description,
      contraindications: data.contraindications.present
          ? data.contraindications.value
          : this.contraindications,
      sideEffects: data.sideEffects.present
          ? data.sideEffects.value
          : this.sideEffects,
      dataVersion: data.dataVersion.present
          ? data.dataVersion.value
          : this.dataVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccineLibraryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('code: $code, ')
          ..write('doseIndex: $doseIndex, ')
          ..write('totalDoses: $totalDoses, ')
          ..write('recommendedAgeDays: $recommendedAgeDays, ')
          ..write('minIntervalDays: $minIntervalDays, ')
          ..write('ageDescription: $ageDescription, ')
          ..write('vaccineType: $vaccineType, ')
          ..write('isCombined: $isCombined, ')
          ..write('description: $description, ')
          ..write('contraindications: $contraindications, ')
          ..write('sideEffects: $sideEffects, ')
          ..write('dataVersion: $dataVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    fullName,
    code,
    doseIndex,
    totalDoses,
    recommendedAgeDays,
    minIntervalDays,
    ageDescription,
    vaccineType,
    isCombined,
    description,
    contraindications,
    sideEffects,
    dataVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccineLibraryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.fullName == this.fullName &&
          other.code == this.code &&
          other.doseIndex == this.doseIndex &&
          other.totalDoses == this.totalDoses &&
          other.recommendedAgeDays == this.recommendedAgeDays &&
          other.minIntervalDays == this.minIntervalDays &&
          other.ageDescription == this.ageDescription &&
          other.vaccineType == this.vaccineType &&
          other.isCombined == this.isCombined &&
          other.description == this.description &&
          other.contraindications == this.contraindications &&
          other.sideEffects == this.sideEffects &&
          other.dataVersion == this.dataVersion);
}

class VaccineLibraryCompanion extends UpdateCompanion<VaccineLibraryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> fullName;
  final Value<String> code;
  final Value<int> doseIndex;
  final Value<int> totalDoses;
  final Value<int> recommendedAgeDays;
  final Value<int?> minIntervalDays;
  final Value<String> ageDescription;
  final Value<int> vaccineType;
  final Value<bool> isCombined;
  final Value<String?> description;
  final Value<String?> contraindications;
  final Value<String?> sideEffects;
  final Value<int> dataVersion;
  const VaccineLibraryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fullName = const Value.absent(),
    this.code = const Value.absent(),
    this.doseIndex = const Value.absent(),
    this.totalDoses = const Value.absent(),
    this.recommendedAgeDays = const Value.absent(),
    this.minIntervalDays = const Value.absent(),
    this.ageDescription = const Value.absent(),
    this.vaccineType = const Value.absent(),
    this.isCombined = const Value.absent(),
    this.description = const Value.absent(),
    this.contraindications = const Value.absent(),
    this.sideEffects = const Value.absent(),
    this.dataVersion = const Value.absent(),
  });
  VaccineLibraryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String fullName,
    required String code,
    required int doseIndex,
    required int totalDoses,
    required int recommendedAgeDays,
    this.minIntervalDays = const Value.absent(),
    required String ageDescription,
    this.vaccineType = const Value.absent(),
    this.isCombined = const Value.absent(),
    this.description = const Value.absent(),
    this.contraindications = const Value.absent(),
    this.sideEffects = const Value.absent(),
    this.dataVersion = const Value.absent(),
  }) : name = Value(name),
       fullName = Value(fullName),
       code = Value(code),
       doseIndex = Value(doseIndex),
       totalDoses = Value(totalDoses),
       recommendedAgeDays = Value(recommendedAgeDays),
       ageDescription = Value(ageDescription);
  static Insertable<VaccineLibraryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? fullName,
    Expression<String>? code,
    Expression<int>? doseIndex,
    Expression<int>? totalDoses,
    Expression<int>? recommendedAgeDays,
    Expression<int>? minIntervalDays,
    Expression<String>? ageDescription,
    Expression<int>? vaccineType,
    Expression<bool>? isCombined,
    Expression<String>? description,
    Expression<String>? contraindications,
    Expression<String>? sideEffects,
    Expression<int>? dataVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fullName != null) 'full_name': fullName,
      if (code != null) 'code': code,
      if (doseIndex != null) 'dose_index': doseIndex,
      if (totalDoses != null) 'total_doses': totalDoses,
      if (recommendedAgeDays != null)
        'recommended_age_days': recommendedAgeDays,
      if (minIntervalDays != null) 'min_interval_days': minIntervalDays,
      if (ageDescription != null) 'age_description': ageDescription,
      if (vaccineType != null) 'vaccine_type': vaccineType,
      if (isCombined != null) 'is_combined': isCombined,
      if (description != null) 'description': description,
      if (contraindications != null) 'contraindications': contraindications,
      if (sideEffects != null) 'side_effects': sideEffects,
      if (dataVersion != null) 'data_version': dataVersion,
    });
  }

  VaccineLibraryCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? fullName,
    Value<String>? code,
    Value<int>? doseIndex,
    Value<int>? totalDoses,
    Value<int>? recommendedAgeDays,
    Value<int?>? minIntervalDays,
    Value<String>? ageDescription,
    Value<int>? vaccineType,
    Value<bool>? isCombined,
    Value<String?>? description,
    Value<String?>? contraindications,
    Value<String?>? sideEffects,
    Value<int>? dataVersion,
  }) {
    return VaccineLibraryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      code: code ?? this.code,
      doseIndex: doseIndex ?? this.doseIndex,
      totalDoses: totalDoses ?? this.totalDoses,
      recommendedAgeDays: recommendedAgeDays ?? this.recommendedAgeDays,
      minIntervalDays: minIntervalDays ?? this.minIntervalDays,
      ageDescription: ageDescription ?? this.ageDescription,
      vaccineType: vaccineType ?? this.vaccineType,
      isCombined: isCombined ?? this.isCombined,
      description: description ?? this.description,
      contraindications: contraindications ?? this.contraindications,
      sideEffects: sideEffects ?? this.sideEffects,
      dataVersion: dataVersion ?? this.dataVersion,
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
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (doseIndex.present) {
      map['dose_index'] = Variable<int>(doseIndex.value);
    }
    if (totalDoses.present) {
      map['total_doses'] = Variable<int>(totalDoses.value);
    }
    if (recommendedAgeDays.present) {
      map['recommended_age_days'] = Variable<int>(recommendedAgeDays.value);
    }
    if (minIntervalDays.present) {
      map['min_interval_days'] = Variable<int>(minIntervalDays.value);
    }
    if (ageDescription.present) {
      map['age_description'] = Variable<String>(ageDescription.value);
    }
    if (vaccineType.present) {
      map['vaccine_type'] = Variable<int>(vaccineType.value);
    }
    if (isCombined.present) {
      map['is_combined'] = Variable<bool>(isCombined.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (contraindications.present) {
      map['contraindications'] = Variable<String>(contraindications.value);
    }
    if (sideEffects.present) {
      map['side_effects'] = Variable<String>(sideEffects.value);
    }
    if (dataVersion.present) {
      map['data_version'] = Variable<int>(dataVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccineLibraryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('code: $code, ')
          ..write('doseIndex: $doseIndex, ')
          ..write('totalDoses: $totalDoses, ')
          ..write('recommendedAgeDays: $recommendedAgeDays, ')
          ..write('minIntervalDays: $minIntervalDays, ')
          ..write('ageDescription: $ageDescription, ')
          ..write('vaccineType: $vaccineType, ')
          ..write('isCombined: $isCombined, ')
          ..write('description: $description, ')
          ..write('contraindications: $contraindications, ')
          ..write('sideEffects: $sideEffects, ')
          ..write('dataVersion: $dataVersion')
          ..write(')'))
        .toString();
  }
}

class $VaccineRecordsTable extends VaccineRecords
    with TableInfo<$VaccineRecordsTable, VaccineRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccineRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vaccineLibraryIdMeta = const VerificationMeta(
    'vaccineLibraryId',
  );
  @override
  late final GeneratedColumn<int> vaccineLibraryId = GeneratedColumn<int>(
    'vaccine_library_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualDateMeta = const VerificationMeta(
    'actualDate',
  );
  @override
  late final GeneratedColumn<DateTime> actualDate = GeneratedColumn<DateTime>(
    'actual_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchNumberMeta = const VerificationMeta(
    'batchNumber',
  );
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
    'batch_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hospitalMeta = const VerificationMeta(
    'hospital',
  );
  @override
  late final GeneratedColumn<String> hospital = GeneratedColumn<String>(
    'hospital',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _injectionSiteMeta = const VerificationMeta(
    'injectionSite',
  );
  @override
  late final GeneratedColumn<int> injectionSite = GeneratedColumn<int>(
    'injection_site',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reactionLevelMeta = const VerificationMeta(
    'reactionLevel',
  );
  @override
  late final GeneratedColumn<int> reactionLevel = GeneratedColumn<int>(
    'reaction_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reactionDetailMeta = const VerificationMeta(
    'reactionDetail',
  );
  @override
  late final GeneratedColumn<String> reactionDetail = GeneratedColumn<String>(
    'reaction_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reactionOnsetMeta = const VerificationMeta(
    'reactionOnset',
  );
  @override
  late final GeneratedColumn<int> reactionOnset = GeneratedColumn<int>(
    'reaction_onset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    babyId,
    vaccineLibraryId,
    actualDate,
    batchNumber,
    manufacturer,
    hospital,
    injectionSite,
    reactionLevel,
    reactionDetail,
    reactionOnset,
    notes,
    status,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccine_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaccineRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('vaccine_library_id')) {
      context.handle(
        _vaccineLibraryIdMeta,
        vaccineLibraryId.isAcceptableOrUnknown(
          data['vaccine_library_id']!,
          _vaccineLibraryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vaccineLibraryIdMeta);
    }
    if (data.containsKey('actual_date')) {
      context.handle(
        _actualDateMeta,
        actualDate.isAcceptableOrUnknown(data['actual_date']!, _actualDateMeta),
      );
    } else if (isInserting) {
      context.missing(_actualDateMeta);
    }
    if (data.containsKey('batch_number')) {
      context.handle(
        _batchNumberMeta,
        batchNumber.isAcceptableOrUnknown(
          data['batch_number']!,
          _batchNumberMeta,
        ),
      );
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('hospital')) {
      context.handle(
        _hospitalMeta,
        hospital.isAcceptableOrUnknown(data['hospital']!, _hospitalMeta),
      );
    }
    if (data.containsKey('injection_site')) {
      context.handle(
        _injectionSiteMeta,
        injectionSite.isAcceptableOrUnknown(
          data['injection_site']!,
          _injectionSiteMeta,
        ),
      );
    }
    if (data.containsKey('reaction_level')) {
      context.handle(
        _reactionLevelMeta,
        reactionLevel.isAcceptableOrUnknown(
          data['reaction_level']!,
          _reactionLevelMeta,
        ),
      );
    }
    if (data.containsKey('reaction_detail')) {
      context.handle(
        _reactionDetailMeta,
        reactionDetail.isAcceptableOrUnknown(
          data['reaction_detail']!,
          _reactionDetailMeta,
        ),
      );
    }
    if (data.containsKey('reaction_onset')) {
      context.handle(
        _reactionOnsetMeta,
        reactionOnset.isAcceptableOrUnknown(
          data['reaction_onset']!,
          _reactionOnsetMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccineRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccineRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baby_id'],
      )!,
      vaccineLibraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vaccine_library_id'],
      )!,
      actualDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_date'],
      )!,
      batchNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_number'],
      ),
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      hospital: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital'],
      ),
      injectionSite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}injection_site'],
      ),
      reactionLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reaction_level'],
      ),
      reactionDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reaction_detail'],
      ),
      reactionOnset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reaction_onset'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VaccineRecordsTable createAlias(String alias) {
    return $VaccineRecordsTable(attachedDatabase, alias);
  }
}

class VaccineRecord extends DataClass implements Insertable<VaccineRecord> {
  /// 主键ID
  final int id;

  /// 宝宝ID
  final int babyId;

  /// 疫苗库ID（关联疫苗信息）
  final int vaccineLibraryId;

  /// 实际接种日期
  final DateTime actualDate;

  /// 疫苗批号
  final String? batchNumber;

  /// 生产厂家
  final String? manufacturer;

  /// 接种医院
  final String? hospital;

  /// 接种部位：0=左上臂、1=右上臂、2=左大腿、3=右大腿、4=口服、5=其他
  final int? injectionSite;

  /// 反应等级：0=无、1=轻微、2=中等、3=严重
  final int? reactionLevel;

  /// 反应详情描述
  final String? reactionDetail;

  /// 反应出现时间（接种后多少小时）
  final int? reactionOnset;

  /// 备注
  final String? notes;

  /// 接种状态：0=待接种、1=已接种、2=已逾期、3=推迟/放弃
  final int status;

  /// 服务器ID（用于同步）
  final String? serverId;

  /// 设备ID（创建设备标识）
  final String? deviceId;

  /// 同步状态：0=已同步、1=待上传、2=待下载、3=冲突
  final int syncStatus;

  /// 数据版本号
  final int version;

  /// 是否已删除（软删除标记）
  final bool isDeleted;

  /// 删除时间
  final DateTime? deletedAt;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const VaccineRecord({
    required this.id,
    required this.babyId,
    required this.vaccineLibraryId,
    required this.actualDate,
    this.batchNumber,
    this.manufacturer,
    this.hospital,
    this.injectionSite,
    this.reactionLevel,
    this.reactionDetail,
    this.reactionOnset,
    this.notes,
    required this.status,
    this.serverId,
    this.deviceId,
    required this.syncStatus,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baby_id'] = Variable<int>(babyId);
    map['vaccine_library_id'] = Variable<int>(vaccineLibraryId);
    map['actual_date'] = Variable<DateTime>(actualDate);
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || hospital != null) {
      map['hospital'] = Variable<String>(hospital);
    }
    if (!nullToAbsent || injectionSite != null) {
      map['injection_site'] = Variable<int>(injectionSite);
    }
    if (!nullToAbsent || reactionLevel != null) {
      map['reaction_level'] = Variable<int>(reactionLevel);
    }
    if (!nullToAbsent || reactionDetail != null) {
      map['reaction_detail'] = Variable<String>(reactionDetail);
    }
    if (!nullToAbsent || reactionOnset != null) {
      map['reaction_onset'] = Variable<int>(reactionOnset);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VaccineRecordsCompanion toCompanion(bool nullToAbsent) {
    return VaccineRecordsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      vaccineLibraryId: Value(vaccineLibraryId),
      actualDate: Value(actualDate),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      hospital: hospital == null && nullToAbsent
          ? const Value.absent()
          : Value(hospital),
      injectionSite: injectionSite == null && nullToAbsent
          ? const Value.absent()
          : Value(injectionSite),
      reactionLevel: reactionLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionLevel),
      reactionDetail: reactionDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionDetail),
      reactionOnset: reactionOnset == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionOnset),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      syncStatus: Value(syncStatus),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VaccineRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccineRecord(
      id: serializer.fromJson<int>(json['id']),
      babyId: serializer.fromJson<int>(json['babyId']),
      vaccineLibraryId: serializer.fromJson<int>(json['vaccineLibraryId']),
      actualDate: serializer.fromJson<DateTime>(json['actualDate']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      hospital: serializer.fromJson<String?>(json['hospital']),
      injectionSite: serializer.fromJson<int?>(json['injectionSite']),
      reactionLevel: serializer.fromJson<int?>(json['reactionLevel']),
      reactionDetail: serializer.fromJson<String?>(json['reactionDetail']),
      reactionOnset: serializer.fromJson<int?>(json['reactionOnset']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<int>(json['status']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'babyId': serializer.toJson<int>(babyId),
      'vaccineLibraryId': serializer.toJson<int>(vaccineLibraryId),
      'actualDate': serializer.toJson<DateTime>(actualDate),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'hospital': serializer.toJson<String?>(hospital),
      'injectionSite': serializer.toJson<int?>(injectionSite),
      'reactionLevel': serializer.toJson<int?>(reactionLevel),
      'reactionDetail': serializer.toJson<String?>(reactionDetail),
      'reactionOnset': serializer.toJson<int?>(reactionOnset),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<int>(status),
      'serverId': serializer.toJson<String?>(serverId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VaccineRecord copyWith({
    int? id,
    int? babyId,
    int? vaccineLibraryId,
    DateTime? actualDate,
    Value<String?> batchNumber = const Value.absent(),
    Value<String?> manufacturer = const Value.absent(),
    Value<String?> hospital = const Value.absent(),
    Value<int?> injectionSite = const Value.absent(),
    Value<int?> reactionLevel = const Value.absent(),
    Value<String?> reactionDetail = const Value.absent(),
    Value<int?> reactionOnset = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? status,
    Value<String?> serverId = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    int? syncStatus,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VaccineRecord(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    vaccineLibraryId: vaccineLibraryId ?? this.vaccineLibraryId,
    actualDate: actualDate ?? this.actualDate,
    batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    hospital: hospital.present ? hospital.value : this.hospital,
    injectionSite: injectionSite.present
        ? injectionSite.value
        : this.injectionSite,
    reactionLevel: reactionLevel.present
        ? reactionLevel.value
        : this.reactionLevel,
    reactionDetail: reactionDetail.present
        ? reactionDetail.value
        : this.reactionDetail,
    reactionOnset: reactionOnset.present
        ? reactionOnset.value
        : this.reactionOnset,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    serverId: serverId.present ? serverId.value : this.serverId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VaccineRecord copyWithCompanion(VaccineRecordsCompanion data) {
    return VaccineRecord(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      vaccineLibraryId: data.vaccineLibraryId.present
          ? data.vaccineLibraryId.value
          : this.vaccineLibraryId,
      actualDate: data.actualDate.present
          ? data.actualDate.value
          : this.actualDate,
      batchNumber: data.batchNumber.present
          ? data.batchNumber.value
          : this.batchNumber,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      hospital: data.hospital.present ? data.hospital.value : this.hospital,
      injectionSite: data.injectionSite.present
          ? data.injectionSite.value
          : this.injectionSite,
      reactionLevel: data.reactionLevel.present
          ? data.reactionLevel.value
          : this.reactionLevel,
      reactionDetail: data.reactionDetail.present
          ? data.reactionDetail.value
          : this.reactionDetail,
      reactionOnset: data.reactionOnset.present
          ? data.reactionOnset.value
          : this.reactionOnset,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccineRecord(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('vaccineLibraryId: $vaccineLibraryId, ')
          ..write('actualDate: $actualDate, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('hospital: $hospital, ')
          ..write('injectionSite: $injectionSite, ')
          ..write('reactionLevel: $reactionLevel, ')
          ..write('reactionDetail: $reactionDetail, ')
          ..write('reactionOnset: $reactionOnset, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    babyId,
    vaccineLibraryId,
    actualDate,
    batchNumber,
    manufacturer,
    hospital,
    injectionSite,
    reactionLevel,
    reactionDetail,
    reactionOnset,
    notes,
    status,
    serverId,
    deviceId,
    syncStatus,
    version,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccineRecord &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.vaccineLibraryId == this.vaccineLibraryId &&
          other.actualDate == this.actualDate &&
          other.batchNumber == this.batchNumber &&
          other.manufacturer == this.manufacturer &&
          other.hospital == this.hospital &&
          other.injectionSite == this.injectionSite &&
          other.reactionLevel == this.reactionLevel &&
          other.reactionDetail == this.reactionDetail &&
          other.reactionOnset == this.reactionOnset &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.serverId == this.serverId &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaccineRecordsCompanion extends UpdateCompanion<VaccineRecord> {
  final Value<int> id;
  final Value<int> babyId;
  final Value<int> vaccineLibraryId;
  final Value<DateTime> actualDate;
  final Value<String?> batchNumber;
  final Value<String?> manufacturer;
  final Value<String?> hospital;
  final Value<int?> injectionSite;
  final Value<int?> reactionLevel;
  final Value<String?> reactionDetail;
  final Value<int?> reactionOnset;
  final Value<String?> notes;
  final Value<int> status;
  final Value<String?> serverId;
  final Value<String?> deviceId;
  final Value<int> syncStatus;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VaccineRecordsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.vaccineLibraryId = const Value.absent(),
    this.actualDate = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.hospital = const Value.absent(),
    this.injectionSite = const Value.absent(),
    this.reactionLevel = const Value.absent(),
    this.reactionDetail = const Value.absent(),
    this.reactionOnset = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VaccineRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int babyId,
    required int vaccineLibraryId,
    required DateTime actualDate,
    this.batchNumber = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.hospital = const Value.absent(),
    this.injectionSite = const Value.absent(),
    this.reactionLevel = const Value.absent(),
    this.reactionDetail = const Value.absent(),
    this.reactionOnset = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.serverId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : babyId = Value(babyId),
       vaccineLibraryId = Value(vaccineLibraryId),
       actualDate = Value(actualDate);
  static Insertable<VaccineRecord> custom({
    Expression<int>? id,
    Expression<int>? babyId,
    Expression<int>? vaccineLibraryId,
    Expression<DateTime>? actualDate,
    Expression<String>? batchNumber,
    Expression<String>? manufacturer,
    Expression<String>? hospital,
    Expression<int>? injectionSite,
    Expression<int>? reactionLevel,
    Expression<String>? reactionDetail,
    Expression<int>? reactionOnset,
    Expression<String>? notes,
    Expression<int>? status,
    Expression<String>? serverId,
    Expression<String>? deviceId,
    Expression<int>? syncStatus,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (vaccineLibraryId != null) 'vaccine_library_id': vaccineLibraryId,
      if (actualDate != null) 'actual_date': actualDate,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (hospital != null) 'hospital': hospital,
      if (injectionSite != null) 'injection_site': injectionSite,
      if (reactionLevel != null) 'reaction_level': reactionLevel,
      if (reactionDetail != null) 'reaction_detail': reactionDetail,
      if (reactionOnset != null) 'reaction_onset': reactionOnset,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (serverId != null) 'server_id': serverId,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VaccineRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? babyId,
    Value<int>? vaccineLibraryId,
    Value<DateTime>? actualDate,
    Value<String?>? batchNumber,
    Value<String?>? manufacturer,
    Value<String?>? hospital,
    Value<int?>? injectionSite,
    Value<int?>? reactionLevel,
    Value<String?>? reactionDetail,
    Value<int?>? reactionOnset,
    Value<String?>? notes,
    Value<int>? status,
    Value<String?>? serverId,
    Value<String?>? deviceId,
    Value<int>? syncStatus,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VaccineRecordsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      vaccineLibraryId: vaccineLibraryId ?? this.vaccineLibraryId,
      actualDate: actualDate ?? this.actualDate,
      batchNumber: batchNumber ?? this.batchNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      hospital: hospital ?? this.hospital,
      injectionSite: injectionSite ?? this.injectionSite,
      reactionLevel: reactionLevel ?? this.reactionLevel,
      reactionDetail: reactionDetail ?? this.reactionDetail,
      reactionOnset: reactionOnset ?? this.reactionOnset,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      serverId: serverId ?? this.serverId,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (vaccineLibraryId.present) {
      map['vaccine_library_id'] = Variable<int>(vaccineLibraryId.value);
    }
    if (actualDate.present) {
      map['actual_date'] = Variable<DateTime>(actualDate.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (hospital.present) {
      map['hospital'] = Variable<String>(hospital.value);
    }
    if (injectionSite.present) {
      map['injection_site'] = Variable<int>(injectionSite.value);
    }
    if (reactionLevel.present) {
      map['reaction_level'] = Variable<int>(reactionLevel.value);
    }
    if (reactionDetail.present) {
      map['reaction_detail'] = Variable<String>(reactionDetail.value);
    }
    if (reactionOnset.present) {
      map['reaction_onset'] = Variable<int>(reactionOnset.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccineRecordsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('vaccineLibraryId: $vaccineLibraryId, ')
          ..write('actualDate: $actualDate, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('hospital: $hospital, ')
          ..write('injectionSite: $injectionSite, ')
          ..write('reactionLevel: $reactionLevel, ')
          ..write('reactionDetail: $reactionDetail, ')
          ..write('reactionOnset: $reactionOnset, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('serverId: $serverId, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AgeBenchmarkDataTable extends AgeBenchmarkData
    with TableInfo<$AgeBenchmarkDataTable, AgeBenchmarkDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgeBenchmarkDataTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ageMonthsMeta = const VerificationMeta(
    'ageMonths',
  );
  @override
  late final GeneratedColumn<int> ageMonths = GeneratedColumn<int>(
    'age_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMedianMeta = const VerificationMeta(
    'weightMedian',
  );
  @override
  late final GeneratedColumn<double> weightMedian = GeneratedColumn<double>(
    'weight_median',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightP3Meta = const VerificationMeta(
    'weightP3',
  );
  @override
  late final GeneratedColumn<double> weightP3 = GeneratedColumn<double>(
    'weight_p3',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightP97Meta = const VerificationMeta(
    'weightP97',
  );
  @override
  late final GeneratedColumn<double> weightP97 = GeneratedColumn<double>(
    'weight_p97',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMedianMeta = const VerificationMeta(
    'heightMedian',
  );
  @override
  late final GeneratedColumn<double> heightMedian = GeneratedColumn<double>(
    'height_median',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightP3Meta = const VerificationMeta(
    'heightP3',
  );
  @override
  late final GeneratedColumn<double> heightP3 = GeneratedColumn<double>(
    'height_p3',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightP97Meta = const VerificationMeta(
    'heightP97',
  );
  @override
  late final GeneratedColumn<double> heightP97 = GeneratedColumn<double>(
    'height_p97',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headCircumferenceMedianMeta =
      const VerificationMeta('headCircumferenceMedian');
  @override
  late final GeneratedColumn<double> headCircumferenceMedian =
      GeneratedColumn<double>(
        'head_circumference_median',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _headCircumferenceP3Meta =
      const VerificationMeta('headCircumferenceP3');
  @override
  late final GeneratedColumn<double> headCircumferenceP3 =
      GeneratedColumn<double>(
        'head_circumference_p3',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _headCircumferenceP97Meta =
      const VerificationMeta('headCircumferenceP97');
  @override
  late final GeneratedColumn<double> headCircumferenceP97 =
      GeneratedColumn<double>(
        'head_circumference_p97',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataVersionMeta = const VerificationMeta(
    'dataVersion',
  );
  @override
  late final GeneratedColumn<int> dataVersion = GeneratedColumn<int>(
    'data_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ageMonths,
    gender,
    weightMedian,
    weightP3,
    weightP97,
    heightMedian,
    heightP3,
    heightP97,
    headCircumferenceMedian,
    headCircumferenceP3,
    headCircumferenceP97,
    dataVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'age_benchmark_data';
  @override
  VerificationContext validateIntegrity(
    Insertable<AgeBenchmarkDataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('age_months')) {
      context.handle(
        _ageMonthsMeta,
        ageMonths.isAcceptableOrUnknown(data['age_months']!, _ageMonthsMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMonthsMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('weight_median')) {
      context.handle(
        _weightMedianMeta,
        weightMedian.isAcceptableOrUnknown(
          data['weight_median']!,
          _weightMedianMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightMedianMeta);
    }
    if (data.containsKey('weight_p3')) {
      context.handle(
        _weightP3Meta,
        weightP3.isAcceptableOrUnknown(data['weight_p3']!, _weightP3Meta),
      );
    } else if (isInserting) {
      context.missing(_weightP3Meta);
    }
    if (data.containsKey('weight_p97')) {
      context.handle(
        _weightP97Meta,
        weightP97.isAcceptableOrUnknown(data['weight_p97']!, _weightP97Meta),
      );
    } else if (isInserting) {
      context.missing(_weightP97Meta);
    }
    if (data.containsKey('height_median')) {
      context.handle(
        _heightMedianMeta,
        heightMedian.isAcceptableOrUnknown(
          data['height_median']!,
          _heightMedianMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_heightMedianMeta);
    }
    if (data.containsKey('height_p3')) {
      context.handle(
        _heightP3Meta,
        heightP3.isAcceptableOrUnknown(data['height_p3']!, _heightP3Meta),
      );
    } else if (isInserting) {
      context.missing(_heightP3Meta);
    }
    if (data.containsKey('height_p97')) {
      context.handle(
        _heightP97Meta,
        heightP97.isAcceptableOrUnknown(data['height_p97']!, _heightP97Meta),
      );
    } else if (isInserting) {
      context.missing(_heightP97Meta);
    }
    if (data.containsKey('head_circumference_median')) {
      context.handle(
        _headCircumferenceMedianMeta,
        headCircumferenceMedian.isAcceptableOrUnknown(
          data['head_circumference_median']!,
          _headCircumferenceMedianMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_headCircumferenceMedianMeta);
    }
    if (data.containsKey('head_circumference_p3')) {
      context.handle(
        _headCircumferenceP3Meta,
        headCircumferenceP3.isAcceptableOrUnknown(
          data['head_circumference_p3']!,
          _headCircumferenceP3Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_headCircumferenceP3Meta);
    }
    if (data.containsKey('head_circumference_p97')) {
      context.handle(
        _headCircumferenceP97Meta,
        headCircumferenceP97.isAcceptableOrUnknown(
          data['head_circumference_p97']!,
          _headCircumferenceP97Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_headCircumferenceP97Meta);
    }
    if (data.containsKey('data_version')) {
      context.handle(
        _dataVersionMeta,
        dataVersion.isAcceptableOrUnknown(
          data['data_version']!,
          _dataVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {ageMonths, gender},
  ];
  @override
  AgeBenchmarkDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgeBenchmarkDataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ageMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_months'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gender'],
      )!,
      weightMedian: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_median'],
      )!,
      weightP3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_p3'],
      )!,
      weightP97: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_p97'],
      )!,
      heightMedian: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_median'],
      )!,
      heightP3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_p3'],
      )!,
      heightP97: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_p97'],
      )!,
      headCircumferenceMedian: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}head_circumference_median'],
      )!,
      headCircumferenceP3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}head_circumference_p3'],
      )!,
      headCircumferenceP97: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}head_circumference_p97'],
      )!,
      dataVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}data_version'],
      )!,
    );
  }

  @override
  $AgeBenchmarkDataTable createAlias(String alias) {
    return $AgeBenchmarkDataTable(attachedDatabase, alias);
  }
}

class AgeBenchmarkDataData extends DataClass
    implements Insertable<AgeBenchmarkDataData> {
  /// 主键ID
  final int id;

  /// 月龄（0-60个月）
  final int ageMonths;

  /// 性别：0=男、1=女
  final int gender;

  /// 体重中位数（kg）
  final double weightMedian;

  /// 体重P3百分位（kg）
  final double weightP3;

  /// 体重P97百分位（kg）
  final double weightP97;

  /// 身高中位数（cm）
  final double heightMedian;

  /// 身高P3百分位（cm）
  final double heightP3;

  /// 身高P97百分位（cm）
  final double heightP97;

  /// 头围中位数（cm）
  final double headCircumferenceMedian;

  /// 头围P3百分位（cm）
  final double headCircumferenceP3;

  /// 头围P97百分位（cm）
  final double headCircumferenceP97;

  /// 数据版本号（用于判断是否需要更新）
  final int dataVersion;
  const AgeBenchmarkDataData({
    required this.id,
    required this.ageMonths,
    required this.gender,
    required this.weightMedian,
    required this.weightP3,
    required this.weightP97,
    required this.heightMedian,
    required this.heightP3,
    required this.heightP97,
    required this.headCircumferenceMedian,
    required this.headCircumferenceP3,
    required this.headCircumferenceP97,
    required this.dataVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['age_months'] = Variable<int>(ageMonths);
    map['gender'] = Variable<int>(gender);
    map['weight_median'] = Variable<double>(weightMedian);
    map['weight_p3'] = Variable<double>(weightP3);
    map['weight_p97'] = Variable<double>(weightP97);
    map['height_median'] = Variable<double>(heightMedian);
    map['height_p3'] = Variable<double>(heightP3);
    map['height_p97'] = Variable<double>(heightP97);
    map['head_circumference_median'] = Variable<double>(
      headCircumferenceMedian,
    );
    map['head_circumference_p3'] = Variable<double>(headCircumferenceP3);
    map['head_circumference_p97'] = Variable<double>(headCircumferenceP97);
    map['data_version'] = Variable<int>(dataVersion);
    return map;
  }

  AgeBenchmarkDataCompanion toCompanion(bool nullToAbsent) {
    return AgeBenchmarkDataCompanion(
      id: Value(id),
      ageMonths: Value(ageMonths),
      gender: Value(gender),
      weightMedian: Value(weightMedian),
      weightP3: Value(weightP3),
      weightP97: Value(weightP97),
      heightMedian: Value(heightMedian),
      heightP3: Value(heightP3),
      heightP97: Value(heightP97),
      headCircumferenceMedian: Value(headCircumferenceMedian),
      headCircumferenceP3: Value(headCircumferenceP3),
      headCircumferenceP97: Value(headCircumferenceP97),
      dataVersion: Value(dataVersion),
    );
  }

  factory AgeBenchmarkDataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgeBenchmarkDataData(
      id: serializer.fromJson<int>(json['id']),
      ageMonths: serializer.fromJson<int>(json['ageMonths']),
      gender: serializer.fromJson<int>(json['gender']),
      weightMedian: serializer.fromJson<double>(json['weightMedian']),
      weightP3: serializer.fromJson<double>(json['weightP3']),
      weightP97: serializer.fromJson<double>(json['weightP97']),
      heightMedian: serializer.fromJson<double>(json['heightMedian']),
      heightP3: serializer.fromJson<double>(json['heightP3']),
      heightP97: serializer.fromJson<double>(json['heightP97']),
      headCircumferenceMedian: serializer.fromJson<double>(
        json['headCircumferenceMedian'],
      ),
      headCircumferenceP3: serializer.fromJson<double>(
        json['headCircumferenceP3'],
      ),
      headCircumferenceP97: serializer.fromJson<double>(
        json['headCircumferenceP97'],
      ),
      dataVersion: serializer.fromJson<int>(json['dataVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ageMonths': serializer.toJson<int>(ageMonths),
      'gender': serializer.toJson<int>(gender),
      'weightMedian': serializer.toJson<double>(weightMedian),
      'weightP3': serializer.toJson<double>(weightP3),
      'weightP97': serializer.toJson<double>(weightP97),
      'heightMedian': serializer.toJson<double>(heightMedian),
      'heightP3': serializer.toJson<double>(heightP3),
      'heightP97': serializer.toJson<double>(heightP97),
      'headCircumferenceMedian': serializer.toJson<double>(
        headCircumferenceMedian,
      ),
      'headCircumferenceP3': serializer.toJson<double>(headCircumferenceP3),
      'headCircumferenceP97': serializer.toJson<double>(headCircumferenceP97),
      'dataVersion': serializer.toJson<int>(dataVersion),
    };
  }

  AgeBenchmarkDataData copyWith({
    int? id,
    int? ageMonths,
    int? gender,
    double? weightMedian,
    double? weightP3,
    double? weightP97,
    double? heightMedian,
    double? heightP3,
    double? heightP97,
    double? headCircumferenceMedian,
    double? headCircumferenceP3,
    double? headCircumferenceP97,
    int? dataVersion,
  }) => AgeBenchmarkDataData(
    id: id ?? this.id,
    ageMonths: ageMonths ?? this.ageMonths,
    gender: gender ?? this.gender,
    weightMedian: weightMedian ?? this.weightMedian,
    weightP3: weightP3 ?? this.weightP3,
    weightP97: weightP97 ?? this.weightP97,
    heightMedian: heightMedian ?? this.heightMedian,
    heightP3: heightP3 ?? this.heightP3,
    heightP97: heightP97 ?? this.heightP97,
    headCircumferenceMedian:
        headCircumferenceMedian ?? this.headCircumferenceMedian,
    headCircumferenceP3: headCircumferenceP3 ?? this.headCircumferenceP3,
    headCircumferenceP97: headCircumferenceP97 ?? this.headCircumferenceP97,
    dataVersion: dataVersion ?? this.dataVersion,
  );
  AgeBenchmarkDataData copyWithCompanion(AgeBenchmarkDataCompanion data) {
    return AgeBenchmarkDataData(
      id: data.id.present ? data.id.value : this.id,
      ageMonths: data.ageMonths.present ? data.ageMonths.value : this.ageMonths,
      gender: data.gender.present ? data.gender.value : this.gender,
      weightMedian: data.weightMedian.present
          ? data.weightMedian.value
          : this.weightMedian,
      weightP3: data.weightP3.present ? data.weightP3.value : this.weightP3,
      weightP97: data.weightP97.present ? data.weightP97.value : this.weightP97,
      heightMedian: data.heightMedian.present
          ? data.heightMedian.value
          : this.heightMedian,
      heightP3: data.heightP3.present ? data.heightP3.value : this.heightP3,
      heightP97: data.heightP97.present ? data.heightP97.value : this.heightP97,
      headCircumferenceMedian: data.headCircumferenceMedian.present
          ? data.headCircumferenceMedian.value
          : this.headCircumferenceMedian,
      headCircumferenceP3: data.headCircumferenceP3.present
          ? data.headCircumferenceP3.value
          : this.headCircumferenceP3,
      headCircumferenceP97: data.headCircumferenceP97.present
          ? data.headCircumferenceP97.value
          : this.headCircumferenceP97,
      dataVersion: data.dataVersion.present
          ? data.dataVersion.value
          : this.dataVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgeBenchmarkDataData(')
          ..write('id: $id, ')
          ..write('ageMonths: $ageMonths, ')
          ..write('gender: $gender, ')
          ..write('weightMedian: $weightMedian, ')
          ..write('weightP3: $weightP3, ')
          ..write('weightP97: $weightP97, ')
          ..write('heightMedian: $heightMedian, ')
          ..write('heightP3: $heightP3, ')
          ..write('heightP97: $heightP97, ')
          ..write('headCircumferenceMedian: $headCircumferenceMedian, ')
          ..write('headCircumferenceP3: $headCircumferenceP3, ')
          ..write('headCircumferenceP97: $headCircumferenceP97, ')
          ..write('dataVersion: $dataVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ageMonths,
    gender,
    weightMedian,
    weightP3,
    weightP97,
    heightMedian,
    heightP3,
    heightP97,
    headCircumferenceMedian,
    headCircumferenceP3,
    headCircumferenceP97,
    dataVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgeBenchmarkDataData &&
          other.id == this.id &&
          other.ageMonths == this.ageMonths &&
          other.gender == this.gender &&
          other.weightMedian == this.weightMedian &&
          other.weightP3 == this.weightP3 &&
          other.weightP97 == this.weightP97 &&
          other.heightMedian == this.heightMedian &&
          other.heightP3 == this.heightP3 &&
          other.heightP97 == this.heightP97 &&
          other.headCircumferenceMedian == this.headCircumferenceMedian &&
          other.headCircumferenceP3 == this.headCircumferenceP3 &&
          other.headCircumferenceP97 == this.headCircumferenceP97 &&
          other.dataVersion == this.dataVersion);
}

class AgeBenchmarkDataCompanion extends UpdateCompanion<AgeBenchmarkDataData> {
  final Value<int> id;
  final Value<int> ageMonths;
  final Value<int> gender;
  final Value<double> weightMedian;
  final Value<double> weightP3;
  final Value<double> weightP97;
  final Value<double> heightMedian;
  final Value<double> heightP3;
  final Value<double> heightP97;
  final Value<double> headCircumferenceMedian;
  final Value<double> headCircumferenceP3;
  final Value<double> headCircumferenceP97;
  final Value<int> dataVersion;
  const AgeBenchmarkDataCompanion({
    this.id = const Value.absent(),
    this.ageMonths = const Value.absent(),
    this.gender = const Value.absent(),
    this.weightMedian = const Value.absent(),
    this.weightP3 = const Value.absent(),
    this.weightP97 = const Value.absent(),
    this.heightMedian = const Value.absent(),
    this.heightP3 = const Value.absent(),
    this.heightP97 = const Value.absent(),
    this.headCircumferenceMedian = const Value.absent(),
    this.headCircumferenceP3 = const Value.absent(),
    this.headCircumferenceP97 = const Value.absent(),
    this.dataVersion = const Value.absent(),
  });
  AgeBenchmarkDataCompanion.insert({
    this.id = const Value.absent(),
    required int ageMonths,
    required int gender,
    required double weightMedian,
    required double weightP3,
    required double weightP97,
    required double heightMedian,
    required double heightP3,
    required double heightP97,
    required double headCircumferenceMedian,
    required double headCircumferenceP3,
    required double headCircumferenceP97,
    this.dataVersion = const Value.absent(),
  }) : ageMonths = Value(ageMonths),
       gender = Value(gender),
       weightMedian = Value(weightMedian),
       weightP3 = Value(weightP3),
       weightP97 = Value(weightP97),
       heightMedian = Value(heightMedian),
       heightP3 = Value(heightP3),
       heightP97 = Value(heightP97),
       headCircumferenceMedian = Value(headCircumferenceMedian),
       headCircumferenceP3 = Value(headCircumferenceP3),
       headCircumferenceP97 = Value(headCircumferenceP97);
  static Insertable<AgeBenchmarkDataData> custom({
    Expression<int>? id,
    Expression<int>? ageMonths,
    Expression<int>? gender,
    Expression<double>? weightMedian,
    Expression<double>? weightP3,
    Expression<double>? weightP97,
    Expression<double>? heightMedian,
    Expression<double>? heightP3,
    Expression<double>? heightP97,
    Expression<double>? headCircumferenceMedian,
    Expression<double>? headCircumferenceP3,
    Expression<double>? headCircumferenceP97,
    Expression<int>? dataVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ageMonths != null) 'age_months': ageMonths,
      if (gender != null) 'gender': gender,
      if (weightMedian != null) 'weight_median': weightMedian,
      if (weightP3 != null) 'weight_p3': weightP3,
      if (weightP97 != null) 'weight_p97': weightP97,
      if (heightMedian != null) 'height_median': heightMedian,
      if (heightP3 != null) 'height_p3': heightP3,
      if (heightP97 != null) 'height_p97': heightP97,
      if (headCircumferenceMedian != null)
        'head_circumference_median': headCircumferenceMedian,
      if (headCircumferenceP3 != null)
        'head_circumference_p3': headCircumferenceP3,
      if (headCircumferenceP97 != null)
        'head_circumference_p97': headCircumferenceP97,
      if (dataVersion != null) 'data_version': dataVersion,
    });
  }

  AgeBenchmarkDataCompanion copyWith({
    Value<int>? id,
    Value<int>? ageMonths,
    Value<int>? gender,
    Value<double>? weightMedian,
    Value<double>? weightP3,
    Value<double>? weightP97,
    Value<double>? heightMedian,
    Value<double>? heightP3,
    Value<double>? heightP97,
    Value<double>? headCircumferenceMedian,
    Value<double>? headCircumferenceP3,
    Value<double>? headCircumferenceP97,
    Value<int>? dataVersion,
  }) {
    return AgeBenchmarkDataCompanion(
      id: id ?? this.id,
      ageMonths: ageMonths ?? this.ageMonths,
      gender: gender ?? this.gender,
      weightMedian: weightMedian ?? this.weightMedian,
      weightP3: weightP3 ?? this.weightP3,
      weightP97: weightP97 ?? this.weightP97,
      heightMedian: heightMedian ?? this.heightMedian,
      heightP3: heightP3 ?? this.heightP3,
      heightP97: heightP97 ?? this.heightP97,
      headCircumferenceMedian:
          headCircumferenceMedian ?? this.headCircumferenceMedian,
      headCircumferenceP3: headCircumferenceP3 ?? this.headCircumferenceP3,
      headCircumferenceP97: headCircumferenceP97 ?? this.headCircumferenceP97,
      dataVersion: dataVersion ?? this.dataVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ageMonths.present) {
      map['age_months'] = Variable<int>(ageMonths.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (weightMedian.present) {
      map['weight_median'] = Variable<double>(weightMedian.value);
    }
    if (weightP3.present) {
      map['weight_p3'] = Variable<double>(weightP3.value);
    }
    if (weightP97.present) {
      map['weight_p97'] = Variable<double>(weightP97.value);
    }
    if (heightMedian.present) {
      map['height_median'] = Variable<double>(heightMedian.value);
    }
    if (heightP3.present) {
      map['height_p3'] = Variable<double>(heightP3.value);
    }
    if (heightP97.present) {
      map['height_p97'] = Variable<double>(heightP97.value);
    }
    if (headCircumferenceMedian.present) {
      map['head_circumference_median'] = Variable<double>(
        headCircumferenceMedian.value,
      );
    }
    if (headCircumferenceP3.present) {
      map['head_circumference_p3'] = Variable<double>(
        headCircumferenceP3.value,
      );
    }
    if (headCircumferenceP97.present) {
      map['head_circumference_p97'] = Variable<double>(
        headCircumferenceP97.value,
      );
    }
    if (dataVersion.present) {
      map['data_version'] = Variable<int>(dataVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgeBenchmarkDataCompanion(')
          ..write('id: $id, ')
          ..write('ageMonths: $ageMonths, ')
          ..write('gender: $gender, ')
          ..write('weightMedian: $weightMedian, ')
          ..write('weightP3: $weightP3, ')
          ..write('weightP97: $weightP97, ')
          ..write('heightMedian: $heightMedian, ')
          ..write('heightP3: $heightP3, ')
          ..write('heightP97: $heightP97, ')
          ..write('headCircumferenceMedian: $headCircumferenceMedian, ')
          ..write('headCircumferenceP3: $headCircumferenceP3, ')
          ..write('headCircumferenceP97: $headCircumferenceP97, ')
          ..write('dataVersion: $dataVersion')
          ..write(')'))
        .toString();
  }
}

abstract class _$TestDatabase extends GeneratedDatabase {
  _$TestDatabase(QueryExecutor e) : super(e);
  $TestDatabaseManager get managers => $TestDatabaseManager(this);
  late final $TestRecordsTable testRecords = $TestRecordsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $FamiliesTable families = $FamiliesTable(this);
  late final $FamilyMembersTable familyMembers = $FamilyMembersTable(this);
  late final $BabiesTable babies = $BabiesTable(this);
  late final $ActivityRecordsTable activityRecords = $ActivityRecordsTable(
    this,
  );
  late final $GrowthRecordsTable growthRecords = $GrowthRecordsTable(this);
  late final $VaccineLibraryTable vaccineLibrary = $VaccineLibraryTable(this);
  late final $VaccineRecordsTable vaccineRecords = $VaccineRecordsTable(this);
  late final $AgeBenchmarkDataTable ageBenchmarkData = $AgeBenchmarkDataTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    testRecords,
    users,
    families,
    familyMembers,
    babies,
    activityRecords,
    growthRecords,
    vaccineLibrary,
    vaccineRecords,
    ageBenchmarkData,
  ];
}

typedef $$TestRecordsTableCreateCompanionBuilder =
    TestRecordsCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$TestRecordsTableUpdateCompanionBuilder =
    TestRecordsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

class $$TestRecordsTableFilterComposer
    extends Composer<_$TestDatabase, $TestRecordsTable> {
  $$TestRecordsTableFilterComposer({
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
}

class $$TestRecordsTableOrderingComposer
    extends Composer<_$TestDatabase, $TestRecordsTable> {
  $$TestRecordsTableOrderingComposer({
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
}

class $$TestRecordsTableAnnotationComposer
    extends Composer<_$TestDatabase, $TestRecordsTable> {
  $$TestRecordsTableAnnotationComposer({
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
}

class $$TestRecordsTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $TestRecordsTable,
          TestRecord,
          $$TestRecordsTableFilterComposer,
          $$TestRecordsTableOrderingComposer,
          $$TestRecordsTableAnnotationComposer,
          $$TestRecordsTableCreateCompanionBuilder,
          $$TestRecordsTableUpdateCompanionBuilder,
          (
            TestRecord,
            BaseReferences<_$TestDatabase, $TestRecordsTable, TestRecord>,
          ),
          TestRecord,
          PrefetchHooks Function()
        > {
  $$TestRecordsTableTableManager(_$TestDatabase db, $TestRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TestRecordsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TestRecordsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TestRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $TestRecordsTable,
      TestRecord,
      $$TestRecordsTableFilterComposer,
      $$TestRecordsTableOrderingComposer,
      $$TestRecordsTableAnnotationComposer,
      $$TestRecordsTableCreateCompanionBuilder,
      $$TestRecordsTableUpdateCompanionBuilder,
      (
        TestRecord,
        BaseReferences<_$TestDatabase, $TestRecordsTable, TestRecord>,
      ),
      TestRecord,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String?> phone,
      Value<String?> email,
      required String nickname,
      Value<String?> avatarUrl,
      Value<String?> serverId,
      Value<DateTime?> lastSyncAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isGuest,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String?> phone,
      Value<String?> email,
      Value<String> nickname,
      Value<String?> avatarUrl,
      Value<String?> serverId,
      Value<DateTime?> lastSyncAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isGuest,
    });

class $$UsersTableFilterComposer extends Composer<_$TestDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$TestDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$TestDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isGuest =>
      $composableBuilder(column: $table.isGuest, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$TestDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$TestDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isGuest = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                phone: phone,
                email: email,
                nickname: nickname,
                avatarUrl: avatarUrl,
                serverId: serverId,
                lastSyncAt: lastSyncAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isGuest: isGuest,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required String nickname,
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isGuest = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                phone: phone,
                email: email,
                nickname: nickname,
                avatarUrl: avatarUrl,
                serverId: serverId,
                lastSyncAt: lastSyncAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isGuest: isGuest,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$TestDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$FamiliesTableCreateCompanionBuilder =
    FamiliesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> inviteCode,
      Value<int?> ownerId,
      Value<String?> serverId,
      Value<DateTime?> lastSyncAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
    });
typedef $$FamiliesTableUpdateCompanionBuilder =
    FamiliesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> inviteCode,
      Value<int?> ownerId,
      Value<String?> serverId,
      Value<DateTime?> lastSyncAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
    });

class $$FamiliesTableFilterComposer
    extends Composer<_$TestDatabase, $FamiliesTable> {
  $$FamiliesTableFilterComposer({
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

  ColumnFilters<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamiliesTableOrderingComposer
    extends Composer<_$TestDatabase, $FamiliesTable> {
  $$FamiliesTableOrderingComposer({
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

  ColumnOrderings<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamiliesTableAnnotationComposer
    extends Composer<_$TestDatabase, $FamiliesTable> {
  $$FamiliesTableAnnotationComposer({
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

  GeneratedColumn<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FamiliesTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $FamiliesTable,
          Family,
          $$FamiliesTableFilterComposer,
          $$FamiliesTableOrderingComposer,
          $$FamiliesTableAnnotationComposer,
          $$FamiliesTableCreateCompanionBuilder,
          $$FamiliesTableUpdateCompanionBuilder,
          (Family, BaseReferences<_$TestDatabase, $FamiliesTable, Family>),
          Family,
          PrefetchHooks Function()
        > {
  $$FamiliesTableTableManager(_$TestDatabase db, $FamiliesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamiliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamiliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamiliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> inviteCode = const Value.absent(),
                Value<int?> ownerId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FamiliesCompanion(
                id: id,
                name: name,
                inviteCode: inviteCode,
                ownerId: ownerId,
                serverId: serverId,
                lastSyncAt: lastSyncAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> inviteCode = const Value.absent(),
                Value<int?> ownerId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FamiliesCompanion.insert(
                id: id,
                name: name,
                inviteCode: inviteCode,
                ownerId: ownerId,
                serverId: serverId,
                lastSyncAt: lastSyncAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamiliesTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $FamiliesTable,
      Family,
      $$FamiliesTableFilterComposer,
      $$FamiliesTableOrderingComposer,
      $$FamiliesTableAnnotationComposer,
      $$FamiliesTableCreateCompanionBuilder,
      $$FamiliesTableUpdateCompanionBuilder,
      (Family, BaseReferences<_$TestDatabase, $FamiliesTable, Family>),
      Family,
      PrefetchHooks Function()
    >;
typedef $$FamilyMembersTableCreateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<int> id,
      required int familyId,
      required int userId,
      Value<int> role,
      Value<String?> serverId,
      Value<DateTime> joinedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
    });
typedef $$FamilyMembersTableUpdateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<int> id,
      Value<int> familyId,
      Value<int> userId,
      Value<int> role,
      Value<String?> serverId,
      Value<DateTime> joinedAt,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
    });

class $$FamilyMembersTableFilterComposer
    extends Composer<_$TestDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableFilterComposer({
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

  ColumnFilters<int> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyMembersTableOrderingComposer
    extends Composer<_$TestDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableOrderingComposer({
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

  ColumnOrderings<int> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyMembersTableAnnotationComposer
    extends Composer<_$TestDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$FamilyMembersTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $FamilyMembersTable,
          FamilyMember,
          $$FamilyMembersTableFilterComposer,
          $$FamilyMembersTableOrderingComposer,
          $$FamilyMembersTableAnnotationComposer,
          $$FamilyMembersTableCreateCompanionBuilder,
          $$FamilyMembersTableUpdateCompanionBuilder,
          (
            FamilyMember,
            BaseReferences<_$TestDatabase, $FamilyMembersTable, FamilyMember>,
          ),
          FamilyMember,
          PrefetchHooks Function()
        > {
  $$FamilyMembersTableTableManager(_$TestDatabase db, $FamilyMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> familyId = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> role = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => FamilyMembersCompanion(
                id: id,
                familyId: familyId,
                userId: userId,
                role: role,
                serverId: serverId,
                joinedAt: joinedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int familyId,
                required int userId,
                Value<int> role = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => FamilyMembersCompanion.insert(
                id: id,
                familyId: familyId,
                userId: userId,
                role: role,
                serverId: serverId,
                joinedAt: joinedAt,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $FamilyMembersTable,
      FamilyMember,
      $$FamilyMembersTableFilterComposer,
      $$FamilyMembersTableOrderingComposer,
      $$FamilyMembersTableAnnotationComposer,
      $$FamilyMembersTableCreateCompanionBuilder,
      $$FamilyMembersTableUpdateCompanionBuilder,
      (
        FamilyMember,
        BaseReferences<_$TestDatabase, $FamilyMembersTable, FamilyMember>,
      ),
      FamilyMember,
      PrefetchHooks Function()
    >;
typedef $$BabiesTableCreateCompanionBuilder =
    BabiesCompanion Function({
      Value<int> id,
      Value<int?> familyId,
      required String name,
      required DateTime birthDate,
      Value<int> gender,
      Value<String?> avatarUrl,
      Value<double?> birthWeight,
      Value<double?> birthHeight,
      Value<double?> birthHeadCircumference,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BabiesTableUpdateCompanionBuilder =
    BabiesCompanion Function({
      Value<int> id,
      Value<int?> familyId,
      Value<String> name,
      Value<DateTime> birthDate,
      Value<int> gender,
      Value<String?> avatarUrl,
      Value<double?> birthWeight,
      Value<double?> birthHeight,
      Value<double?> birthHeadCircumference,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BabiesTableFilterComposer
    extends Composer<_$TestDatabase, $BabiesTable> {
  $$BabiesTableFilterComposer({
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

  ColumnFilters<int> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthWeight => $composableBuilder(
    column: $table.birthWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthHeight => $composableBuilder(
    column: $table.birthHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthHeadCircumference => $composableBuilder(
    column: $table.birthHeadCircumference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BabiesTableOrderingComposer
    extends Composer<_$TestDatabase, $BabiesTable> {
  $$BabiesTableOrderingComposer({
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

  ColumnOrderings<int> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthWeight => $composableBuilder(
    column: $table.birthWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthHeight => $composableBuilder(
    column: $table.birthHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthHeadCircumference => $composableBuilder(
    column: $table.birthHeadCircumference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BabiesTableAnnotationComposer
    extends Composer<_$TestDatabase, $BabiesTable> {
  $$BabiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<double> get birthWeight => $composableBuilder(
    column: $table.birthWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthHeight => $composableBuilder(
    column: $table.birthHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthHeadCircumference => $composableBuilder(
    column: $table.birthHeadCircumference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BabiesTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $BabiesTable,
          Baby,
          $$BabiesTableFilterComposer,
          $$BabiesTableOrderingComposer,
          $$BabiesTableAnnotationComposer,
          $$BabiesTableCreateCompanionBuilder,
          $$BabiesTableUpdateCompanionBuilder,
          (Baby, BaseReferences<_$TestDatabase, $BabiesTable, Baby>),
          Baby,
          PrefetchHooks Function()
        > {
  $$BabiesTableTableManager(_$TestDatabase db, $BabiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BabiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BabiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BabiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> familyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<double?> birthWeight = const Value.absent(),
                Value<double?> birthHeight = const Value.absent(),
                Value<double?> birthHeadCircumference = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BabiesCompanion(
                id: id,
                familyId: familyId,
                name: name,
                birthDate: birthDate,
                gender: gender,
                avatarUrl: avatarUrl,
                birthWeight: birthWeight,
                birthHeight: birthHeight,
                birthHeadCircumference: birthHeadCircumference,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> familyId = const Value.absent(),
                required String name,
                required DateTime birthDate,
                Value<int> gender = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<double?> birthWeight = const Value.absent(),
                Value<double?> birthHeight = const Value.absent(),
                Value<double?> birthHeadCircumference = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BabiesCompanion.insert(
                id: id,
                familyId: familyId,
                name: name,
                birthDate: birthDate,
                gender: gender,
                avatarUrl: avatarUrl,
                birthWeight: birthWeight,
                birthHeight: birthHeight,
                birthHeadCircumference: birthHeadCircumference,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BabiesTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $BabiesTable,
      Baby,
      $$BabiesTableFilterComposer,
      $$BabiesTableOrderingComposer,
      $$BabiesTableAnnotationComposer,
      $$BabiesTableCreateCompanionBuilder,
      $$BabiesTableUpdateCompanionBuilder,
      (Baby, BaseReferences<_$TestDatabase, $BabiesTable, Baby>),
      Baby,
      PrefetchHooks Function()
    >;
typedef $$ActivityRecordsTableCreateCompanionBuilder =
    ActivityRecordsCompanion Function({
      Value<int> id,
      required int babyId,
      required int type,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<int?> durationSeconds,
      Value<String?> notes,
      Value<bool> isVerified,
      Value<int?> eatingMethod,
      Value<int?> breastSide,
      Value<int?> breastDurationMinutes,
      Value<int?> formulaAmountMl,
      Value<String?> foodType,
      Value<int?> sleepQuality,
      Value<int?> sleepLocation,
      Value<int?> sleepAssistMethod,
      Value<int?> activityType,
      Value<int?> mood,
      Value<int?> diaperType,
      Value<int?> stoolColor,
      Value<int?> stoolTexture,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ActivityRecordsTableUpdateCompanionBuilder =
    ActivityRecordsCompanion Function({
      Value<int> id,
      Value<int> babyId,
      Value<int> type,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<int?> durationSeconds,
      Value<String?> notes,
      Value<bool> isVerified,
      Value<int?> eatingMethod,
      Value<int?> breastSide,
      Value<int?> breastDurationMinutes,
      Value<int?> formulaAmountMl,
      Value<String?> foodType,
      Value<int?> sleepQuality,
      Value<int?> sleepLocation,
      Value<int?> sleepAssistMethod,
      Value<int?> activityType,
      Value<int?> mood,
      Value<int?> diaperType,
      Value<int?> stoolColor,
      Value<int?> stoolTexture,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ActivityRecordsTableFilterComposer
    extends Composer<_$TestDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableFilterComposer({
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

  ColumnFilters<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eatingMethod => $composableBuilder(
    column: $table.eatingMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breastSide => $composableBuilder(
    column: $table.breastSide,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breastDurationMinutes => $composableBuilder(
    column: $table.breastDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get formulaAmountMl => $composableBuilder(
    column: $table.formulaAmountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodType => $composableBuilder(
    column: $table.foodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepLocation => $composableBuilder(
    column: $table.sleepLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepAssistMethod => $composableBuilder(
    column: $table.sleepAssistMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaperType => $composableBuilder(
    column: $table.diaperType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stoolColor => $composableBuilder(
    column: $table.stoolColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stoolTexture => $composableBuilder(
    column: $table.stoolTexture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityRecordsTableOrderingComposer
    extends Composer<_$TestDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eatingMethod => $composableBuilder(
    column: $table.eatingMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breastSide => $composableBuilder(
    column: $table.breastSide,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breastDurationMinutes => $composableBuilder(
    column: $table.breastDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get formulaAmountMl => $composableBuilder(
    column: $table.formulaAmountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodType => $composableBuilder(
    column: $table.foodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepLocation => $composableBuilder(
    column: $table.sleepLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepAssistMethod => $composableBuilder(
    column: $table.sleepAssistMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaperType => $composableBuilder(
    column: $table.diaperType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stoolColor => $composableBuilder(
    column: $table.stoolColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stoolTexture => $composableBuilder(
    column: $table.stoolTexture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityRecordsTableAnnotationComposer
    extends Composer<_$TestDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eatingMethod => $composableBuilder(
    column: $table.eatingMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breastSide => $composableBuilder(
    column: $table.breastSide,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breastDurationMinutes => $composableBuilder(
    column: $table.breastDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get formulaAmountMl => $composableBuilder(
    column: $table.formulaAmountMl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodType =>
      $composableBuilder(column: $table.foodType, builder: (column) => column);

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepLocation => $composableBuilder(
    column: $table.sleepLocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepAssistMethod => $composableBuilder(
    column: $table.sleepAssistMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get diaperType => $composableBuilder(
    column: $table.diaperType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stoolColor => $composableBuilder(
    column: $table.stoolColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stoolTexture => $composableBuilder(
    column: $table.stoolTexture,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActivityRecordsTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $ActivityRecordsTable,
          ActivityRecord,
          $$ActivityRecordsTableFilterComposer,
          $$ActivityRecordsTableOrderingComposer,
          $$ActivityRecordsTableAnnotationComposer,
          $$ActivityRecordsTableCreateCompanionBuilder,
          $$ActivityRecordsTableUpdateCompanionBuilder,
          (
            ActivityRecord,
            BaseReferences<
              _$TestDatabase,
              $ActivityRecordsTable,
              ActivityRecord
            >,
          ),
          ActivityRecord,
          PrefetchHooks Function()
        > {
  $$ActivityRecordsTableTableManager(
    _$TestDatabase db,
    $ActivityRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> babyId = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<int?> eatingMethod = const Value.absent(),
                Value<int?> breastSide = const Value.absent(),
                Value<int?> breastDurationMinutes = const Value.absent(),
                Value<int?> formulaAmountMl = const Value.absent(),
                Value<String?> foodType = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<int?> sleepLocation = const Value.absent(),
                Value<int?> sleepAssistMethod = const Value.absent(),
                Value<int?> activityType = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<int?> diaperType = const Value.absent(),
                Value<int?> stoolColor = const Value.absent(),
                Value<int?> stoolTexture = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ActivityRecordsCompanion(
                id: id,
                babyId: babyId,
                type: type,
                startTime: startTime,
                endTime: endTime,
                durationSeconds: durationSeconds,
                notes: notes,
                isVerified: isVerified,
                eatingMethod: eatingMethod,
                breastSide: breastSide,
                breastDurationMinutes: breastDurationMinutes,
                formulaAmountMl: formulaAmountMl,
                foodType: foodType,
                sleepQuality: sleepQuality,
                sleepLocation: sleepLocation,
                sleepAssistMethod: sleepAssistMethod,
                activityType: activityType,
                mood: mood,
                diaperType: diaperType,
                stoolColor: stoolColor,
                stoolTexture: stoolTexture,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int babyId,
                required int type,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<int?> eatingMethod = const Value.absent(),
                Value<int?> breastSide = const Value.absent(),
                Value<int?> breastDurationMinutes = const Value.absent(),
                Value<int?> formulaAmountMl = const Value.absent(),
                Value<String?> foodType = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<int?> sleepLocation = const Value.absent(),
                Value<int?> sleepAssistMethod = const Value.absent(),
                Value<int?> activityType = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<int?> diaperType = const Value.absent(),
                Value<int?> stoolColor = const Value.absent(),
                Value<int?> stoolTexture = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ActivityRecordsCompanion.insert(
                id: id,
                babyId: babyId,
                type: type,
                startTime: startTime,
                endTime: endTime,
                durationSeconds: durationSeconds,
                notes: notes,
                isVerified: isVerified,
                eatingMethod: eatingMethod,
                breastSide: breastSide,
                breastDurationMinutes: breastDurationMinutes,
                formulaAmountMl: formulaAmountMl,
                foodType: foodType,
                sleepQuality: sleepQuality,
                sleepLocation: sleepLocation,
                sleepAssistMethod: sleepAssistMethod,
                activityType: activityType,
                mood: mood,
                diaperType: diaperType,
                stoolColor: stoolColor,
                stoolTexture: stoolTexture,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $ActivityRecordsTable,
      ActivityRecord,
      $$ActivityRecordsTableFilterComposer,
      $$ActivityRecordsTableOrderingComposer,
      $$ActivityRecordsTableAnnotationComposer,
      $$ActivityRecordsTableCreateCompanionBuilder,
      $$ActivityRecordsTableUpdateCompanionBuilder,
      (
        ActivityRecord,
        BaseReferences<_$TestDatabase, $ActivityRecordsTable, ActivityRecord>,
      ),
      ActivityRecord,
      PrefetchHooks Function()
    >;
typedef $$GrowthRecordsTableCreateCompanionBuilder =
    GrowthRecordsCompanion Function({
      Value<int> id,
      required int babyId,
      required DateTime recordDate,
      Value<double?> weight,
      Value<double?> height,
      Value<double?> headCircumference,
      Value<String?> notes,
      Value<int?> relatedActivityId,
      Value<int?> context,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$GrowthRecordsTableUpdateCompanionBuilder =
    GrowthRecordsCompanion Function({
      Value<int> id,
      Value<int> babyId,
      Value<DateTime> recordDate,
      Value<double?> weight,
      Value<double?> height,
      Value<double?> headCircumference,
      Value<String?> notes,
      Value<int?> relatedActivityId,
      Value<int?> context,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$GrowthRecordsTableFilterComposer
    extends Composer<_$TestDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableFilterComposer({
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

  ColumnFilters<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headCircumference => $composableBuilder(
    column: $table.headCircumference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedActivityId => $composableBuilder(
    column: $table.relatedActivityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GrowthRecordsTableOrderingComposer
    extends Composer<_$TestDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headCircumference => $composableBuilder(
    column: $table.headCircumference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedActivityId => $composableBuilder(
    column: $table.relatedActivityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrowthRecordsTableAnnotationComposer
    extends Composer<_$TestDatabase, $GrowthRecordsTable> {
  $$GrowthRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get headCircumference => $composableBuilder(
    column: $table.headCircumference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get relatedActivityId => $composableBuilder(
    column: $table.relatedActivityId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GrowthRecordsTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $GrowthRecordsTable,
          GrowthRecord,
          $$GrowthRecordsTableFilterComposer,
          $$GrowthRecordsTableOrderingComposer,
          $$GrowthRecordsTableAnnotationComposer,
          $$GrowthRecordsTableCreateCompanionBuilder,
          $$GrowthRecordsTableUpdateCompanionBuilder,
          (
            GrowthRecord,
            BaseReferences<_$TestDatabase, $GrowthRecordsTable, GrowthRecord>,
          ),
          GrowthRecord,
          PrefetchHooks Function()
        > {
  $$GrowthRecordsTableTableManager(_$TestDatabase db, $GrowthRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrowthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrowthRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrowthRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> babyId = const Value.absent(),
                Value<DateTime> recordDate = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<double?> headCircumference = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> relatedActivityId = const Value.absent(),
                Value<int?> context = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GrowthRecordsCompanion(
                id: id,
                babyId: babyId,
                recordDate: recordDate,
                weight: weight,
                height: height,
                headCircumference: headCircumference,
                notes: notes,
                relatedActivityId: relatedActivityId,
                context: context,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int babyId,
                required DateTime recordDate,
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<double?> headCircumference = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> relatedActivityId = const Value.absent(),
                Value<int?> context = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GrowthRecordsCompanion.insert(
                id: id,
                babyId: babyId,
                recordDate: recordDate,
                weight: weight,
                height: height,
                headCircumference: headCircumference,
                notes: notes,
                relatedActivityId: relatedActivityId,
                context: context,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GrowthRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $GrowthRecordsTable,
      GrowthRecord,
      $$GrowthRecordsTableFilterComposer,
      $$GrowthRecordsTableOrderingComposer,
      $$GrowthRecordsTableAnnotationComposer,
      $$GrowthRecordsTableCreateCompanionBuilder,
      $$GrowthRecordsTableUpdateCompanionBuilder,
      (
        GrowthRecord,
        BaseReferences<_$TestDatabase, $GrowthRecordsTable, GrowthRecord>,
      ),
      GrowthRecord,
      PrefetchHooks Function()
    >;
typedef $$VaccineLibraryTableCreateCompanionBuilder =
    VaccineLibraryCompanion Function({
      Value<int> id,
      required String name,
      required String fullName,
      required String code,
      required int doseIndex,
      required int totalDoses,
      required int recommendedAgeDays,
      Value<int?> minIntervalDays,
      required String ageDescription,
      Value<int> vaccineType,
      Value<bool> isCombined,
      Value<String?> description,
      Value<String?> contraindications,
      Value<String?> sideEffects,
      Value<int> dataVersion,
    });
typedef $$VaccineLibraryTableUpdateCompanionBuilder =
    VaccineLibraryCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> fullName,
      Value<String> code,
      Value<int> doseIndex,
      Value<int> totalDoses,
      Value<int> recommendedAgeDays,
      Value<int?> minIntervalDays,
      Value<String> ageDescription,
      Value<int> vaccineType,
      Value<bool> isCombined,
      Value<String?> description,
      Value<String?> contraindications,
      Value<String?> sideEffects,
      Value<int> dataVersion,
    });

class $$VaccineLibraryTableFilterComposer
    extends Composer<_$TestDatabase, $VaccineLibraryTable> {
  $$VaccineLibraryTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doseIndex => $composableBuilder(
    column: $table.doseIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDoses => $composableBuilder(
    column: $table.totalDoses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recommendedAgeDays => $composableBuilder(
    column: $table.recommendedAgeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minIntervalDays => $composableBuilder(
    column: $table.minIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageDescription => $composableBuilder(
    column: $table.ageDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vaccineType => $composableBuilder(
    column: $table.vaccineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCombined => $composableBuilder(
    column: $table.isCombined,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contraindications => $composableBuilder(
    column: $table.contraindications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sideEffects => $composableBuilder(
    column: $table.sideEffects,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaccineLibraryTableOrderingComposer
    extends Composer<_$TestDatabase, $VaccineLibraryTable> {
  $$VaccineLibraryTableOrderingComposer({
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

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doseIndex => $composableBuilder(
    column: $table.doseIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDoses => $composableBuilder(
    column: $table.totalDoses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recommendedAgeDays => $composableBuilder(
    column: $table.recommendedAgeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minIntervalDays => $composableBuilder(
    column: $table.minIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageDescription => $composableBuilder(
    column: $table.ageDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vaccineType => $composableBuilder(
    column: $table.vaccineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCombined => $composableBuilder(
    column: $table.isCombined,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contraindications => $composableBuilder(
    column: $table.contraindications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sideEffects => $composableBuilder(
    column: $table.sideEffects,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaccineLibraryTableAnnotationComposer
    extends Composer<_$TestDatabase, $VaccineLibraryTable> {
  $$VaccineLibraryTableAnnotationComposer({
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

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get doseIndex =>
      $composableBuilder(column: $table.doseIndex, builder: (column) => column);

  GeneratedColumn<int> get totalDoses => $composableBuilder(
    column: $table.totalDoses,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recommendedAgeDays => $composableBuilder(
    column: $table.recommendedAgeDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minIntervalDays => $composableBuilder(
    column: $table.minIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ageDescription => $composableBuilder(
    column: $table.ageDescription,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vaccineType => $composableBuilder(
    column: $table.vaccineType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCombined => $composableBuilder(
    column: $table.isCombined,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contraindications => $composableBuilder(
    column: $table.contraindications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sideEffects => $composableBuilder(
    column: $table.sideEffects,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => column,
  );
}

class $$VaccineLibraryTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $VaccineLibraryTable,
          VaccineLibraryData,
          $$VaccineLibraryTableFilterComposer,
          $$VaccineLibraryTableOrderingComposer,
          $$VaccineLibraryTableAnnotationComposer,
          $$VaccineLibraryTableCreateCompanionBuilder,
          $$VaccineLibraryTableUpdateCompanionBuilder,
          (
            VaccineLibraryData,
            BaseReferences<
              _$TestDatabase,
              $VaccineLibraryTable,
              VaccineLibraryData
            >,
          ),
          VaccineLibraryData,
          PrefetchHooks Function()
        > {
  $$VaccineLibraryTableTableManager(
    _$TestDatabase db,
    $VaccineLibraryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccineLibraryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccineLibraryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccineLibraryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> doseIndex = const Value.absent(),
                Value<int> totalDoses = const Value.absent(),
                Value<int> recommendedAgeDays = const Value.absent(),
                Value<int?> minIntervalDays = const Value.absent(),
                Value<String> ageDescription = const Value.absent(),
                Value<int> vaccineType = const Value.absent(),
                Value<bool> isCombined = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> contraindications = const Value.absent(),
                Value<String?> sideEffects = const Value.absent(),
                Value<int> dataVersion = const Value.absent(),
              }) => VaccineLibraryCompanion(
                id: id,
                name: name,
                fullName: fullName,
                code: code,
                doseIndex: doseIndex,
                totalDoses: totalDoses,
                recommendedAgeDays: recommendedAgeDays,
                minIntervalDays: minIntervalDays,
                ageDescription: ageDescription,
                vaccineType: vaccineType,
                isCombined: isCombined,
                description: description,
                contraindications: contraindications,
                sideEffects: sideEffects,
                dataVersion: dataVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String fullName,
                required String code,
                required int doseIndex,
                required int totalDoses,
                required int recommendedAgeDays,
                Value<int?> minIntervalDays = const Value.absent(),
                required String ageDescription,
                Value<int> vaccineType = const Value.absent(),
                Value<bool> isCombined = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> contraindications = const Value.absent(),
                Value<String?> sideEffects = const Value.absent(),
                Value<int> dataVersion = const Value.absent(),
              }) => VaccineLibraryCompanion.insert(
                id: id,
                name: name,
                fullName: fullName,
                code: code,
                doseIndex: doseIndex,
                totalDoses: totalDoses,
                recommendedAgeDays: recommendedAgeDays,
                minIntervalDays: minIntervalDays,
                ageDescription: ageDescription,
                vaccineType: vaccineType,
                isCombined: isCombined,
                description: description,
                contraindications: contraindications,
                sideEffects: sideEffects,
                dataVersion: dataVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaccineLibraryTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $VaccineLibraryTable,
      VaccineLibraryData,
      $$VaccineLibraryTableFilterComposer,
      $$VaccineLibraryTableOrderingComposer,
      $$VaccineLibraryTableAnnotationComposer,
      $$VaccineLibraryTableCreateCompanionBuilder,
      $$VaccineLibraryTableUpdateCompanionBuilder,
      (
        VaccineLibraryData,
        BaseReferences<
          _$TestDatabase,
          $VaccineLibraryTable,
          VaccineLibraryData
        >,
      ),
      VaccineLibraryData,
      PrefetchHooks Function()
    >;
typedef $$VaccineRecordsTableCreateCompanionBuilder =
    VaccineRecordsCompanion Function({
      Value<int> id,
      required int babyId,
      required int vaccineLibraryId,
      required DateTime actualDate,
      Value<String?> batchNumber,
      Value<String?> manufacturer,
      Value<String?> hospital,
      Value<int?> injectionSite,
      Value<int?> reactionLevel,
      Value<String?> reactionDetail,
      Value<int?> reactionOnset,
      Value<String?> notes,
      Value<int> status,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$VaccineRecordsTableUpdateCompanionBuilder =
    VaccineRecordsCompanion Function({
      Value<int> id,
      Value<int> babyId,
      Value<int> vaccineLibraryId,
      Value<DateTime> actualDate,
      Value<String?> batchNumber,
      Value<String?> manufacturer,
      Value<String?> hospital,
      Value<int?> injectionSite,
      Value<int?> reactionLevel,
      Value<String?> reactionDetail,
      Value<int?> reactionOnset,
      Value<String?> notes,
      Value<int> status,
      Value<String?> serverId,
      Value<String?> deviceId,
      Value<int> syncStatus,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$VaccineRecordsTableFilterComposer
    extends Composer<_$TestDatabase, $VaccineRecordsTable> {
  $$VaccineRecordsTableFilterComposer({
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

  ColumnFilters<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vaccineLibraryId => $composableBuilder(
    column: $table.vaccineLibraryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualDate => $composableBuilder(
    column: $table.actualDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hospital => $composableBuilder(
    column: $table.hospital,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get injectionSite => $composableBuilder(
    column: $table.injectionSite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reactionLevel => $composableBuilder(
    column: $table.reactionLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reactionDetail => $composableBuilder(
    column: $table.reactionDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reactionOnset => $composableBuilder(
    column: $table.reactionOnset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaccineRecordsTableOrderingComposer
    extends Composer<_$TestDatabase, $VaccineRecordsTable> {
  $$VaccineRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vaccineLibraryId => $composableBuilder(
    column: $table.vaccineLibraryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualDate => $composableBuilder(
    column: $table.actualDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hospital => $composableBuilder(
    column: $table.hospital,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get injectionSite => $composableBuilder(
    column: $table.injectionSite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reactionLevel => $composableBuilder(
    column: $table.reactionLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reactionDetail => $composableBuilder(
    column: $table.reactionDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reactionOnset => $composableBuilder(
    column: $table.reactionOnset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaccineRecordsTableAnnotationComposer
    extends Composer<_$TestDatabase, $VaccineRecordsTable> {
  $$VaccineRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<int> get vaccineLibraryId => $composableBuilder(
    column: $table.vaccineLibraryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualDate => $composableBuilder(
    column: $table.actualDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hospital =>
      $composableBuilder(column: $table.hospital, builder: (column) => column);

  GeneratedColumn<int> get injectionSite => $composableBuilder(
    column: $table.injectionSite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reactionLevel => $composableBuilder(
    column: $table.reactionLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reactionDetail => $composableBuilder(
    column: $table.reactionDetail,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reactionOnset => $composableBuilder(
    column: $table.reactionOnset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VaccineRecordsTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $VaccineRecordsTable,
          VaccineRecord,
          $$VaccineRecordsTableFilterComposer,
          $$VaccineRecordsTableOrderingComposer,
          $$VaccineRecordsTableAnnotationComposer,
          $$VaccineRecordsTableCreateCompanionBuilder,
          $$VaccineRecordsTableUpdateCompanionBuilder,
          (
            VaccineRecord,
            BaseReferences<_$TestDatabase, $VaccineRecordsTable, VaccineRecord>,
          ),
          VaccineRecord,
          PrefetchHooks Function()
        > {
  $$VaccineRecordsTableTableManager(
    _$TestDatabase db,
    $VaccineRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccineRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccineRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccineRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> babyId = const Value.absent(),
                Value<int> vaccineLibraryId = const Value.absent(),
                Value<DateTime> actualDate = const Value.absent(),
                Value<String?> batchNumber = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> hospital = const Value.absent(),
                Value<int?> injectionSite = const Value.absent(),
                Value<int?> reactionLevel = const Value.absent(),
                Value<String?> reactionDetail = const Value.absent(),
                Value<int?> reactionOnset = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VaccineRecordsCompanion(
                id: id,
                babyId: babyId,
                vaccineLibraryId: vaccineLibraryId,
                actualDate: actualDate,
                batchNumber: batchNumber,
                manufacturer: manufacturer,
                hospital: hospital,
                injectionSite: injectionSite,
                reactionLevel: reactionLevel,
                reactionDetail: reactionDetail,
                reactionOnset: reactionOnset,
                notes: notes,
                status: status,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int babyId,
                required int vaccineLibraryId,
                required DateTime actualDate,
                Value<String?> batchNumber = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> hospital = const Value.absent(),
                Value<int?> injectionSite = const Value.absent(),
                Value<int?> reactionLevel = const Value.absent(),
                Value<String?> reactionDetail = const Value.absent(),
                Value<int?> reactionOnset = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VaccineRecordsCompanion.insert(
                id: id,
                babyId: babyId,
                vaccineLibraryId: vaccineLibraryId,
                actualDate: actualDate,
                batchNumber: batchNumber,
                manufacturer: manufacturer,
                hospital: hospital,
                injectionSite: injectionSite,
                reactionLevel: reactionLevel,
                reactionDetail: reactionDetail,
                reactionOnset: reactionOnset,
                notes: notes,
                status: status,
                serverId: serverId,
                deviceId: deviceId,
                syncStatus: syncStatus,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaccineRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $VaccineRecordsTable,
      VaccineRecord,
      $$VaccineRecordsTableFilterComposer,
      $$VaccineRecordsTableOrderingComposer,
      $$VaccineRecordsTableAnnotationComposer,
      $$VaccineRecordsTableCreateCompanionBuilder,
      $$VaccineRecordsTableUpdateCompanionBuilder,
      (
        VaccineRecord,
        BaseReferences<_$TestDatabase, $VaccineRecordsTable, VaccineRecord>,
      ),
      VaccineRecord,
      PrefetchHooks Function()
    >;
typedef $$AgeBenchmarkDataTableCreateCompanionBuilder =
    AgeBenchmarkDataCompanion Function({
      Value<int> id,
      required int ageMonths,
      required int gender,
      required double weightMedian,
      required double weightP3,
      required double weightP97,
      required double heightMedian,
      required double heightP3,
      required double heightP97,
      required double headCircumferenceMedian,
      required double headCircumferenceP3,
      required double headCircumferenceP97,
      Value<int> dataVersion,
    });
typedef $$AgeBenchmarkDataTableUpdateCompanionBuilder =
    AgeBenchmarkDataCompanion Function({
      Value<int> id,
      Value<int> ageMonths,
      Value<int> gender,
      Value<double> weightMedian,
      Value<double> weightP3,
      Value<double> weightP97,
      Value<double> heightMedian,
      Value<double> heightP3,
      Value<double> heightP97,
      Value<double> headCircumferenceMedian,
      Value<double> headCircumferenceP3,
      Value<double> headCircumferenceP97,
      Value<int> dataVersion,
    });

class $$AgeBenchmarkDataTableFilterComposer
    extends Composer<_$TestDatabase, $AgeBenchmarkDataTable> {
  $$AgeBenchmarkDataTableFilterComposer({
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

  ColumnFilters<int> get ageMonths => $composableBuilder(
    column: $table.ageMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightMedian => $composableBuilder(
    column: $table.weightMedian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightP3 => $composableBuilder(
    column: $table.weightP3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightP97 => $composableBuilder(
    column: $table.weightP97,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightMedian => $composableBuilder(
    column: $table.heightMedian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightP3 => $composableBuilder(
    column: $table.heightP3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightP97 => $composableBuilder(
    column: $table.heightP97,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headCircumferenceMedian => $composableBuilder(
    column: $table.headCircumferenceMedian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headCircumferenceP3 => $composableBuilder(
    column: $table.headCircumferenceP3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headCircumferenceP97 => $composableBuilder(
    column: $table.headCircumferenceP97,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AgeBenchmarkDataTableOrderingComposer
    extends Composer<_$TestDatabase, $AgeBenchmarkDataTable> {
  $$AgeBenchmarkDataTableOrderingComposer({
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

  ColumnOrderings<int> get ageMonths => $composableBuilder(
    column: $table.ageMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightMedian => $composableBuilder(
    column: $table.weightMedian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightP3 => $composableBuilder(
    column: $table.weightP3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightP97 => $composableBuilder(
    column: $table.weightP97,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightMedian => $composableBuilder(
    column: $table.heightMedian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightP3 => $composableBuilder(
    column: $table.heightP3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightP97 => $composableBuilder(
    column: $table.heightP97,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headCircumferenceMedian => $composableBuilder(
    column: $table.headCircumferenceMedian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headCircumferenceP3 => $composableBuilder(
    column: $table.headCircumferenceP3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headCircumferenceP97 => $composableBuilder(
    column: $table.headCircumferenceP97,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AgeBenchmarkDataTableAnnotationComposer
    extends Composer<_$TestDatabase, $AgeBenchmarkDataTable> {
  $$AgeBenchmarkDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ageMonths =>
      $composableBuilder(column: $table.ageMonths, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get weightMedian => $composableBuilder(
    column: $table.weightMedian,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightP3 =>
      $composableBuilder(column: $table.weightP3, builder: (column) => column);

  GeneratedColumn<double> get weightP97 =>
      $composableBuilder(column: $table.weightP97, builder: (column) => column);

  GeneratedColumn<double> get heightMedian => $composableBuilder(
    column: $table.heightMedian,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heightP3 =>
      $composableBuilder(column: $table.heightP3, builder: (column) => column);

  GeneratedColumn<double> get heightP97 =>
      $composableBuilder(column: $table.heightP97, builder: (column) => column);

  GeneratedColumn<double> get headCircumferenceMedian => $composableBuilder(
    column: $table.headCircumferenceMedian,
    builder: (column) => column,
  );

  GeneratedColumn<double> get headCircumferenceP3 => $composableBuilder(
    column: $table.headCircumferenceP3,
    builder: (column) => column,
  );

  GeneratedColumn<double> get headCircumferenceP97 => $composableBuilder(
    column: $table.headCircumferenceP97,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => column,
  );
}

class $$AgeBenchmarkDataTableTableManager
    extends
        RootTableManager<
          _$TestDatabase,
          $AgeBenchmarkDataTable,
          AgeBenchmarkDataData,
          $$AgeBenchmarkDataTableFilterComposer,
          $$AgeBenchmarkDataTableOrderingComposer,
          $$AgeBenchmarkDataTableAnnotationComposer,
          $$AgeBenchmarkDataTableCreateCompanionBuilder,
          $$AgeBenchmarkDataTableUpdateCompanionBuilder,
          (
            AgeBenchmarkDataData,
            BaseReferences<
              _$TestDatabase,
              $AgeBenchmarkDataTable,
              AgeBenchmarkDataData
            >,
          ),
          AgeBenchmarkDataData,
          PrefetchHooks Function()
        > {
  $$AgeBenchmarkDataTableTableManager(
    _$TestDatabase db,
    $AgeBenchmarkDataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgeBenchmarkDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgeBenchmarkDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgeBenchmarkDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ageMonths = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<double> weightMedian = const Value.absent(),
                Value<double> weightP3 = const Value.absent(),
                Value<double> weightP97 = const Value.absent(),
                Value<double> heightMedian = const Value.absent(),
                Value<double> heightP3 = const Value.absent(),
                Value<double> heightP97 = const Value.absent(),
                Value<double> headCircumferenceMedian = const Value.absent(),
                Value<double> headCircumferenceP3 = const Value.absent(),
                Value<double> headCircumferenceP97 = const Value.absent(),
                Value<int> dataVersion = const Value.absent(),
              }) => AgeBenchmarkDataCompanion(
                id: id,
                ageMonths: ageMonths,
                gender: gender,
                weightMedian: weightMedian,
                weightP3: weightP3,
                weightP97: weightP97,
                heightMedian: heightMedian,
                heightP3: heightP3,
                heightP97: heightP97,
                headCircumferenceMedian: headCircumferenceMedian,
                headCircumferenceP3: headCircumferenceP3,
                headCircumferenceP97: headCircumferenceP97,
                dataVersion: dataVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ageMonths,
                required int gender,
                required double weightMedian,
                required double weightP3,
                required double weightP97,
                required double heightMedian,
                required double heightP3,
                required double heightP97,
                required double headCircumferenceMedian,
                required double headCircumferenceP3,
                required double headCircumferenceP97,
                Value<int> dataVersion = const Value.absent(),
              }) => AgeBenchmarkDataCompanion.insert(
                id: id,
                ageMonths: ageMonths,
                gender: gender,
                weightMedian: weightMedian,
                weightP3: weightP3,
                weightP97: weightP97,
                heightMedian: heightMedian,
                heightP3: heightP3,
                heightP97: heightP97,
                headCircumferenceMedian: headCircumferenceMedian,
                headCircumferenceP3: headCircumferenceP3,
                headCircumferenceP97: headCircumferenceP97,
                dataVersion: dataVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AgeBenchmarkDataTableProcessedTableManager =
    ProcessedTableManager<
      _$TestDatabase,
      $AgeBenchmarkDataTable,
      AgeBenchmarkDataData,
      $$AgeBenchmarkDataTableFilterComposer,
      $$AgeBenchmarkDataTableOrderingComposer,
      $$AgeBenchmarkDataTableAnnotationComposer,
      $$AgeBenchmarkDataTableCreateCompanionBuilder,
      $$AgeBenchmarkDataTableUpdateCompanionBuilder,
      (
        AgeBenchmarkDataData,
        BaseReferences<
          _$TestDatabase,
          $AgeBenchmarkDataTable,
          AgeBenchmarkDataData
        >,
      ),
      AgeBenchmarkDataData,
      PrefetchHooks Function()
    >;

class $TestDatabaseManager {
  final _$TestDatabase _db;
  $TestDatabaseManager(this._db);
  $$TestRecordsTableTableManager get testRecords =>
      $$TestRecordsTableTableManager(_db, _db.testRecords);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$FamiliesTableTableManager get families =>
      $$FamiliesTableTableManager(_db, _db.families);
  $$FamilyMembersTableTableManager get familyMembers =>
      $$FamilyMembersTableTableManager(_db, _db.familyMembers);
  $$BabiesTableTableManager get babies =>
      $$BabiesTableTableManager(_db, _db.babies);
  $$ActivityRecordsTableTableManager get activityRecords =>
      $$ActivityRecordsTableTableManager(_db, _db.activityRecords);
  $$GrowthRecordsTableTableManager get growthRecords =>
      $$GrowthRecordsTableTableManager(_db, _db.growthRecords);
  $$VaccineLibraryTableTableManager get vaccineLibrary =>
      $$VaccineLibraryTableTableManager(_db, _db.vaccineLibrary);
  $$VaccineRecordsTableTableManager get vaccineRecords =>
      $$VaccineRecordsTableTableManager(_db, _db.vaccineRecords);
  $$AgeBenchmarkDataTableTableManager get ageBenchmarkData =>
      $$AgeBenchmarkDataTableTableManager(_db, _db.ageBenchmarkData);
}
