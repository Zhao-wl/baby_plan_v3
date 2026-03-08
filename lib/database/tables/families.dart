import 'package:drift/drift.dart';

/// 家庭组表定义
///
/// 存储家庭组信息，支持家庭组共享宝宝数据。
/// 支持软删除和同步字段。
class Families extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 家庭名称
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// 邀请码（用于加入家庭）
  TextColumn get inviteCode => text().withLength(min: 6, max: 6).nullable()();

  /// 创建者用户ID
  IntColumn get ownerId => integer().nullable()();

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
}