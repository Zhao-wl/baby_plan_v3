/// 时间段枚举
///
/// 将一天划分为 5 个固定时段，用于活动模式分析。
/// 每个时段对应不同的宝宝行为特征。
enum TimeSlot {
  /// 早晨: 06:00-09:00
  /// 刚醒来，吃奶需求高
  morning(
    0,
    '早晨',
    startHour: 6,
    endHour: 9,
    description: '刚醒来，吃奶需求高',
  ),

  /// 上午: 09:00-12:00
  /// 活动期
  forenoon(
    1,
    '上午',
    startHour: 9,
    endHour: 12,
    description: '活动期',
  ),

  /// 下午: 12:00-18:00
  /// 最长时段，包含午睡
  afternoon(
    2,
    '下午',
    startHour: 12,
    endHour: 18,
    description: '包含午睡',
  ),

  /// 傍晚: 18:00-22:00
  /// 睡前准备期
  evening(
    3,
    '傍晚',
    startHour: 18,
    endHour: 22,
    description: '睡前准备期',
  ),

  /// 夜间: 22:00-06:00
  /// 长觉期，间隔拉长
  night(
    4,
    '夜间',
    startHour: 22,
    endHour: 6,
    description: '长觉期',
  );

  const TimeSlot(
    this.value,
    this.label, {
    required this.startHour,
    required this.endHour,
    required this.description,
  });

  /// 枚举值
  final int value;

  /// 显示标签
  final String label;

  /// 时段开始小时（24小时制）
  final int startHour;

  /// 时段结束小时（24小时制）
  final int endHour;

  /// 时段描述
  final String description;

  /// 是否为夜间时段
  bool get isNight => this == TimeSlot.night;

  /// 根据当前时间获取时段
  ///
  /// [hour] 当前小时（0-23）
  static TimeSlot fromHour(int hour) {
    // 夜间时段跨日: 22:00-06:00
    if (hour >= 22 || hour < 6) {
      return TimeSlot.night;
    }
    // 早晨: 06:00-09:00
    if (hour >= 6 && hour < 9) {
      return TimeSlot.morning;
    }
    // 上午: 09:00-12:00
    if (hour >= 9 && hour < 12) {
      return TimeSlot.forenoon;
    }
    // 下午: 12:00-18:00
    if (hour >= 12 && hour < 18) {
      return TimeSlot.afternoon;
    }
    // 傍晚: 18:00-22:00
    return TimeSlot.evening;
  }

  /// 根据日期时间获取时段
  static TimeSlot fromDateTime(DateTime dateTime) {
    return fromHour(dateTime.hour);
  }

  /// 获取相邻的下一个时段
  TimeSlot get next {
    return switch (this) {
      TimeSlot.morning => TimeSlot.forenoon,
      TimeSlot.forenoon => TimeSlot.afternoon,
      TimeSlot.afternoon => TimeSlot.evening,
      TimeSlot.evening => TimeSlot.night,
      TimeSlot.night => TimeSlot.morning,
    };
  }

  /// 获取相邻的上一个时段
  TimeSlot get previous {
    return switch (this) {
      TimeSlot.morning => TimeSlot.night,
      TimeSlot.forenoon => TimeSlot.morning,
      TimeSlot.afternoon => TimeSlot.forenoon,
      TimeSlot.evening => TimeSlot.afternoon,
      TimeSlot.night => TimeSlot.evening,
    };
  }

  /// 检查指定时间是否在时段边界附近
  ///
  /// [hour] 当前小时
  /// [minute] 当前分钟
  /// [thresholdMinutes] 边界阈值（分钟），默认 30
  bool isNearBoundary(int hour, int minute, {int thresholdMinutes = 30}) {
    final totalMinutes = hour * 60 + minute;

    // 计算时段开始时间的分钟数
    final startMinutes = startHour * 60;

    // 计算时段结束时间的分钟数（处理夜间跨日）
    int endMinutes;
    if (endHour < startHour) {
      // 夜间时段跨日
      endMinutes = endHour * 60 + 24 * 60;
    } else {
      endMinutes = endHour * 60;
    }

    // 检查是否接近开始边界
    if (totalMinutes >= startMinutes - thresholdMinutes &&
        totalMinutes < startMinutes + thresholdMinutes) {
      return true;
    }

    // 检查是否接近结束边界
    if (totalMinutes >= endMinutes - thresholdMinutes &&
        totalMinutes < endMinutes + thresholdMinutes) {
      return true;
    }

    return false;
  }

  /// 从枚举值创建
  static TimeSlot? fromValue(int value) {
    return switch (value) {
      0 => TimeSlot.morning,
      1 => TimeSlot.forenoon,
      2 => TimeSlot.afternoon,
      3 => TimeSlot.evening,
      4 => TimeSlot.night,
      _ => null,
    };
  }
}