## Context

当前应用使用 Flutter + Riverpod + Drift 架构。活动记录存储在本地 SQLite 数据库中，通过 Drift ORM 进行访问。各种 provider（timelineProvider、statsProvider、recentActivitiesProvider）使用 `FutureProvider` 从数据库查询数据。

问题的核心在于：
1. `FutureProvider` 只在依赖变化时重新执行，但 `databaseProvider` 是单例，不会变化
2. `TimelinePage` 使用 `AutomaticKeepAliveClientMixin` 保持页面状态，不会因为切换 tab 而重建
3. 当前的数据刷新机制是手动调用 `ref.invalidate()`，但只在 `quick_record_sheet.dart` 中针对当天日期的 provider 进行刷新

这导致：
- 如果时间线页面显示的是其他日期，数据不会刷新
- 即使显示当天，由于 keep-alive 机制，页面可能仍显示旧数据

## Goals / Non-Goals

**Goals:**
- 实现全局数据变化通知机制，在数据变更时自动触发所有相关 provider 刷新
- 确保时间线页面、统计卡片、最近活动列表都能实时反映数据变化
- 保持现有 API 不变，改动向后兼容
- 不引入复杂的外部依赖

**Non-Goals:**
- 不涉及真正的实时同步（如 WebSocket、服务器推送）
- 不修改数据库 schema
- 不重构整个状态管理架构
- 不涉及多设备同步问题

## Decisions

### 1. 使用 StateProvider 作为变化通知器

**决策**: 创建一个 `activityDataChangeProvider`（StateProvider<int>），每次数据变化时递增版本号。

**理由**:
- Riverpod 中 StateProvider 的变化会触发所有监听者的重建
- 简单轻量，不需要额外的依赖
- 与现有架构完全兼容

**替代方案**:
- 使用 StreamProvider: 过于复杂，不需要持续的流式数据
- 使用 ChangeNotifier: 需要额外的类定义，StateProvider 更简洁
- 使用 Drift 的 Stream 查询: 需要大量重构现有代码，改动面太大

### 2. 在现有 provider 中 watch 变化通知器

**决策**: 修改 `timelineProvider`、`statsProvider`、`recentActivitiesProvider`，让它们 `watch(activityDataChangeProvider)`。

**理由**:
- 保持 provider 的现有签名和查询逻辑不变
- 当数据变化时，由于 watch 了 change provider，会自动重新执行
- Riverpod 的依赖追踪会自动处理缓存失效

**代码示例**:
```dart
final timelineProvider = FutureProvider.family<List<ActivityRecord>, TimelineQuery>((ref, query) async {
  // 监听数据变化通知
  ref.watch(activityDataChangeProvider);

  final db = ref.watch(databaseProvider);
  // ... 原有查询逻辑
});
```

### 3. 在数据变更操作后触发通知

**决策**: 在 `quick_record_sheet.dart` 和 `timeline_page.dart` 的数据插入、更新、删除操作成功后，递增 `activityDataChangeProvider` 的值。

**理由**:
- 集中控制数据变更通知的触发时机
- 确保只有在数据库操作成功后才会触发刷新
- 避免不必要的数据库查询

**替代方案**:
- 在数据库层拦截所有操作: 需要修改 Drift 代码生成，复杂度高
- 使用数据库触发器: 不适用于 Drift 的 Dart 层查询

### 4. 移除现有的手动 invalidate 调用

**决策**: 在实现全局通知机制后，移除 `_refreshData()` 方法中对特定 provider 的 `invalidate` 调用。

**理由**:
- 全局通知机制会自动刷新所有相关 provider
- 避免重复刷新导致的性能浪费

## Risks / Trade-offs

**[风险] 额外的数据库查询开销**
→ 缓解: 使用 Riverpod 的自动缓存机制，相同参数的查询在缓存期内不会重复执行。变化通知只会在数据真正变化时触发一次刷新。

**[风险] 页面切换时可能看到旧数据一闪而过**
→ 缓解: 这是 `FutureProvider` 的正常行为（loading → data）。如果需要立即显示，可以考虑使用 `AsyncValue` 的 `previous` 值。

**[风险] 忘记在某些数据变更处触发通知**
→ 缓解: 当前应用的数据变更入口比较集中（主要在 quick_record_sheet 和 timeline_page），容易覆盖。未来新增数据变更入口时需要遵循此模式。

**[权衡] Provider 重建粒度**
→ 当前方案使用全局版本号，任何数据变化都会触发所有相关 provider 刷新。如果需要更细粒度的控制（如只刷新特定宝宝或特定日期的数据），可以考虑在 change provider 中包含更多状态信息，但会增加复杂度。
