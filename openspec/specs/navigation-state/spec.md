## Requirements

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

### Requirement: 页面状态保持
系统 SHALL 使用 IndexedStack 保持所有页面的状态，防止切换时重置。

#### Scenario: 页面状态保持
- **WHEN** 用户从 Tab A 切换到 Tab B
- **THEN** Tab A 的页面状态 SHALL 被保留
- **AND** 再次切换回 Tab A 时 SHALL 恢复之前的状态

#### Scenario: 滚动位置保持
- **WHEN** 用户在某个页面滚动到特定位置
- **AND** 切换到其他 Tab
- **AND** 再次切换回该页面
- **THEN** 滚动位置 SHALL 保持不变

### Requirement: 导航接口
系统 SHALL 提供统一的导航接口供其他模块调用。

#### Scenario: 程序化导航
- **WHEN** 其他模块需要切换到特定 Tab
- **THEN** 系统 SHALL 提供 `setTab(NavTab tab)` 方法
- **AND** 调用后导航状态 SHALL 更新

#### Scenario: 获取当前 Tab
- **WHEN** 其他模块需要知道当前选中的 Tab
- **THEN** 系统 SHALL 提供 `currentTab` 属性
- **AND** 返回当前 Tab 枚举值