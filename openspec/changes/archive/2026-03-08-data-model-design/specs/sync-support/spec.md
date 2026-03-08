## ADDED Requirements

### Requirement: 同步字段定义
所有需要同步的用户数据表 SHALL 包含 serverId、deviceId、syncStatus、version 字段。

#### Scenario: 同步字段完整性
- **WHEN** 开发人员创建新的用户数据表
- **THEN** SHALL 包含 TextColumn serverId (nullable)、TextColumn deviceId (nullable)、IntColumn syncStatus (default 0)、IntColumn version (default 1)

### Requirement: 同步状态定义
系统 SHALL 定义明确的同步状态值。

#### Scenario: 同步状态值定义
- **WHEN** 查看记录的 syncStatus 字段
- **THEN** SHALL 支持 0=已同步、1=待上传、2=待下载、3=冲突 四种状态

### Requirement: 设备标识生成
系统 SHALL 在首次启动时生成唯一设备标识并持久化存储。

#### Scenario: UUID 生成
- **WHEN** 应用首次启动
- **THEN** SHALL 生成 UUID v4 作为设备标识

#### Scenario: SharedPreferences 存储
- **WHEN** 设备标识生成后
- **THEN** SHALL 存储在 SharedPreferences 中，键名为 "device_id"

#### Scenario: 后续启动读取
- **WHEN** 应用非首次启动
- **THEN** SHALL 从 SharedPreferences 读取已有的设备标识

### Requirement: Last Write Wins 冲突解决
系统 SHALL 使用 LWW (Last Write Wins) 策略解决同步冲突。

#### Scenario: 版本号比较
- **WHEN** 发生数据冲突
- **THEN** version 较大的记录 SHALL 胜出

#### Scenario: 时间戳比较
- **WHEN** version 相同时发生冲突
- **THEN** updatedAt 较新的记录 SHALL 胜出

### Requirement: 更新时间戳维护
系统 SHALL 自动维护 updatedAt 时间戳。

#### Scenario: 创建时设置
- **WHEN** 创建新记录
- **THEN** updatedAt SHALL 设置为当前时间

#### Scenario: 更新时刷新
- **WHEN** 修改记录
- **THEN** updatedAt SHALL 更新为当前时间，version SHALL 自增 1