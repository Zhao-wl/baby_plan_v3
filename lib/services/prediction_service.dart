import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/awake_stage.dart';
import '../models/prediction_result.dart';
import '../models/time_slot.dart';
import '../models/time_slot_pattern.dart';

/// 预测服务
///
/// 负责基于历史数据和月龄基准计算宝宝下一项活动的预测。
/// 使用三元加权融合算法：时段历史 + 全天历史 + 月龄基准。
class PredictionService {
  /// 创建预测服务
  PredictionService(this._db);

  final AppDatabase _db;

  /// 历史数据窗口（天数）- 扩展到14天以获取更多时段样本
  static const int historyWindowDays = 14;

  /// 预测合并时间窗口（分钟）
  static const int mergeWindowMinutes = 15;

  /// 最少历史记录数
  static const int minHistoryRecords = 5;

  /// 时段样本充足的阈值
  static const int timeSlotMinSamples = 3;

  // ========== 权重配置 ==========

  /// 时段样本充足时的时段权重
  static const double timeSlotWeightHigh = 0.4;

  /// 时段样本充足时的全天权重
  static const double globalHistoryWeightHigh = 0.3;

  /// 时段样本不足时的时段权重
  static const double timeSlotWeightLow = 0.2;

  /// 时段样本不足时的全天权重
  static const double globalHistoryWeightLow = 0.5;

  /// 月龄基准权重
  static const double benchmarkWeight = 0.3;

  /// 获取预测结果
  ///
  /// 基于历史数据和月龄基准计算下一项活动的预测。
  /// [babyId] 宝宝 ID
  /// [ageWeeks] 宝宝周龄
  /// [ongoingActivityType] 进行中的活动类型（如果有）
  /// [lastSleepEndTime] 最近一次睡眠结束时间（用于计算睡眠阶段）
  Future<PredictionResult?> getPrediction({
    required int babyId,
    required int ageWeeks,
    int? ongoingActivityType,
    DateTime? lastSleepEndTime,
  }) async {
    final now = DateTime.now();
    final currentTimeSlot = TimeSlot.fromDateTime(now);
    final awakeStage = lastSleepEndTime != null
        ? AwakeStage.fromSleepEndTime(lastSleepEndTime, now)
        : null;

    // 1. 查询最近14天的活动记录
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
        currentTimeSlot: currentTimeSlot,
        awakeStage: awakeStage,
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
        currentTimeSlot: currentTimeSlot,
        awakeStage: awakeStage,
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
        currentTimeSlot: currentTimeSlot,
        awakeStage: awakeStage,
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
    return _mergePredictions(
      predictions: predictions,
      hasEnoughHistory: hasEnoughHistory,
      timeSlot: currentTimeSlot,
      awakeStage: awakeStage,
    );
  }

  /// 查询最近14天的活动记录
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

