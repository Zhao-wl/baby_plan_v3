import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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

  // ========== 疫苗库数据管理 ==========

  /// 从 JSON 文件加载疫苗库数据到数据库
  ///
  /// 仅在数据库为空或版本更新时执行加载。
  /// 返回是否执行了加载操作。
  Future<bool> loadVaccineLibraryFromJson() async {
    try {
      // 检查数据库是否已有数据
      final existingCount = await (select(vaccineLibrary).get()).then((list) => list.length);

      // 读取 JSON 文件
      final jsonString = await rootBundle.loadString('assets/data/vaccine_library.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final version = jsonData['version'] as int;
      final vaccines = jsonData['vaccines'] as List<dynamic>;

      // 检查是否需要更新（版本号更高或数据库为空）
      if (existingCount > 0) {
        // 获取当前数据库中的版本号
        final existingRecords = await select(vaccineLibrary).get();
        final currentVersion = existingRecords.first.dataVersion;

        if (currentVersion >= version) {
          // 数据已是最新，无需加载
          return false;
        }

        // 版本更新，先清空旧数据
        await delete(vaccineLibrary).go();
      }

      // 批量插入新数据
      await batch((batch) {
        for (final vaccineJson in vaccines) {
          batch.insert(
            vaccineLibrary,
            VaccineLibraryCompanion.insert(
              name: vaccineJson['name'] as String,
              fullName: vaccineJson['fullName'] as String,
              code: vaccineJson['code'] as String,
              doseIndex: vaccineJson['doseIndex'] as int,
              totalDoses: vaccineJson['totalDoses'] as int,
              recommendedAgeDays: vaccineJson['recommendedAgeDays'] as int,
              minIntervalDays: Value(vaccineJson['minIntervalDays'] as int?),
              ageDescription: vaccineJson['ageDescription'] as String,
              vaccineType: Value(vaccineJson['vaccineType'] as int? ?? 0),
              isCombined: Value(vaccineJson['isCombined'] as bool? ?? false),
              description: Value(vaccineJson['description'] as String?),
              contraindications: Value(vaccineJson['contraindications'] as String?),
              sideEffects: Value(vaccineJson['sideEffects'] as String?),
              dataVersion: Value(version),
            ),
          );
        }
      });

      return true;
    } catch (e) {
      // 加载失败，记录错误但不抛出异常
      print('加载疫苗库数据失败: $e');
      return false;
    }
  }

  /// 获取所有疫苗库数据（按推荐年龄排序）
  Future<List<VaccineLibraryData>> getAllVaccines() async {
    return (select(vaccineLibrary)
          ..orderBy([(v) => OrderingTerm.asc(v.recommendedAgeDays)]))
        .get();
  }

  /// 获取指定月龄分组的疫苗列表
  Future<List<VaccineLibraryData>> getVaccinesByAgeGroup(String ageDescription) async {
    return (select(vaccineLibrary)
          ..where((v) => v.ageDescription.equals(ageDescription))
          ..orderBy([(v) => OrderingTerm.asc(v.doseIndex)]))
        .get();
  }

  /// 获取所有月龄分组（去重，按推荐年龄排序）
  Future<List<String>> getAgeGroups() async {
    final vaccines = await select(vaccineLibrary).get();

    // 使用 Map 保存每个 ageGroup 的最小 recommendedAgeDays
    final ageGroupMinDays = <String, int>{};
    for (final vaccine in vaccines) {
      final existing = ageGroupMinDays[vaccine.ageDescription];
      if (existing == null || vaccine.recommendedAgeDays < existing) {
        ageGroupMinDays[vaccine.ageDescription] = vaccine.recommendedAgeDays;
      }
    }

    // 按 recommendedAgeDays 排序
    final sortedAgeGroups = ageGroupMinDays.keys.toList()
      ..sort((a, b) => ageGroupMinDays[a]!.compareTo(ageGroupMinDays[b]!));

    return sortedAgeGroups;
  }

  // ========== 接种记录管理 ==========

  /// 获取宝宝的接种记录（关联疫苗库信息）
  Future<List<VaccineRecord>> getVaccineRecordsByBaby(int babyId) async {
    return (select(vaccineRecords)
          ..where((r) => r.babyId.equals(babyId))
          ..where((r) => r.isDeleted.equals(false))
          ..orderBy([(r) => OrderingTerm.desc(r.actualDate)]))
        .get();
  }

  /// 获取宝宝指定疫苗的接种记录
  Future<VaccineRecord?> getVaccineRecord(int babyId, int vaccineLibraryId) async {
    return (select(vaccineRecords)
          ..where((r) => r.babyId.equals(babyId))
          ..where((r) => r.vaccineLibraryId.equals(vaccineLibraryId))
          ..where((r) => r.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 创建接种记录
  Future<int> createVaccineRecord({
    required int babyId,
    required int vaccineLibraryId,
    required DateTime actualDate,
    String? batchNumber,
    String? manufacturer,
    String? hospital,
    int? injectionSite,
    int? reactionLevel,
    String? reactionDetail,
    String? notes,
  }) async {
    return await into(vaccineRecords).insert(
      VaccineRecordsCompanion.insert(
        babyId: babyId,
        vaccineLibraryId: vaccineLibraryId,
        actualDate: actualDate,
        batchNumber: Value(batchNumber),
        manufacturer: Value(manufacturer),
        hospital: Value(hospital),
        injectionSite: Value(injectionSite),
        reactionLevel: Value(reactionLevel),
        reactionDetail: Value(reactionDetail),
        notes: Value(notes),
        status: const Value(1), // 已接种
      ),
    );
  }

  /// 更新接种记录
  Future<void> updateVaccineRecord(VaccineRecord record) async {
    await update(vaccineRecords).replace(
      record.copyWith(
        updatedAt: DateTime.now(),
        syncStatus: 1, // 标记为待上传
        version: record.version + 1,
      ),
    );
  }
}