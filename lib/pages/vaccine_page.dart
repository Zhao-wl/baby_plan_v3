import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_plan_v3/providers/providers.dart';
import 'package:baby_plan_v3/widgets/vaccine/immunity_shield_card.dart';
import 'package:baby_plan_v3/widgets/vaccine/vaccine_group_card.dart';
import 'package:baby_plan_v3/widgets/vaccine/vaccine_record_sheet.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 疫苗接种页面
///
/// 按月龄分组展示国家免疫规划疫苗，支持状态显示和接种记录录入。
class VaccinePage extends ConsumerStatefulWidget {
  const VaccinePage({super.key});

  @override
  ConsumerState<VaccinePage> createState() => _VaccinePageState();
}

class _VaccinePageState extends ConsumerState<VaccinePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 疫苗组卡片的 GlobalKey 映射（月龄 -> key）
  final Map<String, GlobalKey> _ageGroupKeys = {};

  /// 是否需要自动滚动到首个未完成疫苗
  bool _needsAutoScroll = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用从后台恢复时，刷新数据
    if (state == AppLifecycleState.resumed) {
      ref.read(vaccineScheduleProvider.notifier).refresh();
    }
  }

  /// 打开接种记录弹窗
  Future<void> _openRecordSheet(VaccineScheduleItem item) async {
    if (item.isDone) {
      // 已完成的疫苗不响应点击
      return;
    }

    await VaccineRecordSheet.show(
      context: context,
      vaccine: item.vaccine,
      existingRecord: item.record,
    );

    // 记录完成后，下次进入需要重新定位
    _needsAutoScroll = true;
  }

  /// 查找首个未完成的疫苗（按优先级：逾期 > 近期计划 > 待接种）
  VaccineScheduleItem? _findFirstIncompleteVaccine(VaccineScheduleState state) {
    final allItems = state.vaccinesByAge.values.expand((list) => list).toList();

    // 按优先级查找
    // 1. 逾期疫苗
    final overdue = allItems.where((item) => item.isOverdue).firstOrNull;
    if (overdue != null) return overdue;

    // 2. 近期计划疫苗
    final upcoming = allItems.where((item) => item.isUpcoming).firstOrNull;
    if (upcoming != null) return upcoming;

    // 3. 待接种疫苗
    return allItems.where((item) => item.isPending).firstOrNull;
  }

  /// 自动滚动到首个未完成的疫苗
  void _autoScrollToFirstIncomplete(VaccineScheduleState state) {
    if (!_needsAutoScroll || state.isLoading || state.ageGroups.isEmpty) {
      return;
    }

    final targetItem = _findFirstIncompleteVaccine(state);
    if (targetItem == null) {
      // 所有疫苗已完成，不需要滚动
      _needsAutoScroll = false;
      return;
    }

    // 找到目标疫苗所在的月龄组
    final targetAgeGroup = targetItem.ageGroup;
    final targetKey = _ageGroupKeys[targetAgeGroup];

    if (targetKey?.currentContext != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          targetKey!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }

    _needsAutoScroll = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final scheduleState = ref.watch(vaccineScheduleProvider);
    final currentBaby = ref.watch(currentBabyProvider);

    // 数据加载完成后，自动滚动到首个未完成疫苗
    if (!scheduleState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoScrollToFirstIncomplete(scheduleState);
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(vaccineScheduleProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 应用栏
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text('疫苗接种'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showVaccineInfo(context),
                ),
              ],
            ),

            // 内容
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.paddingMd),
              sliver: scheduleState.isLoading
                  ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : scheduleState.error != null
                      ? SliverFillRemaining(
                          child: _buildErrorState(scheduleState.error!),
                        )
                      : currentBaby.baby == null
                          ? SliverFillRemaining(
                              child: _buildEmptyBabyState(),
                            )
                          : _buildContent(scheduleState),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建主内容
  Widget _buildContent(VaccineScheduleState state) {
    // 确保每个月龄组都有 GlobalKey
    for (final ageGroup in state.ageGroups) {
      _ageGroupKeys.putIfAbsent(ageGroup, () => GlobalKey());
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        // 免疫盾概览卡片
        ImmunityShieldCard(stats: state.stats),
        const SizedBox(height: AppSpacing.paddingLg),

        // 疫苗列表（按月龄分组）
        if (state.ageGroups.isEmpty)
          _buildEmptyState()
        else
          ...state.ageGroups.map((ageGroup) {
            final vaccines = state.vaccinesByAge[ageGroup] ?? [];
            final isLast = ageGroup == state.ageGroups.last;

            return Padding(
              key: _ageGroupKeys[ageGroup],
              padding: const EdgeInsets.only(bottom: AppSpacing.paddingMd),
              child: VaccineGroupCard(
                ageGroup: ageGroup,
                vaccines: vaccines,
                isLast: isLast,
                onRecordTap: _openRecordSheet,
              ),
            );
          }),
      ]),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: AppSpacing.paddingMd),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingMd),
          FilledButton(
            onPressed: () =>
                ref.read(vaccineScheduleProvider.notifier).refresh(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 构建空宝宝状态
  Widget _buildEmptyBabyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.child_care, size: 48, color: Colors.grey),
          const SizedBox(height: AppSpacing.paddingMd),
          Text(
            '请先添加宝宝信息',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.vaccines, size: 48, color: Colors.grey),
          const SizedBox(height: AppSpacing.paddingMd),
          Text(
            '暂无疫苗数据',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.paddingMd),
          FilledButton(
            onPressed: () =>
                ref.read(vaccineScheduleProvider.notifier).refresh(),
            child: const Text('刷新'),
          ),
        ],
      ),
    );
  }

  /// 显示疫苗信息
  void _showVaccineInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于疫苗接种'),
        content: const Text(
          '本页面展示国家免疫规划疫苗，按月龄分组排列。\n\n'
          '状态说明：\n'
          '• 已完成：该疫苗已接种\n'
          '• 已逾期：超过推荐日期30天未接种\n'
          '• 近期计划：推荐日期前后7天内\n'
          '• 待接种：距离推荐日期超过7天\n\n'
          '点击"记录"或"补录"按钮可录入接种信息。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}