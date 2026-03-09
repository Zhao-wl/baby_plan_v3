# smart-prediction-card Specification

## Purpose
首页智能预测卡片占位组件，显示示例预测内容和开发中提示。

## Requirements
### Requirement: 显示智能预测卡片占位

系统 SHALL 在首页显示智能预测卡片占位组件。

#### Scenario: 智能预测卡片视觉展示
- **WHEN** 用户进入首页
- **THEN** 系统显示智能预测卡片
- **AND** 卡片使用紫色到粉色渐变背景 (#F3E5F5 → #FCE4EC)
- **AND** 卡片圆角为 24 像素

### Requirement: 智能预测标题

系统 SHALL 在智能预测卡片中显示标题区域。

#### Scenario: 标题显示
- **WHEN** 智能预测卡片显示时
- **THEN** 显示紫色圆角图标背景
- **AND** 显示"智能预测"标题
- **AND** 标题左侧显示星星图标 (Sparkles)

### Requirement: 智能预测内容占位

系统 SHALL 在智能预测卡片中显示示例预测内容。

#### Scenario: 示例预测展示
- **WHEN** 智能预测卡片显示时
- **THEN** 显示一条示例预测
- **AND** 左侧显示紫色竖线装饰
- **AND** 显示时间圆圈（如"14:30"）
- **AND** 显示预测内容文字

#### Scenario: 开发中提示
- **WHEN** 智能预测卡片显示时
- **THEN** 卡片底部显示"功能开发中，敬请期待..."提示