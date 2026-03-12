import '../database/database.dart';
import 'time_slot.dart';

/// 时段活动模式
///
/// 包含单个时段的活动模式数据，用于预测计算。
class TimeSlotPattern {
  /// 创建时段活动模式
  const TimeSlotPattern({
    required this.timeSlot,
    this.intervalMinutes,
    this.durationMinutes,
    this.sampleCount = 0,
    this.typicalHour,
    this.typicalMinute,
  });

  /// 从数据库记录创建
  factory TimeSlotPattern.fromActivityRecords({
    required TimeSlot timeSlot,
    required List<ActivityRecord> records,
  }) {
    if (records.isEmpty) {
      return TimeSlotPattern(timeSlot: timeSlot);
    }

    // 计算该时段内活动的典型时间（小时和分钟）
    final hours = records.map((r) => r.startTime.hour).toList();
    final minutes = records.map((r) => r.startTime.minute).toList();

    final avgHour = (hours.reduce((a, b) => a + b) / hours.length).round();
    final avgMinute = (minutes.reduce((a, b) => a + b) / minutes.length).round();

    // 计算平均间隔（用于跨时段预测）
    final intervals = <int>[];
    for (int i = 0; i < records.length - 1; i++) {
      final interval =
          records[i].startTime.difference(records[i + 1].startTime).inMinutes;
      if (interval > 0 && interval < 1800) {
        // 排除异常值（超过30小时视为异常）
        intervals.add(interval);
      }
    }

    final avgInterval = intervals.isNotEmpty
        ? (intervals.reduce((a, b) => a + b) / intervals.length).round()
        : null;

    // 计算平均时长
    final durations = records
        .where((r) => r.durationSeconds != null)
        .map((r) => r.durationSeconds! ~/ 60)
        .where((d) => d > 0 && d < 360) // 排除异常值（超过6小时）
        .toList();

    final avgDuration = durations.isNotEmpty
        ? (durations.reduce((a, b) => a + b) / durations.length).round()
        : null;

    return TimeSlotPattern(
      timeSlot: timeSlot,
      intervalMinutes: avgInterval,
      durationMinutes: avgDuration,
      sampleCount: records.length,
      typicalHour: avgHour,
      typicalMinute: avgMinute,
    );
  }

  /// 时段
  final TimeSlot timeSlot;

  /// 平均间隔（分钟）
  final int? intervalMinutes;

  /// 平均持续时间（分钟）
  final int? durationMinutes;

  /// 样本数量
  final int sampleCount;

  /// 典型小时（该时段活动的平均小时）
  final int? typicalHour;

  /// 典型分钟（该时段活动的平均分钟）
  final int? typicalMinute;

  /// 是否有有效数据
  bool get hasData => sampleCount > 0;

  /// 是否有足够的样本（>= 3）
  bool get hasEnoughSamples => sampleCount >= 3;

  /// 是否有间隔数据
  bool get hasInterval => intervalMinutes != null && intervalMinutes! > 0;

  /// 是否有持续时间数据
  bool get hasDuration => durationMinutes != null && durationMinutes! > 0;

  /// 是否有典型时间数据
  bool get hasTypicalTime => typicalHour != null;

  @override
  String toString() {
    final typicalTimeStr = typicalHour != null
        ? '${typicalHour!.toString().padLeft(2, '0')}:${(typicalMinute ?? 0).toString().padLeft(2, '0')}'
        : 'null';
    return 'TimeSlotPattern(timeSlot: $timeSlot, typicalTime: $typicalTimeStr, '
        'durationMinutes: $durationMinutes, sampleCount: $sampleCount)';
  }
}

/// 全时段模式集合
///
/// 包含所有时段的活动模式数据。
class AllTimeSlotsPattern {
  /// 创建全时段模式集合
  const AllTimeSlotsPattern({
    required this.activityType,
    required this.patterns,
  });

  /// 活动类型
  final int activityType;

  /// 各时段模式
  final Map<TimeSlot, TimeSlotPattern> patterns;

  /// 获取指定时段的模式
  TimeSlotPattern? getPattern(TimeSlot slot) => patterns[slot];

  /// 获取有数据的时段数量
  int get slotsWithData => patterns.values.where((p) => p.hasData).length;

  /// 获取总样本数量
  int get totalSampleCount =>
      patterns.values.fold(0, (sum, p) => sum + p.sampleCount);

  @override
  String toString() {
    return 'AllTimeSlotsPattern(activityType: $activityType, slotsWithData: $slotsWithData)';
  }
}

