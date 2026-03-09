## ADDED Requirements

### Requirement: 导航状态管理
系统 SHALL 使用 NavigationProvider 管理当前选中的 Tab 状态。

#### Scenario: 初始状态
- **WHEN** 应用启动
- **THEN** NavigationProvider SHALL 将状态初始化为"首页"

#### Scenario: 状态切换
- **WHEN** 用户切换 Tab
- **THEN** NavigationProvider SHALL 更新当前 Tab 状态
- **AND** 通知所有监听者

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

### Requirement: Tab 枚举定义
系统 SHALL 定义 NavTab 枚举表示 4 个 Tab。

#### Scenario: 枚举值
- **WHEN** 定义 NavTab 枚举
- **THEN** SHALL 包含 4 个值：home, timeline, stats, profile