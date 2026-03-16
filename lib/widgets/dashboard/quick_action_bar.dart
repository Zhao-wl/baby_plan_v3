import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/tables/activity_records.dart';
import '../../providers/providers.dart';
import '../../theme/app_colors.dart';
import '../timeline/ongoing_activity_form_sheet.dart';
import 'growth_record_sheet.dart';
import 'quick_record_sheet.dart';

/// 快捷操作台组件
///
/// 嵌入页面内容流中的快捷按钮区域。
/// 包含五个操作按钮：吃奶、玩耍、睡眠、便便、成长
class QuickActionBar extends ConsumerStatefulWidget {
  const QuickActionBar({super.key});

  @override
  ConsumerState<QuickActionBar> createState() => _QuickActionBarState();
}

class _QuickActionBarState extends ConsumerState<QuickActionBar> {
  DateTime? _lastTapTime;
  static const _debounceDuration = Duration(milliseconds: 500);
  bool _hasShownNoBabyTip = false;
  final Map<ActivityType, bool> _isLongPressing = {};

  /// 处理长按 - 先启动计时器，再弹出表单编辑详情
  Future<void> _handleLongPress(ActivityType activityType) async {
    // 恢复按钮缩放
    setState(() {
      _isLongPressing[activityType] = false;
    });

    final currentBabyId = ref.read(currentBabyIdProvider);

    // 检查是否有宝宝
    if (currentBabyId == null) {
      if (!_hasShownNoBabyTip && mounted) {
        _hasShownNoBabyTip = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请先添加宝宝'),
            duration: Duration(seconds: 2),
          ),
        ).closed.then((_) {
          _hasShownNoBabyTip = false;
        });
      }
      return;
    }

    // 检查是否已有进行中活动
    final timerAsync = ref.read(timerProvider);
    final timerState = switch (timerAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (timerState != null && timerState.isTiming) {
      // 如果是相同活动类型，停止并弹出表单完成记录
      if (timerState.activityType == activityType) {
        final result = await ref.read(timerProvider.notifier).stopWithForm();
        if (result != null && mounted) {
          await QuickRecordSheet.show(
            context: context,
            activityType: result['activityType'] as ActivityType,
            startTime: result['startTime'] as DateTime,
            endTime: result['endTime'] as DateTime,
          );
        }
        return;
      }

      // 不同活动类型，先结束当前活动再开始新活动
      await ref.read(timerProvider.notifier).stop();
    }

    // 启动新计时器（会创建草稿记录）
    final success = await ref.read(timerProvider.notifier).start(activityType);
    if (!success || !mounted) {
      return;
    }

    // 获取刚创建的记录 ID
    final newTimerAsync = ref.read(timerProvider);
    final newTimerState = switch (newTimerAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final recordId = newTimerState?.currentRecordId;

    // 弹出表单让用户编辑详情
    if (mounted && recordId != null) {
      final saved = await OngoingActivityFormSheet.show(
        context: context,
        activityType: activityType,
        draftRecordId: recordId,
      );

      // 如果用户取消，清理计时器和草稿记录
      if (saved != true) {
        await ref.read(timerProvider.notifier).cancel();
      }
    }
  }

  /// 处理长按开始（用于动画）
  void _handleLongPressStart(ActivityType activityType) {
    setState(() {
      _isLongPressing[activityType] = true;
    });
  }

  /// 处理长按结束/取消（用于动画）
  void _handleLongPressEnd(ActivityType activityType) {
    setState(() {
      _isLongPressing[activityType] = false;
    });
  }

  bool _shouldProcessTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < _debounceDuration) {
      return false;
    }
    _lastTapTime = now;
    return true;
  }

  /// 处理按钮点击
  Future<void> _handleTap(ActivityType activityType) async {
    if (!_shouldProcessTap()) return;

    final timerAsync = ref.read(timerProvider);
    final timerState = switch (timerAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final currentBabyId = ref.read(currentBabyIdProvider);

    // 检查是否有宝宝
    if (currentBabyId == null) {
      // 只显示一次提示，避免重复弹出
      if (!_hasShownNoBabyTip && mounted) {
        _hasShownNoBabyTip = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请先添加宝宝'),
            duration: Duration(seconds: 2),
          ),
        ).closed.then((_) {
          // SnackBar 关闭后重置状态，允许再次显示
          _hasShownNoBabyTip = false;
        });
      }
      return;
    }

    // 根据当前状态决定行为
    if (timerState != null && timerState.isTiming) {
      if (timerState.activityType == activityType) {
        // 正在计时相同活动 -> 停止并弹出表单
        final result = await ref.read(timerProvider.notifier).stopWithForm();
        if (result != null && mounted) {
          await QuickRecordSheet.show(
            context: context,
            activityType: result['activityType'] as ActivityType,
            startTime: result['startTime'] as DateTime,
            endTime: result['endTime'] as DateTime,
          );
        }
      } else {
        // 正在计时不同活动 -> 切换
        await ref.read(timerProvider.notifier).switchActivity(activityType);
      }
    } else {
      // 未计时 -> 开始新计时
      await ref.read(timerProvider.notifier).start(activityType);
    }
  }

  /// 处理成长按钮点击
  Future<void> _handleGrowthTap() async {
    if (!_shouldProcessTap()) return;

    final currentBabyId = ref.read(currentBabyIdProvider);

    // 检查是否有宝宝
    if (currentBabyId == null) {
      if (!_hasShownNoBabyTip && mounted) {
        _hasShownNoBabyTip = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请先添加宝宝'),
            duration: Duration(seconds: 2),
          ),
        ).closed.then((_) {
          _hasShownNoBabyTip = false;
        });
      }
      return;
    }

    // 显示成长记录弹窗
    if (mounted) {
      await GrowthRecordSheet.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerAsync = ref.watch(timerProvider);
    final currentBabyId = ref.watch(currentBabyIdProvider);

    // 从 AsyncValue 中提取 TimerState，如果加载中则使用默认状态
    final TimerState timerState;
    switch (timerAsync) {
      case AsyncData(:final value):
        timerState = value;
      case AsyncError():
        timerState = const TimerState();
      case AsyncLoading():
        timerState = const TimerState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // slate-200
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 计算每个按钮的宽度：总宽度 / 5
          final buttonWidth = (constraints.maxWidth - 24) / 5; // 减去左右 padding

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: buttonWidth,
                child: _ActionButton(
                  label: '吃奶',
                  icon: Icons.restaurant,
                  color: AppColors.eat,
                  lightColor: AppColors.eatLight,
                  isActive: timerState.activityType == ActivityType.eat,
                  isPaused: timerState.isPaused,
                  isEnabled: currentBabyId != null,
                  isLongPressing: _isLongPressing[ActivityType.eat] ?? false,
                  duration: timerState.activityType == ActivityType.eat
                      ? timerState.currentDuration
                      : null,
                  onPressed: () => _handleTap(ActivityType.eat),
                  onLongPress: () => _handleLongPress(ActivityType.eat),
                  onLongPressStart: () => _handleLongPressStart(ActivityType.eat),
                  onLongPressEnd: () => _handleLongPressEnd(ActivityType.eat),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: _ActionButton(
                  label: '玩耍',
                  icon: Icons.sentiment_satisfied_alt,
                  color: AppColors.activity,
                  lightColor: AppColors.activityLight,
                  isActive: timerState.activityType == ActivityType.activity,
                  isPaused: timerState.isPaused,
                  isEnabled: currentBabyId != null,
                  isLongPressing: _isLongPressing[ActivityType.activity] ?? false,
                  duration: timerState.activityType == ActivityType.activity
                      ? timerState.currentDuration
                      : null,
                  onPressed: () => _handleTap(ActivityType.activity),
                  onLongPress: () => _handleLongPress(ActivityType.activity),
                  onLongPressStart: () => _handleLongPressStart(ActivityType.activity),
                  onLongPressEnd: () => _handleLongPressEnd(ActivityType.activity),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: _ActionButton(
                  label: '睡眠',
                  icon: Icons.nightlight_round,
                  color: AppColors.sleep,
                  lightColor: AppColors.sleepLight,
                  isActive: timerState.activityType == ActivityType.sleep,
                  isPaused: timerState.isPaused,
                  isEnabled: currentBabyId != null,
                  isLongPressing: _isLongPressing[ActivityType.sleep] ?? false,
                  duration: timerState.activityType == ActivityType.sleep
                      ? timerState.currentDuration
                      : null,
                  onPressed: () => _handleTap(ActivityType.sleep),
                  onLongPress: () => _handleLongPress(ActivityType.sleep),
                  onLongPressStart: () => _handleLongPressStart(ActivityType.sleep),
                  onLongPressEnd: () => _handleLongPressEnd(ActivityType.sleep),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: _ActionButton(
                  label: '便便',
                  icon: Icons.water_drop,
                  color: AppColors.poop,
                  lightColor: AppColors.poopLight,
                  isActive: timerState.activityType == ActivityType.poop,
                  isPaused: timerState.isPaused,
                  isEnabled: currentBabyId != null,
                  isLongPressing: _isLongPressing[ActivityType.poop] ?? false,
                  duration: timerState.activityType == ActivityType.poop
                      ? timerState.currentDuration
                      : null,
                  onPressed: () => _handleTap(ActivityType.poop),
                  onLongPress: () => _handleLongPress(ActivityType.poop),
                  onLongPressStart: () => _handleLongPressStart(ActivityType.poop),
                  onLongPressEnd: () => _handleLongPressEnd(ActivityType.poop),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: _ActionButton(
                  label: '成长',
                  icon: Icons.trending_up,
                  color: AppColors.primary, // Teal
                  lightColor: AppColors.primaryLight,
                  isActive: false, // 成长按钮没有活跃状态
                  isPaused: false,
                  isEnabled: currentBabyId != null,
                  isLongPressing: false,
                  duration: null,
                  onPressed: _handleGrowthTap,
                  onLongPress: null, // 成长按钮不支持长按
                  onLongPressStart: null,
                  onLongPressEnd: null,
                ),
              ),
            ],
          );
        },
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
  final bool isActive;
  final bool isPaused;
  final bool isEnabled;
  final bool isLongPressing;
  final Duration? duration;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
    this.isActive = false,
    this.isPaused = false,
    this.isEnabled = true,
    this.isLongPressing = false,
    this.duration,
    required this.onPressed,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final showDuration = isActive && duration != null && !isPaused;
    // 禁用状态使用更深的灰色，确保与白色背景有明显对比
    const disabledColor = Color(0xFF64748B); // slate-500
    const disabledLightColor = Color(0xFFE2E8F0); // slate-200

    final effectiveColor = isEnabled ? color : disabledColor;
    final effectiveLightColor = isEnabled ? lightColor : disabledLightColor;

    // 长按时的缩放效果
    final scale = isLongPressing ? 0.9 : 1.0;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        onLongPressStart: (_) => onLongPressStart?.call(),
        onLongPressEnd: (_) => onLongPressEnd?.call(),
        onLongPressCancel: () => onLongPressEnd?.call(),
        child: Transform.scale(
          scale: scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标容器
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive ? effectiveColor : effectiveLightColor,
                  shape: BoxShape.circle,
                  // 禁用时添加更明显的边框
                  border: !isEnabled && !isActive
                      ? Border.all(
                          color: const Color(0xFF94A3B8), // slate-400
                          width: 1.5,
                        )
                      : null,
                  boxShadow: isActive && isEnabled
                      ? [
                          BoxShadow(
                            color: effectiveColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : isLongPressing
                          ? [
                              BoxShadow(
                                color: effectiveColor.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                ),
                child: Icon(
                  isPaused && isActive ? Icons.pause : icon,
                  color: isActive ? Colors.white : effectiveColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 6),
              // 时长或标签
              if (showDuration)
                Text(
                  _formatDuration(duration!),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              else
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
}
}