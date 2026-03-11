import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/prediction_result.dart';
import '../../providers/providers.dart';

/// 智能预测卡片组件
///
/// 展示基于历史数据和月龄基准的活动预测。
/// 包含：
/// - 紫色到粉色渐变背景
/// - 标题区域（星星图标 + "智能预测"）
/// - 动态预测内容
/// - 夜间模式支持
class SmartPredictionCard extends ConsumerWidget {
  const SmartPredictionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取屏幕高度，卡片占用约22%的屏幕高度
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.22; // 22% 屏幕高度

    // 监听预测状态
    final predictionStateAsync = ref.watch(predictionStateProvider);

    return Container(
      width: double.infinity,
      height: cardHeight,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3E5F5), // purple-50
            Color(0xFFFCE4EC), // pink-50
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF8BBD9).withValues(alpha: 0.5), // pink-100
          width: 1,
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
      children: [
        // 标题区域
        _buildHeader(context, state),
        const Spacer(),
        // 预测内容
        if (state.isNightMode)
          _buildNightModeContent(context)
        else if (state.hasPrediction)
          _buildPredictionContent(context, ref, state.prediction!)
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
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 18,
            color: Colors.purple.shade600,
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
        if (state.hasPrediction && state.prediction!.isBasedOnAgeBenchmark)
          _buildAgeBenchmarkBadge(),
      ],
    );
  }

  /// 构建"根据月龄推荐"标记
  Widget _buildAgeBenchmarkBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '根据月龄推荐',
        style: TextStyle(
          fontSize: 11,
          color: Colors.purple.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建预测内容
  Widget _buildPredictionContent(
    BuildContext context,
    WidgetRef ref,
    PredictionResult prediction,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // 左侧紫色竖线
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: Colors.purple.shade400,
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
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    prediction.formattedTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
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
                    Text(
                      prediction.description,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155), // slate-700
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prediction.primaryTip,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B), // slate-500
                      ),
                    ),
                    // 显示合并预测的关联提示
                    if (prediction.isMerged) ...[
                      const SizedBox(height: 2),
                      Text(
                        _buildRelatedPredictionTip(prediction),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 确认按钮
              IconButton(
                onPressed: () => _markAsProcessed(ref, prediction),
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.purple.shade400,
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

  /// 构建关联预测提示
  String _buildRelatedPredictionTip(PredictionResult prediction) {
    if (prediction.relatedPredictions == null ||
        prediction.relatedPredictions!.isEmpty) {
      return '';
    }

    final relatedTypes = prediction.relatedPredictions!
        .map((p) => p.type.label)
        .join('、');
    return '同时可能：$relatedTypes';
  }

  /// 构建夜间模式内容
  Widget _buildNightModeContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bedtime,
            color: Colors.purple.shade400,
            size: 32,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '宝宝安睡中',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '夜间不打扰，让宝宝好好休息',
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
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.purple.shade400,
            size: 32,
          ),
          const SizedBox(width: 14),
          const Expanded(
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
        Spacer(),
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