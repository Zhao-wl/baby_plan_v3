import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/tables/activity_records.dart';
import '../../providers/providers.dart';
import '../../theme/app_colors.dart';

/// 活动类型配置
class _ActivityConfig {
  final String label;
  final IconData icon;
  final Color color;
  final Color lightColor;

  const _ActivityConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
  });
}

/// 获取活动类型配置
_ActivityConfig _getActivityConfig(ActivityType type) {
  switch (type) {
    case ActivityType.eat:
      return const _ActivityConfig(
        label: '吃奶',
        icon: Icons.restaurant,
        color: AppColors.eat,
        lightColor: AppColors.eatLight,
      );
    case ActivityType.activity:
      return const _ActivityConfig(
        label: '玩耍',
        icon: Icons.sentiment_satisfied_alt,
        color: AppColors.activity,
        lightColor: AppColors.activityLight,
      );
    case ActivityType.sleep:
      return const _ActivityConfig(
        label: '睡眠',
        icon: Icons.nightlight_round,
        color: AppColors.sleep,
        lightColor: AppColors.sleepLight,
      );
    case ActivityType.poop:
      return const _ActivityConfig(
        label: '便便',
        icon: Icons.water_drop,
        color: AppColors.poop,
        lightColor: AppColors.poopLight,
      );
  }
}

/// 计时器卡片组件
///
/// 显示当前计时状态，包括：
/// - 实时计时时长
/// - 活动类型标签
/// - 控制按钮（暂停/继续、结束、取消）
/// - 空闲状态引导提示
class TimerCard extends ConsumerStatefulWidget {
  const TimerCard({super.key});

  @override
  ConsumerState<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends ConsumerState<TimerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  Timer? _updateTimer;
  Duration _displayDuration = Duration.zero;

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

    // 每秒更新时间显示
    _startTimer();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        final timerState = ref.read(timerProvider);
        if (timerState.isTiming && !timerState.isPaused) {
          setState(() {
            _displayDuration = timerState.currentDuration;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.28; // 28% 屏幕高度

    // 根据计时状态决定是否显示呼吸动画
    if (!timerState.isTiming || timerState.isPaused) {
      _breathController.stop();
    } else {
      _breathController.repeat(reverse: true);
    }

    // 获取活动配置
    final activityConfig = timerState.activityType != null
        ? _getActivityConfig(timerState.activityType!)
        : null;

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: activityConfig != null
              ? [
                  activityConfig.lightColor,
                  activityConfig.lightColor.withValues(alpha: 0.7),
                ]
              : [
                  const Color(0xFFE3F2FD), // blue-50
                  const Color(0xFFE8EAF6), // indigo-50
                ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: activityConfig?.color.withValues(alpha: 0.3) ??
              const Color(0xFFBBDEFB).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 呼吸波纹动效（仅在计时时显示）
          if (timerState.isTiming && !timerState.isPaused)
            _buildBreathingRipples(cardHeight, activityConfig!.color),

          // 内容区域
          timerState.isTiming
              ? _buildTimingContent(context, timerState, activityConfig!)
              : _buildIdleContent(context),
        ],
      ),
    );
  }

  /// 构建呼吸波纹动效
  Widget _buildBreathingRipples(double cardHeight, Color color) {
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
                  color: color.withValues(alpha: 0.15),
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
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建计时中内容
  Widget _buildTimingContent(
    BuildContext context,
    TimerState timerState,
    _ActivityConfig config,
  ) {
    // 更新显示时长
    _displayDuration = timerState.currentDuration;

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
                timerState.isPaused ? Icons.pause : config.icon,
                size: 18,
                color: config.color,
              ),
              const SizedBox(width: 8),
              Text(
                timerState.isPaused ? '已暂停' : config.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: config.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 时间显示
        Text(
          _formatDuration(_displayDuration),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: Color(0xFF334155), // slate-700
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),
        // 今日累计（TODO: 需要从 statsProvider 获取）
        const Text(
          '今日累计: 0 小时 0 分钟',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8), // slate-400
          ),
        ),
        const SizedBox(height: 20),
        // 控制按钮
        _buildControlButtons(context, timerState, config),
      ],
    );
  }

  /// 构建控制按钮
  Widget _buildControlButtons(
    BuildContext context,
    TimerState timerState,
    _ActivityConfig config,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 暂停/继续按钮
        _ControlButton(
          icon: timerState.isPaused ? Icons.play_arrow : Icons.pause,
          label: timerState.isPaused ? '继续' : '暂停',
          color: config.color,
          onPressed: () {
            if (timerState.isPaused) {
              ref.read(timerProvider.notifier).resume();
            } else {
              ref.read(timerProvider.notifier).pause();
            }
          },
        ),
        const SizedBox(width: 16),
        // 结束按钮
        _ControlButton(
          icon: Icons.stop,
          label: '结束',
          color: Colors.green,
          onPressed: () async {
            await ref.read(timerProvider.notifier).stop();
          },
        ),
        const SizedBox(width: 16),
        // 取消按钮
        _ControlButton(
          icon: Icons.close,
          label: '取消',
          color: Colors.red.shade400,
          onPressed: () async {
            await ref.read(timerProvider.notifier).cancel();
          },
        ),
      ],
    );
  }

  /// 构建空闲状态内容
  Widget _buildIdleContent(BuildContext context) {
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

  /// 格式化时长显示
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

/// 控制按钮组件
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
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