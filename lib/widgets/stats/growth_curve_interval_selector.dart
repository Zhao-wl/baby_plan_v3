import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 步长类型
enum GrowthInterval {
  /// 日步长 - 显示最近 30 天
  day,

  /// 周步长 - 显示最近 12 周
  week,

  /// 月步长 - 显示出生至今
  month,
}

/// 快速预设选项
enum DateRangePreset {
  /// 最近 7 天
  last7Days,

  /// 最近 30 天
  last30Days,

  /// 最近 90 天
  last90Days,

  /// 最近 4 周
  last4Weeks,

  /// 最近 12 周
  last12Weeks,

  /// 最近 26 周
  last26Weeks,

  /// 出生至今
  birthToNow,

  /// 最近 6 个月
  last6Months,

  /// 最近 12 个月
  last12Months,

  /// 自定义
  custom,
}

/// 快速预设选项扩展
extension DateRangePresetExtension on DateRangePreset {
  String get label {
    switch (this) {
      case DateRangePreset.last7Days:
        return '最近 7 天';
      case DateRangePreset.last30Days:
        return '最近 30 天';
      case DateRangePreset.last90Days:
        return '最近 90 天';
      case DateRangePreset.last4Weeks:
        return '最近 4 周';
      case DateRangePreset.last12Weeks:
        return '最近 12 周';
      case DateRangePreset.last26Weeks:
        return '最近 26 周';
      case DateRangePreset.birthToNow:
        return '出生至今';
      case DateRangePreset.last6Months:
        return '最近 6 个月';
      case DateRangePreset.last12Months:
        return '最近 12 个月';
      case DateRangePreset.custom:
        return '自定义';
    }
  }

  DateTimeRange? getDateRange(DateTime? birthDate) {
    final now = DateTime.now();
    switch (this) {
      case DateRangePreset.last7Days:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
      case DateRangePreset.last30Days:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
      case DateRangePreset.last90Days:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 90)),
          end: now,
        );
      case DateRangePreset.last4Weeks:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 28)),
          end: now,
        );
      case DateRangePreset.last12Weeks:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 84)),
          end: now,
        );
      case DateRangePreset.last26Weeks:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 182)),
          end: now,
        );
      case DateRangePreset.birthToNow:
        if (birthDate == null) return null;
        return DateTimeRange(
          start: birthDate,
          end: now,
        );
      case DateRangePreset.last6Months:
        return DateTimeRange(
          start: DateTime(now.year, now.month - 6, now.day),
          end: now,
        );
      case DateRangePreset.last12Months:
        return DateTimeRange(
          start: DateTime(now.year - 1, now.month, now.day),
          end: now,
        );
      case DateRangePreset.custom:
        return null;
    }
  }
}

/// 步长选择器的状态
class GrowthIntervalSelectorState {
  /// 当前选中的步长
  final GrowthInterval interval;

  /// 时间区间偏移量（0 表示当前区间，正数表示过去的区间）
  final int offset;

  /// 自定义开始日期
  final DateTime? startDate;

  /// 自定义结束日期
  final DateTime? endDate;

  const GrowthIntervalSelectorState({
    required this.interval,
    this.offset = 0,
    this.startDate,
    this.endDate,
  });

  /// 是否使用自定义日期范围
  bool get hasCustomRange => startDate != null && endDate != null;

  /// 获取日期范围
  DateTimeRange? getDateRange() {
    if (hasCustomRange) {
      return DateTimeRange(start: startDate!, end: endDate!);
    }
    return null;
  }

  GrowthIntervalSelectorState copyWith({
    GrowthInterval? interval,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    bool clearCustomRange = false,
  }) {
    return GrowthIntervalSelectorState(
      interval: interval ?? this.interval,
      offset: offset ?? this.offset,
      startDate: clearCustomRange ? null : (startDate ?? this.startDate),
      endDate: clearCustomRange ? null : (endDate ?? this.endDate),
    );
  }
}

/// 生长曲线步长和区间选择器
///
/// 支持日/周/月步长切换和自定义时间范围选择。
class GrowthCurveIntervalSelector extends StatelessWidget {
  /// 当前选中的步长
  final GrowthInterval selectedInterval;

  /// 当前时间区间偏移量
  final int offset;

  /// 步长切换回调
  final ValueChanged<GrowthInterval> onIntervalChanged;

  /// 时间区间偏移量变化回调
  final ValueChanged<int> onOffsetChanged;

  /// 当前时间区间标题
  final String? rangeTitle;

  /// 是否可以向后切换（是否已到达当前日期）
  final bool canGoForward;

  /// 自定义日期范围变化回调
  final ValueChanged<DateTimeRange?>? onDateRangeChanged;

  /// 当前自定义日期范围
  final DateTimeRange? customDateRange;

  /// 宝宝出生日期（用于"出生至今"预设）
  final DateTime? birthDate;

