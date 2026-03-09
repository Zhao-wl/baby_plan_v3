## ADDED Requirements

### Requirement: 呼吸动效背景组件

系统 SHALL 提供可复用的呼吸动效背景组件。

#### Scenario: 动效自动播放
- **WHEN** 组件加载完成
- **THEN** 动效开始自动播放
- **AND** 循环往复

### Requirement: 动效颜色可配置

系统 SHALL 允许配置呼吸动效的颜色。

#### Scenario: 自定义颜色
- **WHEN** 传入 color 参数
- **THEN** 动效使用指定颜色

### Requirement: 动效性能优化

系统 SHALL 使用 RepaintBoundary 优化动效性能。

#### Scenario: 隔离重绘区域
- **WHEN** 动效运行时
- **THEN** 不影响其他 Widget 的重绘

### Requirement: 支持子组件

系统 SHALL 允许在呼吸动效背景上放置子组件。

#### Scenario: 嵌套子组件
- **WHEN** 传入 child 参数
- **THEN** 子组件显示在动效背景之上