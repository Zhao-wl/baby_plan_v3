import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables/activity_records.dart';
import 'activity_data_change_provider.dart';
import 'current_baby_provider.dart';
import 'database_provider.dart';
import 'timer_storage_provider.dart';

/// 计时器状态
///
/// 包含当前计时活动的所有状态信息。
class TimerState {
  /// 活动类型（null 表示无计时）
  final ActivityType? activityType;

  /// 开始时间
  final DateTime? startTime;

  /// 是否暂停
  final bool isPaused;

  /// 累计暂停时长
  final Duration pausedDuration;

  /// 暂停时间点（用于计算暂停时长）
  final DateTime? pausedAt;

  /// 当前进行中的活动记录 ID（用于更新记录）
  final int? currentRecordId;

  const TimerState({
    this.activityType,
    this.startTime,
    this.isPaused = false,
    this.pausedDuration = Duration.zero,
    this.pausedAt,
    this.currentRecordId,
  });

  /// 是否正在计时
  bool get isTiming => activityType != null && startTime != null;

  /// 获取当前已计时时长
  ///
  /// 计算公式：当前时间 - 开始时间 - 累计暂停时长
  /// 如果当前是暂停状态，则不增加时间。
  Duration get currentDuration {
    if (activityType == null || startTime == null) {
      return Duration.zero;
    }

    final now = DateTime.now();
    final elapsed = now.difference(startTime!);

    // 如果当前是暂停状态，不增加时间
    if (isPaused && pausedAt != null) {
      final currentPauseDuration = pausedAt!.difference(now);
      return elapsed - pausedDuration - currentPauseDuration;
    }

    return elapsed - pausedDuration;
  }

  /// 复制并修改状态
  TimerState copyWith({
    ActivityType? activityType,
    DateTime? startTime,
    bool? isPaused,
    Duration? pausedDuration,
    DateTime? pausedAt,
    int? currentRecordId,
    bool clearActivityType = false,
    bool clearStartTime = false,
    bool clearPausedAt = false,
    bool clearCurrentRecordId = false,
  }) {
    return TimerState(
      activityType: clearActivityType ? null : (activityType ?? this.activityType),
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      isPaused: isPaused ?? this.isPaused,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
      currentRecordId: clearCurrentRecordId ? null : (currentRecordId ?? this.currentRecordId),
    );
  }

  @override
  String toString() {
    return 'TimerState(activityType: $activityType, startTime: $startTime, '
        'isPaused: $isPaused, pausedDuration: $pausedDuration, pausedAt: $pausedAt, '
        'currentRecordId: $currentRecordId)';
  }
}

/// 计时器状态 Notifier
///
/// 管理活动计时的核心逻辑，包括：
/// - 开始、停止、暂停、继续、取消计时
/// - 切换活动类型
/// - 状态持久化
///
/// 初始化时优先从数据库恢复进行中活动状态，再用 SharedPreferences 补充暂停状态。
/// 使用 ref.listen 监听 currentBabyIdProvider 变化，确保页面刷新后正确恢复状态。
class TimerNotifier extends AsyncNotifier<TimerState> {
  @override
  Future<TimerState> build() async {
    // 监听宝宝 ID 变化，当宝宝切换或从 null 变为有效值时重新加载计时器状态
    ref.listen<int?>(currentBabyIdProvider, (previous, next) {
      if (previous != next) {
        // 宝宝 ID 变化时重新加载计时器状态
        _reloadTimerState(next);
      }
    });

    // 获取当前宝宝 ID
    final babyId = ref.read(currentBabyIdProvider);
    return _loadTimerStateFromDb(babyId);
  }

  /// 从数据库加载计时器状态
  ///
  /// 如果 babyId 为 null 或没有进行中活动，返回空的 TimerState。
  Future<TimerState> _loadTimerStateFromDb(int? babyId) async {
    if (babyId == null) {
      return const TimerState();
    }

    // 1. 从数据库查询进行中活动
    final db = ref.read(databaseProvider);
    final ongoingActivity = await db.getOngoingActivity(babyId);

    if (ongoingActivity == null) {
      // 无进行中活动，清除可能存在的旧状态
      await _clearPersistedState();
      return const TimerState();
    }

    // 2. 从 SharedPreferences 获取暂停状态（如果有）
    final pauseState = _loadPauseStateFromPrefs();

    // 3. 构建并返回状态
    return TimerState(
      activityType: ActivityType.values.firstWhere(
        (t) => t.value == ongoingActivity.type,
        orElse: () => ActivityType.eat,
      ),
      startTime: ongoingActivity.startTime,
      isPaused: pauseState.isPaused,
      pausedDuration: pauseState.pausedDuration,
      pausedAt: pauseState.pausedAt,
      currentRecordId: ongoingActivity.id,
    );
  }

