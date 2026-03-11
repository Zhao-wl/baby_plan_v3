import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'activity_data_change_provider.dart';
import 'database_provider.dart';

/// 进行中活动状态枚举
enum ActivityStatus {
  ongoing(0), // 进行中
  completed(1); // 已完成

  const ActivityStatus(this.value);
  final int value;
}

/// 当前进行中活动 Provider
///
/// 返回当前宝宝的进行中活动（status=0），如果没有则返回 null。
///
/// 注意：此 Provider 用于特定场景查询进行中活动。
/// 时间线列表中会自动显示进行中活动，不需要单独使用此 Provider。
///
/// 使用场景：
/// - 检查是否有进行中活动（用于限制同时只能有一个进行中活动）
/// - 在首页等位置显示当前进行中活动状态
final ongoingActivityProvider = StreamProvider.family<ActivityRecord?, int>((ref, babyId) {
  // 监听数据变化通知
  ref.watch(activityDataChangeProvider);

  final db = ref.watch(databaseProvider);

  // 查询指定宝宝的进行中活动
  return db.watchOngoingActivity(babyId);
});
