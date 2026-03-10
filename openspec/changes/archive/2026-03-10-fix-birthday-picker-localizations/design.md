## Context

当前应用使用 `MaterialApp` 作为根组件，但没有配置 `localizationsDelegates`。当 `showDatePicker` 使用 `locale: const Locale('zh', 'CN')` 时，Flutter 无法找到对应的 `MaterialLocalizations` 实现，导致抛出 `No Material Localizations found.` 错误。

Flutter 的本地化系统需要两部分的配合：
1. `flutter_localizations` 包提供 Material 和 Cupertino 组件的本地化代理
2. `MaterialApp` 的 `localizationsDelegates` 参数将这些代理注入到 Widget 树中

## Goals / Non-Goals

**Goals:**
- 修复 `showDatePicker` 在中文 locale 下的崩溃问题
- 为应用添加基础的国际化支持框架
- 确保日期选择器显示中文界面

**Non-Goals:**
- 不实现完整的多语言切换功能（暂只支持中文）
- 不添加用户语言偏好设置
- 不修改其他需要本地化的组件

## Decisions

### 1. 使用 `flutter_localizations` 官方包

**选择**: 使用 Flutter 官方提供的 `flutter_localizations` 包

**理由**:
- 官方维护，与 Flutter SDK 版本同步
- 提供 `GlobalMaterialLocalizations` 和 `GlobalWidgetsLocalizations`
- 无需额外配置即可支持中文

**替代方案**:
- 自定义 `LocalizationsDelegate` - 工作量大，维护成本高
- 使用第三方国际化库 - 引入不必要的依赖

### 2. 配置方式

**选择**: 在 `MaterialApp` 中直接配置 `localizationsDelegates` 和 `supportedLocales`

```dart
MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ],
  // ...
)
```

**理由**:
- 简单直接，无需额外的配置类
- 明确声明支持的语言列表
- 便于后续扩展其他语言

### 3. 默认语言

**选择**: 不设置 `locale` 参数，让系统跟随设备语言

**理由**:
- 用户体验更好，自动适配设备语言
- 如果设备语言不在支持列表中，会回退到 `supportedLocales` 的第一个

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 应用内其他文本未国际化 | 暂时接受，后续可逐步完善 |
| `flutter_localizations` 版本需与 Flutter SDK 匹配 | 使用 `flutter_localizations: any` 或明确版本约束 |
| 增加应用包体积 | 影响极小（约 100KB），可接受 |