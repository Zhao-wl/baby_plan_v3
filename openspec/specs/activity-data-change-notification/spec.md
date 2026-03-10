# activity-data-change-notification Specification

## Purpose
提供全局活动数据变化通知机制，用于在插入、更新、删除活动记录时通知所有依赖的 provider 刷新。

## Requirements

### Requirement: 全局活动数据变化通知

系统 SHALL 提供 `activityDataChangeProvider` 作为全局活动数据变化通知机制。

#### Scenario: 数据变化时通知触发
- **WHEN** 活动记录被插入、更新或删除
- **THEN** `activityDataChangeProvider` 的值发生变化

#### Scenario: Provider 监听数据变化
- **WHEN** 任何依赖活动数据的 provider watch `activityDataChangeProvider`
- **THEN** 当数据变化时，依赖的 provider 自动重新执行

### Requirement: 变化通知使用 StateProvider 实现

`activityDataChangeProvider` SHALL 使用 StateProvider<int> 实现，通过递增版本号表示数据变化。

#### Scenario: 版本号递增
- **WHEN** 调用 `ref.read(activityDataChangeProvider.notifier).state++`
- **THEN** 版本号增加，触发所有监听者

#### Scenario: 初始版本号
- **WHEN** 应用启动
- **THEN** `activityDataChangeProvider` 的初始值为 0
