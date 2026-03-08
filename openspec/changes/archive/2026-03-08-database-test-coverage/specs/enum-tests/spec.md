## ADDED Requirements

### Requirement: 活动类型枚举测试
系统 SHALL 验证 ActivityType 枚举包含所有规格定义的值。

#### Scenario: 活动类型枚举值验证
- **WHEN** 运行活动类型枚举测试
- **THEN** ActivityType.eat.value SHALL 等于 0
- **AND** ActivityType.activity.value SHALL 等于 1
- **AND** ActivityType.sleep.value SHALL 等于 2
- **AND** ActivityType.poop.value SHALL 等于 3

### Requirement: 喂养方式枚举测试
系统 SHALL 验证 EatingMethod 枚举包含所有规格定义的值。

#### Scenario: 喂养方式枚举值验证
- **WHEN** 运行喂养方式枚举测试
- **THEN** EatingMethod.breast.value SHALL 等于 0
- **AND** EatingMethod.formula.value SHALL 等于 1
- **AND** EatingMethod.solid.value SHALL 等于 2

### Requirement: 宝宝性别枚举测试
系统 SHALL 验证 Gender 枚举包含所有规格定义的值。

#### Scenario: 性别枚举值验证
- **WHEN** 运行性别枚举测试
- **THEN** Gender.male.value SHALL 等于 0
- **AND** Gender.female.value SHALL 等于 1

### Requirement: 家庭角色枚举测试
系统 SHALL 验证 FamilyRole 枚举包含所有规格定义的值。

#### Scenario: 家庭角色枚举值验证
- **WHEN** 运行家庭角色枚举测试
- **THEN** FamilyRole.creator.value SHALL 等于 0
- **AND** FamilyRole.admin.value SHALL 等于 1
- **AND** FamilyRole.member.value SHALL 等于 2

### Requirement: 喂奶侧别枚举测试
系统 SHALL 验证 BreastSide 枚举包含所有规格定义的值。

#### Scenario: 喂奶侧别枚举值验证
- **WHEN** 运行喂奶侧别枚举测试
- **THEN** BreastSide.left.value SHALL 等于 0
- **AND** BreastSide.right.value SHALL 等于 1

### Requirement: 接种部位枚举测试
系统 SHALL 验证 InjectionSite 枚举包含所有规格定义的值。

#### Scenario: 接种部位枚举值验证
- **WHEN** 运行接种部位枚举测试
- **THEN** InjectionSite.leftUpperArm.value SHALL 等于 0
- **AND** InjectionSite.rightUpperArm.value SHALL 等于 1
- **AND** InjectionSite.leftThigh.value SHALL 等于 2
- **AND** InjectionSite.rightThigh.value SHALL 等于 3
- **AND** InjectionSite.oral.value SHALL 等于 4
- **AND** InjectionSite.other.value SHALL 等于 5

### Requirement: 接种状态枚举测试
系统 SHALL 验证 VaccineStatus 枚举包含所有规格定义的值。

#### Scenario: 接种状态枚举值验证
- **WHEN** 运行接种状态枚举测试
- **THEN** VaccineStatus.pending.value SHALL 等于 0
- **AND** VaccineStatus.completed.value SHALL 等于 1
- **AND** VaccineStatus.overdue.value SHALL 等于 2
- **AND** VaccineStatus.skipped.value SHALL 等于 3

### Requirement: 同步状态枚举测试
系统 SHALL 验证 SyncStatus 枚举包含所有规格定义的值。

#### Scenario: 同步状态枚举值验证
- **WHEN** 运行同步状态枚举测试
- **THEN** SyncStatus.synced.value SHALL 等于 0
- **AND** SyncStatus.pendingUpload.value SHALL 等于 1
- **AND** SyncStatus.pendingDownload.value SHALL 等于 2
- **AND** SyncStatus.conflict.value SHALL 等于 3

### Requirement: 测量上下文枚举测试
系统 SHALL 验证 GrowthContext 枚举包含所有规格定义的值。

#### Scenario: 测量上下文枚举值验证
- **WHEN** 运行测量上下文枚举测试
- **THEN** GrowthContext.beforeMeal.value SHALL 等于 0
- **AND** GrowthContext.afterMeal.value SHALL 等于 1
- **AND** GrowthContext.beforePoop.value SHALL 等于 2
- **AND** GrowthContext.afterPoop.value SHALL 等于 3