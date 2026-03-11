# activity-record-form Specification

## Purpose

通用活动记录编辑表单，支持四种活动类型（吃/玩/睡/排泄）的详情字段动态显示和表单验证。

## Requirements

### Requirement: 活动类型选择
编辑表单 SHALL 允许用户选择活动类型。

#### Scenario: 用户选择活动类型
- **WHEN** 编辑表单打开
- **THEN** 显示四种活动类型选项：吃(Eat)、玩(Activity)、睡(Sleep)、排泄(Poop)
- **AND** 用户可以选择其中一种类型

### Requirement: 时间设置
编辑表单 SHALL 允许用户设置活动开始时间和结束时间。

#### Scenario: 用户设置活动时间
- **WHEN** 用户点击时间选择字段
- **THEN** 弹出日期选择器
- **AND** 用户确认日期后弹出时间选择器
- **AND** 用户可以选择过去或当前的时间

#### Scenario: 结束时间可选
- **WHEN** 用户未设置结束时间
- **THEN** 系统 SHALL 允许提交表单
- **AND** 结束时间字段留空

### Requirement: 类型专属字段 - 喂养
当选择"吃"类型时，表单 SHALL 显示喂养相关字段。

#### Scenario: 母乳喂养
- **WHEN** 用户选择活动类型为"吃"
- **AND** 选择喂养方式为"母乳"
- **THEN** 显示左右边选择和喂养时长字段

#### Scenario: 配方奶喂养
- **WHEN** 用户选择活动类型为"吃"
- **AND** 选择喂养方式为"配方奶"
- **THEN** 显示奶量(ml)输入字段

#### Scenario: 辅食喂养
- **WHEN** 用户选择活动类型为"吃"
- **AND** 选择喂养方式为"辅食"
- **THEN** 显示食物类型输入字段

### Requirement: 类型专属字段 - 睡眠
当选择"睡"类型时，表单 SHALL 显示睡眠相关字段。

#### Scenario: 睡眠详情
- **WHEN** 用户选择活动类型为"睡"
- **THEN** 显示睡眠地点选择字段
- **AND** 显示入睡方式选择字段
- **AND** 显示睡眠质量评分字段

### Requirement: 类型专属字段 - 活动
当选择"玩"类型时，表单 SHALL 显示活动相关字段。

#### Scenario: 活动详情
- **WHEN** 用户选择活动类型为"玩"
- **THEN** 显示活动类型选择字段
- **AND** 显示情绪状态选择字段

### Requirement: 类型专属字段 - 排泄
当选择"排泄"类型时，表单 SHALL 显示排泄相关字段。

#### Scenario: 排泄详情
- **WHEN** 用户选择活动类型为"排泄"
- **THEN** 显示尿布类型选择字段
- **AND** 显示大便颜色选择字段（如适用）
- **AND** 显示大便质地选择字段（如适用）

### Requirement: 备注字段
所有活动类型 SHALL 支持添加备注。

#### Scenario: 用户添加备注
- **WHEN** 用户在备注字段输入文本
- **THEN** 备注内容 SHALL 随活动记录一起保存

### Requirement: 表单提交
用户 SHALL 能够提交表单保存活动记录。

#### Scenario: 成功提交
- **WHEN** 用户填写完表单并点击保存
- **THEN** 表单 SHALL 验证必填字段
- **AND** 验证通过后关闭表单
- **AND** 时间线列表 SHALL 刷新显示新记录

#### Scenario: 取消编辑
- **WHEN** 用户点击取消或向下滑动
- **THEN** 表单 SHALL 关闭
- **AND** 不保存任何数据