import 'package:drift/drift.dart';

/// 用户表定义
///
/// 存储用户账号信息，包含身份标识、个人信息和同步字段。
/// 支持软删除和同步字段。
class Users extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 手机号
  TextColumn get phone => text().nullable().withLength(max: 20)();

  /// 邮箱
  TextColumn get email => text().nullable().withLength(max: 100)();

  /// 昵称
  TextColumn get nickname => text().withLength(min: 1, max: 50)();

  /// 头像URL
  TextColumn get avatarUrl => text().nullable()();

  /// 服务器ID（用于同步）
  TextColumn get serverId => text().nullable()();

  /// 最后同步时间
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  /// 是否已删除（软删除标记）
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// 删除时间
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}