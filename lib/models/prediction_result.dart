import 'package:flutter/material.dart';

import 'awake_stage.dart';
import 'time_slot.dart';

/// 预测类型枚举
///
/// 表示可以预测的活动类型。
enum PredictionType {
  eat(0, '吃奶', Icons.baby_changing_station, '预计需要喂奶'),
  sleep(2, '睡眠', Icons.bedtime, '预计需要小睡'),
  poop(3, '排泄', Icons.baby_changing_station, '可能需要换尿布');

  const PredictionType(this.value, this.label, this.icon, this.defaultTip);

  /// 活动类型值（与 ActivityRecords 表中的 type 对应）
  final int value;

  /// 显示标签
  final String label;

  /// 图标
  final IconData icon;

  /// 默认提示
  final String defaultTip;

  /// 从活动类型值创建
  static PredictionType? fromValue(int value) {
    return switch (value) {
      0 => PredictionType.eat,
      2 => PredictionType.sleep,
      3 => PredictionType.poop,
      _ => null,
    };
  }
}

/// 预测结果
///
/// 包含单个预测的完整信息。
class PredictionResult {
  /// 创建预测结果
  const PredictionResult({
    required this.type,
    required this.predictedTime,
    required this.confidence,
    required this.description,
    this.tips,
    this.relatedPredictions,
    this.isBasedOnAgeBenchmark = false,
    this.timeSlot,
    this.awakeStage,
    this.timeSlotSampleCount = 0,
  });

  /// 预测类型
  final PredictionType type;

  /// 预测时间
  final DateTime predictedTime;

  /// 置信度 (0.0-1.0)
  final double confidence;

  /// 预测描述
  final String description;

  /// 建议提示
  final String? tips;

  /// 关联预测（15分钟内的其他预测）
  final List<PredictionResult>? relatedPredictions;

  /// 是否基于月龄基准（而非历史数据）
  final bool isBasedOnAgeBenchmark;

  /// 预测时段
  final TimeSlot? timeSlot;

  /// 睡眠阶段
  final AwakeStage? awakeStage;

  /// 时段历史样本数量
  final int timeSlotSampleCount;

  /// 是否为合并预测
  bool get isMerged =>
      relatedPredictions != null && relatedPredictions!.isNotEmpty;

  /// 格式化预测时间
  String get formattedTime {
    final hour = predictedTime.hour.toString().padLeft(2, '0');
    final minute = predictedTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 获取主要提示
  String get primaryTip {
    if (tips != null && tips!.isNotEmpty) {
      return tips!;
    }
    return type.defaultTip;
  }

  /// 复制并修改
  PredictionResult copyWith({
    PredictionType? type,
    DateTime? predictedTime,
    double? confidence,
    String? description,
    String? tips,
    List<PredictionResult>? relatedPredictions,
    bool? isBasedOnAgeBenchmark,
    TimeSlot? timeSlot,
    AwakeStage? awakeStage,
    int? timeSlotSampleCount,
  }) {
    return PredictionResult(
      type: type ?? this.type,
      predictedTime: predictedTime ?? this.predictedTime,
      confidence: confidence ?? this.confidence,
      description: description ?? this.description,
      tips: tips ?? this.tips,
      relatedPredictions: relatedPredictions ?? this.relatedPredictions,
      isBasedOnAgeBenchmark:
          isBasedOnAgeBenchmark ?? this.isBasedOnAgeBenchmark,
      timeSlot: timeSlot ?? this.timeSlot,
      awakeStage: awakeStage ?? this.awakeStage,
      timeSlotSampleCount: timeSlotSampleCount ?? this.timeSlotSampleCount,
    );
  }

  @override
  String toString() {
    return 'PredictionResult(type: $type, predictedTime: $predictedTime, confidence: $confidence, timeSlot: $timeSlot, awakeStage: $awakeStage)';
  }
}

/// 预测状态
///
/// 表示预测引擎的整体状态。
class PredictionState {
  /// 创建预测状态
  const PredictionState({
    this.prediction,
    this.isLoading = false,
    this.error,
    this.isNightMode = false,
    this.ongoingActivityType,
    this.hasInsufficientData = false,
    this.timeSlot,
    this.awakeStage,
  });

  /// 当前预测结果（可能为空）
  final PredictionResult? prediction;

  /// 是否正在加载
  final bool isLoading;

  /// 错误信息
  final String? error;

  /// 是否为夜间模式（22:00-06:00）
  /// 注意：夜间模式不再禁用预测，仅用于 UI 显示调整
  final bool isNightMode;

  /// 进行中的活动类型
  final int? ongoingActivityType;

  /// 历史数据是否不足
  final bool hasInsufficientData;

  /// 当前时段
  final TimeSlot? timeSlot;

  /// 当前睡眠阶段
  final AwakeStage? awakeStage;

  /// 是否有可用预测
  bool get hasPrediction => prediction != null;

  /// 是否有进行中的活动
  bool get hasOngoingActivity => ongoingActivityType != null;

  /// 是否有睡眠阶段信息
  bool get hasAwakeStage => awakeStage != null;

  /// 复制并修改
  PredictionState copyWith({
    PredictionResult? prediction,
    bool? isLoading,
    String? error,
    bool? isNightMode,
    int? ongoingActivityType,
    bool? hasInsufficientData,
    TimeSlot? timeSlot,
    AwakeStage? awakeStage,
  }) {
    return PredictionState(
      prediction: prediction ?? this.prediction,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isNightMode: isNightMode ?? this.isNightMode,
      ongoingActivityType: ongoingActivityType,
      hasInsufficientData: hasInsufficientData ?? this.hasInsufficientData,
      timeSlot: timeSlot ?? this.timeSlot,
      awakeStage: awakeStage ?? this.awakeStage,
    );
  }

  @override
  String toString() {
    return 'PredictionState(hasPrediction: $hasPrediction, isLoading: $isLoading, timeSlot: $timeSlot, awakeStage: $awakeStage)';
  }
}