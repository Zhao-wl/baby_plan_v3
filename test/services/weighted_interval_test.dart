import 'package:flutter_test/flutter_test.dart';

import 'package:baby_plan_v3/models/time_slot.dart';
import 'package:baby_plan_v3/models/time_slot_pattern.dart';

void main() {
  group('三元加权融合算法', () {
    /// 计算三元加权融合间隔
    ///
    /// 模拟 PredictionService._calculateWeightedInterval 的逻辑
    int? calculateWeightedInterval({
      required TimeSlotPattern timeSlotPattern,
      required ({int? intervalMinutes, int? durationMinutes, int sampleCount})
          globalPattern,
      required int? benchmarkInterval,
    }) {
      const timeSlotMinSamples = 3;
      const timeSlotWeightHigh = 0.4;
      const globalHistoryWeightHigh = 0.3;
      const timeSlotWeightLow = 0.2;
      const globalHistoryWeightLow = 0.5;
      const benchmarkWeight = 0.3;

      final timeSlotInterval = timeSlotPattern.intervalMinutes;
      final globalInterval = globalPattern.intervalMinutes;
      final timeSlotSamples = timeSlotPattern.sampleCount;

      // 时段样本充足
      if (timeSlotSamples >= timeSlotMinSamples && timeSlotInterval != null) {
        if (globalInterval != null && benchmarkInterval != null) {
          // 时段历史 × 0.4 + 全天历史 × 0.3 + 月龄基准 × 0.3
          return (timeSlotInterval * timeSlotWeightHigh +
                  globalInterval * globalHistoryWeightHigh +
                  benchmarkInterval * benchmarkWeight)
              .round();
        } else if (globalInterval != null) {
          return (timeSlotInterval * 0.5 + globalInterval * 0.5).round();
        } else if (benchmarkInterval != null) {
          return (timeSlotInterval * 0.7 + benchmarkInterval * 0.3).round();
        }
        return timeSlotInterval;
      }

      // 时段样本不足但有数据
      if (timeSlotSamples > 0 && timeSlotInterval != null) {
        if (globalInterval != null && benchmarkInterval != null) {
          // 时段历史 × 0.2 + 全天历史 × 0.5 + 月龄基准 × 0.3
          return (timeSlotInterval * timeSlotWeightLow +
                  globalInterval * globalHistoryWeightLow +
                  benchmarkInterval * benchmarkWeight)
              .round();
        }
      }

      // 无时段数据，回退到全天历史 + 月龄基准
      if (globalInterval != null && benchmarkInterval != null) {
        // 全天历史 × 0.7 + 月龄基准 × 0.3
        return (globalInterval * 0.7 + benchmarkInterval * 0.3).round();
      } else if (globalInterval != null) {
        return globalInterval;
      } else if (benchmarkInterval != null) {
        return benchmarkInterval;
      }

      return null;
    }

    group('时段样本充足 (>=3)', () {
      test('当三个数据源都存在时，使用正确的权重', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.afternoon,
            intervalMinutes: 120,
            sampleCount: 5,
          ),
          globalPattern: (intervalMinutes: 150, durationMinutes: null, sampleCount: 10),
          benchmarkInterval: 180,
        );

        // 120 * 0.4 + 150 * 0.3 + 180 * 0.3 = 48 + 45 + 54 = 147
        expect(result, equals(147));
      });

      test('时段样本正好等于阈值时，使用高权重', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.morning,
            intervalMinutes: 100,
            sampleCount: 3,
          ),
          globalPattern: (intervalMinutes: 120, durationMinutes: null, sampleCount: 8),
          benchmarkInterval: 150,
        );

        // 100 * 0.4 + 120 * 0.3 + 150 * 0.3 = 40 + 36 + 45 = 121
        expect(result, equals(121));
      });

      test('缺少月龄基准时，时段和全天各占50%', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.evening,
            intervalMinutes: 100,
            sampleCount: 4,
          ),
          globalPattern: (intervalMinutes: 200, durationMinutes: null, sampleCount: 10),
          benchmarkInterval: null,
        );

        // 100 * 0.5 + 200 * 0.5 = 150
        expect(result, equals(150));
      });

      test('缺少全天历史时，时段70%+基准30%', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.night,
            intervalMinutes: 240,
            sampleCount: 6,
          ),
          globalPattern: (intervalMinutes: null, durationMinutes: null, sampleCount: 0),
          benchmarkInterval: 300,
        );

        // 240 * 0.7 + 300 * 0.3 = 168 + 90 = 258
        expect(result, equals(258));
      });

      test('仅有时段数据时，返回时段值', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.afternoon,
            intervalMinutes: 130,
            sampleCount: 5,
          ),
          globalPattern: (intervalMinutes: null, durationMinutes: null, sampleCount: 0),
          benchmarkInterval: null,
        );

        expect(result, equals(130));
      });
    });

    group('时段样本不足 (1-2)', () {
      test('当三个数据源都存在时，使用低时段权重', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.forenoon,
            intervalMinutes: 100,
            sampleCount: 2,
          ),
          globalPattern: (intervalMinutes: 150, durationMinutes: null, sampleCount: 10),
          benchmarkInterval: 180,
        );

        // 100 * 0.2 + 150 * 0.5 + 180 * 0.3 = 20 + 75 + 54 = 149
        expect(result, equals(149));
      });

      test('时段样本为1时，也使用低权重', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.morning,
            intervalMinutes: 90,
            sampleCount: 1,
          ),
          globalPattern: (intervalMinutes: 120, durationMinutes: null, sampleCount: 8),
          benchmarkInterval: 150,
        );

        // 90 * 0.2 + 120 * 0.5 + 150 * 0.3 = 18 + 60 + 45 = 123
        expect(result, equals(123));
      });
    });

    group('无时段样本', () {
      test('回退到全天历史+月龄基准（70%+30%）', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.afternoon,
            sampleCount: 0,
          ),
          globalPattern: (intervalMinutes: 150, durationMinutes: null, sampleCount: 10),
          benchmarkInterval: 180,
        );

        // 150 * 0.7 + 180 * 0.3 = 105 + 54 = 159
        expect(result, equals(159));
      });

      test('仅有全天历史时，返回全天历史值', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.evening,
            sampleCount: 0,
          ),
          globalPattern: (intervalMinutes: 140, durationMinutes: null, sampleCount: 5),
          benchmarkInterval: null,
        );

        expect(result, equals(140));
      });

      test('仅有月龄基准时，返回基准值', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.night,
            sampleCount: 0,
          ),
          globalPattern: (intervalMinutes: null, durationMinutes: null, sampleCount: 0),
          benchmarkInterval: 200,
        );

        expect(result, equals(200));
      });

      test('无任何数据时，返回null', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.morning,
            sampleCount: 0,
          ),
          globalPattern: (intervalMinutes: null, durationMinutes: null, sampleCount: 0),
          benchmarkInterval: null,
        );

        expect(result, isNull);
      });
    });

    group('边界情况', () {
      test('小数值四舍五入正确', () {
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.afternoon,
            intervalMinutes: 123,
            sampleCount: 4,
          ),
          globalPattern: (intervalMinutes: 145, durationMinutes: null, sampleCount: 10),
          benchmarkInterval: 167,
        );

        // 123 * 0.4 + 145 * 0.3 + 167 * 0.3 = 49.2 + 43.5 + 50.1 = 142.8 -> 143
        expect(result, equals(143));
      });

      test('极端值能正确处理', () {
        // 非常长的间隔（夜间长觉）
        final result = calculateWeightedInterval(
          timeSlotPattern: const TimeSlotPattern(
            timeSlot: TimeSlot.night,
            intervalMinutes: 480, // 8小时
            sampleCount: 5,
          ),
          globalPattern: (intervalMinutes: 300, durationMinutes: null, sampleCount: 20),
          benchmarkInterval: 360,
        );

        // 480 * 0.4 + 300 * 0.3 + 360 * 0.3 = 192 + 90 + 108 = 390
        expect(result, equals(390));
      });
    });
  });
}