  /// 重新加载计时器状态（当宝宝 ID 变化时调用）
  void _reloadTimerState(int? babyId) async {
    final newState = await _loadTimerStateFromDb(babyId);
    state = AsyncData(newState);
  }

  /// 从 SharedPreferences 加载暂停状态
  _PauseState _loadPauseStateFromPrefs() {
    try {
      final storage = ref.read(timerStorageServiceProvider);
      if (storage == null) return const _PauseState();

      final savedState = storage.loadTimerState();
      if (savedState == null) return const _PauseState();

      return _PauseState(
        isPaused: savedState['isPaused'] as bool? ?? false,
        pausedDuration: savedState['pausedDuration'] as Duration? ?? Duration.zero,
        pausedAt: savedState['pausedAt'] as DateTime?,
      );
    } catch (e) {
      return const _PauseState();
    }
  }

  /// 获取当前状态值（安全方式）
  TimerState? get _currentState => switch (state) {
    AsyncData(:final value) => value,
    _ => null,
  };

  /// 持久化当前状态
  Future<void> _persistState() async {
    final storage = ref.read(timerStorageServiceProvider);
    if (storage == null) return;

    final currentState = _currentState;
    await storage.saveTimerState(
      activityType: currentState?.activityType,
      startTime: currentState?.startTime,
      isPaused: currentState?.isPaused ?? false,
      pausedDuration: currentState?.pausedDuration ?? Duration.zero,
      pausedAt: currentState?.pausedAt,
      currentRecordId: currentState?.currentRecordId,
    );
  }

  /// 清除持久化数据
  Future<void> _clearPersistedState() async {
    final storage = ref.read(timerStorageServiceProvider);
    if (storage == null) return;

    await storage.clearTimerState();
  }

  /// 清除状态和持久化数据
  Future<void> _clearState() async {
    state = const AsyncData(TimerState());
    await _clearPersistedState();
  }

  /// 获取当前宝宝 ID
  int? get _currentBabyId => ref.read(currentBabyIdProvider);

  /// 开始计时
  ///
  /// [activityType] 活动类型
  /// 返回是否成功开始计时
  ///
  /// 在创建新活动前，会先检查是否有进行中活动：
  /// - 如果新活动开始时间 > 进行中活动开始时间，自动结束进行中活动
  /// - 如果新活动开始时间 <= 进行中活动开始时间，不结束进行中活动（保持数据一致性）
  /// 确保每个宝宝同时只有一条进行中活动。
  Future<bool> start(ActivityType activityType) async {
    // 验证当前宝宝存在
    final babyId = _currentBabyId;
    if (babyId == null) {
      return false;
    }

    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    // 先强制结束该宝宝开始时间早于当前时间的进行中活动
    // 这确保了只有新活动开始时间 > 进行中活动开始时间时才结束
    await db.forceEndOngoingActivities(babyId, beforeStartTime: now);

    // 创建"进行中"的活动记录（status=0）
    final recordId = await db.createOngoingActivity(
      babyId: babyId,
      type: activityType.value,
    );

    // 触发数据变化通知
    ref.read(activityDataChangeProvider.notifier).state++;

    state = AsyncData(TimerState(
      activityType: activityType,
      startTime: now,
      isPaused: false,
      pausedDuration: Duration.zero,
      currentRecordId: recordId,
    ));

    await _persistState();
    return true;
  }

  /// 停止计时并更新活动记录
  ///
  /// 返回活动记录 ID，如果失败返回 null
  Future<int?> stop() async {
    final currentState = _currentState;
    if (currentState == null || !currentState.isTiming) {
      return null;
    }

    final babyId = _currentBabyId;
    if (babyId == null) {
      await _clearState();
      return null;
    }

    // 计算时长
    final duration = currentState.currentDuration;

    // 时长少于1秒不保存，删除草稿记录
    if (duration.inSeconds < 1) {
      // 删除草稿记录
      if (currentState.currentRecordId != null) {
        final db = ref.read(databaseProvider);
        await (db.delete(db.activityRecords)
          ..where((t) => t.id.equals(currentState.currentRecordId!)))
            .go();
        ref.read(activityDataChangeProvider.notifier).notify();
      }
      await _clearState();
      return null;
    }

    // 更新现有记录，添加结束时间和时长
    final db = ref.read(databaseProvider);
    final endTime = DateTime.now();

    if (currentState.currentRecordId != null) {
      // 更新现有记录（使用级联操作符 ..where 指定记录）
      await (db.update(db.activityRecords)
            ..where((t) => t.id.equals(currentState.currentRecordId!)))
          .write(
            ActivityRecordsCompanion(
              endTime: Value(endTime),
              durationSeconds: Value(duration.inSeconds),
              status: const Value(1), // 已完成
              syncStatus: const Value(1), // 标记为待上传
            ),
          );
    } else {
      // 兼容：如果没有记录ID，创建新记录
      await db.into(db.activityRecords).insert(
        ActivityRecordsCompanion.insert(
          babyId: babyId,
          type: currentState.activityType!.value,
          startTime: currentState.startTime!,
          endTime: Value(endTime),
          durationSeconds: Value(duration.inSeconds),
        ),
      );
    }

    // 触发数据变化通知
    ref.read(activityDataChangeProvider.notifier).state++;

    final recordId = currentState.currentRecordId;
    await _clearState();
    return recordId;
  }

