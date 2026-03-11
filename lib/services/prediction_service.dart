import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/prediction_result.dart';

/// 预测服务
///
/// 负责基于历史数据和月龄基准计算宝宝下一项活动的预测。
/// 使用加权融合算法：历史数据 70% + 月龄基准 30%。
class PredictionService {
  /// 创建预测服务
  PredictionService(this._db);

  final AppDatabase _db;

  /// 历史数据窗口（天数）
  static const int historyWindowDays = 7;

  /// 预测合并时间窗口（分钟）
  static const int mergeWindowMinutes = 15;

  /// 最少历史记录数
  static const int minHistoryRecords = 5;

  /// 历史数据权重
  static const double historyWeight = 0.7;

  /// 月龄基准权重
  static const double benchmarkWeight = 0.3;

  /// 获取预测结果
  ///
  /// 基于历史数据和月龄基准计算下一项活动的预测。
  /// [babyId] 宝宝 ID
  /// [ageWeeks] 宝宝周龄
  /// [ongoingActivityType] 进行中的活动类型（如果有）
  Future<PredictionResult?> getPrediction({
    required int babyId,
    required int ageWeeks,
    int? ongoingActivityType,
  }) async {
    // 1. 查询最近7天的活动记录
    final recentActivities = await _queryRecentActivities(babyId);

    // 2. 判断历史数据是否充足
    final hasEnoughHistory = recentActivities.length >= minHistoryRecords;

    // 3. 计算各类型的预测
    final predictions = <PredictionResult>[];

    // 吃奶预测 (type = 0)
    if (ongoingActivityType != 0) {
      final eatPrediction = await _predictActivity(
        babyId: babyId,
        activityType: 0,
        ageWeeks: ageWeeks,
        recentActivities: recentActivities,
        hasEnoughHistory: hasEnoughHistory,
      );
      if (eatPrediction != null) {
        predictions.add(eatPrediction);
      }
    }

    // 睡眠预测 (type = 2)
    if (ongoingActivityType != 2) {
      final sleepPrediction = await _predictActivity(
        babyId: babyId,
        activityType: 2,
        ageWeeks: ageWeeks,
        recentActivities: recentActivities,
        hasEnoughHistory: hasEnoughHistory,
      );
      if (sleepPrediction != null) {
        predictions.add(sleepPrediction);
      }
    }

    // 排泄预测 (type = 3)
    if (ongoingActivityType != 3) {
      final poopPrediction = await _predictActivity(
        babyId: babyId,
        activityType: 3,
        ageWeeks: ageWeeks,
        recentActivities: recentActivities,
        hasEnoughHistory: hasEnoughHistory,
      );
      if (poopPrediction != null) {
        predictions.add(poopPrediction);
      }
    }

    // 4. 如果没有预测，返回 null
    if (predictions.isEmpty) {
      return null;
    }

    // 5. 合并15分钟内的预测
    return _mergePredictions(predictions, hasEnoughHistory);
  }

