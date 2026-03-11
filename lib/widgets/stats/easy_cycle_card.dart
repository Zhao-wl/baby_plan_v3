import 'package:flutter/material.dart';

import '../../providers/stats_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// E.A.S.Y 循环规律分析卡片
///
/// 展示吃/玩/睡的时间比例进度条和平均循环周期。
class EasyCycleCard extends StatelessWidget {
  /// 统计数据
  final StatsData stats;

  /// 当前周期
  final StatsPeriod period;

  const EasyCycleCard({
    super.key,
    required this.stats,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cycleData = stats.easyCycleData;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppBorderRadius.lg,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.paddingMd),
          if (cycleData.hasData)
            _buildProgressBar(context, cycleData)
          else
            _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        const Icon(
          Icons.refresh_outlined,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.paddingSm),
        Text(
          'E.A.S.Y 循环规律',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, EasyCycleData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 横向进度条
        ClipRRect(
          borderRadius: AppBorderRadius.sm,
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                _buildBarSegment(
                  data.eatPercent,
                  AppColors.eat,
                  '吃',
                ),
                _buildBarSegment(
                  data.activityPercent,
                  AppColors.activity,
                  '玩',
                ),
                _buildBarSegment(
                  data.sleepPercent,
                  AppColors.sleep,
                  '睡',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingMd),
        // 比例图例
        _buildLegend(context, data),
        const SizedBox(height: AppSpacing.paddingMd),
        // 平均周期
        _buildCycleInfo(context, data),
      ],
    );
  }

  Widget _buildBarSegment(double percent, Color color, String label) {
    if (percent <= 0) return const SizedBox.shrink();

    return Expanded(
      flex: percent.round().clamp(1, 100),
      child: Container(
        color: color,
        child: percent > 15
            ? Center(
                child: Text(
                  '${percent.round()}%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildLegend(BuildContext context, EasyCycleData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('吃', AppColors.eat, '${data.eatPercent.round()}%'),
        _buildLegendItem('玩', AppColors.activity, '${data.activityPercent.round()}%'),
        _buildLegendItem('睡', AppColors.sleep, '${data.sleepPercent.round()}%'),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppBorderRadius.xs,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCycleInfo(BuildContext context, EasyCycleData data) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withAlpha(51),
        borderRadius: AppBorderRadius.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '平均周期: ',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(178),
            ),
          ),
          Text(
            '${data.avgCycleHours.toStringAsFixed(1)} 小时',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          if (data.cycleChange != null) ...[
            const SizedBox(width: 8),
            _buildChangeIndicator(data.cycleChange!),
          ],
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(double change) {
    final isIncrease = change > 0;
    final color = isIncrease ? Colors.red : Colors.green;
    final icon = isIncrease ? Icons.arrow_upward : Icons.arrow_downward;
    final text = isIncrease ? '延长' : '缩短';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        Text(
          ' $text ${change.abs().toStringAsFixed(1)}h',
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingLg),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 32,
              color: colorScheme.onSurface.withAlpha(77),
            ),
            const SizedBox(height: AppSpacing.paddingSm),
            Text(
              '暂无足够数据',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }
}