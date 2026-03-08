# riverpod-config Specification

## Purpose
TBD - created by archiving change riverpod-architecture. Update Purpose after archive.
## Requirements
### Requirement: Riverpod 代码生成配置

系统 SHALL 配置 `riverpod_annotation` 和 `riverpod_generator` 依赖以支持代码生成。

#### Scenario: 依赖配置正确
- **WHEN** 运行 `flutter pub get`
- **THEN** riverpod_annotation 和 riverpod_generator 依赖成功安装

#### Scenario: 代码生成工作正常
- **WHEN** 运行 `dart run build_runner build`
- **THEN** 生成的 `.g.dart` 文件正确创建

### Requirement: ProviderScope 包裹应用

应用根节点 SHALL 使用 `ProviderScope` 包裹，使所有 Widget 可访问 Provider。

#### Scenario: ProviderScope 正确初始化
- **WHEN** 应用启动
- **THEN** ProviderScope 成功包裹 MaterialApp

#### Scenario: Provider 可被访问
- **WHEN** Widget 使用 `ref.watch()` 或 `ref.read()`
- **THEN** Provider 值正确返回

### Requirement: Providers barrel export

所有 Provider SHALL 通过 `lib/providers/providers.dart` 统一导出。

#### Scenario: 统一导出所有 Provider
- **WHEN** 导入 `package:baby_plan_v3/providers/providers.dart`
- **THEN** 所有 Provider 可直接使用

