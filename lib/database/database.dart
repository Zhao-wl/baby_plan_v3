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
/// Schema 版本 4，包含完整的业务数据模型。
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
  int get schemaVersion => 5;

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
        if (from < 3) {
          // 从 v2 升级到 v3：添加 isGuest 字段
          await m.addColumn(users, users.isGuest);
        }
        if (from < 4) {
          // 从 v3 升级到 v4：添加 device_id 字段
          await m.addColumn(users, users.deviceId);
        }
        if (from < 5) {
          // 从 v4 升级到 v5：添加 activity_records.status 字段
          await m.addColumn(activityRecords, activityRecords.status);
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

  // ========== 进行中活动管理 ==========

  /// 创建进行中活动
  ///
  /// 创建一个新的活动记录，状态为进行中（status=0），没有结束时间
  Future<int> createOngoingActivity({
    required int babyId,
    required int type,
    String? notes,
  }) async {
    final now = DateTime.now();
    final companion = ActivityRecordsCompanion.insert(
      babyId: babyId,
      type: type,
      startTime: now,
      status: const Value(0), // 进行中
      notes: notes != null ? Value(notes) : const Value.absent(),
    );

    return await into(activityRecords).insert(companion);
  }

  /// 创建进行中活动（带详细字段）
  ///
  /// 创建一个新的活动记录，状态为进行中（status=0），支持传入所有详细字段
  Future<int> createOngoingActivityWithDetails({
    required int babyId,
    required int type,
    required DateTime startTime,
    int? eatingMethod,
    int? breastSide,
    int? breastDurationMinutes,
    int? formulaAmountMl,
    String? foodType,
    int? sleepQuality,
    int? sleepLocation,
    int? sleepAssistMethod,
    int? activityType,
    int? mood,
    int? diaperType,
    int? stoolColor,
    int? stoolTexture,
    String? notes,
  }) async {
    final companion = ActivityRecordsCompanion.insert(
      babyId: babyId,
      type: type,
      startTime: startTime,
      status: const Value(0), // 进行中
      notes: notes != null ? Value(notes) : const Value.absent(),
      eatingMethod: eatingMethod != null ? Value(eatingMethod) : const Value.absent(),
      breastSide: breastSide != null ? Value(breastSide) : const Value.absent(),
      breastDurationMinutes: breastDurationMinutes != null
          ? Value(breastDurationMinutes)
          : const Value.absent(),
      formulaAmountMl:
          formulaAmountMl != null ? Value(formulaAmountMl) : const Value.absent(),
      foodType: foodType != null ? Value(foodType) : const Value.absent(),
      sleepQuality: sleepQuality != null ? Value(sleepQuality) : const Value.absent(),
      sleepLocation:
          sleepLocation != null ? Value(sleepLocation) : const Value.absent(),
      sleepAssistMethod: sleepAssistMethod != null
          ? Value(sleepAssistMethod)
          : const Value.absent(),
      activityType:
          activityType != null ? Value(activityType) : const Value.absent(),
      mood: mood != null ? Value(mood) : const Value.absent(),
      diaperType: diaperType != null ? Value(diaperType) : const Value.absent(),
      stoolColor: stoolColor != null ? Value(stoolColor) : const Value.absent(),
      stoolTexture:
          stoolTexture != null ? Value(stoolTexture) : const Value.absent(),
    );

    return await into(activityRecords).insert(companion);
  }

  /// 获取指定宝宝的进行中活动
  ///
  /// 返回指定宝宝的进行中活动，如果没有则返回 null
  Future<ActivityRecord?> getOngoingActivity(int babyId) async {
    final query = select(activityRecords)
      ..where((a) => a.babyId.equals(babyId))
      ..where((a) => a.status.equals(0))
      ..where((a) => a.isDeleted.equals(false))
      ..orderBy([(a) => OrderingTerm.desc(a.startTime)])
      ..limit(1);

    return await query.getSingleOrNull();
  }

  /// 监听指定宝宝的进行中活动
  ///
  /// 返回一个 Stream，当进行中活动变化时自动通知
  Stream<ActivityRecord?> watchOngoingActivity(int babyId) {
    final query = select(activityRecords)
      ..where((a) => a.babyId.equals(babyId))
      ..where((a) => a.status.equals(0))
      ..where((a) => a.isDeleted.equals(false))
      ..orderBy([(a) => OrderingTerm.desc(a.startTime)])
      ..limit(1);

    return query.watchSingleOrNull();
  }

  /// 完成进行中活动
  ///
  /// 将进行中活动标记为已完成，设置结束时间和持续时间
  Future<void> completeActivity(int activityId) async {
    final now = DateTime.now();

    // 获取当前活动记录
    final activity = await (select(activityRecords)
          ..where((a) => a.id.equals(activityId)))
        .getSingle();

    // 计算持续时间
    final durationSeconds = now.difference(activity.startTime).inSeconds;

    // 更新记录
    await update(activityRecords).replace(
      activity.copyWith(
        endTime: Value(now),
        durationSeconds: Value(durationSeconds),
        status: 1, // 已完成
        syncStatus: 1, // 待上传
        version: activity.version + 1,
      ),
    );
  }

  /// 检查是否有进行中活动
  ///
  /// 返回指定宝宝是否有进行中活动
  Future<bool> hasOngoingActivity(int babyId) async {
    final activity = await getOngoingActivity(babyId);
    return activity != null;
  }
}