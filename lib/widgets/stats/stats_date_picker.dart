import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/stats_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 周数据模型
class StatsWeekModel {
  /// 该周的起始日期（周一）
  final DateTime startDate;

  /// 该周的日期列表（周一至周日）
  late final List<DateTime> days;

  StatsWeekModel({required this.startDate}) {
    days = List.generate(7, (index) => startDate.add(Duration(days: index)));
  }
}

/// 月数据模型
class StatsMonthModel {
  final int year;
  final int month;
  late final List<List<DateTime>> weeks;

  StatsMonthModel({required this.year, required this.month}) {
    weeks = _calculateWeeks();
  }

  List<List<DateTime>> _calculateWeeks() {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final firstMonday = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    final lastSunday = lastDay.add(Duration(days: 7 - lastDay.weekday));

    final result = <List<DateTime>>[];
    var current = firstMonday;
    while (current.isBefore(lastSunday) || current.isAtSameMomentAs(lastSunday)) {
      final week = List<DateTime>.generate(7, (index) => current.add(Duration(days: index)));
      result.add(week);
      current = current.add(const Duration(days: 7));
    }
    return result;
  }

  bool isCurrentMonth(DateTime date) {
    return date.year == year && date.month == month;
  }
}

/// 统计页面日期选择器
///
/// 提供可展开/收起的日期选择器，支持：
/// - 收起状态：横向滑动切换时间段
/// - 展开状态：月历视图
/// - 日视图显示日期，周视图显示日期范围，月视图显示月份
class StatsDatePicker extends ConsumerStatefulWidget {
  /// 当前选中的日期
  final DateTime selectedDate;

  /// 当前周期
  final StatsPeriod period;

  /// 日期切换回调
  final ValueChanged<DateTime> onDateSelected;

  const StatsDatePicker({
    super.key,
    required this.selectedDate,
    required this.period,
    required this.onDateSelected,
  });

  @override
  ConsumerState<StatsDatePicker> createState() => _StatsDatePickerState();
}

class _StatsDatePickerState extends ConsumerState<StatsDatePicker> {
  late PageController _pageController;
  late int _currentPage;
  bool _isExpanded = false;

  // 基准日期：2024-01-01（周一）
  static final DateTime _baseDate = DateTime(2024, 1, 1);

  @override
  void initState() {
    super.initState();
    _currentPage = _calculatePageForDate(widget.selectedDate);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(StatsDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.period != widget.period) {
      final newPage = _calculatePageForDate(widget.selectedDate);
      if (newPage != _currentPage) {
        _currentPage = newPage;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentPage);
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 计算日期对应的页码
  int _calculatePageForDate(DateTime date) {
    switch (widget.period) {
      case StatsPeriod.day:
        final target = DateTime(date.year, date.month, date.day);
        return target.difference(_baseDate).inDays;
      case StatsPeriod.week:
        final weekday = date.weekday;
        final weekStart = DateTime(date.year, date.month, date.day)
            .subtract(Duration(days: weekday - 1));
        final difference = weekStart.difference(_baseDate).inDays;
        return difference ~/ 7;
      case StatsPeriod.month:
        return (date.year - _baseDate.year) * 12 + (date.month - _baseDate.month);
    }
  }

  /// 获取指定页码的起始日期
  DateTime _getDateForPage(int page) {
    switch (widget.period) {
      case StatsPeriod.day:
        return _baseDate.add(Duration(days: page));
      case StatsPeriod.week:
        return _baseDate.add(Duration(days: page * 7));
      case StatsPeriod.month:
        final year = _baseDate.year + (page + _baseDate.month - 1) ~/ 12;
        final month = (page + _baseDate.month - 1) % 12 + 1;
        return DateTime(year, month, 1);
    }
  }

  /// 获取显示的标题文本
  String get _displayText {
    final date = _getDateForPage(_currentPage);
    switch (widget.period) {
      case StatsPeriod.day:
        return '${date.year}年${date.month}月${date.day}日';
      case StatsPeriod.week:
        final endDate = date.add(const Duration(days: 6));
        if (date.month == endDate.month) {
          return '${date.month}月${date.day}日 - ${endDate.day}日';
        } else {
          return '${date.month}月${date.day}日 - ${endDate.month}月${endDate.day}日';
        }
      case StatsPeriod.month:
        return '${date.year}年${date.month}月';
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _selectDate(DateTime date) {
    widget.onDateSelected(date);
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentPage = _calculatePageForDate(date);
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentPage);
        }
      });
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == widget.selectedDate.year &&
        date.month == widget.selectedDate.month &&
        date.day == widget.selectedDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 340 : 56,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRect(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isExpanded ? _buildMonthView() : _buildPageView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _toggleExpanded,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMd),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isExpanded) ...[
              IconButton(
                icon: const Icon(Icons.chevron_left),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
              const Spacer(),
            ],
            Text(
              _displayText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
              color: colorScheme.onSurface.withAlpha(153),
            ),
            if (_isExpanded) ...[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, page) {
          final date = _getDateForPage(page);
          return Center(
            child: Text(
              _getDisplayTextForDate(date),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDisplayTextForDate(DateTime date) {
    switch (widget.period) {
      case StatsPeriod.day:
        final weekday = ['一', '二', '三', '四', '五', '六', '日'][date.weekday - 1];
        return '周$weekday';
      case StatsPeriod.week:
        return '本周';
      case StatsPeriod.month:
        return '本月';
    }
  }

  Widget _buildMonthView() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildMonthHeader(),
          SizedBox(
            height: 264,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, page) {
                  final date = _getDateForPage(page);
                  return _buildMonthGrid(StatsMonthModel(year: date.year, month: date.month));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: weekdays.map((day) {
          final isWeekend = day == '六' || day == '日';
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isWeekend
                      ? colorScheme.onSurface.withAlpha(102)
                      : colorScheme.onSurface.withAlpha(153),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthGrid(StatsMonthModel month) {
    const double rowHeight = 44.0;

    return Column(
      children: month.weeks.map((week) {
        return SizedBox(
          height: rowHeight,
          child: Row(
            children: week.map((day) {
              return Expanded(
                child: _buildDayCell(day, isCurrentMonth: month.isCurrentMonth(day)),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayCell(DateTime date, {required bool isCurrentMonth}) {
    final isToday = _isToday(date);
    final isSelected = _isSelected(date);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _selectDate(date),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withAlpha(26)
                      : null,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? AppColors.primary
                          : isCurrentMonth
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withAlpha(77),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}