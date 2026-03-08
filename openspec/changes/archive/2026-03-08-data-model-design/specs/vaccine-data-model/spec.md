## ADDED Requirements

### Requirement: 疫苗库表结构定义
系统 SHALL 定义 VaccineLibrary 表存储内置的疫苗信息，作为只读数据源。

#### Scenario: 疫苗库表字段完整
- **WHEN** 开发人员查看 VaccineLibrary 表定义
- **THEN** SHALL 找到 id、name、fullName、code、doseIndex、totalDoses、recommendedAgeDays、minIntervalDays、ageDescription、vaccineType、isCombined、description、contraindications、sideEffects、dataVersion 字段

### Requirement: 疫苗库数据来源
系统 SHALL 从内置 JSON 文件加载疫苗库数据。

#### Scenario: JSON 加载机制
- **WHEN** 应用启动时检测到疫苗库版本变化
- **THEN** SHALL 从 JSON 文件更新疫苗库数据

### Requirement: 疫苗库只读属性
系统 SHALL 保证疫苗库数据为只读，用户不能修改。

#### Scenario: 禁止用户修改
- **WHEN** 用户尝试修改疫苗库数据
- **THEN** 系统 SHALL 拒绝操作

### Requirement: 接种记录表结构定义
系统 SHALL 定义 VaccineRecords 表存储用户的疫苗接种记录。

#### Scenario: 接种记录表字段完整
- **WHEN** 开发人员查看 VaccineRecords 表定义
- **THEN** SHALL 找到 id、babyId、vaccineLibraryId、actualDate、batchNumber、manufacturer、hospital、injectionSite、reactionLevel、reactionDetail、reactionOnset、notes、status、serverId、deviceId、syncStatus、version、createdAt、updatedAt 字段

### Requirement: 接种记录关联疫苗库
系统 SHALL 通过 vaccineLibraryId 外键关联接种记录与疫苗库。

#### Scenario: 疫苗关联
- **WHEN** 查看接种记录
- **THEN** SHALL 能够通过 vaccineLibraryId 查询对应的疫苗信息

### Requirement: 接种部位定义
系统 SHALL 支持记录疫苗接种部位。

#### Scenario: 部位字段定义
- **WHEN** 查看接种记录
- **THEN** injectionSite 字段 SHALL 支持 0=左上臂、1=右上臂、2=左大腿、3=右大腿、4=口服、5=其他 六种值

### Requirement: 接种状态定义
系统 SHALL 支持疫苗接种状态跟踪。

#### Scenario: 状态字段定义
- **WHEN** 查看接种记录
- **THEN** status 字段 SHALL 支持 0=待接种、1=已接种、2=已逾期、3=推迟/放弃 四种值

### Requirement: 接种反应记录
系统 SHALL 支持记录接种后的不良反应。

#### Scenario: 反应字段
- **WHEN** 用户记录接种反应
- **THEN** SHALL 能够填写 reactionLevel、reactionDetail、reactionOnset 字段