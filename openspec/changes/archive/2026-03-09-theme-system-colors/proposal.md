## Why

项目目前使用 Flutter 默认的 `Colors.deepPurple` 作为主题色，缺乏统一的颜色系统和设计规范。作为育儿应用，需要建立符合产品调性的视觉系统：小清新、低饱和度、高对比度，同时为 E.A.S.Y 活动类型建立专属颜色语义。深色模式是夜间喂奶/哄睡场景的刚需功能。

## What Changes

- 定义 AppTheme 颜色常量（主色 Teal、E/A/S/P 活动颜色）
- 创建 Material 3 ThemeData 配置（浅色/深色两套主题）
- 实现深色模式支持（跟随系统 + 手动切换）
- 配置文本样式和圆角规范
- 预留主题风格切换扩展点（后续实现多巴胺/莫兰迪风格）

## Capabilities

### New Capabilities

- `theme-colors`: E.A.S.Y 活动颜色系统（E-绿/A-黄/S-蓝/P-橙）+ 主色调定义
- `theme-config`: Material 3 ThemeData 配置（浅色/深色主题工厂）
- `dark-mode-support`: 深色模式状态管理与持久化
- `text-styles`: 文本样式规范（标题/正文/辅助文字层级）
- `spacing-radius`: 间距与圆角规范（卡片 24px、按钮 16px 等）

### Modified Capabilities

- `project-config`: 扩展 Settings 类，添加主题模式字段

## Impact

**新增文件：**
- `lib/theme/app_colors.dart` - 颜色常量定义
- `lib/theme/app_text_styles.dart` - 文本样式定义
- `lib/theme/app_spacing.dart` - 间距与圆角规范
- `lib/theme/app_theme.dart` - ThemeData 工厂类
- `lib/providers/theme_provider.dart` - 主题状态管理

**修改文件：**
- `lib/main.dart` - 应用主题配置
- `lib/providers/settings_provider.dart` - 扩展 Settings 类