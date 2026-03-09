import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 计算宝宝月龄
///
/// 根据出生日期计算当前月龄。
/// - 不满 1 个月：显示 "X 天"
/// - 1-11 个月：显示 "X 个月"
/// - 12 个月及以上：显示 "X 岁 Y 个月" 或 "X 岁"
int calculateAgeInMonths(DateTime birthDate) {
  final now = DateTime.now();
  int months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  if (now.day < birthDate.day) {
    months--;
  }
  return months < 0 ? 0 : months;
}

/// 格式化月龄显示
///
/// 将月龄转换为友好的显示文本。
/// - 不满 1 个月：显示 "X 天"
/// - 1-11 个月：显示 "X 个月"
/// - 12 个月及以上：显示 "X 岁 Y 个月" 或 "X 岁"
String formatAge(DateTime birthDate) {
  final now = DateTime.now();
  int months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  if (now.day < birthDate.day) {
    months--;
  }

  if (months < 0) {
    months = 0;
  }

  if (months < 1) {
    final days = now.difference(birthDate).inDays;
    return '$days 天';
  } else if (months < 12) {
    return '$months 个月';
  } else {
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    return remainingMonths > 0 ? '$years 岁 $remainingMonths 个月' : '$years 岁';
  }
}

/// 格式化活动时间显示
///
/// 将活动时间转换为友好的显示文本。
/// - 今天：显示 "今天 HH:mm"
/// - 昨天：显示 "昨天 HH:mm"
/// - 更早：显示 "MM-DD HH:mm"
String formatActivityTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final activityDay = DateTime(time.year, time.month, time.day);

  final timeStr =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  if (activityDay == today) {
    return '今天 $timeStr';
  } else if (activityDay == yesterday) {
    return '昨天 $timeStr';
  } else {
    return '${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} $timeStr';
  }
}

/// 获取活动类型对应的颜色
///
/// 根据 E.A.S.Y 活动类型返回对应颜色。
Color getActivityColor(int activityType) {
  switch (activityType) {
    case 0: // Eat
      return AppColors.eat;
    case 1: // Activity
      return AppColors.activity;
    case 2: // Sleep
      return AppColors.sleep;
    case 3: // Poop
      return AppColors.poop;
    default:
      return AppColors.primary;
  }
}

/// 获取活动类型对应的浅色背景
Color getActivityLightColor(int activityType) {
  switch (activityType) {
    case 0: // Eat
      return AppColors.eatLight;
    case 1: // Activity
      return AppColors.activityLight;
    case 2: // Sleep
      return AppColors.sleepLight;
    case 3: // Poop
      return AppColors.poopLight;
    default:
      return AppColors.primaryLight;
  }
}

/// 获取活动类型名称
String getActivityTypeName(int activityType) {
  switch (activityType) {
    case 0: // Eat
      return '吃';
    case 1: // Activity
      return '玩';
    case 2: // Sleep
      return '睡';
    case 3: // Poop
      return '排泄';
    default:
      return '未知';
  }
}

/// 获取活动类型图标
IconData getActivityIcon(int activityType) {
  switch (activityType) {
    case 0: // Eat
      return Icons.restaurant;
    case 1: // Activity
      return Icons.toys;
    case 2: // Sleep
      return Icons.bedtime;
    case 3: // Poop
      return Icons.baby_changing_station;
    default:
      return Icons.help_outline;
  }
}

/// 格式化时长显示
///
/// 将秒数转换为友好的显示文本。
/// - 不到 1 分钟：显示 "X 秒"
/// - 1-59 分钟：显示 "X 分钟"
/// - 1 小时及以上：显示 "X 小时 Y 分钟"
String formatDuration(int? seconds) {
  if (seconds == null || seconds <= 0) {
    return '--';
  }

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;

  if (hours > 0) {
    return minutes > 0 ? '$hours 小时 $minutes 分钟' : '$hours 小时';
  } else if (minutes > 0) {
    return '$minutes 分钟';
  } else {
    return '$seconds 秒';
  }
}