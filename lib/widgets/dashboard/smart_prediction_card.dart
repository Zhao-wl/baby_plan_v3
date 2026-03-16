import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/awake_stage.dart';
import '../../models/prediction_result.dart';
import '../../models/time_slot.dart';
import '../../providers/providers.dart';

/// 智能预测卡片组件
///
/// 展示基于历史数据和月龄基准的活动预测。
/// 包含：
/// - 简洁白色背景 + Teal 强调边框
/// - 标题区域（星星图标 + "智能预测"）
/// - 动态预测内容
class SmartPredictionCard extends ConsumerWidget {
  const SmartPredictionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听预测状态
    final predictionStateAsync = ref.watch(predictionStateProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF009688).withValues(alpha: 0.3), // Teal 边框
          width: 1.5,
        ),
      ),
      child: predictionStateAsync.when(
        data: (state) => _buildContent(context, ref, state),
        loading: () => _buildLoadingContent(),
        error: (_, __) => _buildErrorContent(),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PredictionState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 标题区域
        _buildHeader(context, state),
        const SizedBox(height: 12),
        // 预测内容 - 夜间也显示预测，帮助用户培养规律作息
        if (state.hasPrediction)
          _buildPredictionContent(context, ref, state)
        else if (state.hasInsufficientData)
          _buildInsufficientDataContent(context, ref)
        else
          _buildEmptyContent(context),
      ],
    );
  }

  /// 构建标题区域
  Widget _buildHeader(BuildContext context, PredictionState state) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1), // Teal-50
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 18,
            color: Color(0xFF009688), // Teal
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          '智能预测',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155), // slate-700
          ),
        ),
        const Spacer(),
        // 显示时段标签
        if (state.timeSlot != null) _buildTimeSlotBadge(state.timeSlot!),
        if (state.hasPrediction && state.prediction!.isBasedOnAgeBenchmark)
          _buildAgeBenchmarkBadge(),
      ],
    );
  }

  /// 构建时段标签
  Widget _buildTimeSlotBadge(TimeSlot timeSlot) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: timeSlot.isNight
            ? Colors.indigo.shade100
            : const Color(0xFFE0F2F1), // Teal-50
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            timeSlot.isNight ? Icons.bedtime : Icons.wb_sunny,
            size: 12,
            color: timeSlot.isNight
                ? Colors.indigo.shade600
                : const Color(0xFF009688), // Teal
          ),
          const SizedBox(width: 4),
          Text(
            '${timeSlot.label}时段',
            style: TextStyle(
              fontSize: 11,
              color: timeSlot.isNight
                  ? Colors.indigo.shade700
                  : const Color(0xFF009688), // Teal
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建"根据月龄推荐"标记
  Widget _buildAgeBenchmarkBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Teal-50
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '根据月龄推荐',
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFF009688), // Teal
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建预测内容
  Widget _buildPredictionContent(
    BuildContext context,
    WidgetRef ref,
    PredictionState state,
  ) {
    final prediction = state.prediction!;
    final timeSlot = state.timeSlot;
    final awakeStage = state.awakeStage;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // 左侧 Teal 竖线
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF009688), // Teal
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // 主内容
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              // 时间圆圈
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1), // Teal-50
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    prediction.formattedTime,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009688), // Teal
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // 预测文字
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 主描述 + 睡眠阶段标签
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            prediction.description,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155), // slate-700
                            ),
                          ),
                        ),
                        // 显示睡眠阶段标签
                        if (awakeStage != null) ...[
                          const SizedBox(width: 8),
                          _buildAwakeStageBadge(awakeStage),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 提示信息 - 根据时段和睡眠阶段生成
                    Text(
                      _buildContextualTip(prediction, timeSlot, awakeStage),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B), // slate-500
                      ),
                    ),
                    // 显示合并预测的关联提示
                    if (prediction.isMerged) ...[
                      const SizedBox(height: 2),
                      const Text(
                        '同时可能：',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF009688), // Teal
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 确认按钮
              IconButton(
                onPressed: () => _markAsProcessed(ref, prediction),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF009688), // Teal
                  size: 28,
                ),
                tooltip: '标记为已处理',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建睡眠阶段标签
  Widget _buildAwakeStageBadge(AwakeStage awakeStage) {
    final color = switch (awakeStage) {
      AwakeStage.awakeEarly => Colors.green,
      AwakeStage.awakeMid => Colors.orange,
      AwakeStage.awakeLate => Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200, width: 1),
      ),
      child: Text(
        awakeStage.label,
        style: TextStyle(
          fontSize: 10,
          color: color.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 根据时段和睡眠阶段生成上下文提示
  String _buildContextualTip(
    PredictionResult prediction,
    TimeSlot? timeSlot,
    AwakeStage? awakeStage,
  ) {
    // 如果有自定义提示且不是通用提示，使用自定义提示
    if (prediction.tips != null &&
        prediction.tips!.isNotEmpty &&
        prediction.tips != prediction.type.defaultTip) {
      return prediction.tips!;
    }

    final tips = <String>[];

    // 根据时段生成提示
    if (timeSlot != null) {
      switch (timeSlot) {
        case TimeSlot.night:
          tips.addAll(_buildNightTips(prediction));
          break;
        case TimeSlot.evening:
          tips.addAll(_buildEveningTips(prediction));
          break;
        case TimeSlot.morning:
          tips.addAll(_buildMorningTips(prediction, awakeStage));
          break;
        default:
          // 其他时段使用默认提示
          break;
      }
    }

    // 根据睡眠阶段补充提示
    if (awakeStage != null) {
      switch (awakeStage) {
        case AwakeStage.awakeEarly:
          if (prediction.type == PredictionType.eat) {
            tips.add('刚醒来，可能需要喂奶');
          }
          break;
        case AwakeStage.awakeMid:
          if (prediction.type == PredictionType.poop) {
            tips.add('活动期，排泄可能增多');
          }
          break;
        case AwakeStage.awakeLate:
          if (prediction.type == PredictionType.sleep) {
            tips.add('宝宝疲劳，建议安排小睡');
          }
          break;
      }
    }

    // 如果没有特殊提示，使用默认提示
    if (tips.isEmpty) {
      return prediction.primaryTip;
    }

    return tips.first;
  }

  /// 构建夜间时段提示
  List<String> _buildNightTips(PredictionResult prediction) {
    switch (prediction.type) {
      case PredictionType.sleep:
        final hours = prediction.predictedTime.hour;
        // 如果是夜间入睡
        if (hours >= 22 || hours < 6) {
          return ['夜间长觉，预计睡眠较长'];
        }
        return ['夜间小睡'];
      case PredictionType.eat:
        return ['如需夜奶，注意保持安静'];
      case PredictionType.poop:
        return ['夜间排泄，轻柔处理'];
    }
  }

  /// 构建傍晚时段提示
  List<String> _buildEveningTips(PredictionResult prediction) {
    switch (prediction.type) {
      case PredictionType.eat:
        return ['睡前喂奶，帮助宝宝安睡'];
      case PredictionType.sleep:
        return ['傍晚小睡，不宜过长'];
      case PredictionType.poop:
        return [prediction.primaryTip];
    }
  }

  /// 构建早晨时段提示
  List<String> _buildMorningTips(
    PredictionResult prediction,
    AwakeStage? awakeStage,
  ) {
    switch (prediction.type) {
      case PredictionType.eat:
        if (awakeStage == AwakeStage.awakeEarly) {
          return ['刚醒来，可能需要喂奶'];
        }
        return ['早晨喂奶'];
      case PredictionType.sleep:
        return ['晨间小睡'];
      case PredictionType.poop:
        return [prediction.primaryTip];
    }
  }

  /// 构建数据不足引导内容
  Widget _buildInsufficientDataContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xFF009688), // Teal
            size: 32,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '正在学习宝宝的作息规律',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '继续记录活动，预测会越来越准确',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建空状态内容
  Widget _buildEmptyContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: Color(0xFF64748B),
            size: 32,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '记录更多活动，解锁智能预测',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '至少记录5条活动后开启预测',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建加载中内容
  Widget _buildLoadingContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建错误内容
  Widget _buildErrorContent() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Color(0xFFEF4444),
            size: 32,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              '预测加载失败，请稍后重试',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 标记预测为已处理
  void _markAsProcessed(WidgetRef ref, PredictionResult prediction) {
    markPredictionAsProcessed(ref, prediction);
    // 触发重新加载
    ref.invalidate(predictionProvider);
  }
}