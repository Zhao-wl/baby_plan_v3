import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_skill/flutter_skill.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'pages/main_page.dart';
import 'providers/providers.dart';
import 'theme/app_theme.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化时区数据库（用于定时通知）
  tz.initializeTimeZones();

  if (kDebugMode) FlutterSkillBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 初始化通知服务
    _initNotificationService();
  }

  /// 初始化通知服务
  Future<void> _initNotificationService() async {
    final notificationService = ref.read(notificationServiceProvider);

    // 初始化通知服务
    await notificationService.initialize(
      onNotificationTapped: _onNotificationTapped,
    );

    // 检查并请求权限
    final permissionNotifier = ref.read(notificationPermissionProvider.notifier);
    await permissionNotifier.checkPermission();

    // 如果未授权且支持通知，请求权限
    final permissionState = ref.read(notificationPermissionProvider);
    if (permissionState == NotificationPermissionState.notDetermined) {
      await permissionNotifier.requestPermission();
    }

    // 恢复即将到来的疫苗提醒
    await _restoreVaccineReminders();
  }

  /// 处理通知点击
  void _onNotificationTapped(String? payload) {
    if (payload == null) return;

    // 解析 payload，格式: "vaccine:123"
    if (payload.startsWith('vaccine:')) {
      final recordId = int.tryParse(payload.substring(8));
      if (recordId != null) {
        // TODO: 跳转到疫苗详情页
        // 当前疫苗页面尚未实现完整功能
        debugPrint('通知点击：跳转到疫苗记录 $recordId');
      }
    }
  }

  /// 恢复即将到来的疫苗提醒
  Future<void> _restoreVaccineReminders() async {
    final currentBabyId = ref.read(currentBabyIdProvider);
    if (currentBabyId == null) return;

    try {
      await ref.read(notificationOperationProvider.notifier)
          .restoreUpcomingReminders(currentBabyId);
    } catch (e) {
      debugPrint('恢复疫苗提醒失败: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    super.didChangeAppLifecycleState(lifecycleState);

    // 当 App 进入后台时，确保计时状态已持久化
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      // TimerNotifier 已在每次状态变更时自动持久化
      // 这里可以添加额外的保存逻辑（如果需要）
    }

    // 当 App 恢复前台时，重新计算时长
    if (lifecycleState == AppLifecycleState.resumed) {
      // 触发状态重建以更新计时时长
      ref.invalidate(timerProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'E.A.S.Y. 育儿助手',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const MainPage(),
    );
  }
}