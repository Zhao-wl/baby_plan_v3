import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../utils/format_utils.dart';

/// 宝宝信息卡片组件
///
/// 显示当前选中宝宝的基本信息（一行紧凑布局）：
/// - 头像（或默认头像）
/// - 姓名 + 月龄
/// - 最新体重身高数据
/// - 设置按钮（占位）
class BabyInfoCard extends ConsumerWidget {
  const BabyInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBabyState = ref.watch(currentBabyProvider);
    final baby = currentBabyState.baby;

    // 加载中状态
    if (currentBabyState.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const SizedBox(height: 48),
      );
    }

    // 无宝宝状态
    if (baby == null) {
      return _buildEmptyState(context);
    }

    // 查询最新生长记录
    final growthAsync = ref.watch(latestGrowthRecordProvider(baby.id));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFB2DFDB), // teal-100
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: baby.avatarUrl != null && baby.avatarUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        baby.avatarUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Text('👶', style: TextStyle(fontSize: 24)),
                      ),
                    )
                  : const Text('👶', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          // 姓名和月龄
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baby.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B), // slate-800
                  ),
                ),
                const SizedBox(height: 2),
                growthAsync.when(
                  data: (growth) => Text(
                    _buildInfoText(baby.birthDate, growth),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B), // slate-500
                    ),
                  ),
                  loading: () => Text(
                    formatAge(baby.birthDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  error: (_, __) => Text(
                    formatAge(baby.birthDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 设置按钮（占位）
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: 导航到设置页面
              },
              icon: const Icon(
                Icons.person_outline,
                size: 18,
                color: Color(0xFF94A3B8), // slate-400
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建无宝宝状态
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9), // slate-100
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_care,
              size: 24,
              color: Color(0xFF94A3B8), // slate-400
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '还没有添加宝宝',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155), // slate-700
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '点击添加宝宝',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B), // slate-500
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              // TODO: 导航到添加宝宝页面
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  /// 构建信息文本
  String _buildInfoText(DateTime birthDate, dynamic growth) {
    final age = formatAge(birthDate);
    if (growth == null) {
      return '$age · --kg · --cm';
    }

    final weight = growth.weight != null
        ? '${growth.weight!.toStringAsFixed(1)}kg'
        : '--kg';
    final height = growth.height != null
        ? '${growth.height!.toStringAsFixed(1)}cm'
        : '--cm';

    return '$age · $weight · $height';
  }
}