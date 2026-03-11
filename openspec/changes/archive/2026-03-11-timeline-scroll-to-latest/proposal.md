## Why

用户在查看时间线时，通常最关心的是最近发生的活动记录。当前时间线页面进入时默认显示顶部，用户需要手动滚动到底部才能看到最新记录，操作不便。自动定位到最新记录可以提升用户体验，让用户快速看到最近的宝宝活动。

## What Changes

- 时间线页面进入时，自动滚动到列表底部，显示最新一条活动记录
- 新记录添加后，自动滚动到新记录位置

## Capabilities

### New Capabilities

无新能力引入。

### Modified Capabilities

- `timeline-list`: 添加自动滚动到最新记录的行为要求

## Impact

- `lib/widgets/timeline/timeline_list.dart` - 时间线列表组件
- `lib/pages/timeline_page.dart` - 时间线页面
- `lib/providers/timeline_provider.dart` - 时间线数据 Provider