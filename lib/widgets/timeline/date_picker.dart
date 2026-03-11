import 'package:flutter/gestures.dart';
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

/// 月数据模型
class MonthModel {
  /// 该月的年份
  final int year;

  /// 该月的月份（1-12）
  final int month;

  /// 该月的日期列表（按周排列）
  late final List<List<DateTime>> weeks;

  MonthModel({required this.year, required this.month}) {
    weeks = _calculateWeeks();
  }

  /// 计算该月的周列表
  List<List<DateTime>> _calculateWeeks() {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    // 找到第一天的周一
    final firstMonday = firstDay.subtract(Duration(days: firstDay.weekday - 1));

    // 找到最后一天的周日
    final lastSunday = lastDay.add(Duration(days: 7 - lastDay.weekday));

    // 生成周列表
    final result = <List<DateTime>>[];
    var current = firstMonday;
    while (current.isBefore(lastSunday) || current.isAtSameMomentAs(lastSunday)) {
      final week = List<DateTime>.generate(7, (index) {
        return current.add(Duration(days: index));
      });
      result.add(week);
      current = current.add(const Duration(days: 7));
    }

    return result;
  }

  /// 判断某天是否属于该月
  bool isCurrentMonth(DateTime date) {
    return date.year == year && date.month == month;
  }
}

