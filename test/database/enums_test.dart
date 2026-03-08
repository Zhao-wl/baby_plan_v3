import 'package:flutter_test/flutter_test.dart';
import 'package:baby_plan_v3/database/tables/activity_records.dart';
import 'package:baby_plan_v3/database/tables/babies.dart';
import 'package:baby_plan_v3/database/tables/family_members.dart';
import 'package:baby_plan_v3/database/tables/vaccine_records.dart';
import 'package:baby_plan_v3/database/tables/growth_records.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ActivityType Enum Tests', () {
    test('ActivityType enum should have correct values', () {
      expect(ActivityType.eat.value, equals(0));
      expect(ActivityType.activity.value, equals(1));
      expect(ActivityType.sleep.value, equals(2));
      expect(ActivityType.poop.value, equals(3));
    });

    test('ActivityType should have exactly 4 values', () {
      expect(ActivityType.values.length, equals(4));
    });

    test('ActivityType values should match E.A.S.Y pattern', () {
      // E - Eat (吃)
      expect(ActivityType.eat.value, equals(0));
      // A - Activity (活动)
      expect(ActivityType.activity.value, equals(1));
      // S - Sleep (睡眠)
      expect(ActivityType.sleep.value, equals(2));
      // Y - (Poop - 排泄)
      expect(ActivityType.poop.value, equals(3));
    });
  });

  group('EatingMethod Enum Tests', () {
    test('EatingMethod enum should have correct values', () {
      expect(EatingMethod.breast.value, equals(0));
      expect(EatingMethod.formula.value, equals(1));
      expect(EatingMethod.solid.value, equals(2));
    });

    test('EatingMethod should have exactly 3 values', () {
      expect(EatingMethod.values.length, equals(3));
    });
  });

  group('Gender Enum Tests', () {
    test('Gender enum should have correct values', () {
      expect(Gender.male.value, equals(0));
      expect(Gender.female.value, equals(1));
    });

    test('Gender should have exactly 2 values', () {
      expect(Gender.values.length, equals(2));
    });
  });

  group('FamilyRole Enum Tests', () {
    test('FamilyRole enum should have correct values', () {
      expect(FamilyRole.creator.value, equals(0));
      expect(FamilyRole.admin.value, equals(1));
      expect(FamilyRole.member.value, equals(2));
    });

    test('FamilyRole should have exactly 3 values', () {
      expect(FamilyRole.values.length, equals(3));
    });
  });

  group('BreastSide Enum Tests', () {
    test('BreastSide enum should have correct values', () {
      expect(BreastSide.left.value, equals(0));
      expect(BreastSide.right.value, equals(1));
      expect(BreastSide.both.value, equals(2));
    });

    test('BreastSide should have exactly 3 values', () {
      expect(BreastSide.values.length, equals(3));
    });
  });

  group('InjectionSite Enum Tests', () {
    test('InjectionSite enum should have correct values', () {
      expect(InjectionSite.leftUpperArm.value, equals(0));
      expect(InjectionSite.rightUpperArm.value, equals(1));
      expect(InjectionSite.leftThigh.value, equals(2));
      expect(InjectionSite.rightThigh.value, equals(3));
      expect(InjectionSite.oral.value, equals(4));
      expect(InjectionSite.other.value, equals(5));
    });

    test('InjectionSite should have exactly 6 values', () {
      expect(InjectionSite.values.length, equals(6));
    });
  });

  group('VaccineStatus Enum Tests', () {
    test('VaccineStatus enum should have correct values', () {
      expect(VaccineStatus.pending.value, equals(0));
      expect(VaccineStatus.completed.value, equals(1));
      expect(VaccineStatus.overdue.value, equals(2));
      expect(VaccineStatus.skipped.value, equals(3));
    });

    test('VaccineStatus should have exactly 4 values', () {
      expect(VaccineStatus.values.length, equals(4));
    });
  });

  group('SyncStatus Enum Tests', () {
    test('SyncStatus enum should have correct values', () {
      expect(SyncStatus.synced.value, equals(0));
      expect(SyncStatus.pendingUpload.value, equals(1));
      expect(SyncStatus.pendingDownload.value, equals(2));
      expect(SyncStatus.conflict.value, equals(3));
    });

    test('SyncStatus should have exactly 4 values', () {
      expect(SyncStatus.values.length, equals(4));
    });
  });

  group('GrowthContext Enum Tests', () {
    test('GrowthContext enum should have correct values', () {
      expect(GrowthContext.beforeMeal.value, equals(0));
      expect(GrowthContext.afterMeal.value, equals(1));
      expect(GrowthContext.beforePoop.value, equals(2));
      expect(GrowthContext.afterPoop.value, equals(3));
    });

    test('GrowthContext should have exactly 4 values', () {
      expect(GrowthContext.values.length, equals(4));
    });
  });
}