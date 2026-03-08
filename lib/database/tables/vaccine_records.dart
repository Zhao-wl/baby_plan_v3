import 'package:drift/drift.dart';

/// 接种状态枚举
enum VaccineStatus {
  pending(0), // 待接种
  completed(1), // 已接种
  overdue(2), // 已逾期
  skipped(3); // 推迟/放弃

  const VaccineStatus(this.value);
  final int value;
}

/// 接种记录表定义
///
/// 存储用户的疫苗接种记录。
/// 支持软删除和同步字段。
class VaccineRecords extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 宝宝ID
  IntColumn get babyId => integer()();

  /// 疫苗库ID（关联疫苗信息）
  IntColumn get vaccineLibraryId => integer()();

  /// 实际接种日期
  DateTimeColumn get actualDate => dateTime()();

  /// 疫苗批号
  TextColumn get batchNumber => text().nullable()();

  /// 生产厂家
  TextColumn get manufacturer => text().nullable()();

  /// 接种医院
  TextColumn get hospital => text().nullable()();

  /// 接种部位：0=左上臂、1=右上臂、2=左大腿、3=右大腿、4=口服、5=其他
  IntColumn get injectionSite => integer().nullable()();

  /// 反应等级：0=无、1=轻微、2=中等、3=严重
  IntColumn get reactionLevel => integer().nullable()();

  /// 反应详情描述
  TextColumn get reactionDetail => text().nullable()();

  /// 反应出现时间（接种后多少小时）
  IntColumn get reactionOnset => integer().nullable()();

  /// 备注
  TextColumn get notes => text().nullable()();

  /// 接种状态：0=待接种、1=已接种、2=已逾期、3=推迟/放弃
  IntColumn get status => integer().withDefault(const Constant(0))();

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