  /// 计算单个活动类型的预测（时段感知）
  Future<PredictionResult?> _predictActivity({
    required int babyId,
    required int activityType,
    required int ageWeeks,
    required List<ActivityRecord> recentActivities,
    required bool hasEnoughHistory,
    required TimeSlot currentTimeSlot,
    AwakeStage? awakeStage,
  }) async {
    final now = DateTime.now();
    print('[PredictionService] ========== 开始预测活动类型 $activityType ==========');
    print('[PredictionService] 当前时间: $now');
    print('[PredictionService] 当前时段: $currentTimeSlot');

    // 过滤该类型的活动
    final typeActivities =
        recentActivities.where((a) => a.type == activityType).toList();

    // 获取最后一次该类型活动的时间（排除未来时间的数据）
    ActivityRecord? lastActivity;
    for (final activity in typeActivities) {
      // 只考虑当前时间之前的活动
      if (!activity.startTime.isAfter(now)) {
        lastActivity = activity;
        break;
      }
    }

    print('[PredictionService] 该类型活动数量: ${typeActivities.length}');
    print('[PredictionService] 排除未来时间后的活动数量: ${typeActivities.where((a) => !a.startTime.isAfter(now)).length}');

    // 打印前5条过去时间的活动
    final pastActivities = typeActivities.where((a) => !a.startTime.isAfter(now)).take(5).toList();
    print('[PredictionService] 最近5条过去时间的活动:');
    for (var i = 0; i < pastActivities.length; i++) {
      print('[PredictionService]   [$i] ${pastActivities[i].startTime} (时段: ${TimeSlot.fromDateTime(pastActivities[i].startTime)})');
    }

    if (lastActivity != null) {
      print('[PredictionService] 最后一次活动开始时间: ${lastActivity.startTime}');
      print('[PredictionService] 最后一次活动结束时间: ${lastActivity.endTime}');
    } else {
      print('[PredictionService] 没有找到过去时间的活动');
    }

    if (lastActivity == null && !hasEnoughHistory) {
      // 没有历史记录且历史数据不足，完全依赖月龄基准
      print('[PredictionService] 无历史数据，使用月龄基准预测');
      return _predictFromBenchmarkOnly(
        activityType: activityType,
        ageWeeks: ageWeeks,
        timeSlot: currentTimeSlot,
        awakeStage: awakeStage,
      );
    }

    // 计算全天历史模式
    // 排除未来的活动数据
    final validTypeActivities = typeActivities.where((a) => !a.startTime.isAfter(now)).toList();
    final globalPattern = _calculateHistoricalPattern(validTypeActivities);
    print('[PredictionService] 全天模式计算结果: interval=${globalPattern.intervalMinutes}, samples=${globalPattern.sampleCount}');
    print('[PredictionService] 用于计算的活动数量: ${validTypeActivities.length}');

    // 打印全天模式的间隔计算细节
    if (validTypeActivities.length >= 2) {
      print('[PredictionService] 全天间隔计算细节:');
      for (int i = 0; i < validTypeActivities.length - 1 && i < 5; i++) {
        final interval = validTypeActivities[i].startTime
            .difference(validTypeActivities[i + 1].startTime)
            .inMinutes;
        print('[PredictionService]   ${validTypeActivities[i].startTime} 与 ${validTypeActivities[i + 1].startTime} 间隔: $interval 分钟');
      }
    }

    // 计算时段历史模式
    final timeSlotActivities = await _db.getTimeSlotActivities(
      babyId,
      activityType,
      currentTimeSlot,
    );

    print('[PredictionService] 时段($currentTimeSlot)内的活动数量: ${timeSlotActivities.length}');
    if (timeSlotActivities.isNotEmpty) {
      print('[PredictionService] 时段内的活动时间:');
      for (var i = 0; i < timeSlotActivities.length && i < 5; i++) {
        print('[PredictionService]   [$i] ${timeSlotActivities[i].startTime}');
      }
    }

    final timeSlotPattern = TimeSlotPattern.fromActivityRecords(
      timeSlot: currentTimeSlot,
      records: timeSlotActivities,
    );
    print('[PredictionService] 时段模式计算结果: interval=${timeSlotPattern.intervalMinutes}, samples=${timeSlotPattern.sampleCount}');

    // 获取时段感知的月龄基准数据
    final benchmarkData = _db.getTimeSlotBenchmarkData(
      ageWeeks,
      activityType,
      currentTimeSlot,
    );

    print('[PredictionService] 时段模式: $timeSlotPattern');
    print('[PredictionService] 全天模式: interval=${globalPattern.intervalMinutes}, samples=${globalPattern.sampleCount}');
    print('[PredictionService] 基准间隔: ${benchmarkData.interval}');

    // ========== 新的预测逻辑 ==========
    DateTime predictedTime;
    double confidence;

    // 策略1: 使用当前时段的典型时间预测
    if (timeSlotPattern.hasTypicalTime && timeSlotPattern.hasEnoughSamples) {
      print('[PredictionService] 使用时段典型时间策略');
      final typicalHour = timeSlotPattern.typicalHour!;
      final typicalMinute = timeSlotPattern.typicalMinute ?? 0;

      // 计算今天的典型时间
      var todayTypicalTime = DateTime(
        now.year,
        now.month,
        now.day,
        typicalHour,
        typicalMinute,
      );

      // 如果今天的典型时间还没过，预测今天
      // 否则预测明天
      if (todayTypicalTime.isAfter(now)) {
        predictedTime = todayTypicalTime;
        print('[PredictionService] 今天典型时间 $todayTypicalTime 还未到达，预测今天');
      } else {
        predictedTime = todayTypicalTime.add(const Duration(days: 1));
        print('[PredictionService] 今天典型时间 $todayTypicalTime 已过，预测明天 $predictedTime');
      }
      confidence = 0.85;
    }
    // 策略2: 使用全天历史间隔预测
    else if (globalPattern.hasInterval && lastActivity != null) {
      print('[PredictionService] 使用全天历史间隔策略');
      final interval = globalPattern.intervalMinutes!;
      predictedTime = lastActivity.startTime.add(Duration(minutes: interval));
      print('[PredictionService] 基于最后活动计算: ${lastActivity.startTime} + $interval 分钟 = $predictedTime');

      // 如果预测时间已过，调整为当前时间之后
      if (predictedTime.isBefore(now)) {
        print('[PredictionService] 预测时间已过，调整');
        int iterations = 0;
        while (predictedTime.isBefore(now) && iterations < 20) {
          predictedTime = predictedTime.add(Duration(minutes: interval));
          iterations++;
        }
        print('[PredictionService] 调整后预测时间: $predictedTime');
      }
      confidence = 0.75;
    }
    // 策略3: 使用月龄基准预测
    else if (benchmarkData.interval != null) {
      print('[PredictionService] 使用月龄基准策略');
      predictedTime = now.add(Duration(minutes: benchmarkData.interval!));
      confidence = 0.5;
    }
    // 无法预测
    else {
      print('[PredictionService] 无法计算预测，返回 null');
      return null;
    }

    print('[PredictionService] 最终预测时间: $predictedTime，置信度: $confidence');

    // 构建预测结果
    return _buildPredictionResult(
      activityType: activityType,
      predictedTime: predictedTime,
      timeSlotPattern: timeSlotPattern,
      globalPattern: globalPattern,
      benchmarkData: benchmarkData,
      hasEnoughHistory: hasEnoughHistory,
      timeSlot: currentTimeSlot,
      awakeStage: awakeStage,
      confidenceOverride: confidence,
    );
  }

