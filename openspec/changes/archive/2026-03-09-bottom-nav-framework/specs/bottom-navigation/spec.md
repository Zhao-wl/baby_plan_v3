## ADDED Requirements

### Requirement: 底部导航栏显示
系统 SHALL 在应用底部显示导航栏，包含 4 个 Tab 入口：首页、时间线、统计、我的。

#### Scenario: 默认显示首页
- **WHEN** 应用启动
- **THEN** 系统 SHALL 显示底部导航栏
- **AND** 默认选中"首页"Tab

#### Scenario: Tab 切换
- **WHEN** 用户点击导航栏中的某个 Tab
- **THEN** 系统 SHALL 切换到对应的页面
- **AND** 更新导航栏选中状态

### Requirement: Material 3 风格
导航栏 SHALL 遵循 Material 3 设计规范，使用 NavigationBar 组件。

#### Scenario: 视觉样式
- **WHEN** 渲染导航栏
- **THEN** 系统 SHALL 使用 Material 3 的 NavigationBar 组件
- **AND** 选中的 Tab 显示图标和文字
- **AND** 未选中的 Tab 仅显示图标

#### Scenario: 主题适配
- **WHEN** 应用切换浅色/深色主题
- **THEN** 导航栏 SHALL 自动适配主题颜色

### Requirement: 导航项配置
每个导航项 SHALL 包含图标和文字标签。

#### Scenario: 首页 Tab
- **WHEN** 查看导航栏
- **THEN** "首页" Tab SHALL 使用 home 图标
- **AND** 显示文字"首页"

#### Scenario: 时间线 Tab
- **WHEN** 查看导航栏
- **THEN** "时间线" Tab SHALL 使用 timeline 或 schedule 图标
- **AND** 显示文字"时间线"

#### Scenario: 统计 Tab
- **WHEN** 查看导航栏
- **THEN** "统计" Tab SHALL 使用 bar_chart 或 analytics 图标
- **AND** 显示文字"统计"

#### Scenario: 我的 Tab
- **WHEN** 查看导航栏
- **THEN** "我的" Tab SHALL 使用 person 图标
- **AND** 显示文字"我的"