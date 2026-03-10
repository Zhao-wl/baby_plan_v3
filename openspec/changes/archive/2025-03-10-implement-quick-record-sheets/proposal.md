## Why

当前快捷操作栏仅支持简单的计时开始/停止功能，无法记录活动的详细属性（如喂养方式、睡眠质量、排泄性状等），用户需要补充完整活动记录时缺乏便捷入口。通过实现基于通用半屏弹窗的快捷记录表单，可同时满足快速录入和详细记录的双重需求，大幅提升用户体验和数据完整性。

## What Changes

- 新增通用快捷记录弹窗组件，支持4种活动类型（吃奶/玩耍/睡眠/排泄）的详情字段动态渲染
- 扩展快捷操作栏交互，支持长按按钮直接弹出对应类型的记录表单
- 计时结束后自动弹出详情表单，引导用户补充活动的完整信息
- 实现表单验证和数据库写入逻辑，支持快速保存（仅记录时间）和详细保存两种模式
- 支持未保存数据检测，关闭时自动提示二次确认

## Capabilities

### New Capabilities
- `quick-record-forms`：通用快捷记录表单组件，支持4种活动类型的专属字段动态显示和表单验证
- `activity-record-crud`：活动记录的增删改查操作封装，提供统一的数据写入接口

### Modified Capabilities
- `quick-action-bar`：扩展快捷操作栏交互逻辑，新增长按弹窗触发机制
- `activity-timer`：扩展计时器服务，计时结束时自动触发详情表单弹窗

## Impact

- **新增文件**：
  - `lib/widgets/dashboard/quick_record_sheet.dart` - 快捷记录弹窗主组件
  - `lib/widgets/common/form_fields.dart` - 通用表单字段组件（选择器、时间选择等）
- **修改文件**：
  - `lib/widgets/dashboard/quick_action_bar.dart` - 扩展长按交互
  - `lib/providers/timer_provider.dart` - 新增计时结束回调
- **无破坏性变更**：完全兼容现有功能，不影响已有API和数据结构
- **无新增依赖**：复用现有HalfScreenSheet组件和数据库层实现
