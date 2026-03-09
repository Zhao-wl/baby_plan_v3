## MODIFIED Requirements

### Requirement: 显示最近活动列表

系统 SHALL 在首页显示最近的活动记录列表，默认显示最近 2 条。

#### Scenario: 有活动记录时显示列表
- **WHEN** 宝宝有活动记录
- **THEN** 系统显示最近 2 条活动记录
- **AND** 每条记录使用白色背景卡片
- **AND** 卡片圆角为 24 像素
- **AND** 每条记录显示活动类型图标、时间、时长

#### Scenario: 无活动记录时显示引导
- **WHEN** 宝宝没有任何活动记录
- **THEN** 系统显示"开始记录第一条活动"引导

### Requirement: 活动记录项样式

系统 SHALL 为每条活动记录设置统一的卡片样式。

#### Scenario: 活动记录项布局
- **WHEN** 显示活动记录项
- **THEN** 左侧显示圆角图标背景（48x48 像素，圆角 16 像素）
- **AND** 图标背景使用活动类型对应颜色浅色
- **AND** 右侧显示活动类型名称（粗体）和详细描述
- **AND** 右上角显示时间

#### Scenario: 活动描述格式
- **WHEN** 显示活动记录详情
- **THEN** 显示格式为"活动类型 · 详情"
- **AND** 喂养类型显示"母乳亲喂 · 左侧 15分钟"等

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