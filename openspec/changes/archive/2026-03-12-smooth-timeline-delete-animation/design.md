## Context

当前 `TimelineList` 使用普通的 `ListView.builder`，没有实现删除动画。当用户删除一条记录时，Provider 更新数据，整个列表重建，造成视觉上的"闪烁"和体验不佳。

Flutter 提供了多种动画列表解决方案，可以在不重建整个列表的情况下实现平滑的删除动画。

## Goals / Non-Goals

**Goals:**
- 删除活动卡片时，被删除项执行平滑的淡出+收缩动画
- 下方卡片平滑上移填补空白，使用插值动画
- 上方卡片保持位置不变
- 新增记录时保持原有的自动滚动行为

**Non-Goals:**
- 不改变删除确认对话框的交互逻辑
- 不新增其他类型的列表动画（如拖拽排序）
- 不修改时间轴线（CustomPainter）的实现

## Decisions

### Decision 1: 使用 AnimatedList 替代 ListView.builder

**选择**: 使用 Flutter 内置的 `AnimatedList` 组件

**理由**:
1. Flutter 官方提供，无需引入第三方依赖
2. 支持插入和删除动画，通过 `AnimatedListState` 控制
3. 可以精确控制每个 item 的动画效果
4. 与现有的 `ScrollController` 兼容

**替代方案**:
- `SliverAnimatedList`: 更适合 CustomScrollView 场景，但当前实现是独立 ListView
- `implicitly_animated_list` 等第三方包: 增加依赖，但功能更强大

### Decision 2: 动画效果设计

**删除动画**:
1. 被删除卡片先执行淡出（opacity: 1 → 0）
2. 同时执行高度收缩（height: actual → 0）
3. 下方卡片自动上移填补空间
4. 动画时长：300ms，使用 `Curves.easeInOut`

**实现方式**: 使用 `AnimatedList` 的 `removeItem` 方法配合 `AnimationController`

### Decision 3: 数据状态管理

**方案**: 保持 Provider 数据流不变，在 Widget 层管理动画状态

**理由**:
- Provider 继续负责数据增删改
- TimelineList 维护一个本地状态用于 AnimatedList
- 删除时：先触发动画，动画完成后再更新 Provider 数据

**流程**:
1. 用户确认删除
2. 调用 `AnimatedListState.removeItem()` 触发动画
3. 动画完成后，调用 Provider 的删除方法
4. 更新本地列表状态

## Risks / Trade-offs

### Risk 1: AnimatedList 与 CustomPainter 的协调
**风险**: CustomPainter 绘制的时间轴线可能不会随着动画更新
**缓解**: 在删除动画期间重新绘制时间轴线，或接受时间轴线在动画完成后再更新的行为

### Risk 2: 数据同步复杂性
**风险**: 本地 AnimatedList 状态与 Provider 数据可能不同步
**缓解**: 使用 `didUpdateWidget` 监听外部数据变化，同步更新 AnimatedList

### Trade-off: 实现复杂度
AnimatedList 需要手动管理列表状态（GlobalKey、AnimatedListState），比普通 ListView 复杂。但这是实现流畅删除动画的标准做法。