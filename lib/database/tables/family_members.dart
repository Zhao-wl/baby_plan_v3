import 'package:drift/drift.dart';

/// 家庭角色枚举
enum FamilyRole {
  creator(0), // 创建者
  admin(1), // 管理员
  member(2); // 成员

  const FamilyRole(this.value);
  final int value;
}

/// 家庭成员关联表定义
///
/// 存储用户与家庭组的关联关系。
/// 支持软删除和同步字段。
class FamilyMembers extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 家庭组ID
  IntColumn get familyId => integer()();

  /// 用户ID
  IntColumn get userId => integer()();

  /// 角色：0=创建者、1=管理员、2=成员
  IntColumn get role => integer().withDefault(const Constant(2))();

  /// 服务器ID（用于同步）
  TextColumn get serverId => text().nullable()();

  /// 加入时间
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();

  /// 是否已删除（软删除标记）
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// 删除时间
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {familyId, userId},
      ];
}