  /// 暂停计时
  Future<void> pause() async {
    final currentState = _currentState;
    if (currentState == null || !currentState.isTiming || currentState.isPaused) {
      return;
    }

    state = AsyncData(currentState.copyWith(
      isPaused: true,
      pausedAt: DateTime.now(),
    ));

    await _persistState();
  }

  /// 继续计时
  Future<void> resume() async {
    final currentState = _currentState;
    if (currentState == null || !currentState.isTiming || !currentState.isPaused) {
      return;
    }

    // 计算本次暂停时长
    final pausedAt = currentState.pausedAt ?? DateTime.now();
    final thisPauseDuration = DateTime.now().difference(pausedAt);

    state = AsyncData(currentState.copyWith(
      isPaused: false,
      pausedDuration: currentState.pausedDuration + thisPauseDuration,
      clearPausedAt: true,
    ));

    await _persistState();
  }

  /// 停止计时并返回时间信息（不自动保存）
  ///
  /// 用于需要弹出表单补充详情的场景
  /// 返回包含 startTime, endTime, duration, recordId 的 Map，如果失败返回 null
  Future<Map<String, dynamic>?> stopWithForm() async {
    final currentState = _currentState;
    if (currentState == null || !currentState.isTiming) {
      return null;
    }

    // 计算时长
    final duration = currentState.currentDuration;

    // 时长少于1秒不处理，删除草稿记录
    if (duration.inSeconds < 1) {
      if (currentState.currentRecordId != null) {
        final db = ref.read(databaseProvider);
        await (db.delete(db.activityRecords)
          ..where((t) => t.id.equals(currentState.currentRecordId!)))
            .go();
        ref.read(activityDataChangeProvider.notifier).notify();
      }
      await _clearState();
      return null;
    }

    final endTime = DateTime.now();
    final result = {
      'activityType': currentState.activityType,
      'startTime': currentState.startTime!,
      'endTime': endTime,
      'duration': duration,
      'recordId': currentState.currentRecordId,
    };

    // 清除状态但不删除记录，因为用户会在表单中更新它
    await _clearState();
    return result;
  }

  /// 取消计时（不保存记录）
  Future<void> cancel() async {
    final currentState = _currentState;
    if (currentState == null) return;

    // 删除草稿记录
    if (currentState.currentRecordId != null) {
      try {
        final db = ref.read(databaseProvider);
        await (db.delete(db.activityRecords)
          ..where((t) => t.id.equals(currentState.currentRecordId!)))
            .go();
        ref.read(activityDataChangeProvider.notifier).notify();
      } catch (e) {
        // 忽略删除失败
      }
    }
    await _clearState();
  }

  /// 切换活动类型
  ///
  /// 自动保存当前活动并开始新活动
  /// 返回新活动记录 ID，如果失败返回 null
  Future<int?> switchActivity(ActivityType newActivityType) async {
    final currentState = _currentState;

    // 如果当前正在计时相同活动，则停止
    if (currentState?.activityType == newActivityType) {
      return await stop();
    }

    // 如果当前有计时，先停止并保存
    if (currentState != null && currentState.isTiming) {
      await stop();
    }

    // 开始新活动
    final success = await start(newActivityType);
    return success ? -1 : null; // -1 表示成功开始新计时（非记录ID）
  }
}

/// 暂停状态（内部使用）
class _PauseState {
  final bool isPaused;
  final Duration pausedDuration;
  final DateTime? pausedAt;

  const _PauseState({
    this.isPaused = false,
    this.pausedDuration = Duration.zero,
    this.pausedAt,
  });
}

/// 计时器 Provider
final timerProvider = AsyncNotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});