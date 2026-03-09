## ADDED Requirements

### Requirement: 深色模式状态管理

系统 SHALL 使用 Riverpod 管理主题模式状态。

**状态定义：**
```dart
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>;
```

**支持的模式：**
- ThemeMode.system: 跟随系统
- ThemeMode.light: 强制浅色
- ThemeMode.dark: 强制深色

#### Scenario: 获取当前主题模式
- **WHEN** 调用 `ref.read(themeProvider)`
- **THEN** 系统 SHALL 返回当前的 ThemeMode 值

#### Scenario: 切换主题模式
- **WHEN** 调用 `ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark)`
- **THEN** 系统 SHALL 更新主题模式状态，并触发 UI 重建

---

### Requirement: 主题模式持久化

系统 SHALL 使用 SharedPreferences 持久化用户的主题偏好。

**存储 Key:** `themeMode`

**存储值:** `system` | `light` | `dark`

#### Scenario: 启动时恢复主题
- **WHEN** 应用启动
- **THEN** 系统 SHALL 从 SharedPreferences 读取上次保存的主题模式，默认为 `system`

#### Scenario: 切换后自动保存
- **WHEN** 用户切换主题模式
- **THEN** 系统 SHALL 自动将新主题模式保存到 SharedPreferences

---

### Requirement: Settings 类扩展

系统 SHALL 扩展 Settings 类，支持主题模式配置。

**扩展字段：**
```dart
class Settings {
  final int? currentBabyId;
  final DateTime? lastSyncTime;
  final ThemeMode themeMode;  // 新增
}
```

#### Scenario: Settings 包含主题模式
- **WHEN** 读取 Settings
- **THEN** 系统 SHALL 包含 themeMode 字段，默认值为 ThemeMode.system

---

### Requirement: MaterialApp 主题集成

系统 SHALL 在 MaterialApp 中集成动态主题切换。

**集成方式：**
```dart
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ref.watch(themeProvider),
);
```

#### Scenario: 动态主题切换
- **WHEN** themeProvider 状态变化
- **THEN** MaterialApp SHALL 自动切换到对应的主题，无需重启应用