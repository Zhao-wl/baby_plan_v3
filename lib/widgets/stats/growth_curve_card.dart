import 'package:drift/drift.dart' hide isNotNull, Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/current_baby_provider.dart';
import '../../providers/database_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'growth_curve_interval_selector.dart';

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
/// 支持日/周/月步长切换和时间区间选择。
class GrowthCurveCard extends ConsumerStatefulWidget {
  /// 宝宝 ID
  final int babyId;

  const GrowthCurveCard({
    super.key,
    required this.babyId,
  });

  @override
  ConsumerState<GrowthCurveCard> createState() => _GrowthCurveCardState();
}

class _GrowthCurveCardState extends ConsumerState<GrowthCurveCard> {
  /// 当前选中的步长
  GrowthInterval _selectedInterval = GrowthInterval.month;

  /// 时间区间偏移量
  int _offset = 0;

  /// 自定义日期范围
  DateTimeRange? _customDateRange;

  void _onIntervalChanged(GrowthInterval interval) {
    setState(() {
      _selectedInterval = interval;
      _offset = 0; // 切换步长时重置偏移量
      _customDateRange = null; // 切换步长时清除自定义范围
    });
  }

  void _onOffsetChanged(int offset) {
    setState(() {
      _offset = offset.clamp(0, 100); // 限制偏移量范围
      _customDateRange = null; // 使用偏移量时清除自定义范围
    });
  }

