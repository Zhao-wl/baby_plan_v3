import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables/activity_records.dart';
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

  const TimerState({
    this.activityType,
    this.startTime,
    this.isPaused = false,
    this.pausedDuration = Duration.zero,
    this.pausedAt,
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
    bool clearActivityType = false,
    bool clearStartTime = false,
    bool clearPausedAt = false,
  }) {
    return TimerState(
      activityType: clearActivityType ? null : (activityType ?? this.activityType),
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      isPaused: isPaused ?? this.isPaused,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
    );
  }

  @override
  String toString() {
    return 'TimerState(activityType: $activityType, startTime: $startTime, '
        'isPaused: $isPaused, pausedDuration: $pausedDuration, pausedAt: $pausedAt)';
  }
}

/// 计时器状态 Notifier
///
/// 管理活动计时的核心逻辑，包括：
/// - 开始、停止、暂停、继续、取消计时
/// - 切换活动类型
/// - 状态持久化
class TimerNotifier extends Notifier<TimerState> {
  @override
  TimerState build() {
    // 从 SharedPreferences 恢复计时状态
    _restoreTimerState();
    return const TimerState();
  }

  /// 从持久化存储恢复计时状态
  void _restoreTimerState() {
    try {
      final storage = ref.read(timerStorageServiceProvider);
      if (storage == null) return;

      final savedState = storage.loadTimerState();

      if (savedState != null) {
        state = TimerState(
          activityType: savedState['activityType'] as ActivityType,
          startTime: savedState['startTime'] as DateTime,
          isPaused: savedState['isPaused'] as bool,
          pausedDuration: savedState['pausedDuration'] as Duration,
          pausedAt: savedState['pausedAt'] as DateTime?,
        );
      }
    } catch (e) {
      // 恢复失败时保持初始状态
      state = const TimerState();
    }
  }

  /// 持久化当前状态
  Future<void> _persistState() async {
    final storage = ref.read(timerStorageServiceProvider);
    if (storage == null) return;

    await storage.saveTimerState(
      activityType: state.activityType,
      startTime: state.startTime,
      isPaused: state.isPaused,
      pausedDuration: state.pausedDuration,
      pausedAt: state.pausedAt,
    );
  }

  /// 清除状态和持久化数据
  Future<void> _clearState() async {
    state = const TimerState();
    final storage = ref.read(timerStorageServiceProvider);
    if (storage == null) return;

    await storage.clearTimerState();
  }

  /// 获取当前宝宝 ID
  int? get _currentBabyId => ref.read(currentBabyIdProvider);

  /// 开始计时
  ///
  /// [activityType] 活动类型
  /// 返回是否成功开始计时
  Future<bool> start(ActivityType activityType) async {
    // 验证当前宝宝存在
    final babyId = _currentBabyId;
    if (babyId == null) {
      return false;
    }

    final now = DateTime.now();
    state = TimerState(
      activityType: activityType,
      startTime: now,
      isPaused: false,
      pausedDuration: Duration.zero,
    );

    await _persistState();
    return true;
  }

  /// 停止计时并生成活动记录
  ///
  /// 返回生成的活动记录 ID，如果失败返回 null
  Future<int?> stop() async {
    if (!state.isTiming) {
      return null;
    }

    final babyId = _currentBabyId;
    if (babyId == null) {
      await _clearState();
      return null;
    }

    // 计算时长
    final duration = state.currentDuration;

    // 时长少于1秒不保存
    if (duration.inSeconds < 1) {
      await _clearState();
      return null;
    }

    // 创建活动记录
    final db = ref.read(databaseProvider);
    final endTime = DateTime.now();

    final recordId = await db.into(db.activityRecords).insert(
          ActivityRecordsCompanion.insert(
            babyId: babyId,
            type: state.activityType!.value,
            startTime: state.startTime!,
            endTime: Value(endTime),
            durationSeconds: Value(duration.inSeconds),
          ),
        );

    await _clearState();
    return recordId;
  }

  /// 暂停计时
  Future<void> pause() async {
    if (!state.isTiming || state.isPaused) {
      return;
    }

    state = state.copyWith(
      isPaused: true,
      pausedAt: DateTime.now(),
    );

    await _persistState();
  }

  /// 继续计时
  Future<void> resume() async {
    if (!state.isTiming || !state.isPaused) {
      return;
    }

    // 计算本次暂停时长
    final pausedAt = state.pausedAt ?? DateTime.now();
    final thisPauseDuration = DateTime.now().difference(pausedAt);

    state = state.copyWith(
      isPaused: false,
      pausedDuration: state.pausedDuration + thisPauseDuration,
      clearPausedAt: true,
    );

    await _persistState();
  }

  /// 停止计时并返回时间信息（不自动保存）
  ///
  /// 用于需要弹出表单补充详情的场景
  /// 返回包含 startTime, endTime, duration 的 Map，如果失败返回 null
  Future<Map<String, dynamic>?> stopWithForm() async {
    if (!state.isTiming) {
      return null;
    }

    // 计算时长
    final duration = state.currentDuration;

    // 时长少于1秒不处理
    if (duration.inSeconds < 1) {
      await _clearState();
      return null;
    }

    final endTime = DateTime.now();
    final result = {
      'activityType': state.activityType,
      'startTime': state.startTime!,
      'endTime': endTime,
      'duration': duration,
    };

    await _clearState();
    return result;
  }

  /// 取消计时（不保存记录）
  Future<void> cancel() async {
    await _clearState();
  }

  /// 切换活动类型
  ///
  /// 自动保存当前活动并开始新活动
  /// 返回新活动记录 ID，如果失败返回 null
  Future<int?> switchActivity(ActivityType newActivityType) async {
    // 如果当前正在计时相同活动，则停止
    if (state.activityType == newActivityType) {
      return await stop();
    }

    // 如果当前有计时，先停止并保存
    if (state.isTiming) {
      await stop();
    }

    // 开始新活动
    final success = await start(newActivityType);
    return success ? -1 : null; // -1 表示成功开始新计时（非记录ID）
  }
}

/// 计时器 Provider
final timerProvider = NotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});