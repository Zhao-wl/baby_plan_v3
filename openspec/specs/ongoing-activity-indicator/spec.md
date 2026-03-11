# ongoing-activity-indicator Specification

## Purpose

时间线列表中进行中活动的视觉标记，帮助用户快速识别当前正在进行的活动。

## Requirements

### Requirement: 进行中活动视觉标记

系统 SHALL 在时间线列表中用视觉标记区分进行中的活动和已完成的活动。

#### Scenario: 进行中活动标记显示
- **WHEN** 时间线列表中存在进行中的活动（status=0）
- **THEN** 系统 SHALL 在该活动卡片上显示"进行中"标签
- **AND** 标签使用对应活动类型的颜色
- **AND** 标签位于卡片右上角或标题旁

#### Scenario: 进行中活动实时计时显示
- **WHEN** 时间线列表显示进行中活动
- **THEN** 系统 SHALL 实时显示已持续时间
- **AND** 时间每秒更新一次
- **AND** 显示格式为"已持续 X 分钟"或"已持续 X 小时 X 分钟"

### Requirement: 进行中活动动画效果

系统 SHALL 为进行中活动提供视觉动画效果，吸引用户注意。

#### Scenario: 呼吸动画效果
- **WHEN** 时间线列表显示进行中活动
- **THEN** 系统 SHALL 为活动节点添加呼吸动画
- **AND** 动画周期为 2 秒
- **AND** 动画效果为节点透明度在 0.6-1.0 之间渐变

### Requirement: 进行中活动交互

系统 SHALL 允许用户在时间线列表中直接操作进行中活动。

#### Scenario: 点击进行中活动
- **WHEN** 用户点击时间线列表中的进行中活动
- **THEN** 系统 SHALL 弹出编辑表单
- **AND** 表单预填充当前活动信息

#### Scenario: 结束进行中活动
- **WHEN** 用户在编辑表单中点击"结束"按钮
- **THEN** 系统 SHALL 将活动状态改为已完成（status=1）
- **AND** 记录结束时间和持续时间
- **AND** 刷新时间线列表