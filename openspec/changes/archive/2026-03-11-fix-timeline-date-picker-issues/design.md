## Context

时间线日期选择器 (`TimelineDatePicker`) 是一个可展开/收起的日期选择组件：
- **收起状态**：显示一周日期，支持左右滑动切换周
- **展开状态**：显示月历视图，支持左右滑动切换月份

当前存在三个 UI 问题：
1. 展开时有 `OVERFLOWED BY 0.4 PIXELS` 溢出
2. 展开后选中日期的白色文字与背景对比度不足
3. 收回时周视图跳转到今天所在周，而非选中日期所在周

## Goals / Non-Goals

**Goals:**
- 修复周视图日期单元格的溢出问题
- 改善展开状态下选中日期的视觉可读性
- 确保收回时保持选中日期所在周的显示

**Non-Goals:**
- 不改变日期选择器的整体交互逻辑
- 不添加新的功能特性
- 不修改组件的对外 API

## Decisions

### 1. 溢出修复方案

**问题分析**：
周视图日期单元格 (`_buildDayCell`) 高度为 72px，内容包含：
- 星期文字 (12px) + SizedBox(4px) + 日期圆形 (32px) + SizedBox(2px) + "今天"文字 (10px)
- 文字高度约 14px + 4px + 32px + 2px + 12px = 64px
- 但加上 padding 和 margin，可能超出 72px

**决策**：调整单元格高度从 72px 增加到 76px，或减少内部间距。选择增加高度，确保内容不被裁剪。

### 2. 选中日期颜色修复方案

**问题分析**：
在月视图（展开状态）下，选中日期使用 `isSelected ? Colors.white` 作为文字颜色，但没有为选中日期添加背景色，导致白色文字在白色背景上不可见。

**决策**：在月视图下，为选中日期添加圆形主色调背景（类似周视图的实现），确保白色文字可读。

### 3. 收回定位修复方案

**问题分析**：
`_selectDate` 方法在收回时调用：
```dart
_currentWeekPage = _calculateWeekPageForDate(date);
_weekPageController.jumpToPage(_currentWeekPage);
```
但 `_toggleExpanded` 在展开时调用：
```dart
_currentMonthPage = _calculateMonthPageForDate(widget.selectedDate);
```
收回时没有同步周视图页码。

**决策**：在 `_selectDate` 收回逻辑中，正确同步周视图页码到选中日期所在周。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 增加单元格高度可能影响整体布局 | 使用精确计算，确保不破坏现有布局 |
| 选中日期样式变更可能影响暗色模式 | 使用 `Theme.of(context).colorScheme` 确保主题适配 |