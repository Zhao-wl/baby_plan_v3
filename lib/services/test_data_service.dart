import 'dart:math';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../database/tables/activity_records.dart';

/// 测试数据服务
///
/// 提供测试数据账号的创建和注入功能。
/// 测试数据账号使用固定 ID: test-user-001
class TestDataService {
  final AppDatabase _db;

  /// 测试用户固定 ID
  static const String testUserId = 'test-user-001';

  /// 测试用户昵称
  static const String testUserNickname = '测试数据账号';

  TestDataService(this._db);

  /// 检查是否已有测试数据
  Future<bool> hasTestData() async {
    final user = await _getTestUser();
    return user != null;
  }

  /// 获取测试用户
  Future<User?> _getTestUser() async {
    return await (_db.select(_db.users)
          ..where((u) => u.nickname.equals(testUserNickname)))
        .getSingleOrNull();
  }

  /// 注入测试数据
  ///
  /// 创建测试用户并注入预设的测试数据。
  /// 如果已存在测试数据，将先清除旧数据。
  Future<void> injectTestData() async {
    // 清除旧测试数据
    await clearTestData();

    // 创建测试用户
    final userId = await _createTestUser();

    // 创建测试宝宝
    final baby1Id = await _createBaby(
      userId: userId,
      name: '小明',
      birthDate: DateTime.now().subtract(const Duration(days: 90)), // 3个月大
      gender: 0, // 男
    );

    final baby2Id = await _createBaby(
      userId: userId,
      name: '小红',
      birthDate: DateTime.now().subtract(const Duration(days: 240)), // 8个月大
      gender: 1, // 女
    );

    // 为两个宝宝生成活动记录
    await _generateActivityRecords(baby1Id, days: 90);
    await _generateActivityRecords(baby2Id, days: 90);

    // 生成疫苗记录
    await _generateVaccineRecords(baby1Id);
    await _generateVaccineRecords(baby2Id);

    // 生成生长记录
    await _generateGrowthRecords(baby1Id);
    await _generateGrowthRecords(baby2Id);
  }

  /// 创建测试用户
  Future<int> _createTestUser() async {
    return await _db.into(_db.users).insert(
          UsersCompanion.insert(
            nickname: testUserNickname,
            isGuest: const Value(false),
          ),
        );
  }

  /// 创建宝宝
  Future<int> _createBaby({
    required int userId,
    required String name,
    required DateTime birthDate,
    required int gender,
  }) async {
    return await _db.into(_db.babies).insert(
          BabiesCompanion.insert(
            name: name,
            birthDate: birthDate,
            gender: Value(gender),
            birthWeight: Value(gender == 0 ? 3.5 : 3.2), // 男孩稍重
            birthHeight: Value(gender == 0 ? 50.0 : 49.0),
          ),
        );
  }

  /// 生成活动记录
  ///
  /// 为指定宝宝生成指定天数的活动记录。
  /// 每天生成 6-10 条记录，覆盖 E/A/S/P 四种类型。
  Future<void> _generateActivityRecords(int babyId, {required int days}) async {
    final random = Random(42); // 固定种子，保证数据可重复
    final now = DateTime.now();

    await _db.batch((batch) {
      for (int day = 0; day < days; day++) {
        final date = now.subtract(Duration(days: day));
        final dayRecords = 6 + random.nextInt(5); // 每天 6-10 条记录

        // 生成一天的活动记录
        _generateDayActivities(
          batch: batch,
          babyId: babyId,
          date: date,
          recordCount: dayRecords,
          random: random,
        );
      }
    });
  }

