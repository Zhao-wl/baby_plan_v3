import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/awake_stage.dart';
import '../models/prediction_result.dart';
import '../models/time_slot.dart';
import '../services/prediction_service.dart';
import 'activity_data_change_provider.dart';
import 'current_baby_provider.dart';
import 'database_provider.dart';
import 'ongoing_activity_provider.dart';

/// 预测服务 Provider
final predictionServiceProvider = Provider<PredictionService>((ref) {
  final db = ref.watch(databaseProvider);
  return PredictionService(db);
});

/// 已处理预测的 Notifier
class ProcessedPredictionsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  /// 添加已处理的预测
  void add(String predictionKey) {
    state = {...state, predictionKey};
  }

  /// 清除所有已处理标记
  void clear() {
    state = {};
  }
}

/// 已处理预测的内存标记
///
/// 存储用户已标记为"已处理"的预测 ID。
/// 注意：这是内存中的 Set，应用重启后会清空。
final processedPredictionsProvider =
    NotifierProvider<ProcessedPredictionsNotifier, Set<String>>(() {
  return ProcessedPredictionsNotifier();
});

/// 最后一次睡眠信息 Provider
///
/// 返回最近一次已完成睡眠的结束时间，用于计算睡眠阶段。
final lastSleepProvider = FutureProvider<DateTime?>((ref) async {
  final currentBabyState = ref.watch(currentBabyProvider);
  final baby = currentBabyState.baby;

  if (baby == null) {
    return null;
  }

  final db = ref.watch(databaseProvider);
  final lastSleep = await db.getLastCompletedSleep(baby.id);

  return lastSleep?.endTime;
});

/// 预测 Provider
///
/// 提供当前宝宝的下一项活动预测。
/// 监听活动数据变化，自动重新计算预测。
/// 支持时段感知和睡眠阶段维度。
final predictionProvider =
    FutureProvider<PredictionResult?>((ref) async {
  // 监听活动数据变化
  ref.watch(activityDataChangeProvider);

  // 获取当前宝宝
  final currentBabyState = ref.watch(currentBabyProvider);
  final baby = currentBabyState.baby;

  if (baby == null) {
    return null;
  }

  // 计算宝宝周龄
  final ageWeeks = _calculateAgeInWeeks(baby.birthDate);

  // 获取进行中的活动
  final ongoingActivity = await ref.watch(
    ongoingActivityProvider(baby.id).future,
  );

  // 获取最后一次睡眠结束时间
  final lastSleepEndTime = await ref.watch(lastSleepProvider.future);

  // 获取预测
  final predictionService = ref.watch(predictionServiceProvider);
  final prediction = await predictionService.getPrediction(
    babyId: baby.id,
    ageWeeks: ageWeeks,
    ongoingActivityType: ongoingActivity?.type,
    lastSleepEndTime: lastSleepEndTime,
  );

  // 检查是否已被标记为已处理
  if (prediction != null) {
    final processedPredictions = ref.watch(processedPredictionsProvider);
    final predictionKey = _generatePredictionKey(prediction);
    if (processedPredictions.contains(predictionKey)) {
      // 该预测已被处理，返回 null
      return null;
    }
  }

  return prediction;
});

/// 预测状态 Provider
///
/// 提供完整的预测状态，包括时段信息、睡眠阶段等。
/// 注意：夜间模式不再禁用预测，仅用于 UI 显示调整。
final predictionStateProvider =
    FutureProvider<PredictionState>((ref) async {
  // 获取当前时段
  final currentTimeSlot = TimeSlot.fromDateTime(DateTime.now());

  // 检查夜间模式（用于 UI 显示调整，不阻止预测）
  final isNightMode = currentTimeSlot.isNight;

  // 获取当前宝宝
  final currentBabyState = ref.watch(currentBabyProvider);
  final baby = currentBabyState.baby;

  if (baby == null) {
    return PredictionState(
      timeSlot: currentTimeSlot,
      isNightMode: isNightMode,
    );
  }

  // 获取进行中的活动
  final ongoingActivity = await ref.watch(
    ongoingActivityProvider(baby.id).future,
  );

  // 获取最后一次睡眠结束时间，计算睡眠阶段
  final lastSleepEndTime = await ref.watch(lastSleepProvider.future);
  final awakeStage = lastSleepEndTime != null
      ? AwakeStage.fromSleepEndTime(lastSleepEndTime)
      : null;

  // 获取预测
  final prediction = await ref.watch(predictionProvider.future);

  // 检查数据是否不足
  final hasInsufficientData = prediction?.isBasedOnAgeBenchmark ?? true;

  return PredictionState(
    prediction: prediction,
    isLoading: false,
    isNightMode: isNightMode,
    ongoingActivityType: ongoingActivity?.type,
    hasInsufficientData: hasInsufficientData,
    timeSlot: currentTimeSlot,
    awakeStage: awakeStage,
  );
});

/// 标记预测为已处理
///
/// 将当前预测标记为已处理，之后该预测不再显示。
void markPredictionAsProcessed(WidgetRef ref, PredictionResult prediction) {
  final predictionKey = _generatePredictionKey(prediction);
  ref.read(processedPredictionsProvider.notifier).add(predictionKey);
}

/// 清除所有已处理标记
///
/// 清除内存中的所有已处理预测标记。
void clearProcessedPredictions(WidgetRef ref) {
  ref.read(processedPredictionsProvider.notifier).clear();
}

/// 计算年龄（周）
int _calculateAgeInWeeks(DateTime birthDate) {
  final now = DateTime.now();
  final difference = now.difference(birthDate);
  return (difference.inDays / 7).floor();
}

/// 生成预测的唯一标识
///
/// 基于预测类型和时间生成一个唯一标识，用于判断是否为相同的预测。
String _generatePredictionKey(PredictionResult prediction) {
  // 使用预测类型和时间（精确到分钟）作为标识
  final timeKey =
      '${prediction.predictedTime.year}'
      '${prediction.predictedTime.month}'
      '${prediction.predictedTime.day}'
      '${prediction.predictedTime.hour}'
      '${prediction.predictedTime.minute}';
  return '${prediction.type.value}_$timeKey';
}