  /// 计算历史模式（全天）
  _HistoricalPattern _calculateHistoricalPattern(List<ActivityRecord> activities) {
    if (activities.length < 2) {
      return _HistoricalPattern();
    }

    // 计算平均间隔
    final intervals = <int>[];
    for (int i = 0; i < activities.length - 1; i++) {
      final interval = activities[i].startTime
          .difference(activities[i + 1].startTime)
          .inMinutes;
      if (interval > 0 && interval < 720) {
        intervals.add(interval);
      }
    }

    final avgInterval = intervals.isNotEmpty
        ? (intervals.reduce((a, b) => a + b) / intervals.length).round()
        : null;

    // 计算平均持续时间
    final durations = activities
        .where((a) => a.durationSeconds != null)
        .map((a) => a.durationSeconds! ~/ 60)
        .where((d) => d > 0 && d < 360)
        .toList();

    final avgDuration = durations.isNotEmpty
        ? (durations.reduce((a, b) => a + b) / durations.length).round()
        : null;

    return _HistoricalPattern(
      intervalMinutes: avgInterval,
      durationMinutes: avgDuration,
      sampleCount: activities.length,
    );
  }

  /// 三元加权融合计算预测间隔
  int? _calculateWeightedInterval({
    required TimeSlotPattern timeSlotPattern,
    required _HistoricalPattern globalPattern,
    required int? benchmarkInterval,
  }) {
    final timeSlotInterval = timeSlotPattern.intervalMinutes;
    final globalInterval = globalPattern.intervalMinutes;
    final timeSlotSamples = timeSlotPattern.sampleCount;

    print('[PredictionService] 加权计算参数:');
    print('[PredictionService]   时段间隔: $timeSlotInterval, 时段样本: $timeSlotSamples');
    print('[PredictionService]   全天间隔: $globalInterval');
    print('[PredictionService]   基准间隔: $benchmarkInterval');

    // 时段样本充足
    if (timeSlotSamples >= timeSlotMinSamples && timeSlotInterval != null) {
      print('[PredictionService] 使用时段样本充足策略 (样本 >= 3)');
      if (globalInterval != null && benchmarkInterval != null) {
        // 时段历史 × 0.4 + 全天历史 × 0.3 + 月龄基准 × 0.3
        final result = (timeSlotInterval * timeSlotWeightHigh +
                globalInterval * globalHistoryWeightHigh +
                benchmarkInterval * benchmarkWeight)
            .round();
        print('[PredictionService] 计算: $timeSlotInterval * 0.4 + $globalInterval * 0.3 + $benchmarkInterval * 0.3 = $result');
        return result;
      } else if (globalInterval != null) {
        final result = (timeSlotInterval * 0.5 + globalInterval * 0.5).round();
        print('[PredictionService] 计算: $timeSlotInterval * 0.5 + $globalInterval * 0.5 = $result');
        return result;
      } else if (benchmarkInterval != null) {
        final result = (timeSlotInterval * 0.7 + benchmarkInterval * 0.3).round();
        print('[PredictionService] 计算: $timeSlotInterval * 0.7 + $benchmarkInterval * 0.3 = $result');
        return result;
      }
      print('[PredictionService] 直接使用时段间隔: $timeSlotInterval');
      return timeSlotInterval;
    }

    // 时段样本不足但有数据
    if (timeSlotSamples > 0 && timeSlotInterval != null) {
      print('[PredictionService] 使用时段样本不足策略 (样本 > 0)');
      if (globalInterval != null && benchmarkInterval != null) {
        // 时段历史 × 0.2 + 全天历史 × 0.5 + 月龄基准 × 0.3
        final result = (timeSlotInterval * timeSlotWeightLow +
                globalInterval * globalHistoryWeightLow +
                benchmarkInterval * benchmarkWeight)
            .round();
        print('[PredictionService] 计算: $timeSlotInterval * 0.2 + $globalInterval * 0.5 + $benchmarkInterval * 0.3 = $result');
        return result;
      }
    }

    // 无时段数据，回退到全天历史 + 月龄基准
    print('[PredictionService] 无时段数据，回退策略');
    if (globalInterval != null && benchmarkInterval != null) {
      // 全天历史 × 0.7 + 月龄基准 × 0.3
      final result = (globalInterval * 0.7 + benchmarkInterval * 0.3).round();
      print('[PredictionService] 计算: $globalInterval * 0.7 + $benchmarkInterval * 0.3 = $result');
      return result;
    } else if (globalInterval != null) {
      print('[PredictionService] 直接使用全天间隔: $globalInterval');
      return globalInterval;
    } else if (benchmarkInterval != null) {
      print('[PredictionService] 直接使用基准间隔: $benchmarkInterval');
      return benchmarkInterval;
    }

    print('[PredictionService] 无法计算，返回 null');
    return null;
  }

