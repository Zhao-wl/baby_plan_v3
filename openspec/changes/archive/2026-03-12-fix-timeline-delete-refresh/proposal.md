## Why

当前时间线删除操作存在两个关键问题：
1. 删除后不会通知其他组件（首页、统计页面），导致数据不一致
2. 删除后重新进入时间线页面，删除的数据会恢复（删除未真正生效）

这是因为之前为解决删除动画卡顿问题，移除了 Provider 刷新调用，导致数据变化无法传播到其他组件，同时删除操作本身可能存在数据库事务问题。

## What Changes

- 恢复删除操作后的数据变化通知，触发相关 Provider 刷新
- 修复删除动画与 Provider 刷新的时序冲突：先完成动画，再触发通知
- 确保删除操作正确更新数据库（软删除）
- 验证时间线查询正确过滤已删除记录

## Capabilities

### New Capabilities

无新增能力。

### Modified Capabilities

- `activity-data-change-notification`: 删除操作需要正确触发数据变化通知
- `timeline-list`: 删除动画完成后需要触发全局数据变化通知

## Impact

- `lib/pages/timeline_page.dart` - 删除操作恢复数据变化通知
- `lib/widgets/timeline/timeline_list.dart` - 删除动画完成后回调
- `lib/providers/activity_data_change_provider.dart` - 可能需要扩展通知机制