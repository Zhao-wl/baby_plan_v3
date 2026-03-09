import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_skill/flutter_skill.dart';

import 'pages/main_page.dart';
import 'providers/providers.dart';
import 'theme/app_theme.dart';

void main() {
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
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const MainPage(),
    );
  }
}