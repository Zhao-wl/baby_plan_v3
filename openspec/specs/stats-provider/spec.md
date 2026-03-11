# stats-provider Specification

## Purpose
statsProvider 提供宝宝活动数据的聚合统计功能，支持日/周/月周期查询，输出图表数据格式，用于统计页面可视化展示。

## Requirements
### Requirement: 统计数据聚合

系统 SHALL 提供 `statsProvider` 聚合 E.A.S.Y 各类活动统计数据，并在数据变化时自动刷新。

#### Scenario: 按日期范围聚合
- **WHEN** 指定日期范围和宝宝 ID
- **THEN** 返回该范围内的活动统计

#### Scenario: 数据变化时自动刷新
- **WHEN** `activityDataChangeProvider` 的值变化
- **THEN** `statsProvider` 自动重新查询并返回最新统计数据

### Requirement: 统计周期支持

statsProvider SHALL 支持日/周/月三种统计周期。

#### Scenario: 日统计
- **WHEN** 周期为日
- **THEN** 返回指定日期的统计数据

#### Scenario: 周统计
- **WHEN** 周期为周
- **THEN** 返回指定周的统计数据（周一到周日）

#### Scenario: 月统计
- **WHEN** 周期为月
- **THEN** 返回指定月的统计数据

### Requirement: 统计数据内容

statsProvider SHALL 返回以下统计指标：
- 各类活动总时长
- 睡眠分布（夜间/白天）
- 喂养次数和总量
- 排泄次数

#### Scenario: 睡眠统计
- **WHEN** 查询睡眠数据
- **THEN** 返回夜间睡眠时长和白天小睡时长

#### Scenario: 喂养统计
- **WHEN** 查询喂养数据
- **THEN** 返回喂养次数、母乳时长、奶粉总量

### Requirement: 统计依赖当前宝宝

statsProvider SHALL 依赖 currentBabyProvider 获取当前宝宝 ID。

#### Scenario: 当前宝宝变更时刷新
- **WHEN** 当前宝宝切换
- **THEN** statsProvider 自动刷新为新宝宝的统计

### Requirement: 支持图表数据格式输出

statsProvider SHALL 提供图表所需的时间序列数据格式，用于睡眠柱状图和生长曲线图。

#### Scenario: 获取周睡眠分布数据
- **WHEN** 请求周视图睡眠图表数据
- **THEN** 返回每日睡眠数据的列表，每项包含日期、夜间睡眠时长、白天小睡时长

#### Scenario: 获取月睡眠分布数据
- **WHEN** 请求月视图睡眠图表数据
- **THEN** 返回每日睡眠数据的列表（最多 30 天）

### Requirement: 提供 E.A.S.Y 循环比例数据

statsProvider SHALL 计算并返回吃/玩/睡的时间比例数据。

#### Scenario: 计算 E.A.S.Y 比例
- **WHEN** 查询统计数据
- **THEN** 返回吃/玩/睡各自占总活动时间的百分比

#### Scenario: 计算平均循环周期
- **WHEN** 查询周/月统计数据
- **THEN** 返回平均 E.A.S.Y 循环周期时长（小时）

### Requirement: 支持环比数据对比

statsProvider SHALL 提供当前周期与上一周期的对比数据。

#### Scenario: 周环比对比
- **WHEN** 查询周视图统计
- **THEN** 返回本周与上周的对比数据（如平均周期变化）

#### Scenario: 月环比对比
- **WHEN** 查询月视图统计
- **THEN** 返回本月与上月的对比数据

