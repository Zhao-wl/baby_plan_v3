## 1. 数据库层修改

- [x] 1.1 修改 `ActivityRecords` 表，新增 `status` 字段（INTEGER，0=进行中，1=已完成，默认1）
- [x] 1.2 修改 `ActivityRecords` 表，`endTime` 字段改为可空（nullable）
- [x] 1.3 修改 `ActivityRecords` 表，`durationSeconds` 字段改为可空（nullable）
- [x] 1.4 创建数据库迁移脚本（schema 版本 4 → 5）
- [x] 1.5 运行代码生成 `dart run build_runner build --delete-conflicting-outputs`

## 2. Provider 层实现

- [x] 2.1 创建 `ongoingActivityProvider`，用于查询当前进行中的活动
- [x] 2.2 修改 `ActivityRecordsDao`，添加 `createOngoingActivity` 方法
- [x] 2.3 修改 `ActivityRecordsDao`，添加 `completeActivity` 方法
- [x] 2.4 修改 `ActivityRecordsDao`，添加 `getOngoingActivity` 方法
- [x] 2.5 修改 `timelineProvider`，过滤或特殊处理进行中活动（放在列表顶部）

## 3. 快捷操作栏修改

- [x] 3.1 修改 `QuickActionBar` 组件，长按逻辑改为创建进行中活动
- [x] 3.2 添加长按动画反馈（按钮缩放效果）
- [x] 3.3 添加防抖处理，避免快速重复触发
- [x] 3.4 添加已有进行中活动时的提示逻辑

## 4. 时间线 UI 修改

- [x] 4.1 创建 `OngoingActivityCard` 组件，显示进行中活动
- [x] 4.2 实现脉冲动画效果表示进行中状态
- [x] 4.3 实现"结束"按钮和确认对话框
- [x] 4.4 修改 `TimelinePage`，在顶部显示进行中活动卡片
- [x] 4.5 实现实时持续时间更新（使用 Timer 每秒刷新）

## 5. 测试与验证

- [x] 5.1 运行数据库迁移测试
- [x] 5.2 验证长按创建进行中活动功能
- [x] 5.3 验证结束活动功能
- [x] 5.4 验证同一时间只能有一个进行中活动
- [x] 5.5 运行 `flutter analyze` 检查代码规范

## 6. 长按流程优化

- [x] 6.1 创建 `OngoingActivityFormSheet` 组件，用于长按时编辑活动详情
- [x] 6.2 在数据库中添加 `createOngoingActivityWithDetails` 方法
- [x] 6.3 修改 `QuickActionBar` 长按逻辑：弹出表单编辑详情后创建进行中活动
- [x] 6.4 删除不再使用的 `_getActivityName` 方法
- [x] 6.5 运行代码生成和 `flutter analyze` 检查
