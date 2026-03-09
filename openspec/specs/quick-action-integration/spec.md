# quick-action-integration Specification

## Purpose
快捷操作栏与计时器的联动，实现一键开始/切换活动。

## Requirements

### Requirement: 点击按钮开始计时

系统 SHALL 支持点击快捷按钮开始对应类型的活动计时。

#### Scenario: 无计时时点击开始
- **WHEN** 当前无计时
- **AND** 用户点击快捷按钮（吃奶/玩耍/睡眠/便便）
- **THEN** 系统开始对应类型的活动计时
- **AND** 按钮显示计时中状态

#### Scenario: 有计时时点击同类按钮
- **WHEN** 当前正在计时活动A
- **AND** 用户点击活动A对应的快捷按钮
- **THEN** 系统停止计时并保存记录
- **AND** 按钮恢复默认状态

### Requirement: 点击不同按钮切换活动

系统 SHALL 支持点击不同类型按钮切换活动。

#### Scenario: 切换活动类型
- **WHEN** 当前正在计时活动A
- **AND** 用户点击活动B对应的快捷按钮（B ≠ A）
- **THEN** 系统自动保存活动A的记录
- **AND** 立即开始活动B的计时

### Requirement: 按钮状态反馈

系统 SHALL 根据计时状态显示按钮状态。

#### Scenario: 显示计时中状态
- **WHEN** 正在计时活动A
- **THEN** 活动A对应的按钮显示计时中状态
- **AND** 按钮颜色加深或添加动画效果
- **AND** 显示已计时时长（如"05:32"）

#### Scenario: 其他按钮可点击
- **WHEN** 正在计时活动A
- **THEN** 其他活动按钮仍可点击
- **AND** 点击时触发切换活动逻辑

### Requirement: 防止误触

系统 SHALL 防止用户误触导致频繁开始/停止计时。

#### Scenario: 按钮防抖
- **WHEN** 用户点击快捷按钮
- **THEN** 按钮在500ms内不响应重复点击

#### Scenario: 取消确认
- **WHEN** 用户点击正在计时的按钮
- **AND** 计时时长超过10秒
- **THEN** 系统显示确认对话框"确定结束计时？"
- **AND** 用户确认后停止计时

### Requirement: 无宝宝时的提示

系统 SHALL 在无宝宝时禁止计时并提示。

#### Scenario: 无宝宝时点击按钮
- **WHEN** 未选择任何宝宝
- **AND** 用户点击快捷按钮
- **THEN** 系统显示"请先添加宝宝"提示
- **AND** 不开始计时