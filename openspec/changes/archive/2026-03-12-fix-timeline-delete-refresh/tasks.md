## 1. 调查问题根因

- [x] 1.1 调查删除后数据恢复问题，检查数据库操作是否正确执行
- [x] 1.2 检查 timelineProvider 查询是否正确过滤 `isDeleted = true` 的记录

## 2. 修复删除通知机制

- [x] 2.1 恢复 `TimelinePage._deleteRecord` 中的 `activityDataChangeProvider.notify()` 调用
- [x] 2.2 确保通知在数据库操作成功后触发，动画完成后触发

## 3. 解决动画与刷新冲突

- [x] 3.1 修改 `TimelineList._handleDelete` 确保动画完成后再调用父组件回调
- [x] 3.2 添加错误处理：数据库操作失败时回滚本地状态

## 4. 验证与测试

- [x] 4.1 测试删除操作：动画流畅、数据真正删除
- [x] 4.2 测试删除后首页、统计页面实时更新
- [x] 4.3 测试删除后重新进入时间线页面，数据不恢复