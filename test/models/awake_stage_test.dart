import 'package:flutter_test/flutter_test.dart';

import 'package:baby_plan_v3/models/awake_stage.dart';

void main() {
  group('AwakeStage', () {
    group('enum values', () {
      test('has all 3 stages', () {
        expect(AwakeStage.values.length, equals(3));
      });

      test('awakeEarly has correct properties', () {
        expect(AwakeStage.awakeEarly.value, equals(0));
        expect(AwakeStage.awakeEarly.label, equals('刚醒期'));
        expect(AwakeStage.awakeEarly.minMinutes, equals(0));
        expect(AwakeStage.awakeEarly.maxMinutes, equals(120));
        expect(AwakeStage.awakeEarly.description, equals('刚醒来，吃奶需求高'));
      });

      test('awakeMid has correct properties', () {
        expect(AwakeStage.awakeMid.value, equals(1));
        expect(AwakeStage.awakeMid.label, equals('活动期'));
        expect(AwakeStage.awakeMid.minMinutes, equals(120));
        expect(AwakeStage.awakeMid.maxMinutes, equals(240));
        expect(AwakeStage.awakeMid.description, equals('活动时间，排泄增多'));
      });

      test('awakeLate has correct properties', () {
        expect(AwakeStage.awakeLate.value, equals(2));
        expect(AwakeStage.awakeLate.label, equals('疲劳期'));
        expect(AwakeStage.awakeLate.minMinutes, equals(240));
        expect(AwakeStage.awakeLate.maxMinutes, isNull);
        expect(AwakeStage.awakeLate.description, equals('即将入睡'));
      });
    });

    group('isAwakeEarly', () {
      test('awakeEarly is awakeEarly', () {
        expect(AwakeStage.awakeEarly.isAwakeEarly, isTrue);
      });

      test('other stages are not awakeEarly', () {
        expect(AwakeStage.awakeMid.isAwakeEarly, isFalse);
        expect(AwakeStage.awakeLate.isAwakeEarly, isFalse);
      });
    });

    group('isAwakeLate', () {
      test('awakeLate is awakeLate', () {
        expect(AwakeStage.awakeLate.isAwakeLate, isTrue);
      });

      test('other stages are not awakeLate', () {
        expect(AwakeStage.awakeEarly.isAwakeLate, isFalse);
        expect(AwakeStage.awakeMid.isAwakeLate, isFalse);
      });
    });

    group('fromMinutesAwake', () {
      test('returns awakeEarly for 0-119 minutes', () {
        expect(AwakeStage.fromMinutesAwake(0), equals(AwakeStage.awakeEarly));
        expect(AwakeStage.fromMinutesAwake(30), equals(AwakeStage.awakeEarly));
        expect(AwakeStage.fromMinutesAwake(60), equals(AwakeStage.awakeEarly));
        expect(AwakeStage.fromMinutesAwake(119), equals(AwakeStage.awakeEarly));
      });

      test('returns awakeMid for 120-239 minutes', () {
        expect(AwakeStage.fromMinutesAwake(120), equals(AwakeStage.awakeMid));
        expect(AwakeStage.fromMinutesAwake(180), equals(AwakeStage.awakeMid));
        expect(AwakeStage.fromMinutesAwake(239), equals(AwakeStage.awakeMid));
      });

      test('returns awakeLate for 240+ minutes', () {
        expect(AwakeStage.fromMinutesAwake(240), equals(AwakeStage.awakeLate));
        expect(AwakeStage.fromMinutesAwake(300), equals(AwakeStage.awakeLate));
        expect(AwakeStage.fromMinutesAwake(600), equals(AwakeStage.awakeLate));
      });
    });

    group('fromSleepEndTime', () {
      test('returns correct stage based on sleep end time', () {
        final now = DateTime(2024, 1, 15, 12, 0);

        // 刚醒期: 睡眠结束于 0-2 小时前
        final earlyEnd = now.subtract(const Duration(minutes: 60));
        expect(
          AwakeStage.fromSleepEndTime(earlyEnd, now),
          equals(AwakeStage.awakeEarly),
        );

        // 活动期: 睡眠结束于 2-4 小时前
        final midEnd = now.subtract(const Duration(minutes: 180));
        expect(
          AwakeStage.fromSleepEndTime(midEnd, now),
          equals(AwakeStage.awakeMid),
        );

        // 疲劳期: 睡眠结束于 4+ 小时前
        final lateEnd = now.subtract(const Duration(minutes: 300));
        expect(
          AwakeStage.fromSleepEndTime(lateEnd, now),
          equals(AwakeStage.awakeLate),
        );
      });

      test('returns null when sleep end time is in the future', () {
        final now = DateTime(2024, 1, 15, 12, 0);
        final futureEnd = now.add(const Duration(hours: 1));

        expect(
          AwakeStage.fromSleepEndTime(futureEnd, now),
          isNull,
        );
      });

      test('uses current time when not provided', () {
        // 测试当前时间的计算（只能验证不抛异常）
        final result = AwakeStage.fromSleepEndTime(
          DateTime.now().subtract(const Duration(minutes: 30)),
        );
        expect(result, equals(AwakeStage.awakeEarly));
      });
    });

    group('fromValue', () {
      test('returns correct stage for valid values', () {
        expect(AwakeStage.fromValue(0), equals(AwakeStage.awakeEarly));
        expect(AwakeStage.fromValue(1), equals(AwakeStage.awakeMid));
        expect(AwakeStage.fromValue(2), equals(AwakeStage.awakeLate));
      });

      test('returns null for invalid values', () {
        expect(AwakeStage.fromValue(-1), isNull);
        expect(AwakeStage.fromValue(3), isNull);
        expect(AwakeStage.fromValue(100), isNull);
      });
    });
  });
}