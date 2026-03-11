## 1. 重构长按快捷按钮逻辑

- [x] 1.1 修改 `QuickActionBar._handleLongPress()` 方法，先调用 `timerProvider.start()` 启动计时器
- [x] 1.2 修改 `OngoingActivityFormSheet` 接收草稿记录 ID 参数，用于更新现有记录而非创建新记录
- [x] 1.3 在 `OngoingActivityFormSheet` 取消时调用 `timerProvider.cancel()` 清理计时器和草稿记录
- [x] 1.4 在 `OngoingActivityFormSheet` 保存时更新草稿记录的详情字段

## 2. 修改时间线页面

- [x] 2.1 删除 `TimelinePage` 中顶部的 `OngoingActivityCard` 组件及相关代码
- [x] 2.2 修改 `TimelineProvider` 查询逻辑，返回所有活动（包括 status=0 的进行中活动）
- [x] 2.3 移除 `timeline_page.dart` 中过滤进行中活动的逻辑（`records.where((r) => r.status == 1)`）

## 3. 实现时间线列表中的进行中活动标记

- [x] 3.1 修改 `TimelineActivityCard` 添加 `isOngoing` 参数
- [x] 3.2 在 `TimelineActivityCard` 中添加"进行中"标签显示
- [x] 3.3 实现进行中活动的实时计时显示（每秒更新）
- [x] 3.4 为进行中活动的节点添加呼吸动画效果
- [x] 3.5 修改 `TimelineList` 传递 `isOngoing` 参数给 `TimelineActivityCard`

## 4. 清理和测试

- [x] 4.1 删除不再使用的 `OngoingActivityCard` 组件文件（如果确认不再需要）
- [x] 4.2 更新 `ongoing_activity_provider.dart` 的注释和文档
- [x] 4.3 测试短按快捷按钮的完整流程
- [x] 4.4 测试长按快捷按钮的完整流程（启动、编辑、保存、取消）
- [x] 4.5 测试时间线列表中进行中活动的显示和交互
- [x] 4.6 运行 `flutter analyze` 确保无错误