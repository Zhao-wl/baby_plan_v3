## Why

首页"最近记录"区域当前无法正确显示活动记录，尽管数据库中已有记录数据。这是一个影响用户体验的关键功能缺陷，需要立即修复以确保用户可以正常查看最近的活动。

## What Changes

- 修复首页"最近记录"区域不显示活动记录的问题
- 检查并修复 `recentActivitiesProvider` 的数据查询逻辑
- 确保数据变化时列表能够正确刷新
- 验证软删除过滤逻辑正确工作

## Capabilities

### New Capabilities
<!-- 无新增功能，仅为 Bug 修复 -->

### Modified Capabilities
- `recent-activities-provider`: 修复数据查询和刷新机制，确保最近活动记录能够正确显示在首页

## Impact

- **代码影响**: `lib/providers/` 目录下相关 Provider 文件
- **UI 影响**: 首页最近记录列表组件
- **无破坏性变更**: 修复现有功能，不影响 API 或数据结构