  /// 完全基于月龄基准的预测
  Future<PredictionResult?> _predictFromBenchmarkOnly({
    required int activityType,
    required int ageWeeks,
    required TimeSlot timeSlot,
    AwakeStage? awakeStage,
  }) async {
    final benchmarkData = _db.getTimeSlotBenchmarkData(
      ageWeeks,
      activityType,
      timeSlot,
    );

    if (benchmarkData.interval == null) {
      return null;
    }

    final now = DateTime.now();
    final predictedTime = now.add(Duration(minutes: benchmarkData.interval!));

    return _buildPredictionResult(
      activityType: activityType,
      predictedTime: predictedTime,
      timeSlotPattern: const TimeSlotPattern(timeSlot: TimeSlot.morning),
      globalPattern: _HistoricalPattern(),
      benchmarkData: benchmarkData,
      hasEnoughHistory: false,
      timeSlot: timeSlot,
      awakeStage: awakeStage,
    );
  }

  /// 构建预测结果
  PredictionResult _buildPredictionResult({
    required int activityType,
    required DateTime predictedTime,
    required TimeSlotPattern timeSlotPattern,
    required _HistoricalPattern globalPattern,
    required ({int? interval, int? duration}) benchmarkData,
    required bool hasEnoughHistory,
    required TimeSlot timeSlot,
    AwakeStage? awakeStage,
    double? confidenceOverride,
  }) {
    final type = PredictionType.fromValue(activityType);
    if (type == null) {
      throw ArgumentError('Invalid activity type: $activityType');
    }

    // 使用传入的置信度或计算置信度
    double confidence;
    if (confidenceOverride != null) {
      confidence = confidenceOverride;
    } else if (timeSlotPattern.hasEnoughSamples) {
      confidence = 0.85; // 时段样本充足
    } else if (hasEnoughHistory && globalPattern.intervalMinutes != null) {
      confidence = 0.75; // 全天历史充足
    } else if (timeSlotPattern.hasData) {
      confidence = 0.6; // 有时段数据但样本不足
    } else if (benchmarkData.interval != null) {
      confidence = 0.5; // 仅基准数据
    } else {
      confidence = 0.3; // 数据不足
    }

    // 睡眠阶段调整置信度
    if (awakeStage != null) {
      if (awakeStage == AwakeStage.awakeLate && type == PredictionType.sleep) {
        confidence = (confidence + 0.1).clamp(0.0, 1.0); // 疲劳期睡眠预测置信度提高
      } else if (awakeStage == AwakeStage.awakeEarly && type == PredictionType.eat) {
        confidence = (confidence + 0.05).clamp(0.0, 1.0); // 刚醒期吃奶预测置信度提高
      }
    }

    // 构建描述和提示
    final (description, tips) = _buildDescriptionAndTips(
      type: type,
      timeSlot: timeSlot,
      awakeStage: awakeStage,
      historicalDuration: globalPattern.durationMinutes ?? timeSlotPattern.durationMinutes,
      benchmarkDuration: benchmarkData.duration,
    );

    return PredictionResult(
      type: type,
      predictedTime: predictedTime,
      confidence: confidence,
      description: description,
      tips: tips,
      isBasedOnAgeBenchmark: !hasEnoughHistory && !timeSlotPattern.hasData,
      timeSlot: timeSlot,
      awakeStage: awakeStage,
      timeSlotSampleCount: timeSlotPattern.sampleCount,
    );
  }

