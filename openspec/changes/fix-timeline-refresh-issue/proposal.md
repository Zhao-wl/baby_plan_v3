## Why

当前应用存在时间线页面数据刷新不及时的问题：在首页（Dashboard）添加活动记录后，切换到详细时间线页面时，新添加的数据不会立即显示，需要手动下拉刷新或编辑某条记录保存后才能看到更新。这严重影响了用户体验，因为用户期望数据能够实时同步。

## What Changes

- 创建全局数据变化通知机制，在活动记录数据变更时触发通知
- 修改 `timelineProvider` 监听数据变化，实现自动刷新
- 修改 `statsProvider` 监听数据变化，实现自动刷新
- 修改 `recentActivitiesProvider` 监听数据变化，实现自动刷新
- 在数据插入、更新、删除操作后触发数据变化通知

## Capabilities

### New Capabilities
- `activity-data-change-notification`: 全局活动数据变化通知机制，使用 Riverpod 的 StateProvider 实现，在数据变更时更新版本号，让所有依赖的 provider 自动刷新

### Modified Capabilities
- `timeline-refresh`: 修改时间线 provider，支持响应数据变化自动刷新
- `stats-refresh`: 修改统计数据 provider，支持响应数据变化自动刷新
- `recent-activities-refresh`: 修改最近活动 provider，支持响应数据变化自动刷新

## Impact

- 修改文件：`lib/providers/timeline_provider.dart`
- 修改文件：`lib/providers/stats_provider.dart`
- 修改文件：`lib/providers/recent_activities_provider.dart`
- 修改文件：`lib/widgets/dashboard/quick_record_sheet.dart`
- 修改文件：`lib/pages/timeline_page.dart`
- 新增文件：`lib/providers/activity_data_change_provider.dart`（变化通知 provider）
