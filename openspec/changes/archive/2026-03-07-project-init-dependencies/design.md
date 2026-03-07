## Context

E.A.S.Y. 育儿助手是一个跨平台 Flutter 应用，需要支持 Android、iOS 和 Web 三端。当前项目仅为 `flutter create` 生成的 starter 模板，缺少核心依赖和开发配置。本设计文档定义项目初始化的技术决策和实施策略。

**当前状态：**
- Flutter SDK 版本：3.x
- 仅有 flutter_lints 基础配置
- 无状态管理、数据库、图表等核心依赖

**约束：**
- 需要支持国内网络环境
- 开发团队熟悉 Riverpod 生态
- 项目需要代码生成支持（Drift、Riverpod、Freezed）

## Goals / Non-Goals

**Goals:**
- 配置支持 Android/iOS/Web 三端的 Flutter 项目
- 添加并验证核心依赖的兼容性
- 建立代码生成工作流
- 配置静态分析规则

**Non-Goals:**
- 不涉及具体业务功能实现
- 不涉及云服务配置
- 不涉及 CI/CD 流程配置

## Decisions

### 1. 状态管理选择 Riverpod + 代码生成

**决策：** 使用 `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`

**理由：**
- 编译时类型安全，避免字符串注入错误
- 代码生成减少模板代码
- 支持依赖注入和测试
- 与 Drift 数据库集成良好

**备选方案：**
- Provider：无代码生成，模板代码多
- Bloc：学习曲线较陡，模板代码多
- GetX：过于庞大，不符合项目规模

### 2. 本地数据库选择 Drift (SQLite ORM)

**决策：** 使用 `drift` + `drift_flutter` + `drift_dev`

**理由：**
- 高性能 SQLite ORM，支持复杂查询和迁移
- 跨平台支持（Android/iOS/Web/Desktop）
- 代码生成支持，类型安全
- 支持离线优先架构
- 成熟的社区和文档

**变更说明：** 原计划使用 Isar 数据库，但在实施过程中发现 Isar 与项目其他依赖库存在版本冲突，经评估后改用 Drift (SQLite ORM)。Drift 同样满足项目需求。

**备选方案：**
- Isar：与项目其他依赖存在版本冲突
- SQLite (sqflite)：Web 支持有限
- Hive：性能较好但功能较少，无索引支持
- ObjectBox：Web 支持有限

### 3. 图表库选择 fl_chart

**决策：** 使用 `fl_chart`

**理由：**
- 纯 Dart 实现，跨平台一致
- 支持堆叠柱状图、折线图、饼图（项目需要）
- 活跃维护，社区支持好
- 自定义能力强

**备选方案：**
- charts_flutter：Google 已停止维护
- syncfusion_flutter_charts：商业许可限制

### 4. 代码生成工具链

**决策：** 使用 `build_runner` + `freezed`

**理由：**
- build_runner 是 Dart 官方代码生成框架
- freezed 提供不可变数据类支持，配合 Riverpod 使用
- 统一的代码生成命令：`dart run build_runner build`

### 5. 分析配置

**决策：** 扩展 `flutter_lints` 规则集

**理由：**
- 保持与 Flutter 社区最佳实践一致
- 添加项目特定规则（如 avoid_print、prefer_const_constructors）

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| Drift Web 兼容性问题 | 使用 sql.js 作为 Web 后端，已验证可行 |
| 代码生成时间长 | 使用 `build_runner watch` 增量生成，避免全量重建 |
| 依赖版本冲突 | 使用 `flutter pub upgrade --major-versions` 解决 |
| freezed 学习成本 | 提供代码模板，团队快速上手 |

## Migration Plan

无需迁移，全新项目初始化。

## Open Questions

- [ ] 是否需要配置多环境（dev/staging/prod）的 dart_define？
- [ ] 是否需要添加常用开发工具依赖（如 logger、dio）？