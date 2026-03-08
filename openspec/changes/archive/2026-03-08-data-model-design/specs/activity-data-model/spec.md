## ADDED Requirements

### Requirement: 活动记录表结构定义
系统 SHALL 定义 ActivityRecords 表存储宝宝的 E.A.S.Y 活动记录，采用混合设计（公共字段 + 专属字段）。

#### Scenario: 活动记录公共字段完整
- **WHEN** 开发人员查看 ActivityRecords 表定义
- **THEN** SHALL 找到 id、babyId、type、startTime、endTime、durationSeconds、notes、isVerified、createdAt、updatedAt 字段

### Requirement: 活动类型定义
系统 SHALL 支持 Eat(吃)、Activity(玩)、Sleep(睡)、Poop(排泄) 四种活动类型。

#### Scenario: 活动类型字段定义
- **WHEN** 查看活动记录
- **THEN** type 字段 SHALL 支持 0=E吃、1=A玩、2=S睡、3=P排泄 四种值

### Requirement: 喂养专属字段
系统 SHALL 为喂养活动(E)提供专属字段记录详细信息。

#### Scenario: 喂养字段完整
- **WHEN** 查看喂养活动记录（type=0）
- **THEN** SHALL 能够使用 eatingMethod、breastSide、breastDurationMinutes、formulaAmountMl、foodType 字段

#### Scenario: 喂养方式定义
- **WHEN** 查看喂养记录
- **THEN** eatingMethod 字段 SHALL 支持 0=母乳、1=奶粉、2=辅食 三种值

### Requirement: 睡眠专属字段
系统 SHALL 为睡眠活动(S)提供专属字段记录详细信息。

#### Scenario: 睡眠字段完整
- **WHEN** 查看睡眠活动记录（type=2）
- **THEN** SHALL 能够使用 sleepQuality、sleepLocation、sleepAssistMethod 字段

### Requirement: 活动专属字段
系统 SHALL 为活动记录(A)提供专属字段记录详细信息。

#### Scenario: 活动字段完整
- **WHEN** 查看活动记录（type=1）
- **THEN** SHALL 能够使用 activityType、mood 字段

### Requirement: 排泄专属字段
系统 SHALL 为排泄记录(P)提供专属字段记录详细信息。

#### Scenario: 排泄字段完整
- **WHEN** 查看排泄记录（type=3）
- **THEN** SHALL 能够使用 diaperType、stoolColor、stoolTexture 字段

### Requirement: 活动校对标记
系统 SHALL 支持活动记录的校对标记，标识用户已编辑过的记录。

#### Scenario: 校对标记字段
- **WHEN** 用户编辑活动记录后保存
- **THEN** isVerified 字段 SHALL 被设置为 true

### Requirement: 活动记录索引
系统 SHALL 为活动记录表创建索引以优化查询性能。

#### Scenario: 宝宝时间索引
- **WHEN** 按宝宝和时间范围查询活动记录
- **THEN** 查询 SHALL 使用 (babyId, startTime) 索引优化

#### Scenario: 同步状态索引
- **WHEN** 查询待同步的活动记录
- **THEN** 查询 SHALL 使用 syncStatus 索引优化