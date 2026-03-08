import 'package:drift/drift.dart';

/// 测量上下文枚举
enum GrowthContext {
  beforeMeal(0), // 饭前
  afterMeal(1), // 饭后
  beforePoop(2), // 便前
  afterPoop(3); // 便后

  const GrowthContext(this.value);
  final int value;
}

/// 同步状态枚举
enum SyncStatus {
  synced(0), // 已同步
  pendingUpload(1), // 待上传
  pendingDownload(2), // 待下载
  conflict(3); // 冲突

  const SyncStatus(this.value);
  final int value;
}

/// 生长记录表定义
///
/// 存储宝宝的生长数据记录。
/// 支持软删除和同步字段。
class GrowthRecords extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 宝宝ID
  IntColumn get babyId => integer()();

  /// 记录日期
  DateTimeColumn get recordDate => dateTime()();

  /// 体重（kg）
  RealColumn get weight => real().nullable()();

  /// 身高（cm）
  RealColumn get height => real().nullable()();

  /// 头围（cm）
  RealColumn get headCircumference => real().nullable()();

  /// 备注
  TextColumn get notes => text().nullable()();

  /// 关联活动记录ID
  IntColumn get relatedActivityId => integer().nullable()();

  /// 测量上下文：0=饭前、1=饭后、2=便前、3=便后
  IntColumn get context => integer().nullable()();

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