/// 时间线日期选择器
///
/// 提供可展开/收起的日期选择器，支持：
/// - 收起状态：横向滑动切换周
/// - 展开状态：月历视图，左右滑动切换月份
/// - 点击月份标题切换展开/收起
/// - 月份标题随滑动实时更新
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
  // 周视图 PageController
  late PageController _weekPageController;
  late int _currentWeekPage;

  // 月视图 PageController
  late PageController _monthPageController;
  late int _currentMonthPage;

  // 展开状态
  bool _isExpanded = false;

  // 基准日期：2024-01-01（周一）
  static final DateTime _baseDate = DateTime(2024, 1, 1);

  // 基准月份：2024年1月
  static final DateTime _baseMonth = DateTime(2024, 1, 1);

  @override
  void initState() {
    super.initState();
    _currentWeekPage = _calculateWeekPageForDate(widget.selectedDate);
    _weekPageController = PageController(initialPage: _currentWeekPage);

    _currentMonthPage = _calculateMonthPageForDate(widget.selectedDate);
    _monthPageController = PageController(initialPage: _currentMonthPage);
  }

  @override
  void didUpdateWidget(TimelineDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      final newWeekPage = _calculateWeekPageForDate(widget.selectedDate);
      if (newWeekPage != _currentWeekPage) {
        _currentWeekPage = newWeekPage;
        // 使用 jumpToPage 避免动画冲突
        if (_weekPageController.hasClients) {
          _weekPageController.jumpToPage(_currentWeekPage);
        }
      }

      final newMonthPage = _calculateMonthPageForDate(widget.selectedDate);
      if (newMonthPage != _currentMonthPage) {
        _currentMonthPage = newMonthPage;
        if (_monthPageController.hasClients) {
          _monthPageController.jumpToPage(_currentMonthPage);
        }
      }
    }
  }

  @override
  void dispose() {
    _weekPageController.dispose();
    _monthPageController.dispose();
    super.dispose();
  }

  /// 计算日期对应的周页码
  int _calculateWeekPageForDate(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(_baseDate).inDays;
    final weekNumber = (difference - (difference % 7)) ~/ 7;
    return weekNumber;
  }

  /// 计算日期对应的月页码
  int _calculateMonthPageForDate(DateTime date) {
    return (date.year - _baseMonth.year) * 12 + (date.month - _baseMonth.month);
  }

  /// 获取指定周页码的周起始日期
  DateTime _getWeekStartForPage(int page) {
    return _baseDate.add(Duration(days: page * 7));
  }

  /// 获取指定月页码的月份
  MonthModel _getMonthForPage(int page) {
    final year = _baseMonth.year + (page + _baseMonth.month - 1) ~/ 12;
    final month = (page + _baseMonth.month - 1) % 12 + 1;
    return MonthModel(year: year, month: month);
  }

  /// 获取当前显示的月份文本
  String get _displayMonthText {
    if (_isExpanded) {
      final monthModel = _getMonthForPage(_currentMonthPage);
      return '${monthModel.year}年${monthModel.month}月';
    } else {
      // 周视图：取周中间日期（周四）作为月份参考
      final weekStart = _getWeekStartForPage(_currentWeekPage);
      final middleDay = weekStart.add(const Duration(days: 3));
      return '${middleDay.year}年${middleDay.month}月';
    }
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

  /// 切换展开/收起状态
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    // 展开时同步月份页码（在下一帧执行，确保 PageView 已构建）
    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentMonthPage = _calculateMonthPageForDate(widget.selectedDate);
        if (_monthPageController.hasClients) {
          _monthPageController.jumpToPage(_currentMonthPage);
        }
      });
    }
  }

  /// 切换到上个月
  void _previousMonth() {
    _monthPageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 切换到下个月
  void _nextMonth() {
    _monthPageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 选择日期
  void _selectDate(DateTime date) {
    widget.onDateSelected(date);
    // 展开状态下选择日期后自动收起
    if (_isExpanded) {
      // 先计算并更新周视图页码，再收起视图
      final newWeekPage = _calculateWeekPageForDate(date);
      _currentWeekPage = newWeekPage;

      setState(() {
        _isExpanded = false;
      });

      // 在下一帧同步 PageController（确保 PageView 已重建）
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_weekPageController.hasClients) {
          _weekPageController.jumpToPage(_currentWeekPage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 340 : 124,
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
        child: ClipRect(  // 裁剪动画过程中的溢出内容
          child: Column(
            children: [
              // 年月显示 Header
              _buildHeader(),
              // 内容区域
              Expanded(
                child: _isExpanded ? _buildMonthPageView() : _buildWeekPageView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建年月显示 Header
  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _toggleExpanded,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 左箭头（展开状态下显示）
            if (_isExpanded) ...[
              IconButton(
                icon: const Icon(Icons.chevron_left),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                onPressed: _previousMonth,
              ),
              const Spacer(),
            ],
            // 年月标题
            Text(
              _displayMonthText,
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
            // 右箭头（展开状态下显示）
            if (_isExpanded) ...[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                onPressed: _nextMonth,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建周视图 PageView
  Widget _buildWeekPageView() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: PageView.builder(
        controller: _weekPageController,
        onPageChanged: (page) {
          setState(() {
            _currentWeekPage = page;
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

  /// 构建月视图 PageView
  Widget _buildMonthPageView() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // 禁止滚动，但允许裁剪溢出
      child: Column(
        children: [
          // 星期标题行
          _buildMonthHeader(),
          // 月历网格 - 使用固定高度
          SizedBox(
            height: 264, // 6行 × 44像素
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: PageView.builder(
                controller: _monthPageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentMonthPage = page;
                  });
                },
                itemBuilder: (context, page) {
                  final monthModel = _getMonthForPage(page);
                  return _buildMonthView(monthModel);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建星期标题行
  Widget _buildMonthHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];

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

  /// 构建一周的视图
  Widget _buildWeekView(WeekModel week) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: week.days.map((day) => _buildDayCell(day, isCompact: true)).toList(),
    );
  }

  /// 构建月视图
  Widget _buildMonthView(MonthModel month) {
    // 每行固定高度 44 像素
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

  /// 构建日期单元格
  Widget _buildDayCell(DateTime date, {bool isCompact = false, bool isCurrentMonth = true}) {
    final isToday = _isToday(date);
    final isSelected = _isSelected(date);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _selectDate(date),
      child: Container(
        width: isCompact ? 44 : null,
        height: isCompact ? 76 : null,
        margin: isCompact ? null : const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isCompact && isSelected ? AppColors.primary : null,
          borderRadius: isCompact ? AppBorderRadius.md : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 星期几（仅周视图显示）
            if (isCompact) ...[
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
            ],
            // 日期数字
            Container(
              width: isCompact ? 32 : 36,
              height: isCompact ? 32 : 36,
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
                    fontSize: isCompact ? 16 : 14,
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
            // 今天标识（仅周视图显示）
            if (isCompact) ...[
              const SizedBox(height: 2),
              Text(
                isToday ? '今天' : '',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}