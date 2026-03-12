## 1. 重构 TimelineList 使用 AnimatedList

- [x] 1.1 将 `TimelineList` 从 `ListView.builder` 改为 `AnimatedList`
- [x] 1.2 添加 `GlobalKey<AnimatedListState>` 用于控制列表动画
- [x] 1.3 创建 `_AnimatedTimelineItem` Widget 封装单个列表项及其动画
- [x] 1.4 实现 `AnimatedItemBuilder` 回调，构建带动画的列表项

## 2. 实现删除动画

- [x] 2.1 创建删除动画效果（淡出 + 高度收缩）
- [x] 2.2 实现 `_handleDelete` 方法，使用 `AnimatedListState.removeItem()`
- [x] 2.3 配置动画参数（时长 300ms，曲线 easeInOut）
- [x] 2.4 确保动画完成后才更新 Provider 数据源

## 3. 数据同步与状态管理

- [x] 3.1 添加本地 `_records` 状态用于 AnimatedList
- [x] 3.2 实现 `didUpdateWidget` 监听外部数据变化并同步 AnimatedList
- [x] 3.3 处理新增记录时的 AnimatedList 插入动画
- [x] 3.4 保持自动滚动到最新记录的功能

## 4. 测试与验证

- [x] 4.1 验证删除动画流畅性（无闪烁、平滑上移）有闪烁，但暂时接受
- [x] 4.2 验证上方卡片位置保持不变
- [x] 4.3 验证新增记录时自动滚动正常工作
- [x] 4.4 验证时间轴线绘制正常（动画过程中和完成后）