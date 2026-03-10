import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../utils/format_utils.dart';
import 'activity_card.dart';

/// 时间轴列表组件
///
/// 展示一天的活动记录列表，包含：
/// - 左侧时间轴线（CustomPainter 绘制）
/// - 活动节点（圆形，颜色对应活动类型）
/// - 活动卡片
/// - 空状态提示
class TimelineList extends StatelessWidget {
  /// 活动记录列表
  final List<ActivityRecord> records;

  /// 点击活动回调
  final ValueChanged<ActivityRecord>? onActivityTap;

  /// 长按活动回调
  final ValueChanged<ActivityRecord>? onActivityLongPress;

  /// 添加记录按钮回调
  final VoidCallback? onAddRecord;

  const TimelineList({
    super.key,
    required this.records,
    this.onActivityTap,
    this.onActivityLongPress,
    this.onAddRecord,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _buildEmptyState(context);
    }

    return CustomPaint(
      painter: _TimelineAxisPainter(
        records: records,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return _buildTimelineItem(context, record, index);
        },
      ),
    );
  }

  /// 构建时间轴项目
  Widget _buildTimelineItem(
    BuildContext context,
    ActivityRecord record,
    int index,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧时间轴区域
          SizedBox(
            width: 48,
            child: Column(
              children: [
                const SizedBox(height: 24),
                // 时间节点
                _buildTimelineNode(record),
                const SizedBox(height: 8),
              ],
            ),
          ),
          // 右侧活动卡片
          Expanded(
            child: TimelineActivityCard(
              record: record,
              onTap: onActivityTap != null
                  ? () => onActivityTap!(record)
                  : null,
              onLongPress: onActivityLongPress != null
                  ? () => onActivityLongPress!(record)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建时间节点
  Widget _buildTimelineNode(ActivityRecord record) {
    final color = getActivityColor(record.type);

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(77),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 空状态插图
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              size: 48,
              color: AppColors.primary.withAlpha(179),
            ),
          ),
          const SizedBox(height: 24),
          // 引导文案
          Text(
            '今天还没有记录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击添加第一条记录',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),
          const SizedBox(height: 24),
          // 添加按钮
          if (onAddRecord != null)
            FilledButton.icon(
              onPressed: onAddRecord,
              icon: const Icon(Icons.add),
              label: const Text('添加记录'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.lg,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 时间轴连线绘制器
class _TimelineAxisPainter extends CustomPainter {
  final List<ActivityRecord> records;

  _TimelineAxisPainter({required this.records});

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.outline.withAlpha(77)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 绘制垂直时间轴线
    // 从第一个节点的中心到最后一个节点的中心
    const startX = 24.0; // 左侧区域宽度48的一半
    const startY = 32.0; // 第一个节点位置 (24 + 16/2 + 8)
    final endY = records.length * 120.0; // 估算每个项目的高度

    // 绘制虚线效果
    const dashHeight = 4.0;
    const dashSpace = 4.0;
    var currentY = startY;

    while (currentY < endY) {
      canvas.drawLine(
        Offset(startX, currentY),
        Offset(startX, currentY + dashHeight),
        paint,
      );
      currentY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
