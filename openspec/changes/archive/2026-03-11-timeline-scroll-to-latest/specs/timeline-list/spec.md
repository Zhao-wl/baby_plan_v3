## ADDED Requirements

### Requirement: 时间线进入时自动滚动到最新记录

系统 SHALL 在时间线页面进入时，自动滚动到列表底部，显示最新一条活动记录。

#### Scenario: 首次进入时间线页面
- **WHEN** 用户首次进入时间线页面且列表有数据
- **THEN** 系统 SHALL 自动滚动到列表底部，显示最新记录
- **AND** 滚动过程 SHALL 使用平滑动画效果

#### Scenario: 列表为空时不滚动
- **WHEN** 时间线页面进入但列表无活动记录
- **THEN** 系统 SHALL 不执行滚动操作

#### Scenario: 新增记录后自动滚动
- **WHEN** 用户在时间线页面新增一条活动记录
- **THEN** 系统 SHALL 自动滚动到新记录位置