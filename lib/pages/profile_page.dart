import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// 我的页面
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final authState = ref.watch(authProvider);
    final currentUser = authState.currentUser;
    final isGuest = authState.isGuest;

    return Scaffold(
      body: ListView(
        children: [
          // 用户信息卡片
          _buildUserCard(context, currentUser, isGuest),

          const SizedBox(height: 16),

          // 功能列表
          _buildMenuSection(context, isGuest),
        ],
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserCard(BuildContext context, currentUser, bool isGuest) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 32,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              isGuest ? Icons.person_outline : Icons.person,
              size: 32,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser?.nickname ?? '加载中...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                if (isGuest)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '游客模式',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 登录/设置按钮
          if (isGuest)
            FilledButton.tonal(
              onPressed: () => _showLoginDialog(context),
              child: const Text('登录'),
            ),
        ],
      ),
    );
  }

  /// 构建菜单部分
  Widget _buildMenuSection(BuildContext context, bool isGuest) {
    return Column(
      children: [
        // 云同步设置
        _MenuTile(
          icon: Icons.cloud_sync_outlined,
          title: '云同步',
          subtitle: isGuest ? '登录后可用' : '管理数据同步',
          isDisabled: isGuest,
          onTap: () => _handleSyncTap(context, isGuest),
        ),
        _MenuTile(
          icon: Icons.family_restroom_outlined,
          title: '家庭组',
          subtitle: isGuest ? '登录后可用' : '管理家庭成员',
          isDisabled: isGuest,
          onTap: () => _handleFamilyTap(context, isGuest),
        ),
        const Divider(indent: 16, endIndent: 16),
        _MenuTile(
          icon: Icons.settings_outlined,
          title: '设置',
          onTap: () {
            // TODO: 跳转到设置页面
          },
        ),
        _MenuTile(
          icon: Icons.help_outline,
          title: '帮助与反馈',
          onTap: () {
            // TODO: 跳转到帮助页面
          },
        ),
        _MenuTile(
          icon: Icons.info_outline,
          title: '关于',
          onTap: () {
            // TODO: 跳转到关于页面
          },
        ),
      ],
    );
  }

  /// 显示登录对话框（占位实现）
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登录账号'),
        content: const Text('登录功能即将上线，敬请期待！\n\n登录后可享受：\n• 云端数据同步\n• 家庭组功能\n• 多设备数据同步'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('登录功能即将上线')),
              );
            },
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  /// 处理云同步点击
  void _handleSyncTap(BuildContext context, bool isGuest) {
    if (isGuest) {
      _showGuestLimitDialog(context, '云同步');
    } else {
      // TODO: 跳转到云同步设置页面
    }
  }

  /// 处理家庭组点击
  void _handleFamilyTap(BuildContext context, bool isGuest) {
    if (isGuest) {
      _showGuestLimitDialog(context, '家庭组');
    } else {
      // TODO: 跳转到家庭组管理页面
    }
  }

  /// 显示游客限制提示对话框
  void _showGuestLimitDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature功能'),
        content: Text('游客模式暂不支持$feature功能。\n\n请登录账号后使用。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showLoginDialog(context);
            },
            child: const Text('登录'),
          ),
        ],
      ),
    );
  }
}

/// 菜单项组件
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDisabled;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isDisabled ? colorScheme.outline : colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDisabled ? colorScheme.outline : colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.outline,
              ),
            )
          : null,
      trailing: isDisabled
          ? null
          : Icon(
              Icons.chevron_right,
              color: colorScheme.outline,
            ),
      onTap: isDisabled ? null : onTap,
    );
  }
}