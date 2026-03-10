## ADDED Requirements

### Requirement: MaterialApp 支持中文本地化

应用 SHALL 在 `MaterialApp` 中配置 `localizationsDelegates`，以支持中文本地化。

#### Scenario: MaterialApp 包含本地化代理配置

- **WHEN** 应用启动时
- **THEN** `MaterialApp` 的 `localizationsDelegates` SHALL 包含 `GlobalMaterialLocalizations.delegate`、`GlobalWidgetsLocalizations.delegate` 和 `GlobalCupertinoLocalizations.delegate`

#### Scenario: MaterialApp 声明支持的语言

- **WHEN** 应用启动时
- **THEN** `MaterialApp` 的 `supportedLocales` SHALL 至少包含中文（`Locale('zh', 'CN')`）

### Requirement: 日期选择器支持中文界面

系统 SHALL 确保 `showDatePicker` 在使用中文 locale 时正常工作，并显示中文界面。

#### Scenario: 日期选择器显示中文界面

- **WHEN** 用户在添加宝宝弹窗中点击出生日期字段
- **THEN** 日期选择器 SHALL 正常弹出
- **AND** 日期选择器界面 SHALL 显示中文文本（如"取消"、"确定"、月份名称等）

#### Scenario: 日期选择器不抛出本地化错误

- **WHEN** `showDatePicker` 使用 `locale: const Locale('zh', 'CN')` 参数时
- **THEN** 系统 SHALL NOT 抛出 `No Material Localizations found` 错误

### Requirement: 依赖管理

应用 SHALL 添加 `flutter_localizations` 依赖以支持本地化功能。

#### Scenario: pubspec.yaml 包含 flutter_localizations 依赖

- **WHEN** 查看 `pubspec.yaml` 文件时
- **THEN** `dependencies` 部分 SHALL 包含 `flutter_localizations` 依赖
- **AND** 版本约束 SHALL 与 Flutter SDK 版本兼容（使用 `sdk: flutter` 约束）