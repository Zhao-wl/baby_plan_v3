## 1. 颜色系统基础

- [x] 1.1 创建 `lib/theme/app_colors.dart` 文件
- [x] 1.2 定义 E.A.S.Y 活动颜色常量（eat/activity/sleep/poop 及 Light 变体）
- [x] 1.3 定义主色调常量（primary/primaryLight/primaryDark）
- [x] 1.4 定义中性色常量（background/surface/onBackground/onSurface/outline）

## 2. 间距与圆角规范

- [x] 2.1 创建 `lib/theme/app_spacing.dart` 文件
- [x] 2.2 定义圆角常量（radiusXs ~ radiusXxl, radiusFull）
- [x] 2.3 定义间距常量（paddingXs ~ paddingXxl）
- [x] 2.4 定义图标尺寸常量（iconSm ~ iconXxl）

## 3. 文本样式配置

- [x] 3.1 创建 `lib/theme/app_text_styles.dart` 文件
- [x] 3.2 定义文本样式层级（h1/h2/h3/body/caption/label）
- [x] 3.3 定义字体大小常量（fontSizeXs ~ fontSizeXxl）
- [x] 3.4 配置行高规范

## 4. ThemeData 配置

- [x] 4.1 创建 `lib/theme/app_theme.dart` 文件
- [x] 4.2 实现 `AppThemeStyle` 枚举（dopamine/morandi 预留）
- [x] 4.3 实现 `AppTheme.light()` 浅色主题工厂方法
- [x] 4.4 实现 `AppTheme.dark()` 深色主题工厂方法
- [x] 4.5 配置 AppBarTheme（居中标题、无阴影）
- [x] 4.6 配置 CardTheme（圆角 24px、微阴影）
- [x] 4.7 配置 ElevatedButtonTheme 和 TextButtonTheme（圆角 16px）
- [x] 4.8 配置 BottomNavigationBarTheme

## 5. 主题状态管理

- [x] 5.1 扩展 Settings 类，添加 themeMode 字段
- [x] 5.2 修改 settings_provider.dart，支持 themeMode 持久化
- [x] 5.3 创建 `lib/providers/theme_provider.dart`
- [x] 5.4 实现 ThemeNotifier（读取/设置/持久化主题模式）

## 6. 应用集成

- [x] 6.1 修改 `lib/main.dart`，配置 MaterialApp 主题
- [x] 6.2 集成 themeProvider 到 MaterialApp.themeMode
- [x] 6.3 添加 Provider 导出到 providers.dart

## 7. 验证与测试

- [x] 7.1 运行 `flutter analyze` 确保无错误
- [x] 7.2 运行 `flutter run -d chrome` 验证主题生效
- [x] 7.3 验证深色模式切换功能
- [x] 7.4 验证主题偏好持久化（重启后保持）