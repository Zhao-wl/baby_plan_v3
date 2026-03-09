# growth-record-provider Specification

## Purpose
提供 Provider 查询指定宝宝的最新生长记录，用于首页宝宝信息卡片显示体重身高数据。

## Requirements
### Requirement: 查询最新生长记录

系统 SHALL 提供 Provider 查询指定宝宝的最新生长记录。

#### Scenario: 有生长记录时返回最新
- **WHEN** 宝宝有多条生长记录
- **THEN** 返回 recordDate 最新的一条记录

#### Scenario: 无生长记录时返回 null
- **WHEN** 宝宝没有任何生长记录
- **THEN** 返回 null

### Requirement: 排除已删除记录

系统 SHALL 在查询时排除已软删除的生长记录。

#### Scenario: 过滤软删除记录
- **WHEN** 宝宝有已删除的生长记录
- **THEN** 查询结果不包含 isDeleted = true 的记录

### Requirement: 响应式更新

系统 SHALL 当生长记录变更时自动更新 Provider 数据。

#### Scenario: 新增记录后自动更新
- **WHEN** 用户新增一条生长记录
- **THEN** latestGrowthRecordProvider 自动返回新记录（如果是最新的）

#### Scenario: 删除记录后自动更新
- **WHEN** 用户删除当前最新的生长记录
- **THEN** latestGrowthRecordProvider 自动返回次新记录