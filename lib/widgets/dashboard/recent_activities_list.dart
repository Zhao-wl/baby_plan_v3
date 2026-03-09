import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../utils/format_utils.dart';

/// 最近动态列表组件
///
/// 显示当前宝宝的最近 N 条活动记录：
/// - 活动类型图标和颜色
/// - 活动时间
/// - 活动描述
class RecentActivitiesList extends ConsumerWidget {
  /// 显示的活动数量
  final int limit;

  const RecentActivitiesList({
    super.key,
    this.limit = 2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBabyState = ref.watch(currentBabyProvider);
    final baby = currentBabyState.baby;

    // 无宝宝时显示引导
    if (baby == null) {
      return _buildEmptyState(context, '请先选择宝宝');
    }

    // 查询最近活动
    final activitiesAsync = ref.watch(
      recentActivitiesProvider((babyId: baby.id, limit: limit)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '最近记录',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B), // slate-800
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 导航到时间线页面
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF009688), // teal-600
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('查看全部'),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 活动列表
        activitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return _buildEmptyState(context, '还没有活动记录');
            }
            return Column(
              children: activities
                  .map((activity) => _ActivityItem(activity: activity))
                  .toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '加载失败: $err',
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history,
            size: 48,
            color: Color(0xFF94A3B8), // slate-400
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF64748B), // slate-500
            ),
          ),
          if (message == '还没有活动记录') ...[
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                // TODO: 导航到记录页面
              },
              child: const Text('开始记录'),
            ),
          ],
        ],
      ),
    );
  }
}

/// 单条活动记录组件
class _ActivityItem extends StatelessWidget {
  final dynamic activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    final activityType = activity.type as int;
    final color = getActivityColor(activityType);
    final lightColor = getActivityLightColor(activityType);
    final icon = getActivityIcon(activityType);
    final typeName = getActivityTypeName(activityType);
    final suffix = getActivitySuffix(activityType);

    // 格式化时间显示
    final startTime = activity.startTime as DateTime;
    final timeStr =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          // 内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 类型名称和时间在同一行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$typeName ($suffix)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334155), // slate-700
                      ),
                    ),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8), // slate-400
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // 描述
                Text(
                  _buildDescription(activity),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B), // slate-500
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建描述文字
  String _buildDescription(dynamic activity) {
    final durationSeconds = activity.durationSeconds as int?;
    if (durationSeconds == null || durationSeconds <= 0) {
      return '暂无详情';
    }

    final minutes = durationSeconds ~/ 60;
    if (minutes > 0) {
      return '约 $minutes 分钟';
    }
    return '$durationSeconds 秒';
  }

  /// 获取活动类型后缀
  String getActivitySuffix(int activityType) {
    switch (activityType) {
      case 0:
        return 'E';
      case 1:
        return 'A';
      case 2:
        return 'S';
      case 3:
        return 'Y';
      default:
        return '';
    }
  }
}