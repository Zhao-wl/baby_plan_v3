## ADDED Requirements

### Requirement: 删除操作完成后触发全局通知

系统 SHALL 在删除动画完成后触发全局数据变化通知，确保其他组件实时更新。

#### Scenario: 删除动画完成后通知
- **WHEN** 用户在时间线列表中删除一条活动记录
- **AND** 删除动画完成
- **AND** 数据库软删除操作成功
- **THEN** 系统 SHALL 触发 `activityDataChangeProvider` 通知
- **AND** 首页、统计页面等依赖组件实时刷新

#### Scenario: 删除失败不触发通知
- **WHEN** 数据库软删除操作失败
- **THEN** 系统 SHALL NOT 触发数据变化通知
- **AND** 显示错误提示
- **AND** 本地状态恢复（如果已更新）

### Requirement: 删除操作正确写入数据库

系统 SHALL 确保删除操作正确执行数据库软删除。

#### Scenario: 软删除成功
- **WHEN** 删除操作执行
- **THEN** 系统 SHALL 将记录的 `isDeleted` 设为 `true`
- **AND** 将 `deletedAt` 设为当前时间
- **AND** 将 `syncStatus` 设为 `1`（待上传）

#### Scenario: 已删除记录不在列表显示
- **WHEN** 时间线查询活动记录
- **THEN** 系统 SHALL 过滤掉 `isDeleted = true` 的记录