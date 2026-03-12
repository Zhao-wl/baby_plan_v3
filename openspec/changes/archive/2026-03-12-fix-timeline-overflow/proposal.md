## Why

时间线页面的活动卡片组件存在布局溢出问题，在特定情况下（内容高度与容器高度不匹配）会显示 `BOTTOM OVERFLOWED BY 2.0 PIXELS` 错误。这是由于 `TimelineActivityCard` 组件内部 `Stack` 布局中使用了 `Positioned.fill`，当上层卡片内容的实际高度小于 Stack 尝试填充的高度时，导致底部溢出。

需要修复此布局问题，确保活动卡片在各种内容情况下都能正确显示，不出现溢出警告。

## What Changes

- 修复 `TimelineActivityCard` 组件中 `Stack` 布局的溢出问题
- 移除 `Positioned.fill` 的使用，改用更适合滑动删除效果的布局方式
- 确保卡片内容高度与容器高度一致，避免溢出

## Capabilities

### New Capabilities

无新能力引入。

### Modified Capabilities

- `timeline-activity-card`: 修复卡片布局溢出问题，调整 Stack 布局结构，确保滑动删除功能的正确实现

## Impact

- **受影响文件**：
  - `lib/widgets/timeline/activity_card.dart` - 主要修改文件
- **影响范围**：仅影响时间线页面的活动卡片显示，不影响其他功能
- **测试场景**：
  - 短内容卡片（无备注）显示正常
  - 长内容卡片（有备注）显示正常
  - 滑动删除功能正常工作
  - 进行中活动显示正常