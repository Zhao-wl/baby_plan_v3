import 'package:flutter/material.dart';
import 'package:baby_plan_v3/database/database.dart';
import 'package:baby_plan_v3/providers/vaccine_provider.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 单个疫苗卡片
///
/// 显示疫苗名称、状态、操作按钮。
/// 未完成的疫苗卡片整体可点击，已完成的不可点击。
class VaccineItemCard extends StatelessWidget {
  /// 疫苗计划项
  final VaccineScheduleItem item;

  /// 点击记录按钮的回调
  final VoidCallback? onRecordTap;

  const VaccineItemCard({
    super.key,
    required this.item,
    this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInteractive = !item.isDone && onRecordTap != null;

    return GestureDetector(
      onTap: isInteractive ? onRecordTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.paddingSm),
        padding: const EdgeInsets.all(AppSpacing.paddingMd),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            // 时间轴节点
            _buildTimelineNode(colorScheme),
            const SizedBox(width: AppSpacing.paddingMd),

            // 疫苗信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 疫苗名称和剂次
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.vaccine.name}（第${item.vaccine.doseIndex}针）',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      // 类型标签
                      _buildTypeTag(context, item.vaccine),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingXs),

                  // 状态信息
                  _buildStatusInfo(context, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建时间轴节点
  Widget _buildTimelineNode(ColorScheme colorScheme) {
    Color nodeColor;
    IconData iconData;

    switch (item.status) {
      case VaccineDisplayStatus.done:
        nodeColor = colorScheme.primary;
        iconData = Icons.check_circle;
        break;
      case VaccineDisplayStatus.overdue:
        nodeColor = colorScheme.error;
        iconData = Icons.warning;
        break;
      case VaccineDisplayStatus.upcoming:
        nodeColor = colorScheme.tertiary;
        iconData = Icons.schedule;
        break;
      case VaccineDisplayStatus.pending:
        nodeColor = colorScheme.outline;
        iconData = Icons.circle_outlined;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: nodeColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: nodeColor,
        size: AppSpacing.iconMd,
      ),
    );
  }

  /// 构建类型标签
  Widget _buildTypeTag(BuildContext context, VaccineLibraryData vaccine) {
    final isFree = vaccine.vaccineType == 0;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingXs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isFree
            ? colorScheme.primaryContainer.withOpacity(0.5)
            : colorScheme.tertiaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        isFree ? '免费' : '自费',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isFree
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onTertiaryContainer,
            ),
      ),
    );
  }

  /// 构建状态信息
  Widget _buildStatusInfo(BuildContext context, ColorScheme colorScheme) {
    // 已完成状态：显示接种日期
    if (item.isDone && item.record != null) {
      final dateStr = _formatDate(item.record!.actualDate);
      return Row(
        children: [
          Icon(
            Icons.check,
            color: colorScheme.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.paddingXs),
          Text(
            '已接种 $dateStr',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
          ),
        ],
      );
    }

    // 已逾期状态：显示逾期提示
    if (item.isOverdue) {
      return Row(
        children: [
          Icon(
            Icons.warning_amber,
            color: colorScheme.error,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.paddingXs),
          Text(
            '已逾期，点击补录',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
          ),
        ],
      );
    }

    // 近期计划状态：显示计划日期
    if (item.isUpcoming) {
      return Row(
        children: [
          Icon(
            Icons.schedule,
            color: colorScheme.tertiary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.paddingXs),
          Text(
            '建议近期接种，点击记录',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.tertiary,
                ),
          ),
        ],
      );
    }

    // 待接种状态：仅显示状态
    return Row(
      children: [
        Icon(
          Icons.circle_outlined,
          color: colorScheme.outline,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.paddingXs),
        Text(
          '待接种',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
        ),
      ],
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }
}