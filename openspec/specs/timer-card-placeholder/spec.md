# timer-card-placeholder Specification

## Purpose
首页计时器卡片占位组件，显示渐变背景和呼吸动效，提示用户开始记录活动。

## Requirements
### Requirement: 显示计时器卡片占位

系统 SHALL 在首页显示计时器卡片占位组件，包含渐变背景和呼吸动效。

#### Scenario: 计时器卡片视觉展示
- **WHEN** 用户进入首页
- **THEN** 系统显示带有渐变背景的计时器卡片
- **AND** 卡片高度至少 160 像素
- **AND** 卡片圆角为 32 像素
- **AND** 背景使用蓝色到靛蓝色渐变 (#E3F2FD → #E8EAF6)

### Requirement: 呼吸动效背景

系统 SHALL 在计时器卡片中显示呼吸动效背景。

#### Scenario: 呼吸波纹动效
- **WHEN** 计时器卡片显示时
- **THEN** 系统显示两个圆形呼吸波纹
- **AND** 第一个波纹使用 3 秒周期
- **AND** 第二个波纹使用 4 秒周期
- **AND** 波纹颜色为半透明蓝色

### Requirement: 计时器状态占位

系统 SHALL 在计时器卡片中显示状态占位信息。

#### Scenario: 未开始状态占位
- **WHEN** 没有正在进行的活动
- **THEN** 显示"点击下方按钮开始记录"提示
- **AND** 显示时钟图标

#### Scenario: 今日统计占位
- **WHEN** 计时器卡片显示时
- **THEN** 底部显示"今日统计: 开发中..."占位文字