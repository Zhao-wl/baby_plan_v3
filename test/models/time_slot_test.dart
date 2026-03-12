import 'package:flutter_test/flutter_test.dart';

import 'package:baby_plan_v3/models/time_slot.dart';

void main() {
  group('TimeSlot', () {
    group('enum values', () {
      test('has all 5 time slots', () {
        expect(TimeSlot.values.length, equals(5));
      });

      test('morning has correct properties', () {
        expect(TimeSlot.morning.value, equals(0));
        expect(TimeSlot.morning.label, equals('早晨'));
        expect(TimeSlot.morning.startHour, equals(6));
        expect(TimeSlot.morning.endHour, equals(9));
        expect(TimeSlot.morning.description, equals('刚醒来，吃奶需求高'));
      });

      test('forenoon has correct properties', () {
        expect(TimeSlot.forenoon.value, equals(1));
        expect(TimeSlot.forenoon.label, equals('上午'));
        expect(TimeSlot.forenoon.startHour, equals(9));
        expect(TimeSlot.forenoon.endHour, equals(12));
        expect(TimeSlot.forenoon.description, equals('活动期'));
      });

      test('afternoon has correct properties', () {
        expect(TimeSlot.afternoon.value, equals(2));
        expect(TimeSlot.afternoon.label, equals('下午'));
        expect(TimeSlot.afternoon.startHour, equals(12));
        expect(TimeSlot.afternoon.endHour, equals(18));
        expect(TimeSlot.afternoon.description, equals('包含午睡'));
      });

      test('evening has correct properties', () {
        expect(TimeSlot.evening.value, equals(3));
        expect(TimeSlot.evening.label, equals('傍晚'));
        expect(TimeSlot.evening.startHour, equals(18));
        expect(TimeSlot.evening.endHour, equals(22));
        expect(TimeSlot.evening.description, equals('睡前准备期'));
      });

      test('night has correct properties', () {
        expect(TimeSlot.night.value, equals(4));
        expect(TimeSlot.night.label, equals('夜间'));
        expect(TimeSlot.night.startHour, equals(22));
        expect(TimeSlot.night.endHour, equals(6));
        expect(TimeSlot.night.description, equals('长觉期'));
      });
    });

    group('isNight', () {
      test('night slot is night', () {
        expect(TimeSlot.night.isNight, isTrue);
      });

      test('other slots are not night', () {
        expect(TimeSlot.morning.isNight, isFalse);
        expect(TimeSlot.forenoon.isNight, isFalse);
        expect(TimeSlot.afternoon.isNight, isFalse);
        expect(TimeSlot.evening.isNight, isFalse);
      });
    });

    group('fromHour', () {
      test('returns night for hours 22-23', () {
        expect(TimeSlot.fromHour(22), equals(TimeSlot.night));
        expect(TimeSlot.fromHour(23), equals(TimeSlot.night));
      });

      test('returns night for hours 0-5', () {
        expect(TimeSlot.fromHour(0), equals(TimeSlot.night));
        expect(TimeSlot.fromHour(1), equals(TimeSlot.night));
        expect(TimeSlot.fromHour(5), equals(TimeSlot.night));
      });

      test('returns morning for hours 6-8', () {
        expect(TimeSlot.fromHour(6), equals(TimeSlot.morning));
        expect(TimeSlot.fromHour(7), equals(TimeSlot.morning));
        expect(TimeSlot.fromHour(8), equals(TimeSlot.morning));
      });

      test('returns forenoon for hours 9-11', () {
        expect(TimeSlot.fromHour(9), equals(TimeSlot.forenoon));
        expect(TimeSlot.fromHour(10), equals(TimeSlot.forenoon));
        expect(TimeSlot.fromHour(11), equals(TimeSlot.forenoon));
      });

      test('returns afternoon for hours 12-17', () {
        expect(TimeSlot.fromHour(12), equals(TimeSlot.afternoon));
        expect(TimeSlot.fromHour(15), equals(TimeSlot.afternoon));
        expect(TimeSlot.fromHour(17), equals(TimeSlot.afternoon));
      });

      test('returns evening for hours 18-21', () {
        expect(TimeSlot.fromHour(18), equals(TimeSlot.evening));
        expect(TimeSlot.fromHour(20), equals(TimeSlot.evening));
        expect(TimeSlot.fromHour(21), equals(TimeSlot.evening));
      });
    });

    group('fromDateTime', () {
      test('returns correct time slot based on datetime hour', () {
        expect(
          TimeSlot.fromDateTime(DateTime(2024, 1, 15, 7, 30)),
          equals(TimeSlot.morning),
        );
        expect(
          TimeSlot.fromDateTime(DateTime(2024, 1, 15, 14, 30)),
          equals(TimeSlot.afternoon),
        );
        expect(
          TimeSlot.fromDateTime(DateTime(2024, 1, 15, 23, 0)),
          equals(TimeSlot.night),
        );
      });
    });

    group('next', () {
      test('returns correct next time slot', () {
        expect(TimeSlot.morning.next, equals(TimeSlot.forenoon));
        expect(TimeSlot.forenoon.next, equals(TimeSlot.afternoon));
        expect(TimeSlot.afternoon.next, equals(TimeSlot.evening));
        expect(TimeSlot.evening.next, equals(TimeSlot.night));
        expect(TimeSlot.night.next, equals(TimeSlot.morning));
      });
    });

    group('previous', () {
      test('returns correct previous time slot', () {
        expect(TimeSlot.morning.previous, equals(TimeSlot.night));
        expect(TimeSlot.forenoon.previous, equals(TimeSlot.morning));
        expect(TimeSlot.afternoon.previous, equals(TimeSlot.forenoon));
        expect(TimeSlot.evening.previous, equals(TimeSlot.afternoon));
        expect(TimeSlot.night.previous, equals(TimeSlot.evening));
      });
    });

    group('fromValue', () {
      test('returns correct time slot for valid values', () {
        expect(TimeSlot.fromValue(0), equals(TimeSlot.morning));
        expect(TimeSlot.fromValue(1), equals(TimeSlot.forenoon));
        expect(TimeSlot.fromValue(2), equals(TimeSlot.afternoon));
        expect(TimeSlot.fromValue(3), equals(TimeSlot.evening));
        expect(TimeSlot.fromValue(4), equals(TimeSlot.night));
      });

      test('returns null for invalid values', () {
        expect(TimeSlot.fromValue(-1), isNull);
        expect(TimeSlot.fromValue(5), isNull);
        expect(TimeSlot.fromValue(100), isNull);
      });
    });

    group('isNearBoundary', () {
      test('returns true for times near slot boundaries', () {
        // 早晨时段边界: 06:00
        expect(TimeSlot.morning.isNearBoundary(5, 45), isTrue); // 05:45 接近 06:00
        expect(TimeSlot.morning.isNearBoundary(6, 15), isTrue); // 06:15 接近 06:00
        // 早晨时段边界: 09:00
        expect(TimeSlot.morning.isNearBoundary(8, 45), isTrue); // 08:45 接近 09:00
        expect(TimeSlot.morning.isNearBoundary(9, 15), isTrue); // 09:15 接近 09:00
      });

      test('returns false for times not near slot boundaries', () {
        // 早晨中间时间 07:30
        expect(TimeSlot.morning.isNearBoundary(7, 30), isFalse);
        // 下午中间时间 15:00
        expect(TimeSlot.afternoon.isNearBoundary(15, 0), isFalse);
      });
    });
  });
}