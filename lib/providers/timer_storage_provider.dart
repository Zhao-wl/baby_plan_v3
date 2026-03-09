import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/timer_storage_service.dart';
import 'settings_provider.dart';

/// TimerStorageService Provider
///
/// 提供计时器存储服务实例。
final timerStorageServiceProvider = Provider<TimerStorageService?>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);

  return prefsAsync.maybeWhen(
    data: (prefs) => TimerStorageService(prefs),
    orElse: () => null,
  );
});