  void _onDateRangeChanged(DateTimeRange? range) {
    setState(() {
      _customDateRange = range;
      _offset = 0; // 使用自定义范围时重置偏移量
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final growthDataAsync = ref.watch(growthRecordsProvider(widget.babyId));
    final currentBabyState = ref.watch(currentBabyProvider);

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
          const SizedBox(height: AppSpacing.paddingSm),
          // 步长选择器
          GrowthCurveIntervalSelector(
            selectedInterval: _selectedInterval,
            offset: _offset,
            onIntervalChanged: _onIntervalChanged,
            onOffsetChanged: _onOffsetChanged,
            rangeTitle: _getRangeTitle(currentBabyState.baby),
            canGoForward: _offset > 0,
            onDateRangeChanged: _onDateRangeChanged,
            customDateRange: _customDateRange,
            birthDate: currentBabyState.baby?.birthDate,
          ),
          const SizedBox(height: AppSpacing.paddingMd),
          growthDataAsync.when(
            data: (data) => data.isNotEmpty
                ? _buildChart(context, data, currentBabyState.baby)
                : _buildEmptyState(context),
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

  /// 获取时间区间标题
  String? _getRangeTitle(baby) {
    // 自定义日期范围优先
    if (_customDateRange != null) {
      final start = _customDateRange!.start;
      final end = _customDateRange!.end;
      return '${start.month}/${start.day} - ${end.month}/${end.day}';
    }

    if (baby == null) return null;

    final now = DateTime.now();

    switch (_selectedInterval) {
      case GrowthInterval.day:
        final startDate = now.subtract(Duration(days: 30 + _offset * 30));
        final endDate = now.subtract(Duration(days: _offset * 30));
        if (_offset == 0) {
          return '最近 30 天';
        }
        return '${startDate.month}/${startDate.day} - ${endDate.month}/${endDate.day}';

      case GrowthInterval.week:
        if (_offset == 0) {
          return '最近 12 周';
        }
        return '往前 $_offset 个周期';

      case GrowthInterval.month:
        if (_offset == 0) {
          return '出生至今';
        }
        final monthsAgo = _offset * 12;
        return '往前 $monthsAgo 个月';
    }
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

  Widget _buildChart(BuildContext context, List<GrowthDataPoint> data, baby) {
    // 过滤出有体重数据的点
    final weightData = data.where((d) => d.weight != null).toList();
    if (weightData.isEmpty) {
      return _buildEmptyState(context);
    }

    // 获取当前主题亮度用于颜色调整
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 根据步长处理数据
    final processedData = _processDataByInterval(weightData, baby);
    if (processedData.isEmpty) {
      return _buildEmptyState(context);
    }

    // 计算图表范围
    final chartRange = _calculateChartRange(processedData, baby);

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8, // 顶部留空间给数据点
          right: 8, // 右侧留空间给数据点
        ),
        child: LineChart(
          LineChartData(
            clipData: const FlClipData.all(),
            minX: chartRange.minX,
            maxX: chartRange.maxX,
            minY: chartRange.minY,
            maxY: chartRange.maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
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
                    return _buildBottomTitle(value, chartRange.maxX);
                  },
                  reservedSize: 30,
                  interval: chartRange.labelInterval,
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
            // WHO 参考区域（仅月步长显示）- 使用蓝色系区分
            rangeAnnotations: RangeAnnotations(
              verticalRangeAnnotations: [],
              horizontalRangeAnnotations: _selectedInterval == GrowthInterval.month
                  ? whoWeightData.map((ref) {
                      // 深色模式下使用稍深的颜色以保持对比度
                      final areaColor = isDark
                          ? Colors.blue.shade900.withAlpha(77)
                          : Colors.blue.shade50;
                      return HorizontalRangeAnnotation(
                        y1: ref.p3Weight,
                        y2: ref.p97Weight,
                        color: areaColor,
                      );
                    }).toList()
                  : [],
            ),
            lineBarsData: [
              // P50 参考线（仅月步长显示）- 使用蓝色系区分
              if (_selectedInterval == GrowthInterval.month)
                _buildReferenceLine(
                    whoWeightData.map((d) => d.p50Weight).toList(), isDark),
              // 宝宝体重曲线
              _buildWeightLine(processedData, chartRange, isDark),
            ],
            extraLinesData: const ExtraLinesData(
              extraLinesOnTop: true,
            ),
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }

  /// 根据步长处理数据
  List<GrowthDataPoint> _processDataByInterval(
    List<GrowthDataPoint> data,
    baby,
  ) {
    final now = DateTime.now();

    // 自定义日期范围优先
    if (_customDateRange != null) {
      final filteredData = data.where((d) {
        return !d.date.isBefore(_customDateRange!.start) &&
               !d.date.isAfter(_customDateRange!.end);
      }).toList();

      // 根据步长聚合数据
      if (_selectedInterval == GrowthInterval.week) {
        return _aggregateByWeek(filteredData);
      }
      return filteredData;
    }

    switch (_selectedInterval) {
      case GrowthInterval.day:
        // 日步长：最近 30 天的每日数据点
        final startDate = now.subtract(Duration(days: 30 + _offset * 30));
        final endDate = now.subtract(Duration(days: _offset * 30));
        return data.where((d) {
          return d.date.isAfter(startDate) && d.date.isBefore(endDate);
        }).toList();

      case GrowthInterval.week:
        // 周步长：最近 12 周的周均数据点
        final startDate = now.subtract(Duration(days: 84 + _offset * 84));
        final endDate = now.subtract(Duration(days: _offset * 84));

        final filteredData = data.where((d) {
          return d.date.isAfter(startDate) && d.date.isBefore(endDate);
        }).toList();

        // 按周聚合数据
        return _aggregateByWeek(filteredData);

      case GrowthInterval.month:
        // 月步长：出生至今的月均数据点
        return data;
    }
  }

  /// 按周聚合数据
  List<GrowthDataPoint> _aggregateByWeek(List<GrowthDataPoint> data) {
    if (data.isEmpty) return [];

    final Map<int, List<GrowthDataPoint>> weekGroups = {};

    for (final point in data) {
      // 计算周数（从数据的第一个点开始计算）
      final daysSinceFirst = point.date.difference(data.first.date).inDays;
      final weekNumber = daysSinceFirst ~/ 7;
      weekGroups.putIfAbsent(weekNumber, () => []).add(point);
    }

    // 每周取平均值
    return weekGroups.entries.map((entry) {
      final weekData = entry.value;
      final avgWeight = weekData
          .where((d) => d.weight != null)
          .map((d) => d.weight!)
          .toList();

      return GrowthDataPoint(
        date: weekData.first.date,
        weight: avgWeight.isNotEmpty
            ? avgWeight.reduce((a, b) => a + b) / avgWeight.length
            : null,
        height: null,
      );
    }).toList();
  }

  /// 计算图表范围
  _ChartRange _calculateChartRange(List<GrowthDataPoint> data, baby) {
    final weights = data.where((d) => d.weight != null).map((d) => d.weight!).toList();
    if (weights.isEmpty) {
      return const _ChartRange(minX: 0, maxX: 12, minY: 2, maxY: 10, labelInterval: 2);
    }

    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    double minY = (minWeight - 1).clamp(2.0, 10.0);
    double maxY = (maxWeight + 1).clamp(6.0, 15.0);

    // 月步长时，确保 y 范围能覆盖 WHO 参考数据
    // 因为 HorizontalRangeAnnotation 不受 clipData 裁剪
    if (_selectedInterval == GrowthInterval.month) {
      // 确保 minY 不高于 WHO P3 最小值（出生时 P3=2.5kg）
      final whoMinP3 = whoWeightData.first.p3Weight; // 2.5kg
      if (minY > whoMinP3) {
        minY = 2.0;
      }

      // 确保 maxY 能覆盖到 WHO P97 最大值（12月时 P97=12.0kg）
      final whoMaxP97 = whoWeightData.last.p97Weight; // 12.0kg
      if (maxY < whoMaxP97 + 1) {
        maxY = whoMaxP97 + 1;
      }
    }

    double minX = 0;
    double maxX;
    double labelInterval;

    switch (_selectedInterval) {
      case GrowthInterval.day:
        maxX = 30.0;
        labelInterval = 7;
        break;
      case GrowthInterval.week:
        maxX = 12.0;
        labelInterval = 2;
        break;
      case GrowthInterval.month:
        // 月步长：根据宝宝月龄动态计算
        if (baby != null) {
          final currentAgeMonths =
              DateTime.now().difference(baby.birthDate).inDays / 30.0;
          maxX = (currentAgeMonths + 1).clamp(1.0, 12.0);
        } else {
          maxX = whoWeightData.length.toDouble() - 1;
        }
        labelInterval = 2;
        break;
    }

    return _ChartRange(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      labelInterval: labelInterval,
    );
  }

  /// 构建 x 轴标签
  Widget _buildBottomTitle(double value, double maxX) {
    if (value < 0 || value > maxX) {
      return const SizedBox.shrink();
    }

    switch (_selectedInterval) {
      case GrowthInterval.day:
        // 日步长：从左到右递增，左边是早期，右边是最近
        final daysAgo = (maxX - value).toInt();
        if (daysAgo == 0) return const Text('今天', style: TextStyle(fontSize: 10));
        if (value == 0) return const Text('30天前', style: TextStyle(fontSize: 10));
        return Text('${daysAgo}天前', style: const TextStyle(fontSize: 10));

      case GrowthInterval.week:
        // 周步长：从左到右递增，左边是早期，右边是最近
        final week = value.toInt();
        if (week == 0) return const Text('最早', style: TextStyle(fontSize: 10));
        if (value >= maxX - 0.5) return const Text('最近', style: TextStyle(fontSize: 10));
        return Text('第${week}周', style: const TextStyle(fontSize: 10));

      case GrowthInterval.month:
        final month = value.toInt();
        if (month == 0) return const Text('出生', style: TextStyle(fontSize: 10));
        return Text('$month月', style: const TextStyle(fontSize: 10));
    }
  }

  LineChartBarData _buildReferenceLine(List<double> p50Values, bool isDark) {
    // P50 参考线使用蓝色系，与主色区分
    final lineColor = isDark ? Colors.blue.shade200 : Colors.blue.shade300;
    return LineChartBarData(
      spots: p50Values.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList(),
      isCurved: true,
      color: lineColor,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData _buildWeightLine(
    List<GrowthDataPoint> data,
    _ChartRange chartRange,
    bool isDark,
  ) {
    // 曲线下方区域颜色，深色模式下略加深以增强可见性
    final belowColor = AppColors.primaryLight.withAlpha(77);

    return LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        final index = entry.key;
        final d = entry.value;

        double x;
        switch (_selectedInterval) {
          case GrowthInterval.day:
            // 日步长：x 为时间序号，从左到右递增（早期数据在左）
            final daysAgo = DateTime.now().difference(d.date).inDays;
            x = (chartRange.maxX - daysAgo).clamp(0.0, chartRange.maxX).toDouble();
            break;
          case GrowthInterval.week:
            // 周步长：x 为周序号，数据已按时间排序，从左到右递增
            x = index.toDouble().clamp(0.0, chartRange.maxX);
            break;
          case GrowthInterval.month:
            // 月步长：x 为月龄
            final ageInDays = d.date.difference(data.first.date).inDays;
            final monthAge = ageInDays / 30.0;
            x = monthAge.clamp(0.0, chartRange.maxX);
            break;
        }

        return FlSpot(x, d.weight!);
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
        color: belowColor,
      ),
      showingIndicators: data.isNotEmpty ? [data.length - 1] : [],
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

/// 图表范围数据类
class _ChartRange {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final double labelInterval;

  const _ChartRange({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.labelInterval,
  });
}