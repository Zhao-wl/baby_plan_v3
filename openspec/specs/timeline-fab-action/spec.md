# timeline-fab-action Specification

## Purpose

时间线页面悬浮操作按钮 (FAB)，提供快速添加活动记录的入口。

## Requirements

### Requirement: FAB 显示在时间线页面
时间线页面 SHALL 在右下角显示一个圆形悬浮操作按钮 (FAB)。

#### Scenario: 用户查看时间线页面
- **WHEN** 用户进入时间线页面
- **THEN** 页面右下角显示一个圆形加号按钮

### Requirement: FAB 样式规范
FAB SHALL 符合 Material Design 设计规范。

#### Scenario: FAB 视觉样式
- **WHEN** 用户查看 FAB
- **THEN** 按钮为圆形，使用应用主题色作为背景
- **AND** 按钮显示白色加号图标

### Requirement: 点击 FAB 打开编辑界面
用户点击 FAB 后 SHALL 弹出活动编辑界面。

#### Scenario: 用户点击 FAB
- **WHEN** 用户点击 FAB
- **THEN** 从屏幕底部弹出编辑表单界面
- **AND** 表单界面可向上滑动展开

### Requirement: FAB 不影响时间线列表滚动
FAB SHALL 不遮挡时间线列表内容的查看。

#### Scenario: 用户滚动时间线
- **WHEN** 用户滚动时间线列表
- **THEN** 列表内容可以在 FAB 后方正常滚动
- **AND** 列表最后一条记录与 FAB 之间有足够的内边距