## ADDED Requirements

### Requirement: 导航 Tab 枚举

系统 SHALL 通过 `NavTab` 枚举定义所有底部导航页签类型。

#### Scenario: 枚举值定义
- **WHEN** 查询 NavTab 枚举
- **THEN** 包含以下值：home、timeline、stats、vaccine、profile

#### Scenario: 枚举索引映射
- **WHEN** 获取枚举值的 index
- **THEN** home=0, timeline=1, stats=2, vaccine=3, profile=4

### Requirement: 导航状态管理

`NavigationState` SHALL 存储当前选中的页签。

#### Scenario: 默认页签
- **WHEN** 应用启动
- **THEN** 默认选中首页（NavTab.home）

#### Scenario: 切换页签
- **WHEN** 用户点击底部导航项
- **THEN** NavigationState 更新为对应的 NavTab 值

### Requirement: 导航 Provider

`navigationProvider` SHALL 作为全局导航状态管理器。

#### Scenario: 读取当前页签
- **WHEN** Widget 通过 ref.watch(navigationProvider) 读取状态
- **THEN** 返回当前选中的 NavTab

#### Scenario: 更新当前页签
- **WHEN** 调用 navigationProvider.notifier.setTab(tab)
- **THEN** NavigationState 更新为新页签