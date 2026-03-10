## Context

当前应用首页的"最近记录"区域无法显示活动记录。经过代码审查，发现以下组件和流程：

1. **数据层**: `recentActivitiesProvider` 使用 Drift ORM 查询最近 N 条活动记录
2. **通知机制**: `activityDataChangeProvider` 用于通知数据变化，provider 监听此通知以自动刷新
3. **UI 层**: `RecentActivitiesList` 组件使用 `ref.watch` 监听 provider 并显示数据

当前代码逻辑看起来正确，但问题可能出现在：
- Provider 缓存机制导致数据不刷新
- 数据变化通知未正确触发
- 查询条件存在问题

## Goals / Non-Goals

**Goals:**
- 诊断并修复首页最近活动记录不显示的问题
- 确保数据变化时列表能够正确刷新
- 验证软删除过滤逻辑正确工作

**Non-Goals:**
- 不修改数据库表结构
- 不修改活动记录的创建/编辑逻辑
- 不修改 UI 样式和布局

## Decisions

### 决策 1: 使用 StreamProvider 替代 FutureProvider

**背景**: `recentActivitiesProvider` 当前使用 `FutureProvider.family`，这会导致每次重建时都重新查询数据库。

**问题**: 虽然 `ref.watch(activityDataChangeProvider)` 应该触发重建，但可能存在 Riverpod 缓存机制导致的问题。

**方案**: 考虑改为使用 `StreamProvider` 或添加 `select` 来优化查询，但首先应验证当前机制是否工作正常。

**当前方案**: 先检查现有逻辑的问题，保持 `FutureProvider` 结构，重点修复通知刷新机制。

### 决策 2: 添加 Provider 调试日志

**方案**: 在 `recentActivitiesProvider` 中添加日志输出，便于诊断查询是否执行以及返回结果。

**实现**: 使用 `debugPrint` 在 provider 中输出查询参数和结果数量。

### 决策 3: 验证查询条件

**方案**: 检查查询条件是否正确过滤软删除记录，并确认 `babyId` 参数传递正确。

**关键点**:
- `isDeleted.equals(false)` 条件是否正确
- `babyId` 是否与当前选中的宝宝一致
- 数据库中是否存在匹配的记录

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 修改引入新的问题 | 在修复前添加单元测试验证当前行为 |
| 性能影响 | 保持现有查询逻辑，仅修复刷新机制 |
| 数据不一致 | 确保软删除过滤逻辑正确工作 |

## Migration Plan

1. **诊断阶段**: 添加调试日志，验证 provider 是否被调用以及返回结果
2. **修复阶段**: 根据诊断结果修复问题
3. **验证阶段**: 在应用中测试首页最近记录显示功能
4. **回归测试**: 确保不影响时间线页面等其他使用活动记录的功能
