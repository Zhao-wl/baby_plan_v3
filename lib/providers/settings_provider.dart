import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Provider
///
/// 提供异步初始化的 SharedPreferences 实例。
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// 设置服务 Provider
///
/// 管理应用设置，包括当前选中宝宝 ID 的持久化。
class SettingsNotifier extends Notifier<AsyncValue<Settings>> {
  @override
  AsyncValue<Settings> build() {
    _loadSettings();
    return const AsyncValue.loading();
  }

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final currentBabyId = prefs.getString('currentBabyId');
      final lastSyncTime = prefs.getString('lastSyncTime');
      final themeModeString = prefs.getString('themeMode');
      return Settings(
        currentBabyId: currentBabyId != null ? int.tryParse(currentBabyId) : null,
        lastSyncTime: lastSyncTime != null ? DateTime.tryParse(lastSyncTime) : null,
        themeMode: _parseThemeMode(themeModeString),
      );
    });
  }

  /// 解析主题模式字符串
  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// 将主题模式转换为字符串
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// 获取当前宝宝 ID
  int? getCurrentBabyId() {
    return state.value?.currentBabyId;
  }

  /// 设置当前宝宝 ID
  Future<void> setCurrentBabyId(int? babyId) async {
    final currentValue = state.value;
    if (currentValue == null) return;

    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (babyId != null) {
      await prefs.setString('currentBabyId', babyId.toString());
    } else {
      await prefs.remove('currentBabyId');
    }
    state = AsyncValue.data(currentValue.copyWith(currentBabyId: babyId));
  }

  /// 获取上次同步时间
  DateTime? getLastSyncTime() {
    return state.value?.lastSyncTime;
  }

  /// 设置上次同步时间
  Future<void> setLastSyncTime(DateTime? time) async {
    final currentValue = state.value;
    if (currentValue == null) return;

    final prefs = await ref.read(sharedPreferencesProvider.future);
    if (time != null) {
      await prefs.setString('lastSyncTime', time.toIso8601String());
    } else {
      await prefs.remove('lastSyncTime');
    }
    state = AsyncValue.data(currentValue.copyWith(lastSyncTime: time));
  }

  /// 获取主题模式
  ThemeMode getThemeMode() {
    return state.value?.themeMode ?? ThemeMode.system;
  }

  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    final currentValue = state.value;
    if (currentValue == null) return;

    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('themeMode', _themeModeToString(mode));
    state = AsyncValue.data(currentValue.copyWith(themeMode: mode));
  }
}

/// 设置数据类
class Settings {
  final int? currentBabyId;
  final DateTime? lastSyncTime;
  final ThemeMode themeMode;

  const Settings({
    this.currentBabyId,
    this.lastSyncTime,
    this.themeMode = ThemeMode.system,
  });

  Settings copyWith({
    int? currentBabyId,
    DateTime? lastSyncTime,
    ThemeMode? themeMode,
  }) {
    return Settings(
      currentBabyId: currentBabyId ?? this.currentBabyId,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// 设置服务 Provider
final settingsProvider = NotifierProvider<SettingsNotifier, AsyncValue<Settings>>(() {
  return SettingsNotifier();
});