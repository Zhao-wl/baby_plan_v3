import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables/activity_records.dart';
import '../providers/current_baby_provider.dart';
import '../providers/database_provider.dart';
import '../providers/timeline_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/dashboard/quick_record_sheet.dart';
import '../widgets/timeline/date_picker.dart';
import '../widgets/timeline/timeline_list.dart';

/// 时间线页面
///
/// 展示宝宝按时间顺序排列的每日活动记录，包含：
/// - 顶部日期选择器（横向滑动切换周）
/// - 时间轴列表（活动卡片 + 时间线）
/// - 点击编辑 / 长按删除功能
/// - 空状态提示
class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// 当前选中的日期
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final currentBabyState = ref.watch(currentBabyProvider);

    return Scaffold(
      body: Column(
        children: [
          // 日期选择器
          TimelineDatePicker(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          // 时间线列表
          Expanded(
            child: _buildTimelineContent(currentBabyState),
          ),
        ],
      ),
    );
  }

  /// 构建时间线内容
  Widget _buildTimelineContent(CurrentBabyState currentBabyState) {
    // 检查是否已选择宝宝
    if (currentBabyState.baby == null) {
      return _buildNoBabyState();
    }

    final babyId = currentBabyState.baby!.id;
    final query = TimelineQuery(babyId: babyId, date: _selectedDate);

    // 监听时间线数据
    final timelineAsync = ref.watch(timelineProvider(query));

    return timelineAsync.when(
      data: (records) => TimelineList(
        records: records,
        onActivityTap: (record) => _onActivityTap(record),
        onActivityLongPress: (record) => _onActivityLongPress(record),
        onAddRecord: () => _showAddRecordSheet(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withAlpha(179),
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败: $error',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(timelineProvider(query)),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建未选择宝宝状态
  Widget _buildNoBabyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care,
              size: 48,
              color: AppColors.primary.withAlpha(179),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '还没有选择宝宝',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请先添加或选择宝宝',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  /// 点击活动卡片
  void _onActivityTap(ActivityRecord record) {
    // 显示编辑弹窗
    _showEditSheet(record);
  }

  /// 长按活动卡片
  void _onActivityLongPress(ActivityRecord record) {
    // 显示删除确认对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除记录'),
        content: Text(
          '确定要删除这条${_getActivityTypeName(record.type)}记录吗？此操作不可恢复。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteRecord(record);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 删除记录
  Future<void> _deleteRecord(ActivityRecord record) async {
    try {
      final db = ref.read(databaseProvider);
      await db.update(db.activityRecords).replace(
            record.copyWith(
              isDeleted: true,
              deletedAt: drift.Value(DateTime.now()),
              syncStatus: 1, // 标记为待上传
            ),
          );

      // 刷新时间线数据
      final babyId = ref.read(currentBabyProvider).baby?.id;
      if (babyId != null) {
        ref.invalidate(timelineProvider(
          TimelineQuery(babyId: babyId, date: _selectedDate),
        ));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('记录已删除'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 显示添加记录弹窗
  void _showAddRecordSheet() {
    // 显示一个选择活动类型的底部弹窗
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '添加记录',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildActivityTypeButton('吃奶', Icons.restaurant, AppColors.eat, () {
              Navigator.pop(context);
              QuickRecordSheet.show(
                context: context,
                activityType: ActivityType.eat,
              );
            }),
            const SizedBox(height: 12),
            _buildActivityTypeButton('玩耍', Icons.toys, AppColors.activity, () {
              Navigator.pop(context);
              QuickRecordSheet.show(
                context: context,
                activityType: ActivityType.activity,
              );
            }),
            const SizedBox(height: 12),
            _buildActivityTypeButton('睡眠', Icons.bedtime, AppColors.sleep, () {
              Navigator.pop(context);
              QuickRecordSheet.show(
                context: context,
                activityType: ActivityType.sleep,
              );
            }),
            const SizedBox(height: 12),
            _buildActivityTypeButton('排泄', Icons.baby_changing_station, AppColors.poop, () {
              Navigator.pop(context);
              QuickRecordSheet.show(
                context: context,
                activityType: ActivityType.poop,
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 构建活动类型按钮
  Widget _buildActivityTypeButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: AppBorderRadius.md,
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: AppBorderRadius.sm,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  /// 显示编辑弹窗
  void _showEditSheet(ActivityRecord record) {
    // 使用编辑模式打开弹窗
    QuickRecordSheet.showEdit(
      context: context,
      record: record,
    );
  }

  /// 获取活动类型名称
  String _getActivityTypeName(int type) {
    switch (type) {
      case 0:
        return '吃奶';
      case 1:
        return '玩耍';
      case 2:
        return '睡眠';
      case 3:
        return '排泄';
      default:
        return '活动';
    }
  }
}
