## Why

时间线页面中的进行中活动卡片 (`OngoingActivityCard`) 包含一个脉冲动画图标 (`_PulsingIcon`)，这是一个持续的呼吸/脉冲效果。这个动画效果对于展示"进行中"状态是合理的，但用户反馈不需要这个动画，希望移除它以简化界面。

## What Changes

- 移除 `OngoingActivityCard` 组件中的 `_PulsingIcon` 脉冲动画效果
- 将图标改为静态显示，保留活动类型图标的展示

## Capabilities

### New Capabilities

无

### Modified Capabilities

无（此变更为纯 UI 实现调整，不涉及 spec 级别的需求变更）

## Impact

- `lib/widgets/timeline/ongoing_activity_card.dart` - 移除 `_PulsingIcon` 组件，使用静态图标