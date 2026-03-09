import 'package:flutter/material.dart';

/// 计时器卡片占位组件
///
/// 作为计时器功能的占位显示，包含：
/// - 渐变背景（蓝色到靛蓝色）
/// - 呼吸波纹动效
/// - 状态占位显示
class TimerCardPlaceholder extends StatefulWidget {
  const TimerCardPlaceholder({super.key});

  @override
  State<TimerCardPlaceholder> createState() => _TimerCardPlaceholderState();
}

class _TimerCardPlaceholderState extends State<TimerCardPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    // 呼吸动画：3秒周期，无限循环
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕高度，卡片占用约30%的屏幕高度
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.28; // 28% 屏幕高度

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD), // blue-50
            Color(0xFFE8EAF6), // indigo-50
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFBBDEFB).withValues(alpha: 0.5), // blue-100
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 呼吸波纹动效
          _buildBreathingRipples(cardHeight),
          // 状态占位显示
          _buildStatusContent(context),
        ],
      ),
    );
  }

  /// 构建呼吸波纹动效
  Widget _buildBreathingRipples(double cardHeight) {
    final rippleSize = cardHeight * 0.6;

    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 外圈波纹
            Transform.scale(
              scale: _breathAnimation.value,
              child: Container(
                width: rippleSize,
                height: rippleSize,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // 内圈波纹
            Transform.scale(
              scale: 0.85 + (_breathAnimation.value - 0.8) * 0.75,
              child: Container(
                width: rippleSize * 1.5,
                height: rippleSize * 1.5,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建状态占位显示
  Widget _buildStatusContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 状态标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.nightlight_round,
                size: 18,
                color: Colors.indigo.shade500,
              ),
              const SizedBox(width: 8),
              Text(
                '点击开始计时',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 时间显示
        const Text(
          '00:00:00',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: Color(0xFF334155), // slate-700
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),
        // 今日统计
        const Text(
          '今日累计: 0 小时 0 分钟',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8), // slate-400
          ),
        ),
      ],
    );
  }
}