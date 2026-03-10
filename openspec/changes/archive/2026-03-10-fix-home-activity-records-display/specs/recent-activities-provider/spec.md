## MODIFIED Requirements

### Requirement: 查询最近活动记录

系统 SHALL 提供 Provider 查询指定宝宝的最近 N 条活动记录，并在数据变化时自动刷新。

#### Scenario: 有活动记录时返回列表

- **WHEN** 宝宝有活动记录
- **THEN** 返回按 startTime 降序排列的最近 N 条记录

#### Scenario: 无活动记录时返回空列表

- **WHEN** 宝宝没有任何活动记录
- **THEN** 返回空列表

#### Scenario: 数据变化时自动刷新

- **WHEN** `activityDataChangeProvider` 的值变化
- **THEN** `recentActivitiesProvider` 自动重新查询并返回最新数据
- **AND** 首页"最近记录"区域显示更新后的数据

### Requirement: 可配置返回数量

系统 SHALL 允许调用者指定返回的记录数量。

#### Scenario: 指定返回数量

- **WHEN** 调用 recentActivitiesProvider 参数 limit = 2
- **THEN** 返回最近 2 条活动记录

### Requirement: 排除已删除记录

系统 SHALL 在查询时排除已软删除的活动记录。

#### Scenario: 过滤软删除记录

- **WHEN** 宝宝有已删除的活动记录
- **THEN** 查询结果不包含 isDeleted = true 的记录

### Requirement: 不限日期范围

系统 SHALL 查询所有历史活动记录，不限日期。

#### Scenario: 跨日期查询

- **WHEN** 宝宝昨天和今天都有活动
- **THEN** 返回的记录可能包含不同日期的活动
