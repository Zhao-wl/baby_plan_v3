import 'package:drift/drift.dart';

/// 宝宝性别枚举
enum Gender {
  male(0), // 男
  female(1); // 女

  const Gender(this.value);
  final int value;
}

/// 宝宝表定义
///
/// 存储宝宝基本信息，支持家庭组关联。
/// 支持软删除和同步字段。
class Babies extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 家庭组ID
  IntColumn get familyId => integer().nullable()();

  /// 宝宝姓名
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// 出生日期
  DateTimeColumn get birthDate => dateTime()();

  /// 性别：0=男、1=女
  IntColumn get gender => integer().withDefault(const Constant(0))();

  /// 头像URL
  TextColumn get avatarUrl => text().nullable()();

  /// 出生体重（kg）
  RealColumn get birthWeight => real().nullable()();

  /// 出生身高（cm）
  RealColumn get birthHeight => real().nullable()();

  /// 出生头围（cm）
  RealColumn get birthHeadCircumference => real().nullable()();

  /// 服务器ID（用于同步）
  TextColumn get serverId => text().nullable()();

  /// 设备ID（创建设备标识）
  TextColumn get deviceId => text().nullable()();

  /// 同步状态：0=已同步、1=待上传、2=待下载、3=冲突
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  /// 数据版本号
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// 是否已删除（软删除标记）
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// 删除时间
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}