  const GrowthCurveIntervalSelector({
    super.key,
    required this.selectedInterval,
    required this.offset,
    required this.onIntervalChanged,
    required this.onOffsetChanged,
    this.rangeTitle,
    this.canGoForward = false,
    this.onDateRangeChanged,
    this.customDateRange,
    this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // 步长选择器
        _buildIntervalTabs(context),
        const SizedBox(height: AppSpacing.paddingSm),
        // 时间区间选择器
        _buildTimeRangeSelector(context, colorScheme),
      ],
    );
  }

  /// 构建步长选择标签
  Widget _buildIntervalTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: GrowthInterval.values.map((interval) {
          final isSelected = interval == selectedInterval;
          return _buildIntervalTab(context, interval, isSelected);
        }).toList(),
      ),
    );
  }

  /// 构建单个步长选项
  Widget _buildIntervalTab(
    BuildContext context,
    GrowthInterval interval,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = _getIntervalLabel(interval);

    return GestureDetector(
      onTap: () => onIntervalChanged(interval),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingXs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppBorderRadius.sm,
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.outline.withAlpha(77),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  /// 获取步长标签
  String _getIntervalLabel(GrowthInterval interval) {
    switch (interval) {
      case GrowthInterval.day:
        return '日';
      case GrowthInterval.week:
        return '周';
      case GrowthInterval.month:
        return '月';
    }
  }

  /// 构建时间区间选择器
  Widget _buildTimeRangeSelector(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 左箭头（向前切换）
        IconButton(
          onPressed: () => onOffsetChanged(offset + 1),
          icon: const Icon(Icons.chevron_left),
          iconSize: 24,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: colorScheme.onSurface.withAlpha(153),
        ),
        // 时间区间标题（可点击）
        _buildClickableRangeTitle(context, colorScheme),
        // 右箭头（向后切换）
        IconButton(
          onPressed: canGoForward ? () => onOffsetChanged(offset - 1) : null,
          icon: const Icon(Icons.chevron_right),
          iconSize: 24,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: canGoForward
              ? colorScheme.onSurface.withAlpha(153)
              : colorScheme.onSurface.withAlpha(51),
        ),
      ],
    );
  }

  /// 构建可点击的时间区间标题
  Widget _buildClickableRangeTitle(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: onDateRangeChanged != null ? () => _showDateRangePicker(context) : null,
      borderRadius: AppBorderRadius.sm,
      child: Container(
        constraints: const BoxConstraints(minWidth: 120),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingSm,
          vertical: AppSpacing.paddingXs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              rangeTitle ?? _getDefaultTitle(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (onDateRangeChanged != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 18,
                color: colorScheme.onSurface.withAlpha(153),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 显示日期范围选择器
  void _showDateRangePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _DateRangePickerSheet(
        selectedInterval: selectedInterval,
        birthDate: birthDate,
        currentRange: customDateRange,
        onRangeSelected: (range) {
          Navigator.of(context).pop();
          onDateRangeChanged?.call(range);
        },
      ),
    );
  }

  /// 获取默认的时间区间标题
  String _getDefaultTitle() {
    if (customDateRange != null) {
      final start = customDateRange!.start;
      final end = customDateRange!.end;
      return '${start.month}/${start.day} - ${end.month}/${end.day}';
    }

    switch (selectedInterval) {
      case GrowthInterval.day:
        return offset == 0 ? '最近 30 天' : '往前 ${offset * 30} 天';
      case GrowthInterval.week:
        return offset == 0 ? '最近 12 周' : '往前 ${offset * 12} 周';
      case GrowthInterval.month:
        return offset == 0 ? '出生至今' : '往前 ${offset * 12} 个月';
    }
  }
}

/// 日期范围选择器底部弹窗
class _DateRangePickerSheet extends StatelessWidget {
  final GrowthInterval selectedInterval;
  final DateTime? birthDate;
  final DateTimeRange? currentRange;
  final ValueChanged<DateTimeRange?> onRangeSelected;

  const _DateRangePickerSheet({
    required this.selectedInterval,
    this.birthDate,
    this.currentRange,
    required this.onRangeSelected,
  });

  List<DateRangePreset> _getPresets() {
    switch (selectedInterval) {
      case GrowthInterval.day:
        return [
          DateRangePreset.last7Days,
          DateRangePreset.last30Days,
          DateRangePreset.last90Days,
        ];
      case GrowthInterval.week:
        return [
          DateRangePreset.last4Weeks,
          DateRangePreset.last12Weeks,
          DateRangePreset.last26Weeks,
        ];
      case GrowthInterval.month:
        return [
          DateRangePreset.birthToNow,
          DateRangePreset.last6Months,
          DateRangePreset.last12Months,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final presets = _getPresets();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingMd),
            child: Text(
              '选择时间范围',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const Divider(height: 1),
          // 预设选项
          ...presets.map((preset) => _buildPresetOption(context, preset)),
          const Divider(height: 1),
          // 自定义选项
          _buildCustomOption(context),
          const SizedBox(height: AppSpacing.paddingMd),
        ],
      ),
    );
  }

  Widget _buildPresetOption(BuildContext context, DateRangePreset preset) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(preset.label),
      trailing: preset == DateRangePreset.birthToNow && birthDate == null
          ? Text(
              '暂无出生日期',
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(128),
                fontSize: 12,
              ),
            )
          : null,
      enabled: !(preset == DateRangePreset.birthToNow && birthDate == null),
      onTap: () {
        final range = preset.getDateRange(birthDate);
        if (range != null) {
          onRangeSelected(range);
        }
      },
    );
  }

  Widget _buildCustomOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('自定义日期范围'),
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: currentRange,
        );
        if (range != null) {
          onRangeSelected(range);
        }
      },
    );
  }
}