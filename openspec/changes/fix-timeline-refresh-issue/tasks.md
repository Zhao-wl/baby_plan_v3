## 1. 创建数据变化通知 Provider

- [x] 1.1 创建 `lib/providers/activity_data_change_provider.dart` 文件
- [x] 1.2 定义 `activityDataChangeProvider` StateProvider<int>
- [x] 1.3 在 `lib/providers/providers.dart` 中导出新的 provider

## 2. 修改时间线 Provider

- [x] 2.1 在 `lib/providers/timeline_provider.dart` 中导入 `activityDataChangeProvider`
- [x] 2.2 在 `timelineProvider` 中添加 `ref.watch(activityDataChangeProvider)`
- [x] 2.3 在 `crossDayTimelineProvider` 中同样添加监听
- [x] 2.4 在 `activityRecordsByDateRangeProvider` 中添加监听

## 3. 修改统计数据 Provider

- [x] 3.1 在 `lib/providers/stats_provider.dart` 中导入 `activityDataChangeProvider`
- [x] 3.2 在 `statsProvider` 中添加 `ref.watch(activityDataChangeProvider)`
- [x] 3.3 在 `todayStatsProvider` 中确认自动继承刷新能力

## 4. 修改最近活动 Provider

- [x] 4.1 在 `lib/providers/recent_activities_provider.dart` 中导入 `activityDataChangeProvider`
- [x] 4.2 在 `recentActivitiesProvider` 中添加 `ref.watch(activityDataChangeProvider)`

## 5. 在数据变更处触发通知

- [x] 5.1 修改 `quick_record_sheet.dart`：在 `_quickInsert` 成功后调用 `ref.read(activityDataChangeProvider.notifier).state++`
- [x] 5.2 修改 `quick_record_sheet.dart`：在 `_quickUpdate` 成功后触发通知
- [x] 5.3 修改 `quick_record_sheet.dart`：在 `_fullInsert` 成功后触发通知
- [x] 5.4 修改 `quick_record_sheet.dart`：在 `_fullUpdate` 成功后触发通知
- [x] 5.5 修改 `timeline_page.dart`：在 `_deleteRecord` 成功后触发通知
- [x] 5.6 移除 `quick_record_sheet.dart` 中 `_refreshData` 方法的特定 provider invalidate 调用（可选，保留无害）

## 6. 测试验证

- [x] 6.1 运行 `flutter analyze` 检查代码错误
- [ ] 6.2 启动应用，在首页添加记录
- [ ] 6.3 切换到时间线页面，验证新记录自动显示
- [ ] 6.4 删除时间线页面的一条记录，验证列表自动更新
- [ ] 6.5 修改一条记录，验证页面自动刷新
