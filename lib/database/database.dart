import 'package:drift/drift.dart';

import 'connection.dart';
import 'tables/test_table.dart';

part 'database.g.dart';

/// 应用数据库
///
/// 使用 Drift ORM 管理 SQLite 数据库。
/// schema 版本 1，包含测试表用于验证数据库功能。
@DriftDatabase(tables: [TestRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // 首次创建数据库时执行
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 版本迁移逻辑
      },
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