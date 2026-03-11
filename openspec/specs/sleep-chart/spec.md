# sleep-chart Specification

## Purpose
睡眠图表组件提供堆叠柱状图展示每日睡眠分布，区分夜间睡眠和白天小睡，支持点击查看详情。

## Requirements

### Requirement: 显示睡眠分布堆叠柱状图

睡眠统计卡片 SHALL 使用堆叠柱状图展示每日的夜间睡眠和白天小睡时长。

#### Scenario: 周视图显示 7 天睡眠分布
- **WHEN** 用户查看周视图
- **THEN** 图表显示周一至周日的睡眠柱状图，每个柱子分为夜间睡眠（深色）和白天小睡（浅色）

#### Scenario: 显示日均总睡眠时长
- **WHEN** 用户查看任意视图
- **THEN** 卡片标题右侧显示日均总睡眠时长（如"13h 20m"）

#### Scenario: 点击柱子查看详情
- **WHEN** 用户点击图表中的某个柱子
- **THEN** 显示该日期的详细睡眠信息（总时长、夜间时长、白天时长、次数）

### Requirement: 图表颜色规范

睡眠图表 SHALL 遵循应用颜色规范：
- 夜间睡眠使用 `AppColors.sleep`（深蓝色）
- 白天小睡使用 `AppColors.sleepLight`（浅蓝色）

#### Scenario: 夜间睡眠颜色
- **WHEN** 渲染睡眠柱状图
- **THEN** 夜间睡眠部分使用深蓝色（#2196F3）

#### Scenario: 白天小睡颜色
- **WHEN** 渲染睡眠柱状图
- **THEN** 白天小睡部分使用浅蓝色（#E3F2FD）

### Requirement: 显示图例说明

睡眠图表 SHALL 提供图例说明，区分夜间睡眠和白天小睡。

#### Scenario: 显示图例
- **WHEN** 渲染睡眠图表
- **THEN** 图表下方显示"夜间睡眠"和"白天小睡"的图例，带有对应颜色的圆点标识