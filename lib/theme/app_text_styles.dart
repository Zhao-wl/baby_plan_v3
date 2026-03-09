import 'package:flutter/material.dart';

/// 应用字体大小常量
class AppFontSizes {
  AppFontSizes._();

  /// 极小标签
  static const double xs = 10.0;

  /// 辅助文字、Caption
  static const double sm = 12.0;

  /// 正文
  static const double base = 14.0;

  /// 小标题
  static const double md = 16.0;

  /// 卡片标题
  static const double lg = 18.0;

  /// 页面标题
  static const double xl = 22.0;

  /// 大标题
  static const double xxl = 28.0;
}

/// 应用文本样式
///
/// 定义统一的文本样式层级，确保视觉一致性。
class AppTextStyles {
  AppTextStyles._();

  /// H1 - 页面标题 (displayLarge)
  static TextStyle get h1 => const TextStyle(
        fontSize: AppFontSizes.xxl,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  /// H2 - 卡片标题 (headlineMedium)
  static TextStyle get h2 => const TextStyle(
        fontSize: AppFontSizes.xl,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  /// H3 - 列表项标题 (titleMedium)
  static TextStyle get h3 => const TextStyle(
        fontSize: AppFontSizes.lg,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );

  /// Body - 正文内容 (bodyMedium)
  static TextStyle get body => const TextStyle(
        fontSize: AppFontSizes.base,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body Large - 大正文
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: AppFontSizes.md,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Caption - 辅助说明 (bodySmall)
  static TextStyle get caption => const TextStyle(
        fontSize: AppFontSizes.sm,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Label - 标签、按钮 (labelMedium)
  static TextStyle get label => const TextStyle(
        fontSize: AppFontSizes.sm,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// Label Large - 大标签
  static TextStyle get labelLarge => const TextStyle(
        fontSize: AppFontSizes.base,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// 多行文本样式（行高 1.6）
  static TextStyle get bodyMultiline => const TextStyle(
        fontSize: AppFontSizes.base,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );
}

/// TextTheme 工厂
///
/// 用于创建 Material 3 兼容的 TextTheme。
class AppTextTheme {
  AppTextTheme._();

  /// 创建浅色文本主题
  static TextTheme light() {
    return TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,
      titleLarge: AppTextStyles.h3,
      titleMedium: AppTextStyles.h3.copyWith(fontSize: AppFontSizes.md),
      titleSmall: AppTextStyles.labelLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.label,
      labelSmall: AppTextStyles.label.copyWith(fontSize: AppFontSizes.xs),
    );
  }

  /// 创建深色文本主题（与浅色相同，颜色由 ColorScheme 控制）
  static TextTheme dark() => light();
}