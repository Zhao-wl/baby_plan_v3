## ADDED Requirements

### Requirement: 疫苗库数据加载
系统 SHALL 从内置 JSON 文件加载疫苗库数据到数据库。

#### Scenario: 首次加载
- **WHEN** 应用首次启动且疫苗库表为空
- **THEN** 系统 SHALL 从 vaccine_library.json 加载数据到 VaccineLibrary 表

#### Scenario: 版本更新加载
- **WHEN** 疫苗库 JSON 文件的版本号高于数据库中的版本号
- **THEN** 系统 SHALL 更新疫苗库数据

#### Scenario: 数据已存在跳过加载
- **WHEN** 疫苗库数据已存在且版本一致
- **THEN** 系统 SHALL 跳过加载过程

### Requirement: 疫苗计划查询
系统 SHALL 提供按宝宝 ID 查询疫苗计划的能力。

#### Scenario: 查询疫苗计划
- **WHEN** 调用疫苗计划查询接口并传入宝宝 ID
- **THEN** 系统 SHALL 返回该宝宝的完整疫苗计划，包含疫苗信息和接种记录

#### Scenario: 按月龄分组
- **WHEN** 查询疫苗计划
- **THEN** 系统 SHALL 返回按月龄分组的数据结构

### Requirement: 疫苗状态计算
系统 SHALL 根据宝宝信息和接种记录计算疫苗显示状态。

#### Scenario: 已完成状态计算
- **WHEN** 存在该疫苗的已完成接种记录
- **THEN** 系统 SHALL 返回状态为 done

#### Scenario: 已逾期状态计算
- **WHEN** 宝宝年龄 >= 疫苗推荐年龄 + 30 天且无接种记录
- **THEN** 系统 SHALL 返回状态为 overdue

#### Scenario: 近期计划状态计算
- **WHEN** 宝宝年龄在疫苗推荐年龄前后 7 天内且无接种记录
- **THEN** 系统 SHALL 返回状态为 upcoming

#### Scenario: 待接种状态计算
- **WHEN** 宝宝年龄 < 疫苗推荐年龄 - 7 天且无接种记录
- **THEN** 系统 SHALL 返回状态为 pending

### Requirement: 接种记录创建
系统 SHALL 允许创建新的接种记录。

#### Scenario: 创建接种记录
- **WHEN** 用户提供宝宝 ID、疫苗库 ID、接种日期
- **THEN** 系统 SHALL 创建新的接种记录，状态设为已接种

#### Scenario: 关联疫苗信息
- **WHEN** 创建接种记录
- **THEN** 系统 SHALL 通过 vaccineLibraryId 关联疫苗库信息

### Requirement: 接种记录查询
系统 SHALL 提供按宝宝 ID 和疫苗 ID 查询接种记录的能力。

#### Scenario: 查询宝宝所有接种记录
- **WHEN** 传入宝宝 ID
- **THEN** 系统 SHALL 返回该宝宝的所有接种记录

#### Scenario: 查询特定疫苗的接种记录
- **WHEN** 传入宝宝 ID 和疫苗库 ID
- **THEN** 系统 SHALL 返回该宝宝该疫苗的接种记录

### Requirement: 统计数据查询
系统 SHALL 提供疫苗统计数据查询能力。

#### Scenario: 已完成数量统计
- **WHEN** 查询疫苗统计
- **THEN** 系统 SHALL 返回已完成接种的疫苗数量

#### Scenario: 逾期疫苗列表
- **WHEN** 查询逾期疫苗
- **THEN** 系统 SHALL 返回所有逾期未接种的疫苗列表

### Requirement: 数据响应式更新
系统 SHALL 在接种记录变更时自动更新相关数据。

#### Scenario: 记录保存后刷新
- **WHEN** 新接种记录保存成功
- **THEN** 系统 SHALL 自动刷新疫苗计划列表和统计数据