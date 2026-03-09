import 'package:flutter/material.dart';

/// 应用颜色常量定义
///
/// 包含 E.A.S.Y 活动颜色、主色调和中性色。
class AppColors {
  AppColors._();

  // ==================== E.A.S.Y 活动颜色 ====================

  /// Eat (吃/喂养) - 成长与能量
  static const Color eat = Color(0xFF4CAF50);

  /// Eat 浅色背景
  static const Color eatLight = Color(0xFFE8F5E9);

  /// Activity (玩/活动) - 活力与阳光
  static const Color activity = Color(0xFFFFC107);

  /// Activity 浅色背景
  static const Color activityLight = Color(0xFFFFF8E1);

  /// Sleep (睡眠) - 沉静与修复
  static const Color sleep = Color(0xFF2196F3);

  /// Sleep 浅色背景
  static const Color sleepLight = Color(0xFFE3F2FD);

  /// Poop (排泄) - 排泄记录
  static const Color poop = Color(0xFFFF9800);

  /// Poop 浅色背景
  static const Color poopLight = Color(0xFFFFF3E0);

  // ==================== 主色调 (Teal) ====================

  /// 主色 - 主按钮、导航选中、强调元素
  static const Color primary = Color(0xFF009688);

  /// 主色浅底
  static const Color primaryLight = Color(0xFFB2DFDB);

  /// 主色深色变体
  static const Color primaryDark = Color(0xFF00796B);

  // ==================== 中性色 ====================

  /// 页面背景
  static const Color background = Color(0xFFFAFAFA);

  /// 卡片背景
  static const Color surface = Color(0xFFFFFFFF);

  /// 背景上的文字
  static const Color onBackground = Color(0xFF1C1B1F);

  /// 表面上的文字
  static const Color onSurface = Color(0xFF1C1B1F);

  /// 边框、分割线
  static const Color outline = Color(0xFF79747E);
}