  /// 生成一天的活动记录
  void _generateDayActivities({
    required Batch batch,
    required int babyId,
    required DateTime date,
    required int recordCount,
    required Random random,
  }) {
    // 模拟一天的作息：
    // 早上 6:00 - 8:00: 喂养
    // 上午 8:00 - 10:00: 活动
    // 上午 10:00 - 12:00: 睡眠
    // 中午 12:00 - 14:00: 喂养
    // 下午 14:00 - 16:00: 活动
    // 下午 16:00 - 18:00: 睡眠
    // 傍晚 18:00 - 20:00: 喂养
    // 晚上 20:00 - 22:00: 睡眠
    // 夜间 22:00 - 06:00: 睡眠

    final schedule = [
      _ActivitySchedule(ActivityType.eat, 6, 8, 15, 30),    // 早餐
      _ActivitySchedule(ActivityType.activity, 8, 10, 60, 120), // 上午活动
      _ActivitySchedule(ActivityType.sleep, 10, 12, 90, 120),  // 上午睡眠
      _ActivitySchedule(ActivityType.eat, 12, 14, 15, 30),  // 午餐
      _ActivitySchedule(ActivityType.poop, 14, 15, 5, 10),  // 排泄
      _ActivitySchedule(ActivityType.activity, 15, 17, 60, 120), // 下午活动
      _ActivitySchedule(ActivityType.sleep, 17, 19, 60, 120),   // 下午睡眠
      _ActivitySchedule(ActivityType.eat, 19, 20, 15, 30),  // 晚餐
      _ActivitySchedule(ActivityType.sleep, 21, 6, 480, 600),   // 夜间睡眠
    ];

    for (final sched in schedule) {
      final startTime = DateTime(
        date.year,
        date.month,
        date.day,
        sched.startHour,
        random.nextInt(30),
      );
      final durationMinutes =
          sched.minDuration + random.nextInt(sched.maxDuration - sched.minDuration);
      final endTime = startTime.add(Duration(minutes: durationMinutes));

      batch.insert(
        _db.activityRecords,
        _createActivityCompanion(
          babyId: babyId,
          type: sched.type,
          startTime: startTime,
          endTime: endTime,
          durationMinutes: durationMinutes,
          random: random,
        ),
      );
    }
  }

  /// 创建活动记录的 Companion
  ActivityRecordsCompanion _createActivityCompanion({
    required int babyId,
    required ActivityType type,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required Random random,
  }) {
    switch (type) {
      case ActivityType.eat:
        return _createEatCompanion(
          babyId: babyId,
          startTime: startTime,
          endTime: endTime,
          durationMinutes: durationMinutes,
          random: random,
        );
      case ActivityType.activity:
        return _createActivityCompanionForType(
          babyId: babyId,
          startTime: startTime,
          endTime: endTime,
          durationMinutes: durationMinutes,
          random: random,
        );
      case ActivityType.sleep:
        return _createSleepCompanion(
          babyId: babyId,
          startTime: startTime,
          endTime: endTime,
          durationMinutes: durationMinutes,
          random: random,
        );
      case ActivityType.poop:
        return _createPoopCompanion(
          babyId: babyId,
          startTime: startTime,
          endTime: endTime,
          random: random,
        );
    }
  }

  /// 创建喂养记录
  ActivityRecordsCompanion _createEatCompanion({
    required int babyId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required Random random,
  }) {
    final eatingMethod = random.nextInt(3); // 0=母乳, 1=奶粉, 2=辅食

    return ActivityRecordsCompanion.insert(
      babyId: babyId,
      type: ActivityType.eat.value,
      startTime: startTime,
      endTime: Value(endTime),
      durationSeconds: Value(durationMinutes * 60),
      status: const Value(1), // 已完成
      eatingMethod: Value(eatingMethod),
      breastSide: eatingMethod == 0 ? Value(random.nextInt(3)) : const Value.absent(),
      breastDurationMinutes:
          eatingMethod == 0 ? Value(durationMinutes) : const Value.absent(),
      formulaAmountMl:
          eatingMethod == 1 ? Value(90 + random.nextInt(90)) : const Value.absent(), // 90-180ml
      foodType: eatingMethod == 2
          ? Value(['米粉', '果泥', '蔬菜泥', '肉泥'][random.nextInt(4)])
          : const Value.absent(),
    );
  }

  /// 创建活动记录
  ActivityRecordsCompanion _createActivityCompanionForType({
    required int babyId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required Random random,
  }) {
    return ActivityRecordsCompanion.insert(
      babyId: babyId,
      type: ActivityType.activity.value,
      startTime: startTime,
      endTime: Value(endTime),
      durationSeconds: Value(durationMinutes * 60),
      status: const Value(1),
      activityType: Value(random.nextInt(9)), // 0-8: 趴/翻身/坐/爬/站/走/户外/游泳/其他
      mood: Value(random.nextInt(3)), // 0-2: 开心/一般/不开心
    );
  }

  /// 创建睡眠记录
  ActivityRecordsCompanion _createSleepCompanion({
    required int babyId,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required Random random,
  }) {
    return ActivityRecordsCompanion.insert(
      babyId: babyId,
      type: ActivityType.sleep.value,
      startTime: startTime,
      endTime: Value(endTime),
      durationSeconds: Value(durationMinutes * 60),
      status: const Value(1),
      sleepQuality: Value(random.nextInt(3)), // 0-2: 差/一般/好
      sleepLocation: Value(random.nextInt(4)), // 0-3: 婴儿床/父母床/推车/其他
      sleepAssistMethod: Value(random.nextInt(4)), // 0-3: 无/安抚奶嘴/摇篮/怀抱
    );
  }

