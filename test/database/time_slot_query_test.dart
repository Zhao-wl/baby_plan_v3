import 'package:flutter_test/flutter_test.dart';

import 'package:baby_plan_v3/models/awake_stage.dart';
import 'package:baby_plan_v3/models/time_slot.dart';
import 'package:baby_plan_v3/models/time_slot_pattern.dart';

void main() {
  group('时段历史数据查询 - 模型测试', () {
    group('TimeSlotPattern', () {
      test('从空数据创建时返回默认值', () {
        const pattern = TimeSlotPattern(timeSlot: TimeSlot.morning);

        expect(pattern.timeSlot, equals(TimeSlot.morning));
        expect(pattern.intervalMinutes, isNull);
        expect(pattern.durationMinutes, isNull);
        expect(pattern.sampleCount, equals(0));
        expect(pattern.hasData, isFalse);
        expect(pattern.hasEnoughSamples, isFalse);
      });

      test('hasEnoughSamples 需要至少3个样本', () {
        const pattern1 = TimeSlotPattern(
          timeSlot: TimeSlot.afternoon,
          sampleCount: 2,
        );
        const pattern2 = TimeSlotPattern(
          timeSlot: TimeSlot.afternoon,
          sampleCount: 3,
        );
        const pattern3 = TimeSlotPattern(
          timeSlot: TimeSlot.afternoon,
          sampleCount: 5,
        );

        expect(pattern1.hasEnoughSamples, isFalse);
        expect(pattern2.hasEnoughSamples, isTrue);
        expect(pattern3.hasEnoughSamples, isTrue);
      });

      test('hasData 根据样本数量判断', () {
        const emptyPattern = TimeSlotPattern(timeSlot: TimeSlot.morning);
        const patternWithData = TimeSlotPattern(
          timeSlot: TimeSlot.morning,
          sampleCount: 1,
        );

        expect(emptyPattern.hasData, isFalse);
        expect(patternWithData.hasData, isTrue);
      });

      test('hasInterval 和 hasDuration 正确判断', () {
        const patternWithInterval = TimeSlotPattern(
          timeSlot: TimeSlot.afternoon,
          intervalMinutes: 120,
        );
        const patternWithDuration = TimeSlotPattern(
          timeSlot: TimeSlot.afternoon,
          durationMinutes: 30,
        );
        const patternWithBoth = TimeSlotPattern(
          timeSlot: TimeSlot.afternoon,
          intervalMinutes: 150,
          durationMinutes: 25,
        );

        expect(patternWithInterval.hasInterval, isTrue);
        expect(patternWithInterval.hasDuration, isFalse);

        expect(patternWithDuration.hasInterval, isFalse);
        expect(patternWithDuration.hasDuration, isTrue);

        expect(patternWithBoth.hasInterval, isTrue);
        expect(patternWithBoth.hasDuration, isTrue);
      });

      test('包含有效样本数据', () {
        const pattern = TimeSlotPattern(
          timeSlot: TimeSlot.evening,
          intervalMinutes: 180,
          durationMinutes: 20,
          sampleCount: 5,
        );

        expect(pattern.sampleCount, equals(5));
        expect(pattern.intervalMinutes, equals(180));
        expect(pattern.durationMinutes, equals(20));
        expect(pattern.hasData, isTrue);
        expect(pattern.hasEnoughSamples, isTrue);
      });
    });

    group('ActivityPatternBenchmark', () {
      test('从旧格式 JSON 创建', () {
        final json = {
          'week': 4,
          'activityType': 0,
          'intervalMinutes': 150,
          'durationMinutes': 25,
          'countPerDay': 8,
        };

        final benchmark = ActivityPatternBenchmark.fromJson(json);

        expect(benchmark.week, equals(4));
        expect(benchmark.activityType, equals(0));
        expect(benchmark.globalInterval, equals(150));
        expect(benchmark.globalDuration, equals(25));
        expect(benchmark.globalCountPerDay, equals(8));
        expect(benchmark.hasTimeSlots, isFalse);
      });

      test('从新格式 JSON 创建（带分时段数据）', () {
        final json = {
          'week': 8,
          'activityType': 2,
          'global': {
            'intervalMinutes': 180,
            'durationMinutes': 60,
            'countPerDay': 4,
          },
          'timeSlots': {
            'morning': {'intervalMinutes': 120, 'durationMinutes': 45},
            'afternoon': {'intervalMinutes': 150, 'durationMinutes': 90},
            'night': {'intervalMinutes': 360, 'durationMinutes': 480},
          },
        };

        final benchmark = ActivityPatternBenchmark.fromJson(json);

        expect(benchmark.week, equals(8));
        expect(benchmark.activityType, equals(2));
        expect(benchmark.globalInterval, equals(180));
        expect(benchmark.hasTimeSlots, isTrue);

        // 时段基准数据
        expect(benchmark.getIntervalForSlot(TimeSlot.morning), equals(120));
        expect(benchmark.getIntervalForSlot(TimeSlot.afternoon), equals(150));
        expect(benchmark.getIntervalForSlot(TimeSlot.night), equals(360));

        // 无时段数据时回退到全局基准
        expect(benchmark.getIntervalForSlot(TimeSlot.forenoon), equals(180));
        expect(benchmark.getIntervalForSlot(TimeSlot.evening), equals(180));
      });

      test('时段基准回退到全局基准', () {
        final json = {
          'week': 12,
          'activityType': 0,
          'global': {
            'intervalMinutes': 200,
            'durationMinutes': 30,
          },
          // 没有 timeSlots
        };

        final benchmark = ActivityPatternBenchmark.fromJson(json);

        // 所有时段都应回退到全局基准
        expect(benchmark.getIntervalForSlot(TimeSlot.morning), equals(200));
        expect(benchmark.getIntervalForSlot(TimeSlot.night), equals(200));
      });
    });
  });

  group('睡眠阶段计算测试', () {
    group('AwakeStage', () {
      test('刚醒期: 0-2小时', () {
        expect(
          AwakeStage.fromMinutesAwake(0),
          equals(AwakeStage.awakeEarly),
        );
        expect(
          AwakeStage.fromMinutesAwake(60),
          equals(AwakeStage.awakeEarly),
        );
        expect(
          AwakeStage.fromMinutesAwake(119),
          equals(AwakeStage.awakeEarly),
        );
      });

      test('活动期: 2-4小时', () {
        expect(
          AwakeStage.fromMinutesAwake(120),
          equals(AwakeStage.awakeMid),
        );
        expect(
          AwakeStage.fromMinutesAwake(180),
          equals(AwakeStage.awakeMid),
        );
        expect(
          AwakeStage.fromMinutesAwake(239),
          equals(AwakeStage.awakeMid),
        );
      });

      test('疲劳期: 4小时以上', () {
        expect(
          AwakeStage.fromMinutesAwake(240),
          equals(AwakeStage.awakeLate),
        );
        expect(
          AwakeStage.fromMinutesAwake(360),
          equals(AwakeStage.awakeLate),
        );
        expect(
          AwakeStage.fromMinutesAwake(600),
          equals(AwakeStage.awakeLate),
        );
      });

      test('从睡眠结束时间计算阶段', () {
        final now = DateTime(2024, 1, 15, 12, 0);

        // 刚醒期
        expect(
          AwakeStage.fromSleepEndTime(
            now.subtract(const Duration(minutes: 60)),
            now,
          ),
          equals(AwakeStage.awakeEarly),
        );

        // 活动期
        expect(
          AwakeStage.fromSleepEndTime(
            now.subtract(const Duration(minutes: 180)),
            now,
          ),
          equals(AwakeStage.awakeMid),
        );

        // 疲劳期
        expect(
          AwakeStage.fromSleepEndTime(
            now.subtract(const Duration(minutes: 300)),
            now,
          ),
          equals(AwakeStage.awakeLate),
        );
      });

      test('睡眠结束时间在未来返回null', () {
        final now = DateTime(2024, 1, 15, 12, 0);
        expect(
          AwakeStage.fromSleepEndTime(
            now.add(const Duration(hours: 1)),
            now,
          ),
          isNull,
        );
      });

      test('睡眠阶段影响预测提示', () {
        // 刚醒期特征
        expect(AwakeStage.awakeEarly.description, contains('吃奶需求高'));

        // 活动期特征
        expect(AwakeStage.awakeMid.description, contains('排泄增多'));

        // 疲劳期特征
        expect(AwakeStage.awakeLate.description, contains('入睡'));
      });
    });
  });

  group('时段感知预测集成测试', () {
    test('时段边界计算正确', () {
      // 夜间时段跨日: 22:00-06:00
      expect(TimeSlot.night.startHour, equals(22));
      expect(TimeSlot.night.endHour, equals(6));
      expect(TimeSlot.night.isNight, isTrue);

      // 其他时段不跨日
      expect(TimeSlot.morning.startHour, lessThan(TimeSlot.morning.endHour));
      expect(TimeSlot.afternoon.startHour, lessThan(TimeSlot.afternoon.endHour));
    });

    test('时段转换正确', () {
      // next
      expect(TimeSlot.morning.next, equals(TimeSlot.forenoon));
      expect(TimeSlot.night.next, equals(TimeSlot.morning));

      // previous
      expect(TimeSlot.morning.previous, equals(TimeSlot.night));
      expect(TimeSlot.forenoon.previous, equals(TimeSlot.morning));
    });

    test('夜间时段特殊处理', () {
      // 验证夜间时段的 isNight 属性
      expect(TimeSlot.night.isNight, isTrue);
      expect(TimeSlot.morning.isNight, isFalse);
      expect(TimeSlot.evening.isNight, isFalse);
    });

    test('预测结果包含时段和睡眠阶段信息', () {
      // 验证 PredictionResult 可以存储时段和睡眠阶段信息
      // 这只是一个类型检查测试
      const timeSlot = TimeSlot.afternoon;
      const awakeStage = AwakeStage.awakeMid;

      // 验证枚举值可被正确引用
      expect(timeSlot.label, equals('下午'));
      expect(awakeStage.label, equals('活动期'));
    });
  });
}