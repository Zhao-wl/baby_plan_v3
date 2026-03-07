## Why

E.A.S.Y. 育儿助手项目需要一个坚实的技术基础，才能支撑后续的功能开发。当前项目仅为 Flutter starter 模板，缺少核心依赖、代码生成配置和开发规范。项目初始化与依赖配置是整个开发流程的第一步，直接影响后续开发效率和代码质量。

## What Changes

- 配置 Flutter 项目最低 SDK 版本（Android API 21+、iOS 12.0+、Web）
- 添加核心状态管理依赖：Riverpod + riverpod_generator（代码生成式 Provider）
- 添加本地数据库依赖：Isar + isar_flutter_libs + isar_generator
- 添加图表依赖：fl_chart（用于统计页面）
- 添加工具依赖：build_runner（代码生成）、freezed（不可变数据类）
- 配置 analysis_options.yaml（启用 flutter_lints 规则集）
- 配置 dart_define 环境变量支持

## Capabilities

### New Capabilities
- `project-config`: 项目基础配置（SDK 版本、分析选项、环境变量）
- `dependencies`: 核心依赖管理（Riverpod、Isar、fl_chart、build_runner）

### Modified Capabilities
无

## Impact

- 受影响文件：`pubspec.yaml`、`analysis_options.yaml`、`lib/main.dart`
- 新增依赖：
  - `flutter_riverpod` / `riverpod_annotation` / `riverpod_generator`
  - `isar` / `isar_flutter_libs` / `isar_generator`
  - `fl_chart`
  - `build_runner` / `freezed` / `freezed_annotation`
- 平影响平台：Android、iOS、Web 三端
- 后续影响：所有后续功能开发都将基于此配置