## ADDED Requirements

### Requirement: 同步状态管理

系统 SHALL 提供 `syncProvider` 管理云同步状态。

#### Scenario: 获取待同步数量
- **WHEN** 查询同步状态
- **THEN** 返回待上传的记录数量

### Requirement: 同步状态字段

syncProvider SHALL 包含以下状态字段：
- isOnline: 网络连接状态
- pendingCount: 待上传记录数
- lastSyncTime: 上次同步时间
- isSyncing: 是否正在同步

#### Scenario: 离线状态
- **WHEN** 设备无网络连接
- **THEN** isOnline 为 false

#### Scenario: 待同步记录
- **WHEN** 本地有未同步的数据变更
- **THEN** pendingCount 更新为待上传数量

### Requirement: 同步状态持久化

syncProvider SHALL 将 lastSyncTime 持久化到 SharedPreferences。

#### Scenario: 恢复上次同步时间
- **WHEN** 应用启动
- **THEN** lastSyncTime 从 SharedPreferences 恢复

### Requirement: 预留同步触发接口

syncProvider SHALL 提供 `syncNow()` 方法预留手动同步触发。

#### Scenario: 触发同步
- **WHEN** 调用 syncNow() 方法
- **THEN** 开始同步流程（实际逻辑在阶段四实现）

**注意**: 实际云同步逻辑在阶段四实现，当前仅搭建框架。