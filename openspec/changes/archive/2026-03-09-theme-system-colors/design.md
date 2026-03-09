## Context

当前项目使用 Flutter 默认主题配置（`Colors.deepPurple`），缺乏统一的颜色系统和设计规范。根据产品原型设计文档，需要建立符合育儿应用调性的视觉系统：

- **主色调**: Teal（青色），代表清新、自然、平静
- **E.A.S.Y 颜色**: E-绿（成长/能量）、A-黄（活力/阳光）、S-蓝（沉静/修复）、P-橙（排泄记录）
- **设计调性**: 小清新、低饱和度、高对比度、大圆角

技术约束：
- 使用 Material 3（`useMaterial3: true`）
- 支持 Flutter Web、Android、iOS 三端
- 使用 Riverpod 进行状态管理
- 使用 SharedPreferences 持久化设置

## Goals / Non-Goals

**Goals:**
- 建立统一的颜色常量系统
- 创建 Material 3 兼容的 ThemeData 配置
- 实现深色模式支持（跟随系统 + 手动切换）
- 定义文本样式和圆角规范
- 预留主题风格切换扩展点

**Non-Goals:**
- 不实现主题风格切换 UI（多巴胺/莫兰迪风格属于后续任务）
- 不实现动态主题色选择器
- 不修改现有页面 UI（仅建立基础主题系统）

## Decisions

### 决策 1：文件组织结构

**选择**: `lib/theme/` 扁平结构

```
lib/theme/
├── app_colors.dart      # 颜色常量
├── app_text_styles.dart # 文本样式
├── app_spacing.dart     # 间距与圆角
└── app_theme.dart       # ThemeData 工厂
```

**理由**:
- 项目规模适中，无需过度设计
- 扁平结构易于查找和维护
- 符合 Flutter 社区常见实践

**备选方案**:
- `lib/core/theme/` 分层结构 - 对于当前规模过于复杂
- `lib/styles/` 命名 - 与 theme 概念重叠

### 决策 2：颜色定义方式

**选择**: 静态常量 + Material 3 Seed Color

```dart
// 语义颜色使用静态常量
class AppColors {
  static const Color eat = Color(0xFF4CAF50);
  static const Color activity = Color(0xFFFFC107);
  // ...
}

// 主题色使用 Seed Color
ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF009688)),
);
```

**理由**:
- E.A.S.Y 颜色是业务语义颜色，需要固定值保证一致性
- 主题色使用 Seed Color 可以自动生成协调的调色板
- 深色模式可通过调整 Seed 亮度或手动覆盖实现

### 决策 3：深色模式策略

**选择**: 语义颜色不变，只调整基础颜色

```dart
// 深色模式下 E/A/S/P 颜色保持不变
// 只调整 background、surface、onSurface 等 Material 颜色
```

**理由**:
- E.A.S.Y 颜色是应用的核心识别色，应保持一致
- 深色模式的主要目的是降低背景亮度，保护视力
- 避免颜色变化导致用户困惑

### 决策 4：主题状态管理

**选择**: 扩展现有 Settings + 新建 ThemeProvider

```dart
class Settings {
  final int? currentBabyId;
  final DateTime? lastSyncTime;
  final ThemeMode themeMode;  // 新增
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>;
```

**理由**:
- 复用现有的 SharedPreferences 持久化机制
- ThemeMode 是 Flutter 内置类型，与 MaterialApp 直接兼容
- 保持 Settings 和 Theme 分离，职责清晰

### 决策 5：主题风格扩展点

**选择**: 枚举 + 工厂模式预留

```dart
enum AppThemeStyle {
  dopamine,    // 多巴胺（未来）
  morandi,     // 莫兰迪（未来）
}

class AppTheme {
  static ThemeData create({
    required Brightness brightness,
    AppThemeStyle style = AppThemeStyle.dopamine,
  });
}
```

**理由**:
- 为后续主题风格切换预留接口
- 不影响当前实现，但架构上可扩展
- 避免未来重构

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 颜色值与原型设计存在偏差 | 在实现阶段使用 Figma 取色器精确获取颜色值 |
| 深色模式下对比度不足 | 使用 WCAG AA 标准验证，必要时微调亮度 |
| SharedPreferences 异步初始化影响启动速度 | 使用 `FutureProvider` 确保异步加载，默认跟随系统 |