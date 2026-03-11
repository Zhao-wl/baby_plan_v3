import 'package:flutter/material.dart';

import '../../providers/stats_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 喂养/排泄双列卡片
///
/// 显示日均奶量和日均排便次数的双列小卡片。
class FeedingPoopCards extends StatelessWidget {
  /// 统计数据
  final StatsData stats;

  /// 当前周期
  final StatsPeriod period;

  const FeedingPoopCards({
    super.key,
    required this.stats,
    required this.period,
  });

  int get _days => period == StatsPeriod.day ? 1 : (period == StatsPeriod.week ? 7 : 30);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildFeedingCard(context)),
        const SizedBox(width: AppSpacing.paddingMd),
        Expanded(child: _buildPoopCard(context)),
      ],
    );
  }

  Widget _buildFeedingCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avgFormula = stats.formulaMl > 0 ? stats.formulaMl ~/ _days : 0;

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
          Row(
            children: [
              const Icon(
                Icons.baby_changing_station_outlined,
                size: 18,
                color: AppColors.eat,
              ),
              const SizedBox(width: 6),
              Text(
                '日均奶量',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withAlpha(178),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingSm),
          Text(
            '$avgFormula',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.eat,
            ),
          ),
          Text(
            'ml/天',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(128),
            ),
          ),
          if (stats.breastMinutes > 0) ...[
            const SizedBox(height: AppSpacing.paddingXs),
            Text(
              '亲喂 ${stats.breastMinutes} 分钟',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurface.withAlpha(102),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPoopCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avgPoop = stats.avgPoopCount(_days);

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
          Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                size: 18,
                color: AppColors.poop,
              ),
              const SizedBox(width: 6),
              Text(
                '日均排便',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withAlpha(178),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingSm),
          Text(
            avgPoop.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.poop,
            ),
          ),
          Text(
            '次/天',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(128),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingXs),
          Row(
            children: [
              Icon(
                _getPoopStatusIcon(),
                size: 14,
                color: _getPoopStatusColor(),
              ),
              const SizedBox(width: 4),
              Text(
                _getPoopStatusText(),
                style: TextStyle(
                  fontSize: 11,
                  color: _getPoopStatusColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPoopStatusIcon() {
    final avgPoop = stats.avgPoopCount(_days);
    if (avgPoop >= 1 && avgPoop <= 4) {
      return Icons.check_circle_outline;
    } else if (avgPoop < 1) {
      return Icons.info_outline;
    } else {
      return Icons.warning_amber_outlined;
    }
  }

  Color _getPoopStatusColor() {
    final avgPoop = stats.avgPoopCount(_days);
    if (avgPoop >= 1 && avgPoop <= 4) {
      return Colors.green;
    } else if (avgPoop < 1) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getPoopStatusText() {
    final avgPoop = stats.avgPoopCount(_days);
    if (avgPoop >= 1 && avgPoop <= 4) {
      return '排便正常';
    } else if (avgPoop < 1) {
      return '排便偏少';
    } else {
      return '排便较多';
    }
  }
}