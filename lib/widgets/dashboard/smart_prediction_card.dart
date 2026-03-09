import 'package:flutter/material.dart';

/// 智能预测卡片占位组件
///
/// 展示智能预测功能的 UI 框架，功能待后续开发。
/// 包含：
/// - 紫色到粉色渐变背景
/// - 标题区域（星星图标 + "智能预测"）
/// - 示例预测内容
class SmartPredictionCard extends StatelessWidget {
  const SmartPredictionCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取屏幕高度，卡片占用约22%的屏幕高度
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.22; // 22% 屏幕高度

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          _buildHeader(context),
          const Spacer(),
          // 示例预测内容
          _buildPredictionContent(context),
        ],
      ),
    );
  }

  /// 构建标题区域
  Widget _buildHeader(BuildContext context) {
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
      ],
    );
  }

  /// 构建示例预测内容
  Widget _buildPredictionContent(BuildContext context) {
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
                    '14:30',
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '预计即将醒来',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155), // slate-700
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '醒后可能会有便便哦，建议提前准备尿不湿。',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B), // slate-500
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}