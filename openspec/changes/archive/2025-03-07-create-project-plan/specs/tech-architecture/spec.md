## ADDED Requirements

### Requirement: 数据层架构设计
系统 SHALL 使用 Isar 3.1+ 作为本地数据库，设计完整的数据模型覆盖所有业务实体。

#### Scenario: 数据模型完整
- **WHEN** 开发人员查看数据层设计
- **THEN** SHALL 找到 Baby、ActivityRecord、GrowthRecord、VaccineRecord、User、FamilyGroup 等实体的定义

#### Scenario: 本地优先支持
- **WHEN** 设备处于离线状态
- **THEN** 应用 SHALL 能够正常记录和查询数据，网络恢复后自动同步

### Requirement: 状态管理层架构
系统 SHALL 使用 Riverpod 2.4+（代码生成版）进行状态管理，实现可测试的依赖注入。

#### Scenario: Provider 结构清晰
- **WHEN** 开发人员查看 providers 目录
- **THEN** SHALL 找到 baby_provider、timeline_provider、stats_provider、sync_provider 等划分清晰的 provider

### Requirement: 服务层设计
系统 SHALL 设计独立的服务层处理业务逻辑，包括预测服务、同步服务、通知服务和导出服务。

#### Scenario: 服务层独立
- **WHEN** 查看 services 目录
- **THEN** SHALL 找到 prediction_service.dart、sync_service.dart、notification_service.dart、export_service.dart

### Requirement: 分层架构清晰
项目结构 SHALL 遵循分层架构，models、providers、repositories、services、ui 各层职责清晰。

#### Scenario: 项目结构检查
- **WHEN** 查看 lib/ 目录
- **THEN** SHALL 看到清晰的分层目录结构，无职责混乱的代码文件
