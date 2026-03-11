## MODIFIED Requirements

### Requirement: 智能预测内容动态显示

系统 SHALL 在智能预测卡片中显示真实的预测内容。

#### Scenario: 预测展示
- **WHEN** 智能预测卡片显示时
- **AND** 系统有可用的预测结果
- **THEN** 显示预测时间
- **AND** 显示预测类型（吃奶/睡眠/排泄）
- **AND** 显示预测描述
- **AND** 左侧显示紫色竖线装饰
- **AND** 显示时间圆圈

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

## ADDED Requirements

### Requirement: 预测卡片交互

系统 SHALL 提供预测卡片的交互功能。

#### Scenario: 标记预测为已处理
- **WHEN** 用户点击预测卡片的确认按钮
- **THEN** 系统将该预测标记为已处理
- **AND** 预测卡片更新为下一个预测

#### Scenario: 点击预测卡片查看详情
- **WHEN** 用户点击预测卡片内容区域
- **THEN** 系统显示预测详情
- **AND** 详情包含：预测依据、置信度、建议

### Requirement: 预测卡片响应系统状态

系统 SHALL 根据系统状态调整预测卡片显示。

#### Scenario: 夜间模式
- **WHEN** 当前时间在22:00-06:00之间
- **THEN** 预测卡片显示"宝宝安睡中"
- **AND** 不显示具体预测

#### Scenario: 进行中活动
- **WHEN** 宝宝有进行中的活动
- **THEN** 预测卡片显示当前活动状态
- **AND** 预测显示为醒后的预测

## REMOVED Requirements

### Requirement: 智能预测内容占位

**Reason**: 预测引擎已实现，不再需要占位内容。

**Migration**: 使用真实预测数据替代静态占位内容。

#### Scenario: 示例预测展示
- **REMOVED** 静态示例预测内容

#### Scenario: 开发中提示
- **REMOVED** "功能开发中，敬请期待..."提示