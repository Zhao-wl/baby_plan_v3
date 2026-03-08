## ADDED Requirements

### Requirement: 生长记录表结构定义
系统 SHALL 定义 GrowthRecords 表存储宝宝的生长数据记录。

#### Scenario: 生长记录表字段完整
- **WHEN** 开发人员查看 GrowthRecords 表定义
- **THEN** SHALL 找到 id、babyId、recordDate、weight、height、headCircumference、notes、relatedActivityId、context、serverId、deviceId、syncStatus、version、createdAt、updatedAt 字段

### Requirement: 生长记录关联活动
系统 SHALL 支持生长记录与活动记录的关联，记录测量时的上下文（饭前/饭后等）。

#### Scenario: 活动关联字段
- **WHEN** 用户在活动记录中添加体重/身高测量
- **THEN** SHALL 能够关联到相关的活动记录

#### Scenario: 上下文字段定义
- **WHEN** 查看生长记录
- **THEN** context 字段 SHALL 支持 0=饭前、1=饭后、2=便前、3=便后 四种值

### Requirement: 生长数据单位
系统 SHALL 使用标准单位存储生长数据。

#### Scenario: 单位定义
- **WHEN** 查看生长记录字段
- **THEN** weight SHALL 使用 kg 单位，height SHALL 使用 cm 单位，headCircumference SHALL 使用 cm 单位