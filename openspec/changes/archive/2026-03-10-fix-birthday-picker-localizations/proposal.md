## Why

在添加宝宝弹窗中，点击出生年月日字段时会报错 `No Material Localizations found.`。这是因为 `MaterialApp` 没有配置 `localizationsDelegates`，导致 `showDatePicker` 无法获取到 `MaterialLocalizations`，当使用中文 locale 时就会抛出此错误。

## What Changes

- 在 `MaterialApp` 中添加 `localizationsDelegates` 配置，支持 `flutter_localizations` 和中文语言包
- 添加 `supportedLocales` 配置，明确支持的语言列表
- 添加 `flutter_localizations` 依赖包到 `pubspec.yaml`

## Capabilities

### New Capabilities

- `app-localization`: 应用国际化基础配置，为应用提供中文本地化支持，确保 `showDatePicker` 等系统组件能正常显示中文界面

### Modified Capabilities

- 无（这是一个新增能力，不修改现有 spec 的需求）

## Impact

- **修改文件**：
  - `lib/main.dart` - 添加 `localizationsDelegates` 和 `supportedLocales` 配置
  - `pubspec.yaml` - 添加 `flutter_localizations` 依赖

- **影响范围**：
  - 所有使用 `showDatePicker`、`showTimePicker` 等 Material 组件的地方
  - 应用整体的语言本地化能力