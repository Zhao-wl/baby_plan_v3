## ADDED Requirements

### Requirement: 活动记录索引验证
系统 SHALL 验证 ActivityRecords 表的索引正确创建。

#### Scenario: 宝宝时间索引验证
- **WHEN** 查询数据库索引列表
- **THEN** SHALL 存在 idx_activity_baby_time 索引，包含 (baby_id, start_time) 列

#### Scenario: 同步状态索引验证
- **WHEN** 查询数据库索引列表
- **THEN** SHALL 存在 idx_activity_sync 索引，包含 (sync_status) 列

### Requirement: 宝宝表索引验证
系统 SHALL 验证 Babies 表的索引正确创建。

#### Scenario: 家庭索引验证
- **WHEN** 查询数据库索引列表
- **THEN** SHALL 存在 idx_babies_family 索引，包含 (family_id) 列

### Requirement: 生长记录索引验证
系统 SHALL 验证 GrowthRecords 表的索引正确创建。

#### Scenario: 宝宝索引验证
- **WHEN** 查询数据库索引列表
- **THEN** SHALL 存在 idx_growth_baby 索引，包含 (baby_id) 列

### Requirement: 接种记录索引验证
系统 SHALL 验证 VaccineRecords 表的索引正确创建。

#### Scenario: 宝宝索引验证
- **WHEN** 查询数据库索引列表
- **THEN** SHALL 存在 idx_vaccine_baby 索引，包含 (baby_id) 列

### Requirement: 索引性能效益验证
系统 SHALL 验证索引能提升查询性能。

#### Scenario: 索引查询计划验证
- **WHEN** 执行使用索引的查询并检查查询计划
- **THEN** 查询计划 SHALL 显示使用了相应索引