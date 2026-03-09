import 'package:flutter/material.dart';

/// 呼吸动效背景组件
///
/// 提供可复用的呼吸动效背景，用于计时器状态的视觉反馈。
/// 使用 RepaintBoundary 优化性能，隔离重绘区域。
class BreathingBackground extends StatefulWidget {
  /// 动效颜色，默认使用主题主色
  final Color? color;

  /// 子组件，显示在动效背景之上
  final Widget? child;

  /// 动画时长，默认 2 秒
  final Duration duration;

  const BreathingBackground({
    super.key,
    this.color,
    this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<BreathingBackground> createState() => _BreathingBackgroundState();
}

class _BreathingBackgroundState extends State<BreathingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(BreathingBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  color.withValues(alpha: _animation.value),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}