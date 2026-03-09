## Why

当前首页实现与原型设计差距较大：
- 计时器占位组件缺乏视觉设计（无渐变背景、无呼吸动效）
- 缺少智能预测卡片（PRD 中的核心亮点）
- 缺少悬浮快捷操作台（单手操作的核心交互）
- 顶部个人信息区布局与原型不一致
- "排泄"按钮文案应改为更亲切的"便便"

这些问题导致用户体验与设计预期不符，需要在功能完善前先进行视觉占位。

## What Changes

- 优化计时器占位组件：添加渐变背景、呼吸动效、状态提示区域
- 新增智能预测卡片占位组件：展示预测 UI 框架（功能待后续开发）
- 新增悬浮快捷操作台组件：吃/玩/睡/便便 四个快捷按钮
- 优化顶部个人信息区布局：头像+姓名+月龄+数据一行展示
- 优化最近记录列表样式：增大圆角、调整布局
- 统一视觉风格：渐变背景、大圆角、毛玻璃效果

## Capabilities

### New Capabilities

- `timer-card-placeholder`: 计时器卡片占位组件，带渐变背景和呼吸动效
- `smart-prediction-card`: 智能预测卡片占位组件（UI 框架，功能待开发）
- `quick-action-bar`: 悬浮快捷操作台组件，包含吃/玩/睡/便便按钮

### Modified Capabilities

- `dashboard-baby-card`: 优化布局，调整为一行紧凑展示
- `dashboard-recent-activities`: 优化列表项样式，增大圆角

## Impact

**新增文件：**
- `lib/widgets/dashboard/timer_card_placeholder.dart` - 计时器卡片（替换原 timer_placeholder.dart）
- `lib/widgets/dashboard/smart_prediction_card.dart` - 智能预测卡片占位
- `lib/widgets/dashboard/quick_action_bar.dart` - 快捷操作台

**修改文件：**
- `lib/pages/home_page.dart` - 集成新组件，调整布局
- `lib/widgets/dashboard/baby_info_card.dart` - 优化布局样式
- `lib/widgets/dashboard/recent_activities_list.dart` - 优化列表项样式
- `lib/widgets/dashboard/timer_placeholder.dart` - 删除（被 timer_card_placeholder.dart 替代）