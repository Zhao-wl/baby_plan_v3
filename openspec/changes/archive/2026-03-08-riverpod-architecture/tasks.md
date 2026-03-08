## 1. Riverpod 代码生成配置

- [x] 1.1 添加 `flutter_riverpod` 依赖到 pubspec.yaml（跳过 riverpod_annotation/riverpod_generator 由于与 drift_dev 的 analyzer 版本冲突）
- [x] 1.2 ~~添加 `riverpod_generator` 开发依赖到 pubspec.yaml~~ (跳过，使用手写 Provider)
- [x] 1.3 创建 `lib/providers/` 目录结构
- [x] 1.4 创建 `lib/providers/providers.dart` barrel export 文件
- [x] 1.5 运行 `flutter pub get` 安装依赖
- [x] 1.6 更新 `main.dart`，用 `ProviderScope` 包裹应用

## 2. 数据库 Provider

- [x] 2.1 创建 `lib/providers/database_provider.dart`
- [x] 2.2 实现 `databaseProvider` 返回 AppDatabase 单例
- [x] 2.3 实现 `ref.onDispose` 关闭数据库连接
- [x] 2.4 ~~运行 `dart run build_runner build --delete-conflicting-outputs` 生成代码~~ (跳过，使用手写 Provider)

## 3. 设置服务 Provider

- [x] 3.1 创建 `lib/providers/settings_provider.dart`
- [x] 3.2 实现 `settingsProvider` 管理 SharedPreferences
- [x] 3.3 实现异步初始化（AsyncNotifierProvider）
- [x] 3.4 提供 `getCurrentBabyId()` 和 `setCurrentBabyId()` 方法

## 4. 当前宝宝 Provider

- [x] 4.1 创建 `lib/providers/babies_provider.dart`
- [x] 4.2 实现 `babiesProvider` 返回宝宝列表
- [x] 4.3 创建 `lib/providers/current_baby_provider.dart`
- [x] 4.4 实现 `currentBabyProvider` 返回当前选中的宝宝
- [x] 4.5 实现初始化时从 SharedPreferences 恢复宝宝选择
- [x] 4.6 实现 `selectBaby()` 方法切换当前宝宝
- [x] 4.7 实现宝宝被删除后的自动切换逻辑

## 5. 家庭组 Provider

- [x] 5.1 创建 `lib/providers/family_provider.dart`
- [x] 5.2 实现 `familyProvider` 返回当前家庭信息
- [x] 5.3 实现 `familyMembersProvider` 返回家庭成员列表

## 6. 时间线 Provider

- [x] 6.1 创建 `lib/providers/timeline_provider.dart`
- [x] 6.2 实现 `timelineProvider(babyId, date)` 参数化 Provider
- [x] 6.3 实现按日期查询活动记录
- [x] 6.4 实现记录按 startTime 排序
- [x] 6.5 使用 AsyncValue 处理异步状态

## 7. 统计 Provider

- [x] 7.1 创建 `lib/providers/stats_provider.dart`
- [x] 7.2 定义统计数据模型（StatsData）
- [x] 7.3 实现 `statsProvider(babyId, period)` 参数化 Provider
- [x] 7.4 实现日/周/月统计周期支持
- [x] 7.5 实现睡眠统计（夜间/白天分布）
- [x] 7.6 实现喂养统计（次数、总量）
- [x] 7.7 实现排泄统计（次数）

## 8. 同步状态 Provider

- [x] 8.1 创建 `lib/providers/sync_provider.dart`
- [x] 8.2 定义 SyncState 数据模型
- [x] 8.3 实现 `syncProvider` 管理同步状态
- [x] 8.4 实现待上传记录数查询
- [x] 8.5 实现 `syncNow()` 预留方法
- [x] 8.6 实现 lastSyncTime 持久化

## 9. 验证与测试

- [x] 9.1 ~~运行 `dart run build_runner build --delete-conflicting-outputs` 生成所有代码~~ (跳过，使用手写 Provider)
- [x] 9.2 运行 `flutter analyze` 检查代码错误
- [x] 9.3 运行 `flutter build web` 验证 Provider 初始化正常
- [x] 9.4 更新 CLAUDE.md 添加 Provider 架构说明