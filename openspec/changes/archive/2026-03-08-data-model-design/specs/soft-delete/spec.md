## ADDED Requirements

### Requirement: 软删除字段定义
所有需要软删除的用户数据表 SHALL 包含 isDeleted 和 deletedAt 字段。

#### Scenario: 软删除字段完整性
- **WHEN** 开发人员创建新的用户数据表
- **THEN** SHALL 包含 BoolColumn isDeleted (default false) 和 DateTimeColumn deletedAt (nullable)

### Requirement: 软删除操作
系统 SHALL 通过设置 isDeleted 标志而非物理删除来执行软删除。

#### Scenario: 标记删除
- **WHEN** 用户删除一条记录
- **THEN** isDeleted SHALL 设置为 true，deletedAt SHALL 设置为当前时间

#### Scenario: 保留原数据
- **WHEN** 执行软删除后
- **THEN** 记录的所有原始数据 SHALL 保持不变

### Requirement: 软删除查询过滤
系统 SHALL 在常规查询中默认排除已软删除的记录。

#### Scenario: 默认过滤
- **WHEN** 执行常规查询（如获取活动列表）
- **THEN** 已软删除的记录（isDeleted=true）SHALL 被排除

#### Scenario: 包含已删除记录
- **WHEN** 需要查看已删除记录（如回收站功能）
- **THEN** SHALL 提供显式参数包含 isDeleted=true 的记录

### Requirement: 软删除恢复
系统 SHALL 支持恢复已软删除的记录。

#### Scenario: 恢复操作
- **WHEN** 用户恢复一条已删除的记录
- **THEN** isDeleted SHALL 重置为 false，deletedAt SHALL 设置为 null

### Requirement: 软删除表范围
以下表 SHALL 支持软删除：
- Users
- Families
- FamilyMembers
- Babies
- ActivityRecords
- GrowthRecords
- VaccineRecords

#### Scenario: 不支持软删除的表
- **WHEN** 查看 VaccineLibrary 和 AgeBenchmarkData 表
- **THEN** 这些表 SHALL NOT 包含软删除字段（内置/缓存数据，不需要软删除）