# timer-ui Specification

## Purpose
计时器 UI 组件，显示实时计时状态，提供控制操作按钮。

## ADDED Requirements

### Requirement: 显示计时状态

系统 SHALL 在首页显示当前计时状态卡片。

#### Scenario: 显示计时中状态
- **WHEN** 正在计时活动
- **THEN** 系统显示：
  - 活动类型标签（吃奶/玩耍/睡眠/便便）
  - 实时计时时长（时:分:秒 格式）
  - 活动对应的主题色
- **AND** 时长每秒更新一次

#### Scenario: 显示暂停状态
- **WHEN** 计时暂停
- **THEN** 系统显示暂停图标
- **AND** 时长不再更新
- **AND** 显示"已暂停"标签

#### Scenario: 显示空闲状态
- **WHEN** 无正在进行的计时
- **THEN** 系统显示"点击下方按钮开始计时"提示
- **AND** 时长显示"00:00:00"

### Requirement: 时间格式化显示

系统 SHALL 以 HH:MM:SS 格式显示计时时长。

#### Scenario: 小于一小时显示
- **WHEN** 计时时长小于1小时
- **THEN** 显示格式为 "MM:SS" 或 "00:MM:SS"

#### Scenario: 超过一小时显示
- **WHEN** 计时时长超过1小时
- **THEN** 显示格式为 "HH:MM:SS"

#### Scenario: 超过24小时显示
- **WHEN** 计时时长超过24小时
- **THEN** 显示格式为 "HH:MM:SS"（小时数继续累加）

### Requirement: 控制按钮

系统 SHALL 提供计时控制按钮。

#### Scenario: 计时中显示的按钮
- **WHEN** 正在计时
- **THEN** 系统显示：
  - 暂停按钮
  - 结束按钮
  - 取消按钮

#### Scenario: 暂停时显示的按钮
- **WHEN** 计时暂停
- **THEN** 系统显示：
  - 继续按钮
  - 结束按钮
  - 取消按钮

#### Scenario: 空闲时无按钮
- **WHEN** 无计时
- **THEN** 系统不显示控制按钮
- **AND** 显示引导提示

### Requirement: 活动类型颜色标识

系统 SHALL 根据活动类型显示对应的主题色。

#### Scenario: 吃奶活动颜色
- **WHEN** 正在计时吃奶活动
- **THEN** 卡片背景使用绿色系（AppColors.eat）

#### Scenario: 玩耍活动颜色
- **WHEN** 正在计时玩耍活动
- **THEN** 卡片背景使用黄色系（AppColors.activity）

#### Scenario: 睡眠活动颜色
- **WHEN** 正在计时睡眠活动
- **THEN** 卡片背景使用蓝色系（AppColors.sleep）

#### Scenario: 便便活动颜色
- **WHEN** 正在计时便便活动
- **THEN** 卡片背景使用棕色系（AppColors.poop）

### Requirement: 呼吸动画效果

系统 SHALL 在计时过程中显示呼吸动画效果。

#### Scenario: 计时中呼吸动画
- **WHEN** 正在计时
- **THEN** 显示呼吸波纹动画
- **AND** 动画周期为3秒

#### Scenario: 暂停时停止动画
- **WHEN** 计时暂停
- **THEN** 呼吸动画停止

### Requirement: 今日累计显示

系统 SHALL 显示今日该类型活动的累计时长。

#### Scenario: 显示今日累计
- **WHEN** 正在计时某类型活动
- **THEN** 显示"今日累计: X 小时 Y 分钟"
- **AND** 累计时长包含当前正在计时的活动