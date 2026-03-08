## ADDED Requirements

### Requirement: 宝宝表结构定义
系统 SHALL 定义 Babies 表存储宝宝基本信息，支持家庭组关联。

#### Scenario: 宝宝表字段完整
- **WHEN** 开发人员查看 Babies 表定义
- **THEN** SHALL 找到 id、familyId、name、birthDate、gender、avatarUrl、birthWeight、birthHeight、birthHeadCircumference、serverId、deviceId、syncStatus、createdAt、updatedAt 字段

### Requirement: 宝宝关联家庭组
系统 SHALL 通过 familyId 外键关联宝宝与家庭组，实现家庭组共享宝宝数据。

#### Scenario: 宝宝归属家庭
- **WHEN** 查看宝宝记录
- **THEN** SHALL 能够通过 familyId 查询该宝宝所属的家庭组

### Requirement: 宝宝性别定义
系统 SHALL 支持宝宝性别记录。

#### Scenario: 性别字段定义
- **WHEN** 查看宝宝记录
- **THEN** gender 字段 SHALL 支持 0=男、1=女 两种值

### Requirement: 宝宝出生信息
系统 SHALL 支持记录宝宝出生时的体重、身高、头围信息。

#### Scenario: 出生信息字段
- **WHEN** 查看宝宝记录
- **THEN** SHALL 能够找到 birthWeight、birthHeight、birthHeadCircumference 字段（均可为空）