  /// 查询最近7天的活动记录
  Future<List<ActivityRecord>> _queryRecentActivities(int babyId) async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: historyWindowDays));

    return (_db.select(_db.activityRecords)
          ..where((a) => a.babyId.equals(babyId))
          ..where((a) => a.isDeleted.equals(false))
          ..where((a) => a.status.equals(1)) // 已完成的活动
          ..where((a) => a.startTime.isBiggerOrEqualValue(startDate))
          ..orderBy([(a) => OrderingTerm.desc(a.startTime)]))
        .get();
  }

  /// 计算单个活动类型的预测
  Future<PredictionResult?> _predictActivity({
    required int babyId,
    required int activityType,
    required int ageWeeks,
    required List<ActivityRecord> recentActivities,
    required bool hasEnoughHistory,
  }) async {
    // 过滤该类型的活动
    final typeActivities =
        recentActivities.where((a) => a.type == activityType).toList();

    // 获取最后一次该类型活动的时间
    final lastActivity = typeActivities.isNotEmpty ? typeActivities.first : null;
    if (lastActivity == null && !hasEnoughHistory) {
      // 没有历史记录且历史数据不足，完全依赖月龄基准
      return _predictFromBenchmarkOnly(activityType, ageWeeks);
    }

    // 计算历史模式
    int? historicalInterval;
    int? historicalDuration;

    if (typeActivities.length >= 2) {
      // 计算平均间隔
      final intervals = <int>[];
      for (int i = 0; i < typeActivities.length - 1; i++) {
        final interval = typeActivities[i].startTime
            .difference(typeActivities[i + 1].startTime)
            .inMinutes;
        if (interval > 0 && interval < 720) { // 排除异常值（超过12小时）
          intervals.add(interval);
        }
      }
      if (intervals.isNotEmpty) {
        historicalInterval =
            (intervals.reduce((a, b) => a + b) / intervals.length).round();
      }

      // 计算平均持续时间（仅对吃奶和睡眠）
      if (activityType == 0 || activityType == 2) {
        final durations = typeActivities
            .where((a) => a.durationSeconds != null)
            .map((a) => a.durationSeconds! ~/ 60)
            .where((d) => d > 0 && d < 360) // 排除异常值（超过6小时）
            .toList();
        if (durations.isNotEmpty) {
          historicalDuration =
              (durations.reduce((a, b) => a + b) / durations.length).round();
        }
      }
    }

    // 获取月龄基准数据
    final benchmark = await _db.getNearestPattern(ageWeeks, activityType);

    // 计算预测时间
    final now = DateTime.now();
    DateTime predictedTime;

    if (hasEnoughHistory && historicalInterval != null && lastActivity != null) {
      if (benchmark != null) {
        // 加权融合：历史 70% + 基准 30%
        final interval = (historicalInterval * historyWeight +
                benchmark.intervalMinutes * benchmarkWeight)
            .round();
        predictedTime = lastActivity.startTime.add(Duration(minutes: interval));
      } else {
        // 没有基准数据，完全使用历史数据
        predictedTime = lastActivity.startTime
            .add(Duration(minutes: historicalInterval));
      }
    } else if (benchmark != null) {
      // 历史数据不足，使用月龄基准
      if (lastActivity != null) {
        predictedTime = lastActivity.startTime.add(Duration(minutes: benchmark.intervalMinutes));
      } else {
        predictedTime = now.add(Duration(minutes: benchmark.intervalMinutes));
      }
    } else {
      // 既没有足够历史数据，也没有基准数据，无法预测
      return null;
    }

    // 如果预测时间已过，调整为当前时间之后
    if (predictedTime.isBefore(now)) {
      // 计算时间差，推算下一个预测时间
      final interval = historicalInterval ?? benchmark?.intervalMinutes ?? 180;
      while (predictedTime.isBefore(now)) {
        predictedTime = predictedTime.add(Duration(minutes: interval));
      }
    }

    // 构建预测结果
    return _buildPredictionResult(
      activityType: activityType,
      predictedTime: predictedTime,
      historicalInterval: historicalInterval,
      historicalDuration: historicalDuration,
      benchmark: benchmark,
      hasEnoughHistory: hasEnoughHistory,
    );
  }

  /// 完全基于月龄基准的预测
  Future<PredictionResult?> _predictFromBenchmarkOnly(
      int activityType, int ageWeeks) async {
    final benchmark = await _db.getNearestPattern(ageWeeks, activityType);
    if (benchmark == null) {
      return null;
    }

    final now = DateTime.now();
    final predictedTime =
        now.add(Duration(minutes: benchmark.intervalMinutes));

    return _buildPredictionResult(
      activityType: activityType,
      predictedTime: predictedTime,
      historicalInterval: null,
      historicalDuration: null,
      benchmark: benchmark,
      hasEnoughHistory: false,
    );
  }

  /// 构建预测结果
  PredictionResult _buildPredictionResult({
    required int activityType,
    required DateTime predictedTime,
    required int? historicalInterval,
    required int? historicalDuration,
    required AgeActivityPattern? benchmark,
    required bool hasEnoughHistory,
  }) {
    final type = PredictionType.fromValue(activityType);
    if (type == null) {
      throw ArgumentError('Invalid activity type: $activityType');
    }

    // 计算置信度
    double confidence;
    if (hasEnoughHistory && historicalInterval != null) {
      confidence = 0.8; // 有历史数据时置信度较高
    } else if (benchmark != null) {
      confidence = 0.5; // 仅基准数据时置信度较低
    } else {
      confidence = 0.3; // 数据不足
    }

    // 构建描述
    String description;
    String? tips;

    switch (type) {
      case PredictionType.eat:
        description = '预计需要喂奶';
        if (historicalDuration != null && historicalDuration > 0) {
          tips = '通常每次喂奶约 $historicalDuration 分钟';
        } else if (benchmark?.durationMinutes != null) {
          tips = '建议准备 ${benchmark!.durationMinutes} 分钟左右的喂养时间';
        }
        break;
      case PredictionType.sleep:
        description = '预计需要小睡';
        if (historicalDuration != null && historicalDuration > 0) {
          tips = '通常小睡约 $historicalDuration 分钟';
        } else if (benchmark?.durationMinutes != null) {
          tips = '预计睡眠时长约 ${benchmark!.durationMinutes} 分钟';
        }
        break;
      case PredictionType.poop:
        description = '可能需要换尿布';
        tips = '建议检查尿布状态';
        break;
    }

    return PredictionResult(
      type: type,
      predictedTime: predictedTime,
      confidence: confidence,
      description: description,
      tips: tips,
      isBasedOnAgeBenchmark: !hasEnoughHistory,
    );
  }

  /// 合并15分钟内的预测
  PredictionResult _mergePredictions(
      List<PredictionResult> predictions, bool hasEnoughHistory) {
    // 按预测时间排序
    predictions.sort((a, b) => a.predictedTime.compareTo(b.predictedTime));

    // 取最近的预测作为主预测
    final mainPrediction = predictions.first;

    // 找出15分钟内的其他预测
    final relatedPredictions = predictions.skip(1).where((p) {
      final diff = p.predictedTime.difference(mainPrediction.predictedTime).inMinutes.abs();
      return diff <= mergeWindowMinutes;
    }).toList();

    // 如果有关联预测，构建合并预测
    if (relatedPredictions.isNotEmpty) {
      // 更新提示信息
      final tips = _buildMergedTips(mainPrediction, relatedPredictions);

      return mainPrediction.copyWith(
        relatedPredictions: relatedPredictions,
        tips: tips,
      );
    }

    return mainPrediction;
  }

  /// 构建合并预测的提示
  String _buildMergedTips(
      PredictionResult main, List<PredictionResult> related) {
    final tips = <String>[];

    if (main.type == PredictionType.sleep) {
      // 睡眠预测为主，检查是否有排泄预测
      final hasPoopPrediction =
          related.any((p) => p.type == PredictionType.poop);
      if (hasPoopPrediction) {
        tips.add('醒后可能需要换尿布');
      }
    } else if (main.type == PredictionType.eat) {
      // 吃奶预测为主
      final hasPoopPrediction =
          related.any((p) => p.type == PredictionType.poop);
      if (hasPoopPrediction) {
        tips.add('喂奶后可能需要换尿布');
      }
    }

    if (tips.isEmpty && related.isNotEmpty) {
      tips.add('同时可能${related.first.type.label}');
    }

    return tips.join('，');
  }
}