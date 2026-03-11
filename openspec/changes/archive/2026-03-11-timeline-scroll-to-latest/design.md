## Context

时间线页面展示选定日期的活动记录列表，按时间从早到晚排序。用户进入时间线页面时，当前实现默认显示列表顶部，但用户通常更关心最近的记录（最新的宝宝活动）。

### 当前实现

- `TimelineList` 组件使用 `ListView.builder` 构建可滚动列表
- 列表按时间从早到晚排序（最新记录在底部）
- 页面进入时没有自动滚动行为

## Goals / Non-Goals

**Goals:**
- 时间线页面进入时，自动滚动到列表底部，显示最新记录
- 新增记录后，自动滚动到新记录位置
- 保持平滑的用户体验，避免突兀的跳转

**Non-Goals:**
- 不改变列表的排序逻辑
- 不改变现有的数据加载方式

## Decisions

### Decision 1: 使用 ScrollController + animateTo

**选择**: 使用 `ScrollController` 的 `animateTo` 方法实现平滑滚动

**原因**:
- Flutter 原生支持，无需额外依赖
- 提供平滑动画效果，用户体验更好
- 可以精确控制滚动位置和动画时长

**替代方案**:
- `jumpTo`: 直接跳转，无动画，体验突兀
- `Scrollable.ensureVisible`: 需要找到特定 Widget 的 context，实现复杂

### Decision 2: 滚动时机 - 数据加载完成后

**选择**: 在数据加载完成后触发滚动

**原因**:
- 需要等待列表构建完成才能计算滚动位置
- 使用 `WidgetsBinding.instance.addPostFrameCallback` 确保在帧渲染后执行

### Decision 3: 滚动动画参数

**选择**:
- 动画时长: 300ms
- 曲线: `Curves.easeOut`

**原因**:
- 300ms 是推荐的动画时长，足够短不会让用户等待，也足够长能看清动画
- `easeOut` 曲线开始快结束慢，符合用户预期

## Risks / Trade-offs

### Risk: 列表为空时滚动失败
→ **Mitigation**: 检查列表是否为空，空列表不执行滚动

### Risk: 用户已手动滚动时被强制跳转
→ **Mitigation**: 仅在首次加载时自动滚动，后续不干预

### Risk: 列表数据量大时计算 maxScrollExtent 可能不精确
→ **Mitigation**: 当前场景下单日记录数量有限，不会出现此问题