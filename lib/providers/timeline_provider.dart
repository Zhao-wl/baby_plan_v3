import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';

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
/// 根据宝宝 ID 和日期查询活动记录。
final timelineProvider = FutureProvider.family<List<ActivityRecord>, TimelineQuery>((ref, query) async {
  final db = ref.watch(databaseProvider);

  // 计算日期范围：当天 00:00:00 到 23:59:59
  final startOfDay = DateTime(query.date.year, query.date.month, query.date.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final records = await (db.select(db.activityRecords).get());

  // 手动过滤和排序
  return records
      .where((r) =>
          r.babyId == query.babyId &&
          !r.isDeleted &&
          r.startTime.isAfter(startOfDay.subtract(const Duration(microseconds: 1))) &&
          r.startTime.isBefore(endOfDay))
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));
});

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