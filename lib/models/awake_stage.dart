/// 睡眠阶段枚举
///
/// 基于"距离上次睡眠结束的时间"划分三个阶段，
/// 用于更准确地预测宝宝的行为需求。
enum AwakeStage {
  /// 刚醒期: 0-2小时
  /// 吃奶需求高
  awakeEarly(
    0,
    '刚醒期',
    minMinutes: 0,
    maxMinutes: 120,
    description: '刚醒来，吃奶需求高',
  ),

  /// 活动期: 2-4小时
  /// 活动时间，排泄增多
  awakeMid(
    1,
    '活动期',
    minMinutes: 120,
    maxMinutes: 240,
    description: '活动时间，排泄增多',
  ),

  /// 疲劳期: 4+小时
  /// 即将入睡，睡眠预测置信度高
  awakeLate(
    2,
    '疲劳期',
    minMinutes: 240,
    maxMinutes: null,
    description: '即将入睡',
  );

  const AwakeStage(
    this.value,
    this.label, {
    required this.minMinutes,
    required this.maxMinutes,
    required this.description,
  });

  /// 枚举值
  final int value;

  /// 显示标签
  final String label;

  /// 最小分钟数（包含）
  final int minMinutes;

  /// 最大分钟数（不包含，null 表示无上限）
  final int? maxMinutes;

  /// 阶段描述
  final String description;

  /// 根据距离上次睡眠的分钟数确定阶段
  ///
  /// [minutesAwake] 距离上次睡眠结束的分钟数
  static AwakeStage fromMinutesAwake(int minutesAwake) {
    if (minutesAwake < 120) {
      return AwakeStage.awakeEarly;
    }
    if (minutesAwake < 240) {
      return AwakeStage.awakeMid;
    }
    return AwakeStage.awakeLate;
  }

  /// 根据睡眠结束时间计算当前阶段
  ///
  /// [sleepEndTime] 上次睡眠结束时间
  /// [currentTime] 当前时间（默认为现在）
  static AwakeStage? fromSleepEndTime(
    DateTime sleepEndTime, [
    DateTime? currentTime,
  ]) {
    final now = currentTime ?? DateTime.now();
    if (sleepEndTime.isAfter(now)) {
      // 睡眠结束时间在未来，无效
      return null;
    }
    final minutesAwake = now.difference(sleepEndTime).inMinutes;
    return fromMinutesAwake(minutesAwake);
  }

  /// 是否为刚醒期
  bool get isAwakeEarly => this == AwakeStage.awakeEarly;

  /// 是否为疲劳期
  bool get isAwakeLate => this == AwakeStage.awakeLate;

  /// 从枚举值创建
  static AwakeStage? fromValue(int value) {
    return switch (value) {
      0 => AwakeStage.awakeEarly,
      1 => AwakeStage.awakeMid,
      2 => AwakeStage.awakeLate,
      _ => null,
    };
  }
}