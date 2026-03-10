import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'activity_data_change_provider.dart';
import 'database_provider.dart';

/// 最近活动查询参数
typedef RecentActivitiesQuery = ({int babyId, int limit});

/// 最近活动记录 Provider
///
/// 查询指定宝宝的最近 N 条活动记录（按 startTime 降序）。
/// 排除已软删除的记录，不限日期范围。
///
/// 参数：
/// - babyId: 宝宝 ID
/// - limit: 返回数量限制
///
/// 返回：
/// - 按开始时间降序排列的活动记录列表
/// - 无记录时返回空列表
final recentActivitiesProvider = FutureProvider.family<
    List<ActivityRecord>, RecentActivitiesQuery>((ref, query) async {
  // 监听数据变化通知
  ref.watch(activityDataChangeProvider);

  final db = ref.watch(databaseProvider);
  return await (db.select(db.activityRecords)
        ..where((r) => r.babyId.equals(query.babyId) & r.isDeleted.equals(false))
        ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
        ..limit(query.limit))
      .get();
});