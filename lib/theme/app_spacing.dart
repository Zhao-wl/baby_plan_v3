import 'package:flutter/material.dart';

/// 应用间距与圆角规范
///
/// 定义统一的圆角、间距和图标尺寸常量。
class AppSpacing {
  AppSpacing._();

  // ==================== 圆角规范 ====================

  /// 小元素、标签
  static const double radiusXs = 4.0;

  /// 按钮、输入框
  static const double radiusSm = 8.0;

  /// 列表项
  static const double radiusMd = 12.0;

  /// 大按钮、弹窗
  static const double radiusLg = 16.0;

  /// 卡片、底部弹窗
  static const double radiusXl = 24.0;

  /// 大卡片、计时器卡片
  static const double radiusXxl = 32.0;

  /// 圆形头像、悬浮按钮
  static const double radiusFull = 9999.0;

  // ==================== 间距规范 ====================

  /// 紧凑元素间距
  static const double paddingXs = 4.0;

  /// 相关元素间距
  static const double paddingSm = 8.0;

  /// 标准内边距
  static const double paddingMd = 16.0;

  /// 卡片内边距
  static const double paddingLg = 24.0;

  /// 区块间距
  static const double paddingXl = 32.0;

  /// 页面边距
  static const double paddingXxl = 48.0;

  // ==================== 图标尺寸规范 ====================

  /// 行内图标
  static const double iconSm = 16.0;

  /// 列表图标
  static const double iconMd = 20.0;

  /// 导航图标、按钮图标
  static const double iconLg = 24.0;

  /// 强调图标
  static const double iconXl = 32.0;

  /// 空状态图标
  static const double iconXxl = 48.0;

  // ==================== 响应式断点 ====================

  /// 紧凑断点上限（手机竖屏）
  static const double breakpointCompact = 600.0;

  /// 展开断点下限（平板）
  static const double breakpointExpanded = 840.0;

  // ==================== 弹窗最大宽度 ====================

  /// 中屏弹窗最大宽度
  static const double sheetMaxWidthMedium = 600.0;

  /// 宽屏弹窗最大宽度
  static const double sheetMaxWidthExpanded = 720.0;
}

/// 圆角边框帮助类
class AppBorderRadius {
  AppBorderRadius._();

  static BorderRadius get xs => BorderRadius.circular(AppSpacing.radiusXs);
  static BorderRadius get sm => BorderRadius.circular(AppSpacing.radiusSm);
  static BorderRadius get md => BorderRadius.circular(AppSpacing.radiusMd);
  static BorderRadius get lg => BorderRadius.circular(AppSpacing.radiusLg);
  static BorderRadius get xl => BorderRadius.circular(AppSpacing.radiusXl);
  static BorderRadius get xxl => BorderRadius.circular(AppSpacing.radiusXxl);
  static BorderRadius get full => BorderRadius.circular(AppSpacing.radiusFull);
}