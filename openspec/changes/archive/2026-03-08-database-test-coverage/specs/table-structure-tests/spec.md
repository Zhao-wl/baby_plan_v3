## ADDED Requirements

### Requirement: 用户表字段完整性测试
系统 SHALL 验证 Users 表包含所有必需字段：id、phone、email、nickname、avatarUrl、serverId、lastSyncAt、createdAt、updatedAt。

#### Scenario: 用户表字段验证
- **WHEN** 运行用户表结构测试
- **THEN** SHALL 验证 Users 表包含 9 个必需字段且类型正确

### Requirement: 家庭组表字段完整性测试
系统 SHALL 验证 Families 表包含所有必需字段：id、name、inviteCode、ownerId、serverId、lastSyncAt、createdAt、isDeleted、deletedAt。

#### Scenario: 家庭组表字段验证
- **WHEN** 运行家庭组表结构测试
- **THEN** SHALL 验证 Families 表包含所有必需字段且类型正确

### Requirement: 家庭成员表字段完整性测试
系统 SHALL 验证 FamilyMembers 表包含所有必需字段：id、familyId、userId、role、serverId、joinedAt、isDeleted、deletedAt。

#### Scenario: 家庭成员表字段验证
- **WHEN** 运行家庭成员表结构测试
- **THEN** SHALL 验证 FamilyMembers 表包含所有必需字段且类型正确

### Requirement: 宝宝表字段完整性测试
系统 SHALL 验证 Babies 表包含所有必需字段：id、familyId、name、birthDate、gender、avatarUrl、birthWeight、birthHeight、birthHeadCircumference、serverId、deviceId、syncStatus、createdAt、updatedAt、isDeleted、deletedAt。

#### Scenario: 宝宝表字段验证
- **WHEN** 运行宝宝表结构测试
- **THEN** SHALL 验证 Babies 表包含所有必需字段且类型正确

### Requirement: 活动记录表字段完整性测试
系统 SHALL 验证 ActivityRecords 表包含公共字段和所有活动类型的专属字段。

#### Scenario: 活动记录公共字段验证
- **WHEN** 运行活动记录表结构测试
- **THEN** SHALL 验证 ActivityRecords 表包含 id、babyId、type、startTime、endTime、durationSeconds、notes、isVerified、serverId、deviceId、syncStatus、version、createdAt、updatedAt、isDeleted、deletedAt 字段

#### Scenario: 喂养专属字段验证
- **WHEN** 验证喂养活动专属字段
- **THEN** SHALL 验证 eatingMethod、breastSide、breastDurationMinutes、formulaAmountMl、foodType 字段存在

#### Scenario: 睡眠专属字段验证
- **WHEN** 验证睡眠活动专属字段
- **THEN** SHALL 验证 sleepQuality、sleepLocation、sleepAssistMethod 字段存在

#### Scenario: 活动专属字段验证
- **WHEN** 验证活动类型专属字段
- **THEN** SHALL 验证 activityType、mood 字段存在

#### Scenario: 排泄专属字段验证
- **WHEN** 验证排泄活动专属字段
- **THEN** SHALL 验证 diaperType、stoolColor、stoolTexture 字段存在

### Requirement: 生长记录表字段完整性测试
系统 SHALL 验证 GrowthRecords 表包含所有必需字段：id、babyId、recordDate、weight、height、headCircumference、notes、relatedActivityId、context、serverId、deviceId、syncStatus、version、createdAt、updatedAt、isDeleted、deletedAt。

#### Scenario: 生长记录表字段验证
- **WHEN** 运行生长记录表结构测试
- **THEN** SHALL 验证 GrowthRecords 表包含所有必需字段且类型正确

### Requirement: 疫苗库表字段完整性测试
系统 SHALL 验证 VaccineLibrary 表包含所有必需字段：id、name、fullName、code、doseIndex、totalDoses、recommendedAgeDays、minIntervalDays、ageDescription、vaccineType、isCombined、description、contraindications、sideEffects、dataVersion。

#### Scenario: 疫苗库表字段验证
- **WHEN** 运行疫苗库表结构测试
- **THEN** SHALL 验证 VaccineLibrary 表包含所有必需字段且类型正确

### Requirement: 接种记录表字段完整性测试
系统 SHALL 验证 VaccineRecords 表包含所有必需字段：id、babyId、vaccineLibraryId、actualDate、batchNumber、manufacturer、hospital、injectionSite、reactionLevel、reactionDetail、reactionOnset、notes、status、serverId、deviceId、syncStatus、version、createdAt、updatedAt、isDeleted、deletedAt。

#### Scenario: 接种记录表字段验证
- **WHEN** 运行接种记录表结构测试
- **THEN** SHALL 验证 VaccineRecords 表包含所有必需字段且类型正确

### Requirement: 月龄基准数据表字段完整性测试
系统 SHALL 验证 AgeBenchmarkData 表包含所有必需字段：id、ageMonths、gender、weightP3、weightP50、weightP97、heightP3、heightP50、heightP97、headCircumferenceP3、headCircumferenceP50、headCircumferenceP97。

#### Scenario: 月龄基准数据表字段验证
- **WHEN** 运行月龄基准数据表结构测试
- **THEN** SHALL 验证 AgeBenchmarkData 表包含所有必需字段且类型正确

### Requirement: 软删除字段验证
系统 SHALL 验证支持软删除的表包含 isDeleted 和 deletedAt 字段。

#### Scenario: 软删除字段存在性验证
- **WHEN** 运行软删除字段测试
- **THEN** SHALL 验证 Users、Families、FamilyMembers、Babies、ActivityRecords、GrowthRecords、VaccineRecords 表包含 isDeleted 和 deletedAt 字段

#### Scenario: 不支持软删除的表验证
- **WHEN** 验证 VaccineLibrary 和 AgeBenchmarkData 表
- **THEN** SHALL 确认这些表不包含软删除字段

### Requirement: 同步字段验证
系统 SHALL 验证支持同步的表包含 serverId、deviceId、syncStatus、version 字段。

#### Scenario: 同步字段存在性验证
- **WHEN** 运行同步字段测试
- **THEN** SHALL 验证 Users、Families、FamilyMembers、Babies、ActivityRecords、GrowthRecords、VaccineRecords 表包含同步字段

#### Scenario: 不同步的表验证
- **WHEN** 验证 VaccineLibrary 和 AgeBenchmarkData 表
- **THEN** SHALL 确认这些表不包含同步字段