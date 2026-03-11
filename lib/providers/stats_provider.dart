import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity_data_change_provider.dart';
import 'database_provider.dart';

/// 统计周期枚举
enum StatsPeriod {
  day,
  week,
  month,
}

/// 睡眠图表数据
///
/// 用于睡眠堆叠柱状图，包含每日的夜间睡眠和白天小睡时长。
class SleepChartData {
  /// 日期
  final DateTime date;

  /// 夜间睡眠时长（分钟）
  final int nightSleepMinutes;

  /// 白天小睡时长（分钟）
  final int daySleepMinutes;

  const SleepChartData({
    required this.date,
    this.nightSleepMinutes = 0,
    this.daySleepMinutes = 0,
  });

  /// 总睡眠时长（分钟）
  int get totalMinutes => nightSleepMinutes + daySleepMinutes;

  /// 格式化日期显示
  String get formattedDate {
    return '${date.month}/${date.day}';
  }

  /// 星期几
  String get weekdayText {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return '周${weekdays[date.weekday - 1]}';
  }
}

/// E.A.S.Y 循环数据
///
/// 用于展示吃/玩/睡的时间比例和平均周期。
class EasyCycleData {
  /// 吃的时间占比（0-100）
  final double eatPercent;

  /// 玩的时间占比（0-100）
  final double activityPercent;

  /// 睡的时间占比（0-100）
  final double sleepPercent;

  /// 平均周期时长（小时）
  final double avgCycleHours;

  /// 环比变化（上一周期对比，正数表示增加，负数表示减少）
  final double? cycleChange;

  const EasyCycleData({
    this.eatPercent = 0,
    this.activityPercent = 0,
    this.sleepPercent = 0,
    this.avgCycleHours = 0,
    this.cycleChange,
  });

  /// 判断是否有有效数据
  bool get hasData => eatPercent > 0 || activityPercent > 0 || sleepPercent > 0;
}

/// 统计数据模型
class StatsData {
  /// 睡眠统计
  final int totalSleepMinutes;
  final int nightSleepMinutes;
  final int daySleepMinutes;
  final int sleepCount;

  /// 喂养统计
  final int feedingCount;
  final int breastMinutes;
  final int formulaMl;
  final int solidCount;

  /// 排泄统计
  final int diaperCount;
  final int peeCount;
  final int poopCount;

  /// 活动统计
  final int activityMinutes;

  const StatsData({
    this.totalSleepMinutes = 0,
    this.nightSleepMinutes = 0,
    this.daySleepMinutes = 0,
    this.sleepCount = 0,
    this.feedingCount = 0,
    this.breastMinutes = 0,
    this.formulaMl = 0,
    this.solidCount = 0,
    this.diaperCount = 0,
    this.peeCount = 0,
    this.poopCount = 0,
    this.activityMinutes = 0,
  });

