import 'package:drift/drift.dart';

import 'connection.dart';
import 'tables/test_table.dart';
import 'tables/users.dart';
import 'tables/families.dart';
import 'tables/family_members.dart';
import 'tables/babies.dart';
import 'tables/activity_records.dart';
import 'tables/growth_records.dart';
import 'tables/vaccine_library.dart';
import 'tables/vaccine_records.dart';
import 'tables/age_benchmark_data.dart';

part 'database.g.dart';

/// 应用数据库
///
/// 使用 Drift ORM 管理 SQLite 数据库。
/// Schema 版本 2，包含完整的业务数据模型。
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
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // 首次创建数据库时执行
        await m.createAll();
        // 创建索引
        await _createIndexes(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 版本迁移逻辑
        if (from < 2) {
          // 从 v1 升级到 v2：创建所有业务表
          await m.createAll();
          // 创建索引
          await _createIndexes(m);
        }
      },
    );
  }

  /// 创建数据库索引
  Future<void> _createIndexes(Migrator m) async {
    // 活动记录：按宝宝和时间查询
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_activity_baby_time ON activity_records(baby_id, start_time)',
    );

    // 活动记录：同步状态查询
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_activity_sync ON activity_records(sync_status)',
    );

    // 宝宝：按家庭查询
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_babies_family ON babies(family_id)',
    );

    // 生长记录：按宝宝查询
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_growth_baby ON growth_records(baby_id)',
    );

    // 疫苗记录：按宝宝查询
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccine_baby ON vaccine_records(baby_id)',
    );
  }

  /// 测试插入性能 - 插入指定数量的记录并返回耗时（毫秒）
  Future<int> testInsertPerformance(int count) async {
    final stopwatch = Stopwatch()..start();

    await batch((batch) {
      for (int i = 0; i < count; i++) {
        batch.insert(
          testRecords,
          TestRecordsCompanion.insert(name: 'Test Record $i'),
        );
      }
    });

    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  /// 获取测试记录数量
  Future<int> getTestRecordCount() async {
    return (select(testRecords).get()).then((records) => records.length);
  }

  /// 清空测试记录
  Future<void> clearTestRecords() async {
    await delete(testRecords).go();
  }
}