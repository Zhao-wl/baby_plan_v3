## MODIFIED Requirements

### Requirement: 卡片视觉样式

系统 SHALL 为活动卡片提供清晰的视觉层级和样式，并确保布局不出现溢出错误。

#### Scenario: 卡片背景色
- **WHEN** 渲染活动卡片
- **THEN** 系统 SHALL 根据活动类型使用对应的浅色背景
  - E (吃): #E8F5E9 (绿色浅底)
  - A (玩): #FFF8E1 (黄色浅底)
  - S (睡): #E3F2FD (蓝色浅底)
  - P (排泄): #FFF3E0 (橙色浅底)

#### Scenario: 类型图标显示
- **WHEN** 渲染活动卡片
- **THEN** 系统 SHALL 显示对应活动类型的图标

#### Scenario: 卡片圆角和阴影
- **WHEN** 渲染活动卡片
- **THEN** 系统 SHALL 应用统一的圆角（12px）和轻微阴影

#### Scenario: 卡片布局不溢出
- **WHEN** 渲染任意内容的活动卡片（包括短内容、长内容、有备注、无备注）
- **THEN** 系统 SHALL 确保卡片内容完整显示
- **AND** 不出现布局溢出警告（如 "BOTTOM OVERFLOWED"）

#### Scenario: 滑动删除按钮层高度正确
- **WHEN** 用户在活动卡片上开始滑动操作
- **THEN** 系统 SHALL 确保删除按钮层的高度与卡片内容高度一致
- **AND** 删除按钮正确显示在卡片右侧