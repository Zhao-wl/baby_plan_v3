## ADDED Requirements

### Requirement: 疫苗页面组件

系统 SHALL 提供 `VaccinePage` 作为疫苗功能的入口页面。

#### Scenario: 页面渲染
- **WHEN** 用户切换到疫苗页签
- **THEN** 显示疫苗页面骨架

#### Scenario: 页面状态保持
- **WHEN** 用户从疫苗页签切换到其他页签
- **THEN** 疫苗页面状态被保留（KeepAlive）

### Requirement: 疫苗页签位置

疫苗页签 SHALL 位于"统计"页签之后、"我的"页签之前，索引为 3。

#### Scenario: 正确的页签顺序
- **WHEN** 查看底部导航栏
- **THEN** 页签顺序为：首页(0)、时间线(1)、统计(2)、疫苗(3)、我的(4)

### Requirement: 疫苗页签图标

疫苗页签 SHALL 使用疫苗相关图标，与其他页签风格一致。

#### Scenario: 图标显示
- **WHEN** 疫苗页签未选中
- **THEN** 显示 `Icons.vaccines_outlined` 图标

#### Scenario: 选中图标显示
- **WHEN** 疫苗页签被选中
- **THEN** 显示 `Icons.vaccines` 图标

### Requirement: 疫苗页签标签

疫苗页签 SHALL 显示中文标签"疫苗"。

#### Scenario: 标签显示
- **WHEN** 查看疫苗页签
- **THEN** 显示标签文字"疫苗"