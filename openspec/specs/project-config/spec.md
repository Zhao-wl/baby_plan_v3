# Project Configuration Spec

## Purpose

定义项目的 SDK 版本配置和代码分析规则，确保跨平台兼容性和代码质量。

## Requirements

### Requirement: Flutter SDK 版本配置

项目 SHALL 配置最低 Flutter SDK 版本，确保三端兼容性。

**Android:**
- 最低 API 级别：API 21 (Android 5.0)
- 目标 API 级别：API 34 (Android 14)
- 编译 SDK 版本：API 34

**iOS:**
- 最低部署版本：iOS 12.0
- 目标 iOS 版本：iOS 17

**Web:**
- 支持 Chrome、Safari、Firefox 最新两个主版本

#### Scenario: Android SDK 版本验证
- **WHEN** 构建 Android APK
- **THEN** 应用 SHALL 在 API 21+ 设备上正常运行

#### Scenario: iOS 部署版本验证
- **WHEN** 构建 iOS IPA
- **THEN** 应用 SHALL 在 iOS 12.0+ 设备上正常运行

#### Scenario: Web 浏览器兼容性
- **WHEN** 在 Web 浏览器中运行应用
- **THEN** 应用 SHALL 在 Chrome、Safari、Firefox 最新两版本中正常渲染

---

### Requirement: 分析选项配置

项目 SHALL 配置 `analysis_options.yaml`，启用代码静态分析规则。

**必须包含的规则：**
- `avoid_print`：警告
- `prefer_const_constructors`：警告
- `prefer_const_declarations`：警告
- `avoid_relative_lib_imports`：错误
- `always_declare_return_types`：警告

#### Scenario: 静态分析执行
- **WHEN** 运行 `flutter analyze`
- **THEN** 所有源文件 SHALL 通过静态分析，无错误

#### Scenario: 代码风格检查
- **WHEN** 提交代码
- **THEN** 代码 SHALL 符合 analysis_options.yaml 定义的规则

---

### Requirement: Settings 类扩展主题模式

系统 SHALL 在 Settings 类中添加主题模式字段。

**扩展字段：**
```dart
class Settings {
  final int? currentBabyId;
  final DateTime? lastSyncTime;
  final ThemeMode themeMode;  // 新增
}
```

**默认值：** `ThemeMode.system`（跟随系统）

#### Scenario: Settings 初始化
- **WHEN** 首次加载 Settings
- **THEN** themeMode SHALL 默认为 ThemeMode.system

#### Scenario: Settings 持久化
- **WHEN** 修改 themeMode
- **THEN** 系统 SHALL 将其持久化到 SharedPreferences

---

### Requirement: SharedPreferences 存储扩展

系统 SHALL 在 SharedPreferences 中支持主题模式存储。

**存储 Key:** `themeMode`

**存储值映射：**
- `system` → ThemeMode.system
- `light` → ThemeMode.light
- `dark` → ThemeMode.dark

#### Scenario: 读取主题模式
- **WHEN** 从 SharedPreferences 读取 themeMode
- **THEN** 系统 SHALL 正确解析字符串为 ThemeMode 枚举值

#### Scenario: 写入主题模式
- **WHEN** 保存 ThemeMode 到 SharedPreferences
- **THEN** 系统 SHALL 将枚举值转换为对应的字符串存储