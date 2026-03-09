## ADDED Requirements

### Requirement: 显示最近活动列表

系统 SHALL 在首页显示最近的活动记录列表，默认显示最近 2 条。

#### Scenario: 有活动记录时显示列表
- **WHEN** 宝宝有活动记录
- **THEN** 系统显示最近 2 条活动记录
- **AND** 每条记录显示活动类型图标、时间、时长

#### Scenario: 无活动记录时显示引导
- **WHEN** 宝宝没有任何活动记录
- **THEN** 系统显示"开始记录第一条活动"引导

### Requirement: 活动类型颜色区分

系统 SHALL 使用不同颜色区分活动类型。

#### Scenario: 活动类型颜色显示
- **WHEN** 显示活动记录
- **THEN** Eat 类型使用绿色 (#4CAF50)
- **AND** Activity 类型使用黄色 (#FFC107)
- **AND** Sleep 类型使用蓝色 (#2196F3)
- **AND** Poop 类型使用橙色 (#FF9800)

### Requirement: 活动记录时间格式化

系统 SHALL 格式化显示活动记录的时间信息。

#### Scenario: 今日活动显示时间
- **WHEN** 活动发生在今天
- **THEN** 显示 "今天 HH:mm"

#### Scenario: 昨日活动显示昨天
- **WHEN** 活动发生在昨天
- **THEN** 显示 "昨天 HH:mm"

#### Scenario: 更早活动显示日期
- **WHEN** 活动发生在更早
- **THEN** 显示 "MM-DD HH:mm"