# quick-action-bar Delta Specification

## MODIFIED Requirements

### Requirement: 显示快捷操作台

系统 SHALL 在首页内容流中显示快捷操作台组件。

#### Scenario: 快捷操作台定位
- **WHEN** 用户进入首页
- **THEN** 系统显示快捷操作台
- **AND** 操作台位于计时器卡片下方
- **AND** 操作台左右边距为 16 像素
- **AND** 操作台在滚动流中，非悬浮定位

### Requirement: 快捷操作按钮

系统 SHALL 在快捷操作台中显示五个快捷按钮。

#### Scenario: 五个快捷按钮展示
- **WHEN** 快捷操作台显示时
- **THEN** 显示五个快捷按钮：吃奶、玩耍、睡眠、便便、成长
- **AND** 每个按钮包含图标和文字标签
- **AND** 前四个按钮图标使用对应颜色（绿、黄、蓝、橙）
- **AND** 成长按钮使用主题主色 (Teal)

### Requirement: 快捷操作台视觉样式

系统 SHALL 为快捷操作台设置简洁的视觉样式。

#### Scenario: 简洁背景效果
- **WHEN** 快捷操作台显示时
- **THEN** 背景为纯白色
- **AND** 圆角为 24 像素
- **AND** 显示浅灰色边框 (slate-100)
- **AND** 显示轻微阴影