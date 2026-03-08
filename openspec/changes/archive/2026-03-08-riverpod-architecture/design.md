## Context

项目已完成 Drift 数据库集成，包含完整的表结构（Users, Families, Babies, ActivityRecords 等）。当前 `main.dart` 使用 StatefulWidget 直接管理数据库实例，缺少响应式状态管理层。

需要搭建 Riverpod 架构以支持：
- 多宝宝切换
- 实时计时器
- 时间线数据查询
- 统计数据聚合
- 云同步状态管理

## Goals / Non-Goals

**Goals:**
- 配置 Riverpod 代码生成（`riverpod_annotation` + `riverpod_generator`）
- 创建清晰的 Provider 层次结构和依赖关系
- 实现当前宝宝状态持久化（SharedPreferences）
- 为时间线、统计、同步功能提供数据接口

**Non-Goals:**
- 不实现 UI 页面（属于后续阶段）
- 不实现云同步逻辑（属于阶段四）
- 不引入 Repository 层（直接 Provider → Database，保持简洁）

## Decisions

### D1: 使用代码生成而非手写 Provider

**选择**: `riverpod_annotation` + `riverpod_generator`

**理由**:
- 代码更简洁，减少样板代码
- 自动生成 family/参数变体
- 类型安全，编译期检查
- 官方推荐的最佳实践

**备选方案**: 手写 `StateNotifierProvider`
- 放弃原因：样板代码多，维护成本高

### D2: Provider 类型选择

**选择**: `NotifierProvider`（通过 `@riverpod` 注解生成）

**理由**:
- Riverpod 3.x 推荐的新 API
- 支持异步初始化
- 与代码生成完美配合

### D3: 当前宝宝持久化方案

**选择**: SharedPreferences 存储 `currentBabyId`

**理由**:
- 简单可靠，无需额外依赖
- 应用启动时快速恢复
- 配合 `SettingsService` 抽象，便于测试

**备选方案**: 数据库存储
- 放弃原因：增加查询开销，SharedPreferences 更适合单一偏好设置

### D4: 数据库生命周期管理

**选择**: Provider scope 内单例，`ref.onDispose` 关闭

**理由**:
- 与应用生命周期绑定
- 自动资源清理
- 便于测试时替换实例

### D5: 不引入 Repository 层

**选择**: Provider 直接调用 Database

**理由**:
- 项目规模适中，不需要额外抽象
- Drift 已提供良好的查询 API
- 保持代码简洁，减少样板层

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 代码生成增加构建时间 | 仅在修改 Provider 时需要重新生成，影响有限 |
| 当前宝宝被删除后状态不一致 | Provider 初始化时检查 babyId 是否存在，不存在则清除 |
| SharedPreferences 异步读取延迟启动 | 使用 `AsyncNotifierProvider` 处理异步初始化 |
| Provider 依赖关系复杂 | 使用依赖图可视化工具，文档记录依赖关系 |

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Provider 依赖关系                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                    ┌─────────────────┐                          │
│                    │ databaseProvider │                         │
│                    │  (AppDatabase)   │                         │
│                    └────────┬────────┘                          │
│                             │                                   │
│         ┌───────────────────┼───────────────────┐              │
│         │                   │                   │              │
│         ▼                   ▼                   ▼              │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │ currentBaby │    │ babiesList  │    │ familyProvider│       │
│  │  Provider   │    │  Provider   │    │              │        │
│  └──────┬──────┘    └─────────────┘    └─────────────┘        │
│         │                                                      │
│         ├──────────────────┬──────────────────┐               │
│         ▼                  ▼                  ▼               │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │ timeline    │    │   stats     │    │   vaccine   │        │
│  │ Provider    │    │  Provider   │    │  Provider   │        │
│  └─────────────┘    └─────────────┘    └─────────────┘        │
│                                                                 │
│  ┌─────────────┐                                               │
│  │   sync      │  ← 监听所有表的 syncStatus                    │
│  │  Provider   │                                               │
│  └─────────────┘                                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## File Structure

```
lib/
  providers/
    providers.dart              # Barrel export
    database_provider.dart      # 数据库单例
    settings_provider.dart      # SharedPreferences 设置
    current_baby_provider.dart  # 当前宝宝状态
    babies_provider.dart        # 宝宝列表
    family_provider.dart        # 家庭组状态
    timeline_provider.dart      # 时间线数据
    stats_provider.dart         # 统计数据
    sync_provider.dart          # 同步状态
  services/
    device_service.dart         # 设备标识（已有）
```