import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';

/// 跨天活动视图模型
class CrossDayActivityView {
  /// 原始活动记录
  final ActivityRecord record;

  /// 是否为跨天活动
  final bool isCrossDay;

  /// 该视图显示的日期
  final DateTime viewDate;

  /// 显示的时间标签（如"昨天 23:00"）
  final String? timeLabel;

  /// 在该日的时长（秒）
  final int? dayDurationSeconds;

  const CrossDayActivityView({
    required this.record,
    required this.isCrossDay,
    required this.viewDate,
    this.timeLabel,
    this.dayDurationSeconds,
  });
}

/// 时间线查询参数
class TimelineQuery {
  final int babyId;
  final DateTime date;

  const TimelineQuery({
    required this.babyId,
    required this.date,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimelineQuery &&
        other.babyId == babyId &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day;
  }

  @override
  int get hashCode => Object.hash(babyId, date.year, date.month, date.day);
}

/// 时间线 Provider
///
/// 根据宝宝 ID 和日期查询活动记录，支持跨天活动。
final timelineProvider = FutureProvider.family<List<ActivityRecord>, TimelineQuery>((ref, query) async {
  final db = ref.watch(databaseProvider);

  // 计算日期范围：当天 00:00:00 到 23:59:59
  final startOfDay = DateTime(query.date.year, query.date.month, query.date.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final records = await (db.select(db.activityRecords).get());

  // 手动过滤和排序
  // 包含：
  // 1. 当天开始的活动
  // 2. 跨天活动（在当天结束的活动）
  final filteredRecords = records
      .where((r) =>
          r.babyId == query.babyId &&
          !r.isDeleted)
      .where((r) {
        // 情况1：当天开始的活动
        final startsToday = r.startTime.isAfter(startOfDay.subtract(const Duration(microseconds: 1))) &&
            r.startTime.isBefore(endOfDay);

        // 情况2：跨天活动（开始时间在昨天或更早，结束时间在当天）
        final endsToday = r.endTime != null &&
            r.endTime!.isAfter(startOfDay.subtract(const Duration(microseconds: 1))) &&
            r.endTime!.isBefore(endOfDay) &&
            r.startTime.isBefore(startOfDay);

        return startsToday || endsToday;
      })
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));

  return filteredRecords;
});

/// 跨天活动查询 Provider
///
/// 返回当天的活动，以 CrossDayActivityView 形式包装，支持跨天标记。
final crossDayTimelineProvider = FutureProvider.family<List<CrossDayActivityView>, TimelineQuery>((ref, query) async {
  final records = await ref.watch(timelineProvider(query).future);
  final startOfDay = DateTime(query.date.year, query.date.month, query.date.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return records.map((record) {
    // 判断是否为跨天活动
    final isCrossDay = record.endTime != null &&
        !_isSameDay(record.startTime, record.endTime!);

    // 判断这是跨天活动的开始日还是结束日
    final isStartDay = _isSameDay(record.startTime, query.date);
    final isEndDay = record.endTime != null && _isSameDay(record.endTime!, query.date);

    String? timeLabel;
    int? dayDuration;

    if (isCrossDay) {
      if (isStartDay) {
        // 开始日：显示"进行中"或"跨天"
        timeLabel = '跨天';
        // 计算从开始到当天结束的时长
        dayDuration = endOfDay.difference(record.startTime).inSeconds;
      } else if (isEndDay) {
        // 结束日：显示跨天时间标注
        final prevDay = record.startTime;
        final prevDayText = _getRelativeDayText(prevDay, query.date);
        timeLabel = prevDayText != null ? '$prevDayText ${_formatTime(record.startTime)}' : null;
        // 计算从当天开始到结束的时长
        dayDuration = record.endTime!.difference(startOfDay).inSeconds;
      }
    }

    return CrossDayActivityView(
      record: record,
      isCrossDay: isCrossDay,
      viewDate: query.date,
      timeLabel: timeLabel,
      dayDurationSeconds: dayDuration,
    );
  }).toList();
});

/// 判断两天是否为同一天
bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// 获取相对日期文本
String? _getRelativeDayText(DateTime date, DateTime relativeTo) {
  final diff = relativeTo.difference(DateTime(date.year, date.month, date.day)).inDays;
  if (diff == 1) return '昨天';
  if (diff == 2) return '前天';
  if (diff == -1) return '明天';
  if (diff == -2) return '后天';
  if (diff == 0) return null;
  return '${date.month}月${date.day}日';
}

/// 格式化时间
String _formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

/// 当前宝宝今日时间线 Provider
///
/// 便捷访问当前宝宝今日的活动记录。
final todayTimelineProvider = FutureProvider.family<List<ActivityRecord>, int>((ref, babyId) async {
  final query = TimelineQuery(
    babyId: babyId,
    date: DateTime.now(),
  );
  return ref.watch(timelineProvider(query).future);
});

/// 日期范围查询参数
class DateRangeQuery {
  final int babyId;
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeQuery({
    required this.babyId,
    required this.startDate,
    required this.endDate,
  });
}

/// 按日期范围查询活动记录 Provider
///
/// 返回指定日期范围内的所有活动记录。
final activityRecordsByDateRangeProvider = FutureProvider.family<List<ActivityRecord>, DateRangeQuery>((ref, query) async {
  final db = ref.watch(databaseProvider);

  final records = await (db.select(db.activityRecords).get());

  // 手动过滤和排序
  return records
      .where((r) =>
          r.babyId == query.babyId &&
          !r.isDeleted &&
          r.startTime.isAfter(query.startDate.subtract(const Duration(microseconds: 1))) &&
          r.startTime.isBefore(query.endDate))
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));
});