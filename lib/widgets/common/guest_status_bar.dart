import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

/// 游客状态提示栏
///
/// 在首页顶部显示游客模式提示，提醒用户当前为游客身份。
/// 点击可查看详细说明。
class GuestStatusBar extends ConsumerWidget {
  const GuestStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);

    // 非游客模式不显示
    if (!isGuest) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showGuestInfoDialog(context),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '游客模式 · 数据仅保存在本设备',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示游客模式说明对话框
  void _showGuestInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 8),
            Text('游客模式'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('您当前以游客身份使用本应用。'),
            SizedBox(height: 16),
            Text('游客模式说明：',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _InfoItem(icon: Icons.check_circle, text: '可使用所有离线功能'),
            _InfoItem(icon: Icons.check_circle, text: '可记录宝宝活动和成长'),
            SizedBox(height: 8),
            _InfoItem(icon: Icons.cancel_outlined, text: '无法使用云同步功能'),
            _InfoItem(icon: Icons.cancel_outlined, text: '无法创建或加入家庭组'),
            SizedBox(height: 16),
            Text('⚠️ 数据仅保存在本设备，卸载应用或更换设备将丢失数据。',
                style: TextStyle(color: Colors.orange)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('我知道了'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 跳转到登录/升级页面
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('登录功能即将上线')),
              );
            },
            child: const Text('登录账号'),
          ),
        ],
      ),
    );
  }
}

/// 信息项组件
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}