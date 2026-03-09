## ADDED Requirements

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