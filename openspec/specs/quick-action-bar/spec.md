# quick-action-bar Specification

## Purpose
首页底部悬浮快捷操作台，提供四个快捷按钮（吃奶、玩耍、睡眠、便便）快速开始记录。

## Requirements
### Requirement: 显示快捷操作台

系统 SHALL 在首页底部显示悬浮快捷操作台组件。

#### Scenario: 快捷操作台定位
- **WHEN** 用户进入首页
- **THEN** 系统显示悬浮快捷操作台
- **AND** 操作台固定在底部导航栏上方
- **AND** 操作台左右边距为 24 像素

### Requirement: 快捷操作按钮

系统 SHALL 在快捷操作台中显示四个快捷按钮。

#### Scenario: 四个快捷按钮展示
- **WHEN** 快捷操作台显示时
- **THEN** 显示四个快捷按钮：吃奶、玩耍、睡眠、便便
- **AND** 每个按钮包含图标和文字标签
- **AND** 按钮图标使用对应颜色（绿、黄、蓝、橙）

### Requirement: 快捷按钮样式

系统 SHALL 为每个快捷按钮设置统一的样式。

#### Scenario: 吃奶按钮样式
- **WHEN** 显示吃奶按钮
- **THEN** 图标为餐具图标 (Icons.restaurant)
- **AND** 背景色为绿色浅色 (#E8F5E9)
- **AND** 图标颜色为绿色 (#4CAF50)
- **AND** 文字为"吃奶"

#### Scenario: 玩耍按钮样式
- **WHEN** 显示玩耍按钮
- **THEN** 图标为笑脸图标 (Icons.sentiment_satisfied)
- **AND** 背景色为黄色浅色 (#FFFDE7)
- **AND** 图标颜色为黄色 (#FFC107)
- **AND** 文字为"玩耍"

#### Scenario: 睡眠按钮样式
- **WHEN** 显示睡眠按钮
- **THEN** 图标为月亮图标 (Icons.nightlight)
- **AND** 背景色为蓝色浅色 (#E3F2FD)
- **AND** 图标颜色为蓝色 (#2196F3)
- **AND** 文字为"睡眠"

#### Scenario: 便便按钮样式
- **WHEN** 显示便便按钮
- **THEN** 图标为水滴图标 (Icons.water_drop)
- **AND** 背景色为橙色浅色 (#FFF3E0)
- **AND** 图标颜色为橙色 (#FF9800)
- **AND** 文字为"便便"（非"排泄"）

### Requirement: 快捷操作台视觉样式

系统 SHALL 为快捷操作台设置毛玻璃效果的视觉样式。

#### Scenario: 毛玻璃背景效果
- **WHEN** 快捷操作台显示时
- **THEN** 背景为半透明白色 (0.9 透明度)
- **AND** 圆角为 32 像素
- **AND** 显示轻微阴影

### Requirement: 长按触发弹窗

快捷操作栏的按钮 SHALL 支持长按交互，长按后弹出对应活动类型的快捷记录弹窗。

#### Scenario: 长按吃奶按钮
- **WHEN** 用户长按"吃奶"按钮超过500ms
- **THEN** 弹出吃奶类型的快捷记录弹窗
- **AND** 弹窗默认填充当前时间作为开始时间

#### Scenario: 短按按钮保持原有功能
- **WHEN** 用户短按按钮（小于500ms）
- **THEN** 保持原有计时开始/停止/切换功能不变

### Requirement: 防抖机制

快捷操作栏 SHALL 实现防抖机制，避免快速重复点击导致的异常。

#### Scenario: 快速重复点击
- **WHEN** 用户在500ms内多次点击同一按钮
- **THEN** 仅响应第一次点击，忽略后续重复点击