  /// 构建描述和提示
  (String, String?) _buildDescriptionAndTips({
    required PredictionType type,
    required TimeSlot timeSlot,
    AwakeStage? awakeStage,
    int? historicalDuration,
    int? benchmarkDuration,
  }) {
    String description;
    String? tips;

    // 时段和睡眠阶段感知的描述
    switch (type) {
      case PredictionType.eat:
        description = _getEatDescription(timeSlot, awakeStage);
        tips = _getEatTips(timeSlot, awakeStage, historicalDuration, benchmarkDuration);
        break;
      case PredictionType.sleep:
        description = _getSleepDescription(timeSlot, awakeStage);
        tips = _getSleepTips(timeSlot, awakeStage, historicalDuration, benchmarkDuration);
        break;
      case PredictionType.poop:
        description = '可能需要换尿布';
        tips = '建议检查尿布状态';
        break;
    }

    return (description, tips);
  }

  String _getEatDescription(TimeSlot timeSlot, AwakeStage? awakeStage) {
    if (timeSlot.isNight) {
      return '夜间可能需要喂奶';
    }
    if (timeSlot == TimeSlot.evening) {
      return '睡前可能需要喂奶';
    }
    if (awakeStage == AwakeStage.awakeEarly) {
      return '刚醒来，可能需要喂奶';
    }
    return '预计需要喂奶';
  }

