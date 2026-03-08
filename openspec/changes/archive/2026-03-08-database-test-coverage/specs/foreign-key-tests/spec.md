## ADDED Requirements

### Requirement: 宝宝关联家庭组测试
系统 SHALL 验证 Babies 表的 familyId 外键正确关联到 Families 表。

#### Scenario: 宝宝家庭关联建立
- **WHEN** 创建家庭后创建宝宝并关联
- **THEN** SHALL 能够通过 familyId 查询到宝宝所属家庭

#### Scenario: 无效家庭ID拒绝
- **WHEN** 尝试创建 familyId 指向不存在家庭的宝宝
- **THEN** 系统 SHALL 拒绝该操作（如启用外键约束）

### Requirement: 家庭成员关联家庭组测试
系统 SHALL 验证 FamilyMembers 表的 familyId 和 userId 外键正确关联。

#### Scenario: 家庭成员关联建立
- **WHEN** 创建用户和家庭后添加家庭成员关系
- **THEN** SHALL 能够正确查询用户所属家庭

#### Scenario: 家庭成员唯一性约束
- **WHEN** 尝试为同一用户在同一家庭创建重复的成员关系
- **THEN** 系统 SHALL 拒绝重复插入

### Requirement: 生长记录关联宝宝测试
系统 SHALL 验证 GrowthRecords 表的 babyId 外键正确关联到 Babies 表。

#### Scenario: 生长记录宝宝关联建立
- **WHEN** 创建宝宝后创建生长记录
- **THEN** SHALL 能够通过 babyId 查询到相关宝宝

### Requirement: 活动记录关联宝宝测试
系统 SHALL 验证 ActivityRecords 表的 babyId 外键正确关联到 Babies 表。

#### Scenario: 活动记录宝宝关联建立
- **WHEN** 创建宝宝后创建活动记录
- **THEN** SHALL 能够通过 babyId 查询到相关宝宝

### Requirement: 接种记录关联宝宝测试
系统 SHALL 验证 VaccineRecords 表的 babyId 外键正确关联到 Babies 表。

#### Scenario: 接种记录宝宝关联建立
- **WHEN** 创建宝宝后创建接种记录
- **THEN** SHALL 能够通过 babyId 查询到相关宝宝

### Requirement: 接种记录关联疫苗库测试
系统 SHALL 验证 VaccineRecords 表的 vaccineLibraryId 外键正确关联到 VaccineLibrary 表。

#### Scenario: 接种记录疫苗关联建立
- **WHEN** 创建疫苗库条目后创建接种记录
- **THEN** SHALL 能够通过 vaccineLibraryId 查询到疫苗信息

### Requirement: 生长记录关联活动测试
系统 SHALL 验证 GrowthRecords 表的 relatedActivityId 字段可关联到 ActivityRecords 表。

#### Scenario: 生长记录活动关联建立
- **WHEN** 创建活动记录后创建生长记录并关联
- **THEN** SHALL 能够通过 relatedActivityId 查询到相关活动记录