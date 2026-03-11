## 1. 添加 ScrollController

- [x] 1.1 在 `TimelineList` 组件中添加 `ScrollController`
- [x] 1.2 确保在组件 dispose 时释放 `ScrollController`

## 2. 实现自动滚动逻辑

- [x] 2.1 创建 `_scrollToBottom` 方法，使用 `animateTo` 实现平滑滚动
- [x] 2.2 在数据加载完成后触发滚动（使用 `addPostFrameCallback`）
- [x] 2.3 添加空列表检查，避免无数据时滚动

## 3. 新增记录后滚动

- [x] 3.1 监听数据变化，当新增记录时触发滚动到底部
- [x] 3.2 确保新增记录后的滚动也使用平滑动画

## 4. 测试验证

- [x] 4.1 验证首次进入时间线页面时自动滚动到底部
- [x] 4.2 验证空列表时不会出现错误
- [x] 4.3 验证新增记录后自动滚动到新记录位置