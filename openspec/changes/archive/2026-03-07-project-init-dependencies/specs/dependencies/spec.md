## ADDED Requirements

### Requirement: Riverpod 状态管理依赖

项目 SHALL 添加 Riverpod 状态管理相关依赖。

**依赖列表：**
- `flutter_riverpod`：核心状态管理包
- `riverpod_annotation`：注解支持
- `riverpod_generator`：代码生成器

**开发依赖：**
- `build_runner`：代码生成运行器

#### Scenario: Riverpod Provider 创建
- **WHEN** 定义使用 @riverpod 注解的 Provider
- **THEN** 运行 `dart run build_runner build` SHALL 生成对应的 Provider 代码

#### Scenario: Provider 在 Widget 中使用
- **WHEN** Widget 使用 `ref.watch()` 读取 Provider
- **THEN** 应用 SHALL 编译通过且运行时无错误

---

### Requirement: Drift 数据库依赖

项目 SHALL 添加 Drift (SQLite ORM) 数据库相关依赖。

**依赖列表：**
- `drift`：核心 SQLite ORM 包
- `drift_flutter`：平台原生支持库

**开发依赖：**
- `drift_dev`：代码生成器

**选型说明:**
原计划使用 Isar 数据库，但由于 Isar 与项目其他依赖库存在版本冲突，经评估后改用 Drift (SQLite ORM)。Drift 同样提供：
- 跨平台支持（Android/iOS/Web/Desktop）
- 类型安全的代码生成
- 良好的迁移支持

#### Scenario: Drift Model 创建
- **WHEN** 定义使用 Drift 注解的数据库表
- **THEN** 运行 `dart run build_runner build` SHALL 生成对应的数据库访问代码

#### Scenario: Drift 数据库初始化
- **WHEN** 应用启动时初始化数据库连接
- **THEN** 数据库 SHALL 成功初始化且无错误

---

### Requirement: fl_chart 图表依赖

项目 SHALL 添加 fl_chart 图表库依赖。

**依赖列表：**
- `fl_chart`：图表绘制库

#### Scenario: 基础图表渲染
- **WHEN** 使用 BarChart、LineChart 或 PieChart 组件
- **THEN** 图表 SHALL 正常渲染且无布局错误

---

### Requirement: freezed 数据类依赖

项目 SHALL 添加 freezed 不可变数据类依赖。

**依赖列表：**
- `freezed_annotation`：注解支持
- `freezed`：代码生成器（dev dependency）

#### Scenario: Freezed 数据类创建
- **WHEN** 定义使用 @freezed 注解的数据类
- **THEN** 运行 `dart run build_runner build` SHALL 生成 copyWith、==、hashCode 等方法

---

### Requirement: 依赖版本约束

所有依赖 SHALL 使用版本约束，而非固定版本。

**格式要求：**
- 使用 `^x.y.z` 格式指定兼容版本
- 避免使用 `any` 或无版本约束

#### Scenario: 依赖解析
- **WHEN** 运行 `flutter pub get`
- **THEN** 所有依赖 SHALL 成功解析，无版本冲突

#### Scenario: 依赖升级
- **WHEN** 运行 `flutter pub upgrade`
- **THEN** 依赖 SHALL 升级到兼容的最新版本