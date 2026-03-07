## ADDED Requirements

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