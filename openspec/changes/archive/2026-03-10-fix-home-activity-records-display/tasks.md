## 1. 诊断问题

- [x] 1.1 在 `recentActivitiesProvider` 中添加调试日志，验证查询是否执行
- [x] 1.2 检查数据库中是否存在对应宝宝的活动记录
- [x] 1.3 验证 `activityDataChangeProvider` 通知是否正确触发

## 2. 修复 Provider 逻辑

- [x] 2.1 检查 `recentActivitiesProvider` 的查询条件是否正确
- [x] 2.2 验证软删除过滤逻辑 `isDeleted.equals(false)` 是否生效
- [x] 2.3 修复 `activityDataChangeProvider` 导入问题（使用 `flutter_riverpod` 而非 `legacy.dart`）

## 3. 测试验证

- [x] 3.1 运行应用验证首页最近记录是否正确显示
- [x] 3.2 添加新记录后验证列表自动刷新
- [x] 3.3 验证切换宝宝后记录列表正确更新
- [x] 3.4 删除调试日志，提交代码
