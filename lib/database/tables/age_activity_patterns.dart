import 'package:drift/drift.dart';

/// 月龄活动模式表定义
///
/// 存储按周龄划分的活动模式基准数据（0-52周）。
/// 用于预测宝宝的下一项活动（吃、睡、排泄）。
/// 注意：此表不支持软删除和同步，因为是内置只读数据。
class AgeActivityPatterns extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 周龄 (0-52)
  IntColumn get week => integer()();

  /// 活动类型：0=吃、2=睡、3=排泄
  /// 注意：不包含活动类型1（玩），因为玩的活动模式较难预测
  IntColumn get activityType => integer()();

  /// 平均间隔（分钟）
  /// 表示该类型活动的平均时间间隔
  IntColumn get intervalMinutes => integer()();

  /// 平均持续时间（分钟）
  /// 可为空，因为排泄活动没有持续时间概念
  IntColumn get durationMinutes => integer().nullable()();

  /// 每日平均次数
  IntColumn get countPerDay => integer()();

  /// 备注
  TextColumn get notes => text().nullable()();

  /// 数据版本号（用于判断是否需要更新内置数据）
  IntColumn get dataVersion => integer().withDefault(const Constant(1))();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {week, activityType},
      ];
}