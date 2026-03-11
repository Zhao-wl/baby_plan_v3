import 'package:flutter/material.dart';
import 'package:baby_plan_v3/providers/vaccine_provider.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 免疫盾概览卡片
///
/// 显示已获得保护数量和逾期预警。
class ImmunityShieldCard extends StatelessWidget {
  /// 统计数据
  final VaccineStats stats;

  const ImmunityShieldCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final protectionPercent = (stats.protectionRatio * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Icon(
                Icons.shield,
                color: colorScheme.onPrimaryContainer,
                size: AppSpacing.iconXl,
              ),
              const SizedBox(width: AppSpacing.paddingSm),
              Text(
                '免疫盾',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingMd),

          // 保护进度
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stats.completedCount.toString(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                ' / ${stats.totalCount}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
              ),
              const SizedBox(width: AppSpacing.paddingSm),
              Text(
                '($protectionPercent%)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingXs),
          Text(
            '已获得保护',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
          ),

          // 逾期预警
          if (stats.hasOverdue) ...[
            const SizedBox(height: AppSpacing.paddingMd),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMd,
                vertical: AppSpacing.paddingSm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: colorScheme.onErrorContainer,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.paddingXs),
                  Text(
                    '${stats.overdueCount} 剂疫苗已逾期，请及时补种',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}