import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/stats_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 睡眠统计卡片
///
/// 使用堆叠柱状图展示每日的夜间睡眠和白天小睡时长。
class SleepStatsCard extends ConsumerWidget {
  /// 宝宝 ID
  final int babyId;

  /// 选中的日期
  final DateTime selectedDate;

  /// 当前周期
  final StatsPeriod period;

  const SleepStatsCard({
    super.key,
    required this.babyId,
    required this.selectedDate,
    required this.period,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final query = StatsQuery(
      babyId: babyId,
      date: selectedDate,
      period: period,
    );

    final sleepDataAsync = ref.watch(weeklySleepDataProvider(query));
    final statsAsync = ref.watch(statsProvider(query));

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
          _buildHeader(context, statsAsync),
          const SizedBox(height: AppSpacing.paddingMd),
          sleepDataAsync.when(
            data: (data) => data.isNotEmpty
                ? _buildChart(context, data)
                : _buildEmptyState(context),
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Center(child: Text('加载失败: $error')),
          ),
          const SizedBox(height: AppSpacing.paddingMd),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue<StatsData> statsAsync) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.bedtime_outlined,
              size: 20,
              color: AppColors.sleep,
            ),
            const SizedBox(width: AppSpacing.paddingSm),
            Text(
              '睡眠分布',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        statsAsync.when(
          data: (stats) {
            final days = period == StatsPeriod.week ? 7 : 30;
            return Text(
              stats.formattedAvgSleepDuration(days),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.sleep,
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<SleepChartData> data) {
    // 限制数据点数量
    final displayData = data.length > 30 ? data.sublist(data.length - 30) : data;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(displayData),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = displayData[groupIndex];
                return BarTooltipItem(
                  '${item.formattedDate}\n夜间: ${(item.nightSleepMinutes / 60).toStringAsFixed(1)}h\n白天: ${(item.daySleepMinutes / 60).toStringAsFixed(1)}h',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= displayData.length) {
                    return const SizedBox.shrink();
                  }
                  final item = displayData[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      period == StatsPeriod.week
                          ? item.weekdayText
                          : item.formattedDate,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  );
                },
                reservedSize: 30,
                interval: 2,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withAlpha(51),
                strokeWidth: 1,
              );
            },
          ),
          barGroups: displayData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.totalMinutes / 60,
                  width: period == StatsPeriod.week ? 24 : 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  rodStackItems: [
                    BarChartRodStackItem(
                      0,
                      item.nightSleepMinutes / 60,
                      AppColors.sleep,
                    ),
                    BarChartRodStackItem(
                      item.nightSleepMinutes / 60,
                      item.totalMinutes / 60,
                      AppColors.sleepLight,
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
        ),
        duration: Duration.zero,
      ),
    );
  }

  double _calculateMaxY(List<SleepChartData> data) {
    if (data.isEmpty) return 12;
    final maxMinutes = data.map((e) => e.totalMinutes).reduce((a, b) => a > b ? a : b);
    final maxHours = maxMinutes / 60;
    // 向上取整到最近的偶数
    return ((maxHours / 2).ceil() * 2).toDouble().clamp(4.0, 24.0);
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('夜间睡眠', AppColors.sleep),
        const SizedBox(width: AppSpacing.paddingLg),
        _buildLegendItem('白天小睡', AppColors.sleepLight),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bedtime_outlined,
              size: 48,
              color: colorScheme.onSurface.withAlpha(77),
            ),
            const SizedBox(height: AppSpacing.paddingSm),
            Text(
              '暂无睡眠记录',
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