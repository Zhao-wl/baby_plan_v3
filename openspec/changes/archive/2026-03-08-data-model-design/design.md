## Context

E.A.S.Y. 育儿助手采用"本地优先"(Local-First) 架构，使用 Drift (SQLite ORM) 作为本地数据库。当前数据库仅包含测试表，需要设计完整的业务数据模型以支持核心功能。

**当前状态：**
- Drift 数据库基础架构已就绪（connection.dart、database.dart）
- 仅有 TestRecords 测试表，schema 版本为 1
- 产品需求文档已完成，明确了数据需求

**约束条件：**
- 必须支持 Android、iOS、Web 三端
- 必须支持本地优先架构（离线可用）
- 必须为未来的家庭组同步预留字段
- 需要支持软删除以防止误删

## Goals / Non-Goals

**Goals:**
- 设计完整的数据模型覆盖所有业务实体
- 实现混合表结构设计（公共字段 + 专属字段）
- 为所有用户数据表添加同步支持字段
- 支持软删除机制
- 支持疫苗库内置数据与用户接种记录分离
- 设计设备标识生成机制

**Non-Goals:**
- 不涉及同步逻辑的具体实现
- 不涉及云服务集成
- 不涉及数据迁移工具开发

## Decisions

### 1. 活动记录表采用混合设计

**选择理由：**
- 公共字段（开始时间、结束时间、时长）便于跨类型统计和 E.A.S.Y 循环分析
- 专属字段（喂养方式、睡眠质量等）提供足够的业务细节
- 单表查询简单，性能好，符合"短时间内需求不太可能扩展"的前提

**备选方案：**
- 多表设计：类型安全性更高，但查询复杂，统计分析困难
- JSON 字段：灵活性高，但类型安全性差

### 2. 同步策略：Last Write Wins (LWW)

**选择理由：**
- 实现简单，适合个人/家庭使用场景
- 通过 version 字段解决冲突，确定性高
- 配合 updatedAt 时间戳作为辅助判断

**字段设计：**
```
serverId    TEXT NULLABLE    -- 服务器ID
deviceId    TEXT NULLABLE    -- 创建设备标识
syncStatus  INT DEFAULT 0    -- 0=已同步, 1=待上传, 2=待下载, 3=冲突
version     INT DEFAULT 1    -- 数据版本号，每次修改 +1
```

### 3. 设备标识：UUID + SharedPreferences

**选择理由：**
- 实现简单，跨平台一致
- 不依赖设备硬件信息（隐私友好）
- 持久化存储，应用卸载后重新生成

**实现方案：**
```dart
// 首次启动时生成
final deviceId = const Uuid().v4();
await SharedPreferences.getInstance().setString('device_id', deviceId);
```

### 4. 软删除机制

**选择理由：**
- 防止误删重要数据
- 支持数据恢复功能
- 便于审计追踪

**字段设计：**
```
isDeleted   BOOL DEFAULT 0   -- 是否已删除
deletedAt   DATETIME NULL    -- 删除时间
```

### 5. 疫苗数据分离设计

**选择理由：**
- 疫苗库（VaccineLibrary）作为内置只读数据，不需要同步
- 接种记录（VaccineRecords）作为用户数据，需要同步
- 清晰的职责分离，便于独立更新疫苗库

**数据来源：**
- 疫苗库：内置 JSON 文件，启动时检查版本并更新
- 接种记录：用户录入，支持家庭组同步

### 6. 索引策略

```sql
-- 活动记录：按宝宝和时间查询
CREATE INDEX idx_activity_baby_time ON activity_records(baby_id, start_time);

-- 同步状态查询
CREATE INDEX idx_activity_sync ON activity_records(sync_status);

-- 宝宝按家庭查询
CREATE INDEX idx_babies_family ON babies(family_id);

-- 疫苗记录按宝宝查询
CREATE INDEX idx_vaccine_baby ON vaccine_records(baby_id);
```

### 7. 项目结构

```
lib/database/
├── connection.dart           # 数据库连接
├── database.dart             # AppDatabase 类
└── tables/
    ├── users.dart            # 用户表
    ├── families.dart         # 家庭组表
    ├── family_members.dart   # 家庭成员关联表
    ├── babies.dart           # 宝宝表
    ├── activity_records.dart # 活动记录表 ★核心
    ├── growth_records.dart   # 生长记录表
    ├── vaccine_library.dart  # 疫苗库表（内置）
    ├── vaccine_records.dart  # 接种记录表
    └── age_benchmark_data.dart # 月龄基准数据表
```

## Risks / Trade-offs

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| 混合设计的 nullable 字段导致类型安全问题 | 中 | 在 Dart 层使用 Freezed 封装类型安全的领域模型 |
| Schema 版本升级时需要处理迁移 | 中 | 使用 Drift 内置的 MigrationStrategy，渐进式迁移 |
| 软删除增加查询复杂度 | 低 | 使用数据库视图或 Repository 层封装过滤逻辑 |
| 疫苗库 JSON 数据过时 | 低 | 版本号管理，支持后续云端更新 |

**Trade-offs：**
- 使用混合设计而非多表：牺牲部分类型安全，换取查询便利性和统计便捷性
- 使用 LWW 而非 CRDT：牺牲部分冲突解决能力，换取实现简单性
- 使用软删除而非硬删：增加存储空间，换取数据安全性