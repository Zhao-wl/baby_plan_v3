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
        color: AppColors.eatSoft, // 使用淡化色
        lightColor: AppColors.eatLight,
      );
    case ActivityType.activity:
      return const _ActivityConfig(
        label: '玩耍',
        icon: Icons.sentiment_satisfied_alt,
        color: AppColors.activitySoft, // 使用淡化色
        lightColor: AppColors.activityLight,
      );
    case ActivityType.sleep:
      return const _ActivityConfig(
        label: '睡眠',
        icon: Icons.nightlight_round,
        color: AppColors.sleepSoft, // 使用淡化色
        lightColor: AppColors.sleepLight,
      );
    case ActivityType.poop:
      return const _ActivityConfig(
        label: '便便',
        icon: Icons.water_drop,
        color: AppColors.poopSoft, // 使用淡化色
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
///
/// 特点：
/// - 内容自适应高度，不使用固定百分比
/// - 简洁视觉风格，无呼吸动画
class TimerCard extends ConsumerStatefulWidget {
  const TimerCard({super.key});

  @override
  ConsumerState<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends ConsumerState<TimerCard> {
  Timer? _updateTimer;
  Duration _displayDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        final timerAsync = ref.read(timerProvider);
        timerAsync.when(
          data: (state) {
            if (state.isTiming && !state.isPaused) {
              setState(() {
                _displayDuration = state.currentDuration;
              });
            }
          },
          loading: () {},
          error: (_, __) {},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerAsync = ref.watch(timerProvider);

    return timerAsync.when(
      data: (timerState) {
        // 获取活动配置
        final activityConfig = timerState.activityType != null
            ? _getActivityConfig(timerState.activityType!)
            : null;

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 140),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: activityConfig?.lightColor ?? Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: activityConfig?.color.withValues(alpha: 0.3) ??
                  const Color(0xFFE2E8F0), // slate-200
              width: 1,
            ),
          ),
          child: timerState.isTiming
              ? _buildTimingContent(context, timerState, activityConfig!)
              : _buildIdleContent(context),
        );
      },
      loading: () => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 140),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFE2E8F0), // slate-200
            width: 1,
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, stack) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 140),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFE2E8F0), // slate-200
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '加载失败: $error',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ),
      ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // 状态标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
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
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Color(0xFF334155), // slate-700
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        // 今日累计
        const Text(
          '今日累计: 0 小时 0 分钟',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8), // slate-400
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(width: 12),
        // 结束按钮
        _ControlButton(
          icon: Icons.stop,
          label: '结束',
          color: AppColors.primary, // Teal
          onPressed: () async {
            await ref.read(timerProvider.notifier).stop();
          },
        ),
        const SizedBox(width: 12),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // 状态标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 18,
                color: Colors.indigo.shade500,
              ),
              const SizedBox(width: 8),
              Text(
                '点击下方按钮开始计时',
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
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Color(0xFF334155), // slate-700
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
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
                      color: color.withValues(alpha: 0.2),
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