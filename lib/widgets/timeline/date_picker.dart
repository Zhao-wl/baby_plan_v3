import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 周数据模型
class WeekModel {
  /// 该周的起始日期（周一）
  final DateTime startDate;

  /// 该周的日期列表（周一至周日）
  late final List<DateTime> days;

  WeekModel({required this.startDate}) {
    // 计算本周的7天
    days = List.generate(7, (index) {
      return startDate.add(Duration(days: index));
    });
  }

  /// 判断某天是否在今天所在的周
  bool containsToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return days.any((day) =>
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day);
  }

  /// 判断某天是否在该周
  bool containsDate(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    return days.any((day) =>
        day.year == target.year &&
        day.month == target.month &&
        day.day == target.day);
  }
}

/// 时间线日期选择器
///
/// 提供横向滑动的一周日期选择器，支持：
/// - 左右滑动切换周
/// - 点击日期选中
/// - 今天标识
/// - 选中日期高亮
class TimelineDatePicker extends ConsumerStatefulWidget {
  /// 当前选中的日期
  final DateTime selectedDate;

  /// 日期切换回调
  final ValueChanged<DateTime> onDateSelected;

  const TimelineDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  ConsumerState<TimelineDatePicker> createState() =>
      _TimelineDatePickerState();
}

class _TimelineDatePickerState extends ConsumerState<TimelineDatePicker> {
  late PageController _pageController;
  late int _currentPage;

  // 基准日期：2024-01-01（周一）
  static final DateTime _baseDate = DateTime(2024, 1, 1);

  @override
  void initState() {
    super.initState();
    _currentPage = _calculatePageForDate(widget.selectedDate);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(TimelineDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      final newPage = _calculatePageForDate(widget.selectedDate);
      if (newPage != _currentPage) {
        _currentPage = newPage;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
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
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(_baseDate).inDays;
    // 计算是第几周（从周一开始）
    final weekNumber = (difference - (difference % 7)) ~/ 7;
    return weekNumber;
  }

  /// 获取指定页码的周起始日期
  DateTime _getWeekStartForPage(int page) {
    return _baseDate.add(Duration(days: page * 7));
  }

  /// 判断是否为今天
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 判断是否为选中的日期
  bool _isSelected(DateTime date) {
    return date.year == widget.selectedDate.year &&
        date.month == widget.selectedDate.month &&
        date.day == widget.selectedDate.day;
  }

  /// 获取星期几文字
  String _getWeekdayText(int weekday) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return weekdays[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80,
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
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, page) {
          final weekStart = _getWeekStartForPage(page);
          final weekModel = WeekModel(startDate: weekStart);
          return _buildWeekView(weekModel);
        },
      ),
    );
  }

  /// 构建一周的视图
  Widget _buildWeekView(WeekModel week) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: week.days.map((day) => _buildDayCell(day)).toList(),
    );
  }

  /// 构建日期单元格
  Widget _buildDayCell(DateTime date) {
    final isToday = _isToday(date);
    final isSelected = _isSelected(date);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => widget.onDateSelected(date),
      child: Container(
        width: 44,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : null,
          borderRadius: AppBorderRadius.md,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 星期几
            Text(
              _getWeekdayText(date.weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 4),
            // 日期数字
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday && !isSelected
                    ? AppColors.primary.withAlpha(26)
                    : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? AppColors.primary
                            : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            // 今天标识
            Text(
              isToday ? '今天' : '',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
