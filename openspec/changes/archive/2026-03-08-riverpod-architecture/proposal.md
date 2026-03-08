## Why

当前项目已完成数据库层搭建（Drift ORM），但应用架构缺少状态管理层。UI 直接操作数据库，导致：
- 状态管理分散在各 Widget 中
- 缺少统一的响应式数据流
- 无法支持多宝宝切换、实时计时器等核心功能

现在需要搭建 Riverpod 状态管理架构，为后续首页 Dashboard、时间线、统计等功能提供数据支撑。

## What Changes

- 添加 `riverpod_annotation` 和 `riverpod_generator` 依赖，启用代码生成
- 创建 `ProviderScope` 包裹应用根节点
- 实现数据库 Provider（单例管理）
- 实现当前宝宝状态 Provider（支持切换和持久化）
- 实现时间线数据 Provider（按日期查询活动记录）
- 实现统计数据 Provider（E.A.S.Y 各类统计）
- 实现同步状态 Provider（为云同步预留框架）

## Capabilities

### New Capabilities

- `riverpod-config`: Riverpod 代码生成配置和基础架构
- `database-provider`: 数据库单例 Provider
- `current-baby-provider`: 当前宝宝状态管理（选择、切换、持久化）
- `timeline-provider`: 时间线数据查询（按宝宝、按日期）
- `stats-provider`: 统计数据聚合（日/周/月维度）
- `sync-provider`: 同步状态管理（待上传数量、同步状态）

### Modified Capabilities

无（新增功能，不修改现有规格）