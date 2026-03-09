import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// 主题风格枚举
///
/// 预留主题风格切换扩展点。
enum AppThemeStyle {
  /// 多巴胺风格（当前默认）
  dopamine,

  /// 莫兰迪风格（未来）
  morandi,
}

/// 应用主题工厂类
///
/// 创建符合 Material 3 规范的 ThemeData。
class AppTheme {
  AppTheme._();

  /// 创建浅色主题
  static ThemeData light({AppThemeStyle style = AppThemeStyle.dopamine}) {
    return _createTheme(
      brightness: Brightness.light,
      style: style,
    );
  }

  /// 创建深色主题
  static ThemeData dark({AppThemeStyle style = AppThemeStyle.dopamine}) {
    return _createTheme(
      brightness: Brightness.dark,
      style: style,
    );
  }

  /// 创建主题
  static ThemeData _createTheme({
    required Brightness brightness,
    required AppThemeStyle style,
  }) {
    // 使用 Material 3 Seed Color 生成调色板
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.light(),
      // AppBar 主题：居中标题、无阴影
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: brightness == Brightness.light
            ? AppColors.surface
            : colorScheme.surface,
        foregroundColor: brightness == Brightness.light
            ? AppColors.onSurface
            : colorScheme.onSurface,
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: brightness == Brightness.light
              ? AppColors.onSurface
              : colorScheme.onSurface,
        ),
      ),
      // 卡片主题：圆角 24px、微阴影
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        color: brightness == Brightness.light
            ? AppColors.surface
            : colorScheme.surfaceContainerHighest,
      ),
      // ElevatedButton 主题：圆角 16px
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingLg,
            vertical: AppSpacing.paddingMd,
          ),
        ),
      ),
      // TextButton 主题：圆角 16px
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingLg,
            vertical: AppSpacing.paddingMd,
          ),
        ),
      ),
      // FloatingActionButton 主题：圆角 16px
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      // 底部导航栏主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? AppColors.surface
            : colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingSm,
        ),
      ),
      // 分割线主题
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      // 图标主题
      iconTheme: IconThemeData(
        size: AppSpacing.iconLg,
        color: brightness == Brightness.light
            ? AppColors.onSurface
            : colorScheme.onSurface,
      ),
    );
  }
}