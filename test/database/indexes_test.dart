import 'package:flutter_test/flutter_test.dart';
import 'test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Database Index Tests', () {
    late TestDatabase db;

    setUp(() async {
      db = TestDatabase();
    });

    tearDown(() async {
      await db.close();
    });

    group('ActivityRecords Index Tests', () {
      test('idx_activity_baby_time index should exist', () async {
        // 查询索引列表
        final result = await db.customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_activity_baby_time'",
        ).get();

        expect(result.isNotEmpty, isTrue,
            reason: 'idx_activity_baby_time index should exist');
      });

      test('idx_activity_baby_time should be on activity_records table', () async {
        // 验证索引所属表
        final result = await db.customSelect(
          "SELECT tbl_name FROM sqlite_master WHERE type='index' AND name='idx_activity_baby_time'",
        ).get();

        if (result.isNotEmpty) {
          expect(result.first.data['tbl_name'], equals('activity_records'));
        }
      });

      test('idx_activity_sync index should exist', () async {
        final result = await db.customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_activity_sync'",
        ).get();

        expect(result.isNotEmpty, isTrue,
            reason: 'idx_activity_sync index should exist');
      });
    });

    group('Babies Index Tests', () {
      test('idx_babies_family index should exist', () async {
        final result = await db.customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_babies_family'",
        ).get();

        expect(result.isNotEmpty, isTrue,
            reason: 'idx_babies_family index should exist');
      });

      test('idx_babies_family should be on babies table', () async {
        final result = await db.customSelect(
          "SELECT tbl_name FROM sqlite_master WHERE type='index' AND name='idx_babies_family'",
        ).get();

        if (result.isNotEmpty) {
          expect(result.first.data['tbl_name'], equals('babies'));
        }
      });
    });

    group('GrowthRecords Index Tests', () {
      test('idx_growth_baby index should exist', () async {
        final result = await db.customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_growth_baby'",
        ).get();

        expect(result.isNotEmpty, isTrue,
            reason: 'idx_growth_baby index should exist');
      });

      test('idx_growth_baby should be on growth_records table', () async {
        final result = await db.customSelect(
          "SELECT tbl_name FROM sqlite_master WHERE type='index' AND name='idx_growth_baby'",
        ).get();

        if (result.isNotEmpty) {
          expect(result.first.data['tbl_name'], equals('growth_records'));
        }
      });
    });

    group('VaccineRecords Index Tests', () {
      test('idx_vaccine_baby index should exist', () async {
        final result = await db.customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_vaccine_baby'",
        ).get();

        expect(result.isNotEmpty, isTrue,
            reason: 'idx_vaccine_baby index should exist');
      });

      test('idx_vaccine_baby should be on vaccine_records table', () async {
        final result = await db.customSelect(
          "SELECT tbl_name FROM sqlite_master WHERE type='index' AND name='idx_vaccine_baby'",
        ).get();

        if (result.isNotEmpty) {
          expect(result.first.data['tbl_name'], equals('vaccine_records'));
        }
      });
    });

    group('Index Performance Tests', () {
      test('Query plan should use idx_activity_baby_time', () async {
        // 先插入一些测试数据
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 插入一些活动记录
        for (int i = 0; i < 10; i++) {
          await db.into(db.activityRecords).insert(
                ActivityRecordsCompanion.insert(
                  babyId: babyId,
                  type: 0,
                  startTime: DateTime(2024, 6, i + 1),
                ),
              );
        }

        // 检查查询计划
        final planResult = await db.customSelect(
          "EXPLAIN QUERY PLAN SELECT * FROM activity_records WHERE baby_id = $babyId ORDER BY start_time",
        ).get();

        // 验证查询计划中使用了索引
        final planStr = planResult.map((r) => r.data.toString()).join('\n');
        // 索引应该出现在查询计划中
        expect(
          planStr.contains('idx_activity_baby_time') ||
              planStr.contains('INDEX') ||
              planStr.contains('COVERING'),
          isTrue,
          reason: 'Query should use index. Plan: $planStr',
        );
      });
    });
  });
}