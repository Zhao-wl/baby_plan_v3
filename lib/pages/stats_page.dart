import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/current_baby_provider.dart';
import '../providers/stats_provider.dart';
import '../theme/app_spacing.dart';
import '../widgets/stats/easy_cycle_card.dart';
import '../widgets/stats/feeding_poop_cards.dart';
import '../widgets/stats/growth_curve_card.dart';
import '../widgets/stats/sleep_stats_card.dart';
import '../widgets/stats/stats_date_picker.dart';
import '../widgets/stats/stats_period_tabs.dart';

/// 统计页面
///
/// 提供日/周/月视图切换，展示 E.A.S.Y 循环规律、睡眠分布、
/// 喂养排泄统计和生长曲线。
class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 当前选中的周期
  StatsPeriod _selectedPeriod = StatsPeriod.day;

  // 当前选中的日期
  DateTime _selectedDate = DateTime.now();

  void _onPeriodChanged(StatsPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    final currentBabyState = ref.watch(currentBabyProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: currentBabyState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentBabyState.baby == null
              ? _buildEmptyState(context)
              : _buildContent(context, currentBabyState.baby!.id),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care_outlined,
            size: 64,
            color: colorScheme.onSurface.withAlpha(77),
          ),
          const SizedBox(height: AppSpacing.paddingMd),
          Text(
            '请先添加宝宝',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, int babyId) {
    final query = StatsQuery(
      babyId: babyId,
      date: _selectedDate,
      period: _selectedPeriod,
    );
    final statsAsync = ref.watch(statsProvider(query));

    return Column(
      children: [
        // 周期切换 Tabs
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingMd),
          child: StatsPeriodTabs(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
          ),
        ),
        // 时间选择器
        StatsDatePicker(
          selectedDate: _selectedDate,
          period: _selectedPeriod,
          onDateSelected: _onDateSelected,
        ),
        // 统计内容
        Expanded(
          child: statsAsync.when(
            data: (stats) => _buildStatsContent(context, stats, babyId),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('加载失败: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsContent(BuildContext context, StatsData stats, int babyId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // E.A.S.Y 循环规律卡片
          EasyCycleCard(
            stats: stats,
            period: _selectedPeriod,
          ),
          const SizedBox(height: AppSpacing.paddingMd),

          // 睡眠分布卡片
          SleepStatsCard(
            babyId: babyId,
            selectedDate: _selectedDate,
            period: _selectedPeriod,
          ),
          const SizedBox(height: AppSpacing.paddingMd),

          // 喂养/排泄双列卡片
          FeedingPoopCards(
            stats: stats,
            period: _selectedPeriod,
          ),
          const SizedBox(height: AppSpacing.paddingMd),

          // 生长曲线卡片
          GrowthCurveCard(babyId: babyId),
          const SizedBox(height: AppSpacing.paddingLg),
        ],
      ),
    );
  }
}