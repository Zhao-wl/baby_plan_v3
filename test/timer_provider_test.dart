import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baby_plan_v3/database/tables/activity_records.dart';
import 'package:baby_plan_v3/providers/timer_provider.dart';
import 'package:baby_plan_v3/services/timer_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimerState', () {
    test('初始状态应该是空闲状态', () {
      const state = TimerState();

      expect(state.activityType, isNull);
      expect(state.startTime, isNull);
      expect(state.isPaused, false);
      expect(state.pausedDuration, Duration.zero);
      expect(state.isTiming, false);
      expect(state.currentDuration, Duration.zero);
    });

    test('currentDuration 应该正确计算已计时时长', () {
      final startTime = DateTime.now().subtract(const Duration(minutes: 5));
      final state = TimerState(
        activityType: ActivityType.sleep,
        startTime: startTime,
        isPaused: false,
      );

      // 允许 1 秒误差
      expect(state.currentDuration.inMinutes, closeTo(5, 1));
    });

    test('isTiming 应该正确判断计时状态', () {
      // 无活动类型
      expect(
        TimerState(activityType: null, startTime: DateTime.now()).isTiming,
        false,
      );

      // 无开始时间
      expect(
        TimerState(activityType: ActivityType.eat, startTime: null).isTiming,
        false,
      );

      // 完整状态
      expect(
        TimerState(
          activityType: ActivityType.sleep,
          startTime: DateTime.now(),
        ).isTiming,
        true,
      );
    });

    test('暂停状态下 currentDuration 不应该增加', () {
      final startTime = DateTime.now().subtract(const Duration(minutes: 5));
      final pausedAt = DateTime.now().subtract(const Duration(minutes: 2));
      final state = TimerState(
        activityType: ActivityType.sleep,
        startTime: startTime,
        isPaused: true,
        pausedAt: pausedAt,
      );

      // 暂停状态下，isTiming 仍然为 true
      expect(state.isTiming, true);
      expect(state.isPaused, true);
    });

    test('copyWith 应该正确复制和修改状态', () {
      final original = TimerState(
        activityType: ActivityType.eat,
        startTime: DateTime.now(),
        isPaused: true,
        pausedDuration: const Duration(minutes: 1),
      );

      final copied = original.copyWith(isPaused: false);

      expect(copied.activityType, original.activityType);
      expect(copied.startTime, original.startTime);
      expect(copied.isPaused, false);
      expect(copied.pausedDuration, original.pausedDuration);
    });

    test('copyWith 的 clear 参数应该正确清除字段', () {
      final original = TimerState(
        activityType: ActivityType.eat,
        startTime: DateTime.now(),
        pausedAt: DateTime.now(),
      );

      final cleared = original.copyWith(
        clearActivityType: true,
        clearStartTime: true,
        clearPausedAt: true,
      );

      expect(cleared.activityType, isNull);
      expect(cleared.startTime, isNull);
      expect(cleared.pausedAt, isNull);
    });
  });

  group('TimerStorageService', () {
    late SharedPreferences prefs;
    late TimerStorageService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = TimerStorageService(prefs);
    });

    test('保存和加载计时状态', () async {
      final startTime = DateTime.now();

      await service.saveTimerState(
        activityType: ActivityType.sleep,
        startTime: startTime,
        isPaused: false,
        pausedDuration: const Duration(minutes: 5),
      );

      final loaded = service.loadTimerState();

      expect(loaded, isNotNull);
      expect(loaded!['activityType'], ActivityType.sleep);
      expect(loaded['startTime'], startTime);
      expect(loaded['isPaused'], false);
      expect(loaded['pausedDuration'], const Duration(minutes: 5));
    });

    test('清除计时状态', () async {
      await service.saveTimerState(
        activityType: ActivityType.eat,
        startTime: DateTime.now(),
        isPaused: false,
        pausedDuration: Duration.zero,
      );

      await service.clearTimerState();

      final loaded = service.loadTimerState();
      expect(loaded, isNull);
    });

    test('暂停状态保存和加载', () async {
      final pausedAt = DateTime.now();

      await service.saveTimerState(
        activityType: ActivityType.activity,
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        isPaused: true,
        pausedDuration: const Duration(minutes: 2),
        pausedAt: pausedAt,
      );

      final loaded = service.loadTimerState();

      expect(loaded, isNotNull);
      expect(loaded!['isPaused'], true);
      expect(loaded['pausedAt'], pausedAt);
    });

    test('无计时状态时 loadTimerState 返回 null', () {
      final loaded = service.loadTimerState();
      expect(loaded, isNull);
    });

    test('保存 null 活动类型应该清除所有数据', () async {
      // 先保存一些数据
      await service.saveTimerState(
        activityType: ActivityType.sleep,
        startTime: DateTime.now(),
        isPaused: false,
        pausedDuration: Duration.zero,
      );

      // 保存 null 活动类型
      await service.saveTimerState(
        activityType: null,
        startTime: null,
        isPaused: false,
        pausedDuration: Duration.zero,
      );

      final loaded = service.loadTimerState();
      expect(loaded, isNull);
    });
  });
}