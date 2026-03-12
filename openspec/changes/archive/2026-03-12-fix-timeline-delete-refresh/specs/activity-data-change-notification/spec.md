## MODIFIED Requirements

### Requirement: 全局活动数据变化通知

系统 SHALL 提供 `activityDataChangeProvider` 作为全局活动数据变化通知机制。

#### Scenario: 数据变化时通知触发
- **WHEN** 活动记录被插入、更新或删除（软删除）
- **THEN** `activityDataChangeProvider` 的值发生变化

#### Scenario: Provider 监听数据变化
- **WHEN** 任何依赖活动数据的 provider watch `activityDataChangeProvider`
- **THEN** 当数据变化时，依赖的 provider 自动重新执行

#### Scenario: 删除操作触发通知
- **WHEN** 时间线列表中的活动记录被删除
- **AND** 删除动画完成
- **AND** 数据库软删除操作成功
- **THEN** 系统 SHALL 触发 `activityDataChangeProvider` 通知
- **AND** 首页、统计页面等依赖组件自动刷新

### Requirement: 变化通知使用 NotifierProvider 实现

`activityDataChangeProvider` SHALL 使用 `NotifierProvider<int>` 实现，通过递增版本号表示数据变化。

#### Scenario: 版本号递增
- **WHEN** 调用 `ref.read(activityDataChangeProvider.notifier).notify()`
- **THEN** 版本号增加，触发所有监听者

#### Scenario: 初始版本号
- **WHEN** 应用启动
- **THEN** `activityDataChangeProvider` 的初始值为 0