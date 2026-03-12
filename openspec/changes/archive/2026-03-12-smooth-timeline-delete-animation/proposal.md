## Why

当前时间线删除活动记录时，整个列表会刷新一次，用户体验非常差。用户期望的是：被删除的卡片平滑消失，上方卡片保持不动，下方卡片平滑上移，形成流畅的动画效果。

这种"整体刷新"的体验问题会影响用户对应用流畅度的感知，尤其是在频繁删除操作时更加明显。

## What Changes

- 删除活动卡片时，被删除项执行淡出+收缩动画
- 上方卡片保持位置不变
- 下方卡片执行平滑上移动画（使用 AnimatedList 或 SliverAnimatedList）
- 取消整体列表刷新，改为局部动画更新

## Capabilities

### New Capabilities

无

### Modified Capabilities

- `timeline-list`: 添加列表项删除动画需求，要求使用 Flutter 的 AnimatedList 或类似机制实现平滑的删除动画效果

## Impact

- 受影响文件：`lib/widgets/timeline/timeline_list.dart` 或类似的时间线列表组件
- 涉及 Flutter 动画 API：`AnimatedList`、`SliverAnimatedList` 或 `ImplicitlyAnimatedList`
- 可能需要调整 Provider 的数据更新方式，避免触发整体刷新