/// 时段基准数据
///
/// 从月龄基准 JSON 加载的分时段基准数据。
class TimeSlotBenchmark {
  /// 创建时段基准数据
  const TimeSlotBenchmark({
    required this.timeSlot,
    this.intervalMinutes,
    this.durationMinutes,
  });

  /// 从 JSON Map 创建
  factory TimeSlotBenchmark.fromJson(Map<String, dynamic> json, TimeSlot slot) {
    return TimeSlotBenchmark(
      timeSlot: slot,
      intervalMinutes: json['intervalMinutes'] as int?,
      durationMinutes: json['durationMinutes'] as int?,
    );
  }

  /// 时段
  final TimeSlot timeSlot;

  /// 基准间隔（分钟）
  final int? intervalMinutes;

  /// 基准持续时间（分钟）
  final int? durationMinutes;

  /// 是否有间隔数据
  bool get hasInterval => intervalMinutes != null && intervalMinutes! > 0;

  /// 是否有持续时间数据
  bool get hasDuration => durationMinutes != null && durationMinutes! > 0;

  @override
  String toString() {
    return 'TimeSlotBenchmark(timeSlot: $timeSlot, intervalMinutes: $intervalMinutes, '
        'durationMinutes: $durationMinutes)';
  }
}

/// 活动模式基准数据（包含全局和分时段）
///
/// 用于存储从 JSON 加载的完整基准数据结构。
class ActivityPatternBenchmark {
  /// 创建活动模式基准数据
  const ActivityPatternBenchmark({
    required this.week,
    required this.activityType,
    required this.globalInterval,
    this.globalDuration,
    this.globalCountPerDay,
    this.timeSlots,
  });

  /// 从 JSON Map 创建
  factory ActivityPatternBenchmark.fromJson(Map<String, dynamic> json) {
    final timeSlots = <TimeSlot, TimeSlotBenchmark>{};

    if (json['timeSlots'] != null && json['timeSlots'] is Map) {
      final timeSlotsJson = json['timeSlots'] as Map<String, dynamic>;
      for (final slot in TimeSlot.values) {
        final slotKey = slot.name;
        if (timeSlotsJson.containsKey(slotKey)) {
          timeSlots[slot] = TimeSlotBenchmark.fromJson(
            timeSlotsJson[slotKey] as Map<String, dynamic>,
            slot,
          );
        }
      }
    }

    // 支持两种格式：新格式（global 字段）和旧格式（直接字段）
    int? globalInterval;
    int? globalDuration;
    int? globalCountPerDay;

    if (json['global'] != null && json['global'] is Map) {
      // 新格式
      final global = json['global'] as Map<String, dynamic>;
      globalInterval = global['intervalMinutes'] as int?;
      globalDuration = global['durationMinutes'] as int?;
      globalCountPerDay = global['countPerDay'] as int?;
    } else {
      // 旧格式（向后兼容）
      globalInterval = json['intervalMinutes'] as int?;
      globalDuration = json['durationMinutes'] as int?;
      globalCountPerDay = json['countPerDay'] as int?;
    }

    return ActivityPatternBenchmark(
      week: json['week'] as int,
      activityType: json['activityType'] as int,
      globalInterval: globalInterval,
      globalDuration: globalDuration,
      globalCountPerDay: globalCountPerDay,
      timeSlots: timeSlots.isEmpty ? null : timeSlots,
    );
  }

  /// 周龄
  final int week;

  /// 活动类型
  final int activityType;

  /// 全局基准间隔（分钟）
  final int? globalInterval;

  /// 全局基准持续时间（分钟）
  final int? globalDuration;

  /// 全局每日次数
  final int? globalCountPerDay;

  /// 分时段基准数据
  final Map<TimeSlot, TimeSlotBenchmark>? timeSlots;

  /// 获取指定时段的基准间隔
  ///
  /// 优先使用时段基准，无则回退到全局基准。
  int? getIntervalForSlot(TimeSlot slot) {
    if (timeSlots != null && timeSlots![slot]?.hasInterval == true) {
      return timeSlots![slot]!.intervalMinutes;
    }
    return globalInterval;
  }

  /// 获取指定时段的基准持续时间
  ///
  /// 优先使用时段基准，无则回退到全局基准。
  int? getDurationForSlot(TimeSlot slot) {
    if (timeSlots != null && timeSlots![slot]?.hasDuration == true) {
      return timeSlots![slot]!.durationMinutes;
    }
    return globalDuration;
  }

  /// 是否有分时段数据
  bool get hasTimeSlots => timeSlots != null && timeSlots!.isNotEmpty;

  @override
  String toString() {
    return 'ActivityPatternBenchmark(week: $week, activityType: $activityType, '
        'globalInterval: $globalInterval, hasTimeSlots: $hasTimeSlots)';
  }
}