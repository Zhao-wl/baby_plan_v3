# smart-prediction-card Delta Specification

## MODIFIED Requirements

### Requirement: 显示智能预测卡片

系统 SHALL 在首页显示智能预测卡片组件。

#### Scenario: 智能预测卡片视觉展示
- **WHEN** 用户进入首页
- **THEN** 系统显示智能预测卡片
- **AND** 卡片使用白色背景
- **AND** 卡片圆角为 24 像素
- **AND** 卡片高度约 120 像素

### Requirement: 智能预测标题

系统 SHALL 在智能预测卡片中显示标题区域。

#### Scenario: 标题显示
- **WHEN** 智能预测卡片显示时
- **THEN** 显示主题色圆角图标背景 (Teal-100)
- **AND** 显示"智能预测"标题
- **AND** 标题左侧显示星星图标 (auto_awesome)
- **AND** 图标颜色使用主题主色 (Teal)

### Requirement: 智能预测内容动态显示

系统 SHALL 在智能预测卡片中显示真实的预测内容。

#### Scenario: 预测展示
- **WHEN** 智能预测卡片显示时
- **AND** 系统有可用的预测结果
- **THEN** 显示预测时间
- **AND** 显示预测类型（吃奶/睡眠/排泄）
- **AND** 显示预测描述
- **AND** 左侧显示主题色竖线装饰 (Teal)

#### Scenario: 合并预测展示
- **WHEN** 智能预测卡片显示合并预测时
- **THEN** 显示主要预测
- **AND** 显示关联提示（如"醒后可能需要换尿布"）

#### Scenario: 数据不足引导
- **WHEN** 宝宝历史数据不足
- **THEN** 显示"根据月龄推荐"标识
- **AND** 显示基于月龄基准的预测

#### Scenario: 无预测状态
- **WHEN** 没有可用的预测结果
- **THEN** 显示引导文字"记录更多活动，解锁智能预测"