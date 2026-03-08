## 1. 测试基础设施准备

- [x] 1.1 创建 `test/database/table_structure_test.dart` 测试文件
- [x] 1.2 创建 `test/database/foreign_keys_test.dart` 测试文件
- [x] 1.3 创建 `test/database/indexes_test.dart` 测试文件
- [x] 1.4 创建 `test/database/enums_test.dart` 测试文件

## 2. 表结构字段测试

- [x] 2.1 实现用户表 (Users) 字段完整性测试
- [x] 2.2 实现家庭组表 (Families) 字段完整性测试
- [x] 2.3 实现家庭成员表 (FamilyMembers) 字段完整性测试
- [x] 2.4 实现宝宝表 (Babies) 字段完整性测试
- [x] 2.5 实现活动记录表 (ActivityRecords) 公共字段测试
- [x] 2.6 实现活动记录表喂养专属字段测试
- [x] 2.7 实现活动记录表睡眠专属字段测试
- [x] 2.8 实现活动记录表活动专属字段测试
- [x] 2.9 实现活动记录表排泄专属字段测试
- [x] 2.10 实现生长记录表 (GrowthRecords) 字段完整性测试
- [x] 2.11 实现疫苗库表 (VaccineLibrary) 字段完整性测试
- [x] 2.12 实现接种记录表 (VaccineRecords) 字段完整性测试
- [x] 2.13 实现月龄基准数据表 (AgeBenchmarkData) 字段完整性测试
- [x] 2.14 实现软删除字段存在性测试
- [x] 2.15 实现同步字段存在性测试

## 3. 外键关联测试

- [x] 3.1 实现宝宝关联家庭组 (Babies.familyId → Families) 测试
- [x] 3.2 实现家庭成员关联家庭组测试
- [x] 3.3 实现家庭成员唯一性约束测试
- [x] 3.4 实现生长记录关联宝宝 (GrowthRecords.babyId → Babies) 测试
- [x] 3.5 实现活动记录关联宝宝 (ActivityRecords.babyId → Babies) 测试
- [x] 3.6 实现接种记录关联宝宝 (VaccineRecords.babyId → Babies) 测试
- [x] 3.7 实现接种记录关联疫苗库 (VaccineRecords.vaccineLibraryId → VaccineLibrary) 测试
- [x] 3.8 实现生长记录关联活动 (GrowthRecords.relatedActivityId → ActivityRecords) 测试

## 4. 索引验证测试

- [x] 4.1 实现活动记录宝宝时间索引 (idx_activity_baby_time) 测试
- [x] 4.2 实现活动记录同步状态索引 (idx_activity_sync) 测试
- [x] 4.3 实现宝宝家庭索引 (idx_babies_family) 测试
- [x] 4.4 实现生长记录宝宝索引 (idx_growth_baby) 测试
- [x] 4.5 实现接种记录宝宝索引 (idx_vaccine_baby) 测试

## 5. 枚举值完整性测试

- [x] 5.1 实现活动类型 (ActivityType) 枚举测试
- [x] 5.2 实现喂养方式 (EatingMethod) 枚举测试
- [x] 5.3 实现宝宝性别 (Gender) 枚举测试
- [x] 5.4 实现家庭角色 (FamilyRole) 枚举测试
- [x] 5.5 实现喂奶侧别 (BreastSide) 枚举测试
- [x] 5.6 实现接种部位 (InjectionSite) 枚举测试
- [x] 5.7 实现接种状态 (VaccineStatus) 枚举测试
- [x] 5.8 实现同步状态 (SyncStatus) 枚举测试
- [x] 5.9 实现测量上下文 (GrowthContext) 枚举测试

## 6. 测试验证与清理

- [x] 6.1 运行 `flutter test test/database/` 验证所有测试通过
- [x] 6.2 运行 `flutter analyze` 确保无代码问题