  String? _getEatTips(
    TimeSlot timeSlot,
    AwakeStage? awakeStage,
    int? historicalDuration,
    int? benchmarkDuration,
  ) {
    final tips = <String>[];

    if (timeSlot.isNight) {
      tips.add('夜间喂奶建议保持安静环境');
    } else if (timeSlot == TimeSlot.evening) {
      tips.add('睡前喂奶有助于宝宝安稳入睡');
    } else if (awakeStage == AwakeStage.awakeEarly) {
      tips.add('刚醒来时喂奶效果较好');
    }

    if (historicalDuration != null && historicalDuration > 0) {
      tips.add('通常每次喂奶约 $historicalDuration 分钟');
    } else if (benchmarkDuration != null) {
      tips.add('建议准备 $benchmarkDuration 分钟左右的喂养时间');
    }

    return tips.isNotEmpty ? tips.join('，') : null;
  }

  String _getSleepDescription(TimeSlot timeSlot, AwakeStage? awakeStage) {
    if (timeSlot.isNight) {
      return '夜间长觉时间';
    }
    if (awakeStage == AwakeStage.awakeLate) {
      return '宝宝疲劳，建议安排小睡';
    }
    if (timeSlot == TimeSlot.afternoon) {
      return '午睡时间到了';
    }
    return '预计需要小睡';
  }

  String? _getSleepTips(
    TimeSlot timeSlot,
    AwakeStage? awakeStage,
    int? historicalDuration,
    int? benchmarkDuration,
  ) {
    final tips = <String>[];

    if (timeSlot.isNight) {
      tips.add('夜间长觉，帮助培养整夜睡眠习惯');
    } else if (awakeStage == AwakeStage.awakeLate) {
      tips.add('宝宝疲劳期，及时安排小睡有助于作息规律');
    }

    if (historicalDuration != null && historicalDuration > 0) {
      tips.add('通常小睡约 $historicalDuration 分钟');
    } else if (benchmarkDuration != null) {
      tips.add('预计睡眠时长约 $benchmarkDuration 分钟');
    }

    return tips.isNotEmpty ? tips.join('，') : null;
  }

  /// 合并15分钟内的预测
  PredictionResult _mergePredictions({
    required List<PredictionResult> predictions,
    required bool hasEnoughHistory,
    required TimeSlot timeSlot,
    AwakeStage? awakeStage,
  }) {
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
      final tips = _buildMergedTips(mainPrediction, relatedPredictions, timeSlot);

      return mainPrediction.copyWith(
        relatedPredictions: relatedPredictions,
        tips: tips,
      );
    }

    return mainPrediction;
  }

  /// 构建合并预测的提示
  String _buildMergedTips(
    PredictionResult main,
    List<PredictionResult> related,
    TimeSlot timeSlot,
  ) {
    final tips = <String>[];

    // 夜间时段的特殊提示
    if (timeSlot.isNight) {
      tips.add('夜间模式：帮助宝宝培养规律作息');
    }

    if (main.type == PredictionType.sleep) {
      final hasPoopPrediction = related.any((p) => p.type == PredictionType.poop);
      if (hasPoopPrediction) {
        tips.add('醒后可能需要换尿布');
      }
      final hasEatPrediction = related.any((p) => p.type == PredictionType.eat);
      if (hasEatPrediction) {
        tips.add('睡前可以考虑喂奶');
      }
    } else if (main.type == PredictionType.eat) {
      final hasPoopPrediction = related.any((p) => p.type == PredictionType.poop);
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

/// 历史模式数据
class _HistoricalPattern {
  _HistoricalPattern({
    this.intervalMinutes,
    this.durationMinutes,
    this.sampleCount = 0,
  });

  final int? intervalMinutes;
  final int? durationMinutes;
  final int sampleCount;

  bool get hasData => sampleCount > 0;
  bool get hasInterval => intervalMinutes != null && intervalMinutes! > 0;
  bool get hasDuration => durationMinutes != null && durationMinutes! > 0;
}