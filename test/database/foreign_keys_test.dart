import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull;
import 'test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Foreign Key Tests', () {
    late TestDatabase db;

    setUp(() async {
      db = TestDatabase();
    });

    tearDown(() async {
      await db.close();
    });

    group('Babies → Families Foreign Key', () {
      test('Baby can be linked to family', () async {
        // 创建家庭
        final familyId = await db.into(db.families).insert(
              FamiliesCompanion.insert(
                name: 'Test Family',
              ),
            );

        // 创建宝宝并关联家庭
        await db.into(db.babies).insert(
              BabiesCompanion.insert(
                familyId: Value(familyId),
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 验证关联
        final baby = await db.select(db.babies).getSingle();
        expect(baby.familyId, equals(familyId));

        // 验证可以通过 familyId 查询家庭
        final family = await (db.select(db.families)
              ..where((t) => t.id.equals(familyId)))
            .getSingle();
        expect(family.id, equals(familyId));
      });

      test('Baby can be created without family (familyId nullable)', () async {
        // 宝宝可以没有家庭关联（familyId 是可空的）
        await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        final baby = await db.select(db.babies).getSingle();
        expect(baby.familyId, isNull);
      });
    });

    group('FamilyMembers → Families/Users Foreign Key', () {
      test('FamilyMember can be linked to family and user', () async {
        // 创建用户
        final userId = await db.into(db.users).insert(
              UsersCompanion.insert(
                nickname: 'Test User',
              ),
            );

        // 创建家庭
        final familyId = await db.into(db.families).insert(
              FamiliesCompanion.insert(
                name: 'Test Family',
              ),
            );

        // 创建家庭成员关联
        await db.into(db.familyMembers).insert(
              FamilyMembersCompanion.insert(
                familyId: familyId,
                userId: userId,
              ),
            );

        // 验证关联
        final member = await db.select(db.familyMembers).getSingle();
        expect(member.familyId, equals(familyId));
        expect(member.userId, equals(userId));
      });

      test('FamilyMember unique constraint on (familyId, userId)', () async {
        // 创建用户
        final userId = await db.into(db.users).insert(
              UsersCompanion.insert(
                nickname: 'Test User',
              ),
            );

        // 创建家庭
        final familyId = await db.into(db.families).insert(
              FamiliesCompanion.insert(
                name: 'Test Family',
              ),
            );

        // 创建第一个家庭成员关联
        await db.into(db.familyMembers).insert(
              FamilyMembersCompanion.insert(
                familyId: familyId,
                userId: userId,
              ),
            );

        // 尝试创建重复的成员关系 - 应该失败
        // Drift 在 SQLite 层面使用 UNIQUE 约束
        expect(
          () async => await db.into(db.familyMembers).insert(
                FamilyMembersCompanion.insert(
                  familyId: familyId,
                  userId: userId,
                ),
              ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('GrowthRecords → Babies Foreign Key', () {
      test('GrowthRecord can be linked to baby', () async {
        // 创建宝宝
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 创建生长记录
        await db.into(db.growthRecords).insert(
              GrowthRecordsCompanion.insert(
                babyId: babyId,
                recordDate: DateTime(2024, 6, 1),
              ),
            );

        // 验证关联
        final record = await db.select(db.growthRecords).getSingle();
        expect(record.babyId, equals(babyId));
      });
    });

    group('ActivityRecords → Babies Foreign Key', () {
      test('ActivityRecord can be linked to baby', () async {
        // 创建宝宝
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 创建活动记录
        await db.into(db.activityRecords).insert(
              ActivityRecordsCompanion.insert(
                babyId: babyId,
                type: 0, // Eat
                startTime: DateTime(2024, 6, 1, 10, 0),
              ),
            );

        // 验证关联
        final record = await db.select(db.activityRecords).getSingle();
        expect(record.babyId, equals(babyId));
      });
    });

    group('VaccineRecords → Babies Foreign Key', () {
      test('VaccineRecord can be linked to baby', () async {
        // 创建宝宝
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 创建疫苗库条目
        final vaccineId = await db.into(db.vaccineLibrary).insert(
              VaccineLibraryCompanion.insert(
                name: '乙肝疫苗',
                fullName: '乙型肝炎疫苗',
                code: 'HepB',
                doseIndex: 1,
                totalDoses: 3,
                recommendedAgeDays: 0,
                ageDescription: '出生时',
              ),
            );

        // 创建接种记录
        await db.into(db.vaccineRecords).insert(
              VaccineRecordsCompanion.insert(
                babyId: babyId,
                vaccineLibraryId: vaccineId,
                actualDate: DateTime(2024, 1, 1),
              ),
            );

        // 验证关联
        final record = await db.select(db.vaccineRecords).getSingle();
        expect(record.babyId, equals(babyId));
      });
    });

    group('VaccineRecords → VaccineLibrary Foreign Key', () {
      test('VaccineRecord can be linked to vaccine library', () async {
        // 创建宝宝
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 创建疫苗库条目
        final vaccineId = await db.into(db.vaccineLibrary).insert(
              VaccineLibraryCompanion.insert(
                name: '乙肝疫苗',
                fullName: '乙型肝炎疫苗',
                code: 'HepB',
                doseIndex: 1,
                totalDoses: 3,
                recommendedAgeDays: 0,
                ageDescription: '出生时',
              ),
            );

        // 创建接种记录
        await db.into(db.vaccineRecords).insert(
              VaccineRecordsCompanion.insert(
                babyId: babyId,
                vaccineLibraryId: vaccineId,
                actualDate: DateTime(2024, 1, 1),
              ),
            );

        // 验证关联
        final record = await db.select(db.vaccineRecords).getSingle();
        expect(record.vaccineLibraryId, equals(vaccineId));

        // 验证可以查询到疫苗信息
        final vaccine = await (db.select(db.vaccineLibrary)
              ..where((t) => t.id.equals(vaccineId)))
            .getSingle();
        expect(vaccine.name, equals('乙肝疫苗'));
      });
    });

    group('GrowthRecords → ActivityRecords Foreign Key', () {
      test('GrowthRecord can be linked to activity record', () async {
        // 创建宝宝
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        // 创建活动记录
        final activityId = await db.into(db.activityRecords).insert(
              ActivityRecordsCompanion.insert(
                babyId: babyId,
                type: 0, // Eat
                startTime: DateTime(2024, 6, 1, 10, 0),
              ),
            );

        // 创建生长记录并关联活动
        await db.into(db.growthRecords).insert(
              GrowthRecordsCompanion.insert(
                babyId: babyId,
                recordDate: DateTime(2024, 6, 1),
                relatedActivityId: Value(activityId),
              ),
            );

        // 验证关联
        final record = await db.select(db.growthRecords).getSingle();
        expect(record.relatedActivityId, equals(activityId));
      });
    });
  });
}