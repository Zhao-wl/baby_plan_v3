import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

/// 主题状态管理 Notifier
///
/// 管理应用主题模式，支持读取、设置和持久化。
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // 从 Settings 中读取初始主题模式
    final settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.maybeWhen(
      data: (settings) => settings.themeMode,
      orElse: () => ThemeMode.system,
    );
  }

  /// 设置主题模式
  ///
  /// 更新状态并持久化到 SharedPreferences。
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(settingsProvider.notifier).setThemeMode(mode);
  }

  /// 切换到浅色模式
  Future<void> setLightMode() => setThemeMode(ThemeMode.light);

  /// 切换到深色模式
  Future<void> setDarkMode() => setThemeMode(ThemeMode.dark);

  /// 切换到跟随系统
  Future<void> setSystemMode() => setThemeMode(ThemeMode.system);

  /// 切换主题模式（循环切换）
  Future<void> toggleThemeMode() async {
    final nextMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(nextMode);
  }
}

/// 主题 Provider
///
/// 提供当前主题模式状态，支持动态切换。
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});