# timer-ui Delta Specification

## REMOVED Requirements

### Requirement: 呼吸动画效果

**Reason**: 视觉风格回归朴素，取消动态动画效果。

**Migration**: 移除 `_breathController`、`_breathAnimation` 及 `_buildBreathingRipples` 方法。计时状态通过颜色标签和文字表达。

## MODIFIED Requirements

### Requirement: 显示计时状态

系统 SHALL 在首页显示当前计时状态卡片。

#### Scenario: 显示计时中状态
- **WHEN** 正在计时活动
- **THEN** 系统显示：
  - 活动类型标签（吃奶/玩耍/睡眠/便便）
  - 实时计时时长（时:分:秒 格式）
  - 活动对应的淡化主题色
- **AND** 时长每秒更新一次
- **AND** 卡片高度自适应内容

#### Scenario: 显示暂停状态
- **WHEN** 计时暂停
- **THEN** 系统显示暂停图标
- **AND** 时长不再更新
- **AND** 显示"已暂停"标签

#### Scenario: 显示空闲状态
- **WHEN** 无正在进行的计时
- **THEN** 系统显示"点击下方按钮开始计时"提示
- **AND** 时长显示"00:00:00"
- **AND** 卡片高度为紧凑模式

### Requirement: 控制按钮

系统 SHALL 提供计时控制按钮，按钮布局自适应。

#### Scenario: 计时中显示的按钮
- **WHEN** 正在计时
- **THEN** 系统显示：
  - 暂停按钮
  - 结束按钮
  - 取消按钮
- **AND** 按钮水平排列，自动换行

#### Scenario: 按钮不溢出
- **WHEN** 计时器在任意屏幕尺寸下显示
- **THEN** 控制按钮始终在卡片内完整显示
- **AND** 不出现溢出或裁剪

### Requirement: 活动类型颜色标识

系统 SHALL 根据活动类型显示对应的淡化主题色。

#### Scenario: 吃奶活动颜色
- **WHEN** 正在计时吃奶活动
- **THEN** 卡片背景使用淡绿色 (green-100)
- **AND** 图标和标签使用淡化的绿色 (green-300)

#### Scenario: 玩耍活动颜色
- **WHEN** 正在计时玩耍活动
- **THEN** 卡片背景使用淡黄色 (amber-100)
- **AND** 图标和标签使用淡化的黄色 (amber-300)

#### Scenario: 睡眠活动颜色
- **WHEN** 正在计时睡眠活动
- **THEN** 卡片背景使用淡蓝色 (blue-100)
- **AND** 图标和标签使用淡化的蓝色 (blue-300)

#### Scenario: 便便活动颜色
- **WHEN** 正在计时便便活动
- **THEN** 卡片背景使用淡橙色 (orange-100)
- **AND** 图标和标签使用淡化的橙色 (orange-300)

#### Scenario: 空闲状态颜色
- **WHEN** 无计时
- **THEN** 卡片背景使用白色
- **AND** 边框使用浅灰色 (slate-200)

## ADDED Requirements

### Requirement: 内容自适应高度

系统 SHALL 让计时器卡片高度根据内容自适应。

#### Scenario: 空闲状态高度
- **WHEN** 无计时
- **THEN** 卡片高度约 140 像素
- **AND** 不显示控制按钮

#### Scenario: 计时状态高度
- **WHEN** 正在计时
- **THEN** 卡片高度约 210 像素
- **AND** 包含控制按钮区域

#### Scenario: 响应式按钮布局
- **WHEN** 屏幕宽度不足以水平排列三个按钮
- **THEN** 按钮使用更紧凑的间距
- **AND** 保持在一行内显示