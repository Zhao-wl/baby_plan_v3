## Context

当前时间线删除流程存在以下问题：

### 现状
1. **删除动画与 Provider 刷新冲突**：之前为解决 `AnimationController` 重复 dispose 问题，完全移除了删除后的 Provider 刷新
2. **数据变化通知缺失**：删除操作不会触发 `activityDataChangeProvider` 通知，导致首页、统计页面数据不更新
3. **数据恢复问题**：删除后重新进入时间线页面，数据恢复 - 这可能是数据库操作未正确执行，或查询未正确过滤已删除记录

### 约束
- 删除动画必须流畅，不能被 Provider 刷新打断
- 使用软删除（`isDeleted = true`），不是物理删除
- 需要保持 AnimatedList 的动画完整性

## Goals / Non-Goals

**Goals:**
- 删除动画完成后正确触发数据变化通知
- 确保首页、统计页面实时更新
- 确保删除操作正确写入数据库
- 保持删除动画流畅性

**Non-Goals:**
- 不修改删除动画的实现细节
- 不改变软删除的数据模型

## Decisions

### Decision 1: 删除动画完成后触发通知

**方案**：在 `_handleDelete` 方法中，动画完成后、调用 `onActivityDelete` 之前，先更新本地状态，然后让父组件的回调负责触发通知。

**理由**：
- 本地状态先更新，动画完成后再通知
- 父组件控制通知时机，更灵活
- 避免 AnimatedList 内部的 Controller 被重复 dispose

**替代方案**：
- 在 `didUpdateWidget` 中检测删除变化并触发通知 - 但这会导致时序复杂
- 使用 `WidgetsBinding.instance.addPostFrameCallback` 延迟通知 - 但可能引入竞态条件

### Decision 2: 删除操作分离关注点

**方案**：
1. `TimelineList._handleDelete` - 负责本地动画和状态更新
2. `TimelinePage._deleteRecord` - 负责数据库更新和全局通知

**理由**：
- 分离关注点，职责清晰
- 动画完成后再触发数据库操作
- 数据库操作成功后再触发全局通知

### Decision 3: 延迟触发 Provider 刷新

**方案**：使用 `Future.delayed` 或 `WidgetsBinding.instance.addPostFrameCallback` 确保动画完成后再刷新 Provider。

```dart
// 动画完成后
await Future.delayed(const Duration(milliseconds: 300));
// 更新数据库
await db.update(...);
// 触发全局通知
ref.read(activityDataChangeProvider.notifier).notify();
```

**理由**：简单的延迟足以解决时序问题，不需要复杂的同步机制。

## Risks / Trade-offs

### Risk 1: 动画和通知时序
**风险**：如果通知触发太快，可能导致动画中断。
**缓解**：确保动画完成后才触发通知，使用 `mounted` 检查组件是否仍然存在。

### Risk 2: 数据一致性
**风险**：如果数据库操作失败，本地状态已更新，会出现不一致。
**缓解**：在数据库操作失败时回滚本地状态，显示错误提示。

### Risk 3: 查询未过滤已删除记录
**风险**：如果查询没有正确过滤 `isDeleted = true` 的记录，会导致数据"恢复"。
**缓解**：检查所有相关 Provider 的查询是否包含 `!r.isDeleted` 过滤条件。