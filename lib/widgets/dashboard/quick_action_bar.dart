import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// 快捷操作台组件
///
/// 悬浮在底部导航上方的快捷按钮区域。
/// 包含四个操作按钮：吃奶、玩耍、睡眠、便便
class QuickActionBar extends StatelessWidget {
  const QuickActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFF1F5F9), // slate-100
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            label: '吃奶',
            icon: Icons.restaurant,
            color: AppColors.eat,
            lightColor: AppColors.eatLight,
            onPressed: () {
              // TODO: 打开吃奶记录弹窗
            },
          ),
          _ActionButton(
            label: '玩耍',
            icon: Icons.sentiment_satisfied_alt,
            color: AppColors.activity,
            lightColor: AppColors.activityLight,
            onPressed: () {
              // TODO: 打开玩耍记录弹窗
            },
          ),
          _ActionButton(
            label: '睡眠',
            icon: Icons.nightlight_round,
            color: AppColors.sleep,
            lightColor: AppColors.sleepLight,
            onPressed: () {
              // TODO: 打开睡眠记录弹窗
            },
          ),
          _ActionButton(
            label: '便便',
            icon: Icons.water_drop,
            color: AppColors.poop,
            lightColor: AppColors.poopLight,
            onPressed: () {
              // TODO: 打开便便记录弹窗
            },
          ),
        ],
      ),
    );
  }
}

/// 快捷操作按钮
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标容器
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: lightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(height: 6),
              // 标签文字
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}