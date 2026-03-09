## ADDED Requirements

### Requirement: ThemeData 工厂类

系统 SHALL 提供 AppTheme 工厂类，创建符合 Material 3 规范的 ThemeData。

**工厂方法：**
```dart
class AppTheme {
  static ThemeData light();
  static ThemeData dark();
}
```

**配置要求：**
- `useMaterial3: true`
- 使用 ColorScheme.fromSeed 生成调色板
- 配置 AppBarTheme、CardTheme、ElevatedButtonTheme 等组件主题

#### Scenario: 浅色主题创建
- **WHEN** 调用 `AppTheme.light()`
- **THEN** 系统 SHALL 返回配置完整的浅色 ThemeData，使用 Teal 作为 seed color

#### Scenario: 深色主题创建
- **WHEN** 调用 `AppTheme.dark()`
- **THEN** 系统 SHALL 返回配置完整的深色 ThemeData，保持相同的 seed color

---

### Requirement: 组件主题配置

系统 SHALL 配置常用组件的主题样式。

**必须配置的组件主题：**
- AppBarTheme: 居中标题、去除阴影、圆角
- CardTheme: 圆角 24px、微阴影
- ElevatedButtonTheme: 圆角 16px、主色背景
- TextButtonTheme: 圆角 16px
- FloatingActionButtonTheme: 圆角 16px
- BottomNavigationBarTheme: 选中态主色、未选中态灰色

#### Scenario: 卡片样式一致性
- **WHEN** 使用 Card 组件
- **THEN** 所有卡片 SHALL 具有统一的圆角（24px）和阴影样式

#### Scenario: 按钮样式一致性
- **WHEN** 使用 ElevatedButton 或 TextButton
- **THEN** 所有按钮 SHALL 具有统一的圆角（16px）和点击反馈

---

### Requirement: 主题风格扩展点

系统 SHALL 预留主题风格切换的扩展接口。

**扩展设计：**
```dart
enum AppThemeStyle {
  dopamine,  // 多巴胺风格（当前默认）
  morandi,   // 莫兰迪风格（未来）
}

class AppTheme {
  static ThemeData create({
    required Brightness brightness,
    AppThemeStyle style = AppThemeStyle.dopamine,
  });
}
```

#### Scenario: 风格扩展接口
- **WHEN** 未来添加新的主题风格
- **THEN** 系统 SHALL 支持通过 `AppThemeStyle` 枚举扩展，无需重构现有架构

#### Scenario: 默认风格
- **WHEN** 未指定风格参数
- **THEN** 系统 SHALL 默认使用 `AppThemeStyle.dopamine`（多巴胺风格）