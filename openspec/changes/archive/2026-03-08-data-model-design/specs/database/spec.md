## MODIFIED Requirements

### Requirement: 数据库表定义
系统 SHALL 使用 Drift ORM 定义数据库表结构，支持 Android、iOS、Web 三端。

#### Scenario: 数据库表完整
- **WHEN** 开发人员查看数据库定义
- **THEN** SHALL 找到 Users、Families、FamilyMembers、Babies、ActivityRecords、GrowthRecords、VaccineLibrary、VaccineRecords、AgeBenchmarkData 表定义

#### Scenario: 三端兼容
- **WHEN** 应用运行在 Android、iOS 或 Web 平台
- **THEN** 数据库 SHALL 正常初始化和运行

### Requirement: Schema 版本管理
系统 SHALL 使用 Drift 内置的 MigrationStrategy 管理 schema 版本升级。

#### Scenario: 版本升级
- **WHEN** 数据库 schema 版本从 1 升级到 2
- **THEN** onUpgrade 回调 SHALL 正确执行迁移逻辑

#### Scenario: 新用户安装
- **WHEN** 新用户首次安装应用
- **THEN** onCreate 回调 SHALL 创建所有业务表

### Requirement: 外键关联
系统 SHALL 通过外键建立表之间的关联关系。

#### Scenario: 外键约束
- **WHEN** 尝试插入无效的外键值
- **THEN** 数据库 SHALL 拒绝操作或根据配置处理

### Requirement: 数据库性能
系统 SHALL 保证数据库操作性能满足用户体验要求。

#### Scenario: 批量插入性能
- **WHEN** 批量插入 1000 条活动记录
- **THEN** 操作 SHALL 在 1000ms 内完成

#### Scenario: 查询响应时间
- **WHEN** 查询单日活动记录（约 20 条）
- **THEN** 查询 SHALL 在 50ms 内完成