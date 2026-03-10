import 'package:shared_preferences/shared_preferences.dart';

import '../database/tables/activity_records.dart';

/// 计时器存储 key 常量
const String kTimerActivityType = 'timer_activity_type';
const String kTimerStartTime = 'timer_start_time';
const String kTimerIsPaused = 'timer_is_paused';
const String kTimerPausedDuration = 'timer_paused_duration';
const String kTimerPausedAt = 'timer_paused_at';
const String kTimerCurrentRecordId = 'timer_current_record_id';

/// 计时器存储服务
///
/// 封装 SharedPreferences 的读写操作，用于计时状态的持久化。
class TimerStorageService {
  final SharedPreferences _prefs;

  TimerStorageService(this._prefs);

  /// 保存计时状态
  Future<void> saveTimerState({
    required ActivityType? activityType,
    required DateTime? startTime,
    required bool isPaused,
    required Duration pausedDuration,
    DateTime? pausedAt,
    int? currentRecordId,
  }) async {
    if (activityType == null || startTime == null) {
      // 清除所有计时数据
      await clearTimerState();
      return;
    }

    await _prefs.setInt(kTimerActivityType, activityType.value);
    await _prefs.setString(kTimerStartTime, startTime.toIso8601String());
    await _prefs.setBool(kTimerIsPaused, isPaused);
    await _prefs.setInt(kTimerPausedDuration, pausedDuration.inSeconds);

    if (pausedAt != null) {
      await _prefs.setString(kTimerPausedAt, pausedAt.toIso8601String());
    } else {
      await _prefs.remove(kTimerPausedAt);
    }

    if (currentRecordId != null) {
      await _prefs.setInt(kTimerCurrentRecordId, currentRecordId);
    } else {
      await _prefs.remove(kTimerCurrentRecordId);
    }
  }

  /// 读取计时状态
  ///
  /// 返回一个 Map，包含所有保存的计时状态数据。
  /// 如果没有保存的数据，返回 null。
  Map<String, dynamic>? loadTimerState() {
    final activityTypeValue = _prefs.getInt(kTimerActivityType);
    final startTimeStr = _prefs.getString(kTimerStartTime);

    if (activityTypeValue == null || startTimeStr == null) {
      return null;
    }

    final isPaused = _prefs.getBool(kTimerIsPaused) ?? false;
    final pausedDurationSeconds = _prefs.getInt(kTimerPausedDuration) ?? 0;
    final pausedAtStr = _prefs.getString(kTimerPausedAt);
    final currentRecordId = _prefs.getInt(kTimerCurrentRecordId);

    return {
      'activityType': ActivityType.values.firstWhere(
        (t) => t.value == activityTypeValue,
        orElse: () => ActivityType.eat,
      ),
      'startTime': DateTime.parse(startTimeStr),
      'isPaused': isPaused,
      'pausedDuration': Duration(seconds: pausedDurationSeconds),
      'pausedAt': pausedAtStr != null ? DateTime.parse(pausedAtStr) : null,
      'currentRecordId': currentRecordId,
    };
  }

  /// 清除计时状态
  Future<void> clearTimerState() async {
    await _prefs.remove(kTimerActivityType);
    await _prefs.remove(kTimerStartTime);
    await _prefs.remove(kTimerIsPaused);
    await _prefs.remove(kTimerPausedDuration);
    await _prefs.remove(kTimerPausedAt);
    await _prefs.remove(kTimerCurrentRecordId);
  }
}