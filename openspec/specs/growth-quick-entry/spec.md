# growth-quick-entry Specification

## Purpose

成长记录快捷入口组件，提供从首页快捷录入宝宝身高体重数据的功能。

## Requirements

### Requirement: 显示成长记录快捷入口

系统 SHALL 在快捷操作栏中显示成长记录入口按钮。

#### Scenario: 成长按钮展示
- **WHEN** 快捷操作栏显示时
- **THEN** 显示第五个按钮"成长"
- **AND** 图标为趋势图标 (Icons.trending_up)
- **AND** 颜色使用主题主色 (Teal #009688)

### Requirement: 成长记录半屏弹窗

系统 SHALL 提供成长记录输入弹窗。

#### Scenario: 点击成长按钮
- **WHEN** 用户点击"成长"按钮
- **THEN** 弹出半屏 Sheet
- **AND** 显示身高输入框
- **AND** 显示体重输入框
- **AND** 显示保存按钮

#### Scenario: 输入身高和体重
- **WHEN** 用户填写身高和/或体重
- **AND** 点击保存按钮
- **THEN** 系统保存生长记录
- **AND** 关闭弹窗
- **AND** 显示成功提示

#### Scenario: 未填写任何数据
- **WHEN** 用户未填写身高和体重
- **AND** 点击保存按钮
- **THEN** 显示提示"请至少填写一项"
- **AND** 不关闭弹窗

#### Scenario: 取消输入
- **WHEN** 用户点击弹窗外部或关闭按钮
- **THEN** 关闭弹窗
- **AND** 不保存任何数据