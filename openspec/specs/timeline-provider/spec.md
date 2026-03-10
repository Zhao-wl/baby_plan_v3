# timeline-provider Specification

## Purpose
TBD - created by archiving change riverpod-architecture. Update Purpose after archive.
## Requirements
### Requirement: 时间线数据查询

系统 SHALL 提供 `timelineProvider` 根据日期查询活动记录，并在数据变化时自动刷新。

#### Scenario: 按日期查询活动记录
- **WHEN** 指定日期和宝宝 ID
- **THEN** 返回该日期该宝宝的所有活动记录

#### Scenario: 记录按时间排序
- **WHEN** 查询时间线数据
- **THEN** 活动记录按 startTime 升序排列

#### Scenario: 数据变化时自动刷新
- **WHEN** `activityDataChangeProvider` 的值变化
- **THEN** `timelineProvider` 自动重新查询并返回最新数据

### Requirement: 时间线参数化

timelineProvider SHALL 支持日期参数，允许切换查看不同日期。

#### Scenario: 切换日期
- **WHEN** 日期参数变更
- **THEN** Provider 自动重新查询新日期的数据

### Requirement: 时间线依赖当前宝宝

timelineProvider SHALL 依赖 currentBabyProvider 获取当前宝宝 ID。

#### Scenario: 当前宝宝变更时刷新
- **WHEN** 当前宝宝切换
- **THEN** timelineProvider 自动刷新为新宝宝的数据

### Requirement: 异步数据处理

timelineProvider SHALL 使用 AsyncValue 处理异步查询状态。

#### Scenario: 加载状态
- **WHEN** 数据正在加载
- **THEN** AsyncValue 处于 loading 状态

#### Scenario: 错误处理
- **WHEN** 查询发生错误
- **THEN** AsyncValue 包含错误信息

#### Scenario: 数据成功加载
- **WHEN** 查询成功完成
- **THEN** AsyncValue 包含活动记录列表

