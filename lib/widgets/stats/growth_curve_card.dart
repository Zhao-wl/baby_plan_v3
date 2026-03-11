import 'package:drift/drift.dart' hide isNotNull, Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/database_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 生长曲线数据点
class GrowthDataPoint {
  final DateTime date;
  final double? weight;
  final double? height;
  final int? ageInDays;

  const GrowthDataPoint({
    required this.date,
    this.weight,
    this.height,
    this.ageInDays,
  });
}

/// WHO 生长标准参考数据（模拟数据）
///
/// 实际应用应从数据库或 API 获取真实的 WHO 数据。
class WHOReferenceData {
  /// 月龄
  final int monthAge;

  /// P3 百分位体重（kg）
  final double p3Weight;

  /// P50 百分位体重（kg）
  final double p50Weight;

  /// P97 百分位体重（kg）
  final double p97Weight;

  const WHOReferenceData({
    required this.monthAge,
    required this.p3Weight,
    required this.p50Weight,
    required this.p97Weight,
  });
}

/// 模拟 WHO 体重参考数据（男宝）
const List<WHOReferenceData> whoWeightData = [
  WHOReferenceData(monthAge: 0, p3Weight: 2.5, p50Weight: 3.3, p97Weight: 4.4),
  WHOReferenceData(monthAge: 1, p3Weight: 3.4, p50Weight: 4.5, p97Weight: 5.8),
  WHOReferenceData(monthAge: 2, p3Weight: 4.3, p50Weight: 5.6, p97Weight: 7.1),
  WHOReferenceData(monthAge: 3, p3Weight: 5.0, p50Weight: 6.4, p97Weight: 8.0),
  WHOReferenceData(monthAge: 4, p3Weight: 5.6, p50Weight: 7.0, p97Weight: 8.7),
  WHOReferenceData(monthAge: 5, p3Weight: 6.0, p50Weight: 7.5, p97Weight: 9.3),
  WHOReferenceData(monthAge: 6, p3Weight: 6.4, p50Weight: 7.9, p97Weight: 9.8),
  WHOReferenceData(monthAge: 7, p3Weight: 6.7, p50Weight: 8.3, p97Weight: 10.3),
  WHOReferenceData(monthAge: 8, p3Weight: 7.0, p50Weight: 8.6, p97Weight: 10.7),
  WHOReferenceData(monthAge: 9, p3Weight: 7.2, p50Weight: 8.9, p97Weight: 11.0),
  WHOReferenceData(monthAge: 10, p3Weight: 7.5, p50Weight: 9.2, p97Weight: 11.4),
  WHOReferenceData(monthAge: 11, p3Weight: 7.7, p50Weight: 9.4, p97Weight: 11.7),
  WHOReferenceData(monthAge: 12, p3Weight: 7.9, p50Weight: 9.6, p97Weight: 12.0),
];

/// 生长记录列表 Provider
final growthRecordsProvider =
    FutureProvider.family<List<GrowthDataPoint>, int>((ref, babyId) async {
  final db = ref.watch(databaseProvider);
  final records = await (db.select(db.growthRecords)
        ..where((r) => r.babyId.equals(babyId) & r.isDeleted.equals(false))
        ..orderBy([(r) => OrderingTerm.asc(r.recordDate)]))
      .get();

  return records
      .map((r) => GrowthDataPoint(
            date: r.recordDate,
            weight: r.weight,
            height: r.height,
          ))
      .toList();
});

/// 生长曲线卡片
///
/// 显示体重生长曲线折线图，包含 WHO 标准参考区域。
class GrowthCurveCard extends ConsumerWidget {
  /// 宝宝 ID
  final int babyId;

  const GrowthCurveCard({
    super.key,
    required this.babyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final growthDataAsync = ref.watch(growthRecordsProvider(babyId));

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
          growthDataAsync.when(
            data: (data) =>
                data.length >= 2 ? _buildChart(context, data) : _buildEmptyState(context),
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Center(child: Text('加载失败: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.trending_up_outlined,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.paddingSm),
            Text(
              '生长曲线',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // TODO: 导航到生长记录详情页面
          },
          child: const Text('查看详情'),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<GrowthDataPoint> data) {
    // 过滤出有体重数据的点
    final weightData = data.where((d) => d.weight != null).toList();
    if (weightData.isEmpty) {
      return _buildEmptyState(context);
    }

    // 计算图表范围
    final firstDate = weightData.first.date;
    final maxX = whoWeightData.length.toDouble() - 1;

    // 找到体重范围
    final weights = weightData.map((d) => d.weight!).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final minY = (minWeight - 1).clamp(2.0, 10.0);
    final maxY = (maxWeight + 1).clamp(6.0, 15.0);

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withAlpha(51),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final month = value.toInt();
                  if (month < 0 || month >= whoWeightData.length) {
                    return const SizedBox.shrink();
                  }
                  if (month == 0) {
                    return const Text('出生', style: TextStyle(fontSize: 10));
                  }
                  return Text('$month月', style: const TextStyle(fontSize: 10));
                },
                reservedSize: 30,
                interval: 2,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}kg',
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  );
                },
                reservedSize: 40,
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
          // WHO 参考区域（P3-P97）
          rangeAnnotations: RangeAnnotations(
            verticalRangeAnnotations: [],
            horizontalRangeAnnotations: whoWeightData.map((ref) {
              return HorizontalRangeAnnotation(
                y1: ref.p3Weight,
                y2: ref.p97Weight,
                color: AppColors.primaryLight.withAlpha(26),
              );
            }).toList(),
          ),
          lineBarsData: [
            // P50 参考线
            _buildReferenceLine(whoWeightData.map((d) => d.p50Weight).toList()),
            // 宝宝体重曲线
            _buildWeightLine(weightData, firstDate, minY),
          ],
          extraLinesData: const ExtraLinesData(
            extraLinesOnTop: true,
          ),
        ),
        duration: Duration.zero,
      ),
    );
  }

  LineChartBarData _buildReferenceLine(List<double> p50Values) {
    return LineChartBarData(
      spots: p50Values.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList(),
      isCurved: true,
      color: AppColors.primary.withAlpha(77),
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _buildWeightLine(
    List<GrowthDataPoint> data,
    DateTime firstDate,
    double minY,
  ) {
    return LineChartBarData(
      spots: data.map((d) {
        // 计算月龄
        final ageInDays = d.date.difference(firstDate).inDays;
        final monthAge = ageInDays / 30.0;
        return FlSpot(monthAge.clamp(0.0, 12.0), d.weight!);
      }).toList(),
      isCurved: true,
      color: AppColors.primary,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: AppColors.primary,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: AppColors.primaryLight.withAlpha(51),
      ),
      showingIndicators: data.length > 0 ? [data.length - 1] : [],
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
              Icons.trending_up_outlined,
              size: 48,
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
            const SizedBox(height: AppSpacing.paddingXs),
            TextButton(
              onPressed: () {
                // TODO: 导航到添加生长记录
              },
              child: const Text('添加生长记录'),
            ),
          ],
        ),
      ),
    );
  }
}