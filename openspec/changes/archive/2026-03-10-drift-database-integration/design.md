## Context

E.A.S.Y. 育儿助手采用"本地优先"架构，需要在本地存储宝宝的日常活动记录、生长数据、疫苗记录等信息。Drift 作为 SQLite 的类型安全 ORM，提供编译时检查、响应式查询和跨平台支持。

当前状态：
- Drift 依赖已在 `pubspec.yaml` 中配置（drift ^2.32.0、drift_flutter ^0.3.0、drift_dev ^2.32.0）
- 需要创建数据库初始化代码
- 需要验证三端兼容性

约束条件：
- 必须支持 Android、iOS、Web 三端
- 数据库文件需要持久化存储
- 需要支持 schema 迁移

## Goals / Non-Goals

**Goals:**
- 完成数据库连接初始化代码
- 验证三端（Android/iOS/Web）兼容性
- 建立 schema 版本管理和迁移机制
- 验证基本 CRUD 操作性能

**Non-Goals:**
- 不涉及具体数据模型设计（属于 1.3 任务）
- 不涉及数据同步逻辑
- 不涉及数据加密

## Decisions

### 1. 数据库连接方式：drift_flutter

**选择理由：**
- drift_flutter 是 Drift 官方推荐的跨平台连接方案
- 自动处理平台差异（Android/iOS 使用 sqlite3，Web 使用 sql.js）
- 支持内存数据库（便于测试）

```dart
// lib/database/connection.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

LazyDatabase openConnection() {
  return driftDatabase(name: 'baby_plan');
}
```

### 2. Schema 版本管理：内置 Migration

**选择理由：**
- Drift 内置 migration 支持，可在 `onUpgrade` 中处理版本升级
- 配合 build_runner 生成 schema 验证代码
- 支持渐进式迁移

```dart
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 版本迁移逻辑
      },
    );
  }
}
```

### 3. 项目结构

```
lib/
├── database/
│   ├── connection.dart      # 数据库连接
│   ├── database.dart        # Database 类定义
│   └── tables/              # 表定义（后续添加）
│       ├── babies.dart
│       ├── activity_records.dart
│       └── ...
```

### 4. 性能验证方案

| 平台 | 验证内容 | 验收标准 |
|------|----------|----------|
| Android | 插入 1000 条记录 | < 500ms |
| iOS | 插入 1000 条记录 | < 500ms |
| Web | 插入 1000 条记录 | < 1000ms |
| All | 数据库文件持久化 | 重启后数据存在 |

## Risks / Trade-offs

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Web 端 sql.js 加载问题 | 中 | 使用 IndexedDB 存储 SQLite 文件，测试大容量场景 |
| schema 迁移复杂度 | 低 | 初始版本简单，后续使用 drift_dev 生成迁移代码 |
| iOS 后台数据库访问 | 低 | 使用 Drift 的 isolate 支持（如需要） |

**Trade-offs:**
- 使用 drift_flutter 而非原生 sqlite3：获得跨平台一致性，但增加依赖层级
- 初始 schema 版本设为 1：后续添加表需要 migration，但符合最佳实践