  /// 格式化睡眠时长
  String get formattedSleepDuration {
    final hours = totalSleepMinutes ~/ 60;
    final minutes = totalSleepMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  /// 格式化日均睡眠时长
  String formattedAvgSleepDuration(int days) {
    final avgMinutes = totalSleepMinutes ~/ days;
    final hours = avgMinutes ~/ 60;
    final minutes = avgMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  /// 格式化奶粉量
  String get formattedFormulaAmount => '${formulaMl}ml';

  /// 格式化日均奶量
  String formattedAvgFormulaAmount(int days) {
    final avg = formulaMl ~/ days;
    return '${avg}ml';
  }

  /// 日均排便次数
  double avgPoopCount(int days) {
    if (days <= 0) return 0;
    return poopCount / days;
  }

  /// E.A.S.Y 循环数据
  EasyCycleData get easyCycleData {
    final totalMinutes =
        totalSleepMinutes + activityMinutes + (breastMinutes + formulaMl ~/ 30);
    if (totalMinutes == 0) {
      return const EasyCycleData();
    }

    // 估算吃的时间：母乳按实际时长，奶粉按每30ml约5分钟计算
    final eatingMinutes = breastMinutes + (formulaMl ~/ 30) * 5;

    final eatPercent = (eatingMinutes / totalMinutes * 100).clamp(0.0, 100.0);
    final activityPercent =
        (activityMinutes / totalMinutes * 100).clamp(0.0, 100.0);
    final sleepPercent =
        (totalSleepMinutes / totalMinutes * 100).clamp(0.0, 100.0);

    // 计算平均周期（简化计算：基于喂奶次数估算）
    double avgCycleHours = 0;
    if (feedingCount > 0) {
      final totalHours = totalMinutes / 60;
      avgCycleHours = totalHours / feedingCount;
    }

    return EasyCycleData(
      eatPercent: eatPercent,
      activityPercent: activityPercent,
      sleepPercent: sleepPercent,
      avgCycleHours: avgCycleHours,
    );
  }
}

/// 统计查询参数
class StatsQuery {
  final int babyId;
  final DateTime date;
  final StatsPeriod period;

  const StatsQuery({
    required this.babyId,
    required this.date,
    this.period = StatsPeriod.day,
  });

  /// 获取查询的日期范围
  ({DateTime start, DateTime end}) get dateRange {
    switch (period) {
      case StatsPeriod.day:
        final start = DateTime(date.year, date.month, date.day);
        return (start: start, end: start.add(const Duration(days: 1)));
      case StatsPeriod.week:
        // 周一到周日
        final weekday = date.weekday;
        final start = DateTime(date.year, date.month, date.day)
            .subtract(Duration(days: weekday - 1));
        return (start: start, end: start.add(const Duration(days: 7)));
      case StatsPeriod.month:
        final start = DateTime(date.year, date.month, 1);
        return (start: start, end: DateTime(date.year, date.month + 1, 1));
    }
  }

  /// 获取上一周期的查询参数（用于环比）
  StatsQuery get previousPeriod {
    switch (period) {
      case StatsPeriod.day:
        return StatsQuery(
          babyId: babyId,
          date: date.subtract(const Duration(days: 1)),
          period: period,
        );
      case StatsPeriod.week:
        return StatsQuery(
          babyId: babyId,
          date: date.subtract(const Duration(days: 7)),
          period: period,
        );
      case StatsPeriod.month:
        return StatsQuery(
          babyId: babyId,
          date: DateTime(date.year, date.month - 1, 1),
          period: period,
        );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatsQuery &&
        other.babyId == babyId &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day &&
        other.period == period;
  }

  @override
  int get hashCode =>
      Object.hash(babyId, date.year, date.month, date.day, period);
}

/// 统计数据 Provider
///
/// 根据宝宝 ID、日期和周期计算统计数据。
final statsProvider =
    FutureProvider.family<StatsData, StatsQuery>((ref, query) async {
  // 监听数据变化通知
  ref.watch(activityDataChangeProvider);

  final db = ref.watch(databaseProvider);
  final range = query.dateRange;

  // 查询日期范围内的所有活动记录
  final records = await (db.select(db.activityRecords).get());

  // 过滤日期范围
  final filteredRecords = records.where((r) =>
      r.babyId == query.babyId &&
      !r.isDeleted &&
      r.startTime.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
      r.startTime.isBefore(range.end));

  // 统计数据
  int totalSleepMinutes = 0;
  int nightSleepMinutes = 0;
  int daySleepMinutes = 0;
  int sleepCount = 0;
  int feedingCount = 0;
  int breastMinutes = 0;
  int formulaMl = 0;
  int solidCount = 0;
  int diaperCount = 0;
  int peeCount = 0;
  int poopCount = 0;
  int activityMinutes = 0;

  for (final record in filteredRecords) {
    switch (record.type) {
      case 0: // Eat
        feedingCount++;
        if (record.eatingMethod != null) {
          switch (record.eatingMethod!) {
            case 0: // 母乳
              breastMinutes += record.breastDurationMinutes ?? 0;
              break;
            case 1: // 奶粉
              formulaMl += record.formulaAmountMl ?? 0;
              break;
            case 2: // 辅食
              solidCount++;
              break;
          }
        }
        break;
      case 1: // Activity
        if (record.durationSeconds != null) {
          activityMinutes += record.durationSeconds! ~/ 60;
        }
        break;
      case 2: // Sleep
        sleepCount++;
        if (record.durationSeconds != null) {
          final minutes = record.durationSeconds! ~/ 60;
          totalSleepMinutes += minutes;

          // 判断夜间睡眠（20:00 - 08:00）
          final hour = record.startTime.hour;
          if (hour >= 20 || hour < 8) {
            nightSleepMinutes += minutes;
          } else {
            daySleepMinutes += minutes;
          }
        }
        break;
      case 3: // Poop
        diaperCount++;
        if (record.diaperType != null) {
          switch (record.diaperType!) {
            case 0: // 尿
              peeCount++;
              break;
            case 1: // 屎
              poopCount++;
              break;
            case 2: // 混合
              peeCount++;
              poopCount++;
              break;
          }
        }
        break;
    }
  }

  return StatsData(
    totalSleepMinutes: totalSleepMinutes,
    nightSleepMinutes: nightSleepMinutes,
    daySleepMinutes: daySleepMinutes,
    sleepCount: sleepCount,
    feedingCount: feedingCount,
    breastMinutes: breastMinutes,
    formulaMl: formulaMl,
    solidCount: solidCount,
    diaperCount: diaperCount,
    peeCount: peeCount,
    poopCount: poopCount,
    activityMinutes: activityMinutes,
  );
});

/// 今日统计 Provider（便捷访问）
final todayStatsProvider =
    FutureProvider.family<StatsData, int>((ref, babyId) async {
  final query = StatsQuery(
    babyId: babyId,
    date: DateTime.now(),
    period: StatsPeriod.day,
  );
  return ref.watch(statsProvider(query).future);
});

/// 周睡眠分布数据 Provider
///
/// 返回指定周内每天的睡眠数据列表，用于睡眠堆叠柱状图。
final weeklySleepDataProvider = FutureProvider.family<List<SleepChartData>,
    StatsQuery>((ref, query) async {
  // 监听数据变化通知
  ref.watch(activityDataChangeProvider);

  final db = ref.watch(databaseProvider);
  final range = query.dateRange;

  // 查询日期范围内的所有睡眠记录
  final records = await (db.select(db.activityRecords).get());

  // 按日期分组统计
  final Map<DateTime, SleepChartData> dailyData = {};

  // 初始化每天的空数据
  var current = range.start;
  while (current.isBefore(range.end)) {
    final dayKey = DateTime(current.year, current.month, current.day);
    dailyData[dayKey] = SleepChartData(date: dayKey);
    current = current.add(const Duration(days: 1));
  }

  // 填充睡眠数据
  final filteredRecords = records.where((r) =>
      r.babyId == query.babyId &&
      !r.isDeleted &&
      r.type == 2 && // Sleep
      r.startTime.isAfter(range.start.subtract(const Duration(microseconds: 1))) &&
      r.startTime.isBefore(range.end));

  for (final record in filteredRecords) {
    if (record.durationSeconds == null) continue;

    final dayKey =
        DateTime(record.startTime.year, record.startTime.month, record.startTime.day);
    final existing = dailyData[dayKey] ?? SleepChartData(date: dayKey);
    final minutes = record.durationSeconds! ~/ 60;

    // 判断夜间睡眠（20:00 - 08:00）
    final hour = record.startTime.hour;
    if (hour >= 20 || hour < 8) {
      dailyData[dayKey] = SleepChartData(
        date: dayKey,
        nightSleepMinutes: existing.nightSleepMinutes + minutes,
        daySleepMinutes: existing.daySleepMinutes,
      );
    } else {
      dailyData[dayKey] = SleepChartData(
        date: dayKey,
        nightSleepMinutes: existing.nightSleepMinutes,
        daySleepMinutes: existing.daySleepMinutes + minutes,
      );
    }
  }

  // 转换为有序列表
  final sortedKeys = dailyData.keys.toList()
    ..sort((a, b) => a.compareTo(b));
  return sortedKeys.map((key) => dailyData[key]!).toList();
});

/// 环比数据 Provider
///
/// 返回当前周期与上一周期的对比数据。
final periodComparisonProvider =
    FutureProvider.family<({StatsData current, StatsData previous}), StatsQuery>(
        (ref, query) async {
  final currentStats = await ref.watch(statsProvider(query).future);
  final previousStats =
      await ref.watch(statsProvider(query.previousPeriod).future);

  return (current: currentStats, previous: previousStats);
});