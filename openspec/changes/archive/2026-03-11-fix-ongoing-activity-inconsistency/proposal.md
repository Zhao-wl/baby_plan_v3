## Why

当前存在两套不一致的"进行中活动"机制：

1. **快捷按钮短按**：通过 `timerProvider` 在内存中管理计时状态，同时创建数据库记录。首页快捷按钮状态会正确反映计时状态。

2. **快捷按钮长按**：直接通过 `OngoingActivityFormSheet` 创建数据库记录，但不更新 `timerProvider` 状态。导致首页快捷按钮状态与实际进行中活动不一致。

这导致：
- 时间线页面顶部的进行中活动卡片只显示长按创建的活动
- 首页快捷按钮状态只反映短按创建的活动
- 两处显示不一致，用户困惑

## What Changes

- 统一长按和短按的底层逻辑：都通过 `timerProvider` 管理"进行中活动"状态
- 长按变更为：先启动计时器 → 弹出表单编辑详情 → 更新数据库记录
- **删除**时间线页面顶部单独的 `OngoingActivityCard` 组件
- 在时间线列表中**标记**进行中的活动（通过视觉样式区分）
- 在 `TimelineActivityCard` 上添加"进行中"指示器

## Capabilities

### New Capabilities
- `ongoing-activity-indicator`: 时间线列表中进行中活动的视觉标记组件

### Modified Capabilities
- `activity-timer`: 统一计时器状态管理，确保长按和短按行为一致
- `quick-action-bar`: 长按逻辑调整为先启动计时器再弹出表单
- `timeline-list`: 支持在列表中标记进行中的活动

## Impact

- `lib/providers/timer_provider.dart` - 计时器状态管理
- `lib/widgets/dashboard/quick_action_bar.dart` - 快捷按钮长按逻辑
- `lib/widgets/timeline/ongoing_activity_form_sheet.dart` - 表单逻辑调整
- `lib/pages/timeline_page.dart` - 移除顶部 OngoingActivityCard
- `lib/widgets/timeline/timeline_list.dart` - 支持显示进行中活动
- `lib/widgets/timeline/activity_card.dart` - 添加进行中指示器
- `lib/providers/ongoing_activity_provider.dart` - 可能需要调整