import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';

/// 统计周期枚举
enum StatsPeriod {
  day,
  week,
  month,
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

  /// 格式化奶粉量
  String get formattedFormulaAmount => '${formulaMl}ml';
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
  int get hashCode => Object.hash(babyId, date.year, date.month, date.day, period);
}

/// 统计数据 Provider
///
/// 根据宝宝 ID、日期和周期计算统计数据。
final statsProvider = FutureProvider.family<StatsData, StatsQuery>((ref, query) async {
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
final todayStatsProvider = FutureProvider.family<StatsData, int>((ref, babyId) async {
  final query = StatsQuery(
    babyId: babyId,
    date: DateTime.now(),
    period: StatsPeriod.day,
  );
  return ref.watch(statsProvider(query).future);
});