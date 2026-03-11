## Context

当前疫苗界面 (`VaccinePage`) 使用 `VaccineScheduleNotifier` 管理疫苗数据。存在的问题：

1. **数据刷新依赖手动触发**：
   - `initState` 中调用 `refresh()` 仅在页面首次创建时执行
   - 使用 `AutomaticKeepAliveClientMixin` 保持页面状态，切换 Tab 再回来不会重新触发 `initState`
   - `VaccineScheduleNotifier` 在 `build()` 中加载数据，但未监听 `currentBabyProvider` 的变化

2. **缺少滚动定位功能**：
   - 疫苗列表按月龄分组展示，用户需要手动滚动找到待处理的疫苗
   - 没有机制在页面加载后自动定位到首个未完成的疫苗

## Goals / Non-Goals

**Goals:**
- 当宝宝数据变化（新增、切换）时，自动刷新疫苗数据
- 当页面重新获得焦点时，检查并刷新数据
- 打开疫苗界面时，自动滚动到首个未完成的疫苗位置
- 保持现有的下拉刷新功能

**Non-Goals:**
- 不改变现有的疫苗数据结构和 UI 设计
- 不实现后台自动同步功能
- 不添加推送通知功能

## Decisions

### 1. 使用 `ref.listen` 监听 `currentBabyProvider` 变化

**选择**: 在 `VaccineScheduleNotifier.build()` 中使用 `ref.listen` 监听 `currentBabyProvider`

**原因**:
- `ref.listen` 可以在 provider 状态变化时执行副作用
- 比 `ref.watch` 更适合用于触发异步刷新操作
- 符合 Riverpod 的最佳实践

**替代方案**:
- 在 `VaccinePage` 的 `didChangeDependencies` 中监听：需要处理 Widget 生命周期，代码复杂
- 使用 `ref.watch` 直接依赖：会在每次重建时触发，可能导致不必要的刷新

### 2. 使用 `WidgetsBindingObserver` 监听页面焦点

**选择**: 在 `VaccinePage` 中 mixin `WidgetsBindingObserver`，监听 `AppLifecycleState.resumed`

**原因**:
- 可以检测用户从其他应用返回的场景
- 与 `AutomaticKeepAliveClientMixin` 兼容
- 系统级生命周期监听更可靠

### 3. 使用 `ScrollController` 和 `GlobalKey` 实现自动滚动

**选择**: 为每个疫苗组卡片分配 `GlobalKey`，使用 `ScrollController` 滚动到目标位置

**原因**:
- Flutter 官方推荐的方式
- 可以精确滚动到指定 Widget
- 与 `CustomScrollView` 兼容良好

### 4. 滚动时机：数据加载完成后延迟执行

**选择**: 在数据加载完成的回调中，使用 `Future.delayed(Duration.zero)` 或 `SchedulerBinding.instance.addPostFrameCallback` 执行滚动

**原因**:
- 确保 UI 已经渲染完成
- 避免在数据加载过程中尝试滚动导致错误

## Risks / Trade-offs

**[Risk] 频繁刷新导致性能问题**
→ 缓存上次刷新时间，短时间内（如 5 秒）不重复刷新

**[Risk] 滚动到不存在的元素**
→ 添加空值检查，找不到目标疫苗时不执行滚动

**[Risk] 焦点监听与下拉刷新冲突**
→ 刷新操作是幂等的，多次调用不会造成数据问题