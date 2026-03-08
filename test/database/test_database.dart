import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:baby_plan_v3/database/tables/test_table.dart';
import 'package:baby_plan_v3/database/tables/users.dart';
import 'package:baby_plan_v3/database/tables/families.dart';
import 'package:baby_plan_v3/database/tables/family_members.dart';
import 'package:baby_plan_v3/database/tables/babies.dart';
import 'package:baby_plan_v3/database/tables/activity_records.dart';
import 'package:baby_plan_v3/database/tables/growth_records.dart';
import 'package:baby_plan_v3/database/tables/vaccine_library.dart';
import 'package:baby_plan_v3/database/tables/vaccine_records.dart';
import 'package:baby_plan_v3/database/tables/age_benchmark_data.dart';

part 'test_database.g.dart';

/// 测试用内存数据库
@DriftDatabase(
  tables: [
    TestRecords,
    Users,
    Families,
    FamilyMembers,
    Babies,
    ActivityRecords,
    GrowthRecords,
    VaccineLibrary,
    VaccineRecords,
    AgeBenchmarkData,
  ],
)
class TestDatabase extends _$TestDatabase {
  TestDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createIndexes(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createAll();
          await _createIndexes(m);
        }
      },
    );
  }

  Future<void> _createIndexes(Migrator m) async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_activity_baby_time ON activity_records(baby_id, start_time)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_activity_sync ON activity_records(sync_status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_babies_family ON babies(family_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_growth_baby ON growth_records(baby_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccine_baby ON vaccine_records(baby_id)',
    );
  }
}