  /// 创建排泄记录
  ActivityRecordsCompanion _createPoopCompanion({
    required int babyId,
    required DateTime startTime,
    required DateTime endTime,
    required Random random,
  }) {
    return ActivityRecordsCompanion.insert(
      babyId: babyId,
      type: ActivityType.poop.value,
      startTime: startTime,
      endTime: Value(endTime),
      durationSeconds: const Value(300), // 约5分钟
      status: const Value(1),
      diaperType: Value(random.nextInt(3)), // 0-2: 尿/屎/混合
      stoolColor: Value(random.nextInt(5)), // 0-4: 黄/绿/棕/黑/其他
      stoolTexture: Value(random.nextInt(3)), // 0-2: 正常/稀/干硬
    );
  }

  /// 生成疫苗记录
  Future<void> _generateVaccineRecords(int babyId) async {
    // 获取疫苗库
    final vaccines = await _db.getAllVaccines();
    if (vaccines.isEmpty) return;

    final random = Random(42);
    final now = DateTime.now();

    // 模拟已接种的疫苗（按月龄）
    await _db.batch((batch) {
      for (final vaccine in vaccines) {
        // 计算接种日期
        final ageInDays = vaccine.recommendedAgeDays;
        final actualDays = ageInDays + random.nextInt(7); // 推荐日期 + 0-6 天

        // 只生成已过期的疫苗记录
        if (actualDays <= 180) {
          final actualDate = now.subtract(Duration(days: 180 - actualDays));

          batch.insert(
            _db.vaccineRecords,
            VaccineRecordsCompanion.insert(
              babyId: babyId,
              vaccineLibraryId: vaccine.id,
              actualDate: actualDate,
              status: const Value(1), // 已接种
              hospital: Value(['儿童医院', '社区医院', '妇幼保健院'][random.nextInt(3)]),
            ),
          );
        }
      }
    });
  }

  /// 生成生长记录
  Future<void> _generateGrowthRecords(int babyId) async {
    final random = Random(42);
    final now = DateTime.now();

    // 每2周一条生长记录
    await _db.batch((batch) {
      for (int week = 0; week < 12; week++) {
        final recordDate = now.subtract(Duration(days: week * 14));

        // 模拟体重增长：出生体重 + 每周增长约 0.2kg
        final weight = 3.5 + (week * 0.2) + (random.nextDouble() * 0.1);
        // 模拟身高增长：出生身高 + 每周增长约 0.5cm
        final height = 50.0 + (week * 0.5) + (random.nextDouble() * 0.2);
        // 模拟头围增长：出生头围 + 每周增长约 0.2cm
        final headCircumference = 35.0 + (week * 0.2) + (random.nextDouble() * 0.1);

        batch.insert(
          _db.growthRecords,
          GrowthRecordsCompanion.insert(
            babyId: babyId,
            recordDate: recordDate,
            weight: Value(double.parse(weight.toStringAsFixed(2))),
            height: Value(double.parse(height.toStringAsFixed(1))),
            headCircumference: Value(double.parse(headCircumference.toStringAsFixed(1))),
          ),
        );
      }
    });
  }

  /// 清除测试数据
  ///
  /// 删除所有与测试用户相关的数据。
  Future<void> clearTestData() async {
    // 获取测试用户
    final testUser = await _getTestUser();
    if (testUser == null) return;

    // 删除活动记录
    await (_db.delete(_db.activityRecords)
          ..where((a) => a.isDeleted.equals(false))).go();

    // 删除疫苗记录
    await (_db.delete(_db.vaccineRecords)
          ..where((v) => v.isDeleted.equals(false))).go();

    // 删除生长记录
    await (_db.delete(_db.growthRecords)
          ..where((g) => g.isDeleted.equals(false))).go();

    // 删除宝宝
    await (_db.delete(_db.babies)
          ..where((b) => b.isDeleted.equals(false))).go();

    // 删除测试用户
    await (_db.delete(_db.users)
          ..where((u) => u.id.equals(testUser.id))).go();
  }
}

/// 活动时间安排
class _ActivitySchedule {
  final ActivityType type;
  final int startHour;
  final int endHour;
  final int minDuration;
  final int maxDuration;

  _ActivitySchedule(this.type, this.startHour, this.endHour, this.minDuration, this.maxDuration);
}