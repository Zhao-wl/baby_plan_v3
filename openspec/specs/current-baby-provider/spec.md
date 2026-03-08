# current-baby-provider Specification

## Purpose
TBD - created by archiving change riverpod-architecture. Update Purpose after archive.
## Requirements
### Requirement: 当前宝宝状态管理

系统 SHALL 提供 `currentBabyProvider` 管理当前选中的宝宝状态。

#### Scenario: 初始化时恢复上次选择
- **WHEN** 应用启动且 SharedPreferences 中存储了有效的 babyId
- **THEN** currentBabyProvider 自动恢复该宝宝作为当前宝宝

#### Scenario: 切换当前宝宝
- **WHEN** 用户选择另一个宝宝
- **THEN** currentBabyProvider 更新为新选择的宝宝

#### Scenario: 持久化当前宝宝选择
- **WHEN** 当前宝宝切换
- **THEN** 新的 babyId 存储到 SharedPreferences

### Requirement: 空状态处理

当没有可用宝宝时，currentBabyProvider SHALL 返回 null。

#### Scenario: 无宝宝时返回 null
- **WHEN** 数据库中没有宝宝记录
- **THEN** currentBabyProvider 返回 null

#### Scenario: 已删除宝宝的处理
- **WHEN** 当前选中的宝宝被删除
- **THEN** currentBabyProvider 自动切换到第一个可用宝宝或 null

### Requirement: 宝宝列表 Provider

系统 SHALL 提供 `babiesProvider` 返回当前家庭的所有宝宝列表。

#### Scenario: 获取宝宝列表
- **WHEN** Widget 订阅 babiesProvider
- **THEN** 返回当前家庭的所有未删除宝宝

#### Scenario: 宝宝列表实时更新
- **WHEN** 添加或删除宝宝
- **THEN** babiesProvider 自动更新

