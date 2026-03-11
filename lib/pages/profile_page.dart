import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/profile/baby_add_sheet.dart';

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
    final isTestAccount = ref.watch(isTestAccountProvider);

    return Scaffold(
      body: ListView(
        children: [
          // 用户信息卡片
          _buildUserCard(context, currentUser, isGuest, isTestAccount),

          const SizedBox(height: 16),

          // 功能列表
          _buildMenuSection(context, isGuest, isTestAccount),

          // 测试数据功能区域
          _buildTestAccountSection(context, isTestAccount),
        ],
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserCard(BuildContext context, currentUser, bool isGuest, bool isTestAccount) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        // 测试账号显示特殊边框
        border: isTestAccount
            ? Border.all(color: Colors.orange.shade400, width: 2)
            : null,
      ),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 32,
            backgroundColor: isTestAccount
                ? Colors.orange.shade100
                : colorScheme.primaryContainer,
            child: Icon(
              isTestAccount
                  ? Icons.science
                  : (isGuest ? Icons.person_outline : Icons.person),
              size: 32,
              color: isTestAccount
                  ? Colors.orange.shade700
                  : colorScheme.onPrimaryContainer,
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
                if (isTestAccount)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '测试数据账号',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (isGuest)
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
          // 登录按钮（非测试账号时显示）
          if (isGuest && !isTestAccount)
            FilledButton.tonal(
              onPressed: () => _showLoginDialog(context),
              child: const Text('登录'),
            ),
        ],
      ),
    );
  }

  /// 构建菜单部分
  Widget _buildMenuSection(BuildContext context, bool isGuest, bool isTestAccount) {
    return Column(
      children: [
        // 宝宝管理
        _MenuTile(
          icon: Icons.child_care_outlined,
          title: '宝宝管理',
          subtitle: '添加和管理宝宝信息',
          onTap: () => _handleBabyManagementTap(context),
        ),
        const Divider(indent: 16, endIndent: 16),
        // 云同步设置
        _MenuTile(
          icon: Icons.cloud_sync_outlined,
          title: '云同步',
          subtitle: isGuest || isTestAccount ? '登录后可用' : '管理数据同步',
          isDisabled: isGuest || isTestAccount,
          onTap: () => _handleSyncTap(context, isGuest, isTestAccount),
        ),
        _MenuTile(
          icon: Icons.family_restroom_outlined,
          title: '家庭组',
          subtitle: isGuest || isTestAccount ? '登录后可用' : '管理家庭成员',
          isDisabled: isGuest || isTestAccount,
          onTap: () => _handleFamilyTap(context, isGuest, isTestAccount),
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

  /// 构建测试账号功能区域
  Widget _buildTestAccountSection(BuildContext context, bool isTestAccount) {
    final testDataState = ref.watch(testDataProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          if (isTestAccount) ...[
            // 清除测试数据按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: testDataState.isInjecting
                    ? null
                    : () => _showClearTestDataDialog(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('清除测试数据'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ] else ...[
            // 测试数据登录按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: testDataState.isInjecting
                    ? null
                    : () => _showTestDataLoginDialog(context),
                icon: const Icon(Icons.science),
                label: const Text('测试数据登录'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade700,
                  side: BorderSide(color: Colors.orange.shade400),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '仅供测试使用，将注入预设的测试数据',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          // 进度指示器
          if (testDataState.isInjecting) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: testDataState.progress),
            const SizedBox(height: 8),
            Text(
              '正在注入测试数据... ${(testDataState.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
          // 错误信息
          if (testDataState.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              testDataState.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// 显示测试数据登录确认对话框
  void _showTestDataLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.science, color: Colors.orange),
            SizedBox(width: 8),
            Text('测试数据登录'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('将注入预设的测试数据，包括：'),
            SizedBox(height: 8),
            Text('• 2个测试宝宝（3个月大 + 8个月大）'),
            Text('• 90天的活动记录'),
            Text('• 疫苗接种记录'),
            Text('• 生长记录'),
            SizedBox(height: 16),
            Text(
              '注意：现有数据将被覆盖！',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _injectTestData();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('确认注入'),
          ),
        ],
      ),
    );
  }

  /// 显示清除测试数据确认对话框
  void _showClearTestDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除测试数据'),
        content: const Text('确定要清除所有测试数据吗？\n\n此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _clearTestData();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('确认清除'),
          ),
        ],
      ),
    );
  }

  /// 注入测试数据
  Future<void> _injectTestData() async {
    final success = await ref.read(testDataProvider.notifier).injectTestData();

    if (mounted) {
      if (success) {
        // 刷新认证状态
        await ref.read(authProvider.notifier).refresh();
        // 刷新宝宝列表
        ref.invalidate(babiesProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('测试数据注入成功！'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('测试数据注入失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 清除测试数据
  Future<void> _clearTestData() async {
    final success = await ref.read(testDataProvider.notifier).clearTestData();

    if (mounted) {
      if (success) {
        // 刷新认证状态
        await ref.read(authProvider.notifier).refresh();
        // 刷新宝宝列表
        ref.invalidate(babiesProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('测试数据已清除'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('清除测试数据失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  /// 处理宝宝管理点击
  void _handleBabyManagementTap(BuildContext context) {
    BabyAddSheet.show(context);
  }

  /// 处理云同步点击
  void _handleSyncTap(BuildContext context, bool isGuest, bool isTestAccount) {
    if (isTestAccount) {
      _showTestAccountLimitDialog(context, '云同步');
    } else if (isGuest) {
      _showGuestLimitDialog(context, '云同步');
    } else {
      // TODO: 跳转到云同步设置页面
    }
  }

  /// 处理家庭组点击
  void _handleFamilyTap(BuildContext context, bool isGuest, bool isTestAccount) {
    if (isTestAccount) {
      _showTestAccountLimitDialog(context, '家庭组');
    } else if (isGuest) {
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

  /// 显示测试账号限制提示对话框
  void _showTestAccountLimitDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature功能'),
        content: const Text('测试数据账号不支持此功能。\n\n测试数据仅供功能测试使用，不支持云同步。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
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