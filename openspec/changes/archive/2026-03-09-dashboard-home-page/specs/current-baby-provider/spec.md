## ADDED Requirements

### Requirement: 计算宝宝月龄

系统 SHALL 提供计算宝宝月龄的辅助方法。

#### Scenario: 计算月龄
- **WHEN** 调用月龄计算方法
- **THEN** 返回从出生日期到当前日期的月龄

#### Scenario: 处理未满月
- **WHEN** 宝宝出生不满 1 个月
- **THEN** 返回天数

### Requirement: 格式化月龄显示

系统 SHALL 提供格式化月龄显示的辅助方法。

#### Scenario: 格式化显示
- **WHEN** 调用格式化方法
- **THEN** 返回 "X 天"、"X 个月" 或 "X 岁 Y 个月" 格式的字符串