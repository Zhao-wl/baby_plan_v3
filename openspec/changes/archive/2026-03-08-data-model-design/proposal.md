## Why

E.A.S.Y. 育儿助手的核心功能依赖于完整的数据模型设计。当前数据库仅有测试表，需要实现完整的业务数据表结构，以支持宝宝活动记录、生长追踪、疫苗管理等核心功能，并为未来的家庭组同步奠定基础。

## What Changes

- 新增用户相关表：`Users`、`Families`、`FamilyMembers`
- 新增宝宝相关表：`Babies`
- 新增活动记录表：`ActivityRecords`（混合设计，公共字段 + 专属字段）
- 新增生长记录表：`GrowthRecords`
- 新增疫苗相关表：`VaccineLibrary`（内置只读）、`VaccineRecords`（用户数据）
- 新增月龄基准数据表：`AgeBenchmarkData`（云端缓存）
- 所有用户数据表支持软删除和同步字段
- 设备标识通过 UUID 生成并存储在 SharedPreferences

## Capabilities

### New Capabilities

- `user-data-model`: 用户账号、家庭组、家庭成员关联的数据模型
- `baby-data-model`: 宝宝基本信息数据模型
- `activity-data-model`: E.A.S.Y 活动记录数据模型（吃/玩/睡/排泄）
- `growth-data-model`: 宝宝生长记录数据模型
- `vaccine-data-model`: 疫苗库与接种记录数据模型
- `sync-support`: 数据同步支持字段（serverId、deviceId、syncStatus、version）
- `soft-delete`: 软删除支持字段（isDeleted、deletedAt）

### Modified Capabilities

- `database`: 扩展现有数据库结构，新增业务表定义

## Impact

- **数据库层**：`lib/database/tables/` 目录下新增 8 张表定义
- **代码生成**：需要运行 `build_runner` 重新生成数据库代码
- **Schema 版本**：数据库 schema 版本从 1 升级到 2
- **迁移策略**：需要处理从测试表到业务表的迁移