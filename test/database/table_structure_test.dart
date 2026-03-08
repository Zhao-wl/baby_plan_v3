import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:matcher/matcher.dart' show isNotNull;
import 'test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Table Structure Tests', () {
    late TestDatabase db;

    setUp(() async {
      db = TestDatabase();
    });

    tearDown(() async {
      await db.close();
    });

    group('Users Table Tests', () {
      test('Users table should exist and be accessible', () async {
        // 通过 Companion 对象验证字段存在性 - 如果字段不存在，编译会失败
        final user = UsersCompanion.insert(
          nickname: 'Test User',
        );
        expect(user.nickname.value, equals('Test User'));
      });

      test('Users table can insert and retrieve data', () async {
        final userId = await db.into(db.users).insert(
              UsersCompanion.insert(
                nickname: 'Test User',
                phone: const Value('13800138000'),
                email: const Value('test@example.com'),
              ),
            );

        final user = await db.select(db.users).getSingle();
        expect(user.id, equals(userId));
        expect(user.nickname, equals('Test User'));
        expect(user.phone, equals('13800138000'));
        expect(user.email, equals('test@example.com'));
      });

      test('Users table has soft delete fields', () async {
        await db.into(db.users).insert(
              UsersCompanion.insert(
                nickname: 'Test User',
                isDeleted: const Value(true),
                deletedAt: Value(DateTime(2024, 1, 1)),
              ),
            );

        final user = await db.select(db.users).getSingle();
        expect(user.isDeleted, isTrue);
        expect(user.deletedAt, isNotNull);
      });
    });

    group('Families Table Tests', () {
      test('Families table should exist and be accessible', () async {
        final family = FamiliesCompanion.insert(
          name: 'Test Family',
        );
        expect(family.name.value, equals('Test Family'));
      });

      test('Families table can insert and retrieve data', () async {
        final familyId = await db.into(db.families).insert(
              FamiliesCompanion.insert(
                name: 'Test Family',
                inviteCode: const Value('ABC123'),
              ),
            );

        final family = await db.select(db.families).getSingle();
        expect(family.id, equals(familyId));
        expect(family.name, equals('Test Family'));
        expect(family.inviteCode, equals('ABC123'));
      });

      test('Families table has soft delete fields', () async {
        await db.into(db.families).insert(
              FamiliesCompanion.insert(
                name: 'Test Family',
                isDeleted: const Value(true),
              ),
            );

        final family = await db.select(db.families).getSingle();
        expect(family.isDeleted, isTrue);
      });
    });

    group('FamilyMembers Table Tests', () {
      test('FamilyMembers table should exist and be accessible', () async {
        final member = FamilyMembersCompanion.insert(
          familyId: 1,
          userId: 1,
        );
        expect(member.familyId.value, equals(1));
        expect(member.userId.value, equals(1));
      });

      test('FamilyMembers table can insert and retrieve data', () async {
        final userId = await db.into(db.users).insert(
              UsersCompanion.insert(nickname: 'Test User'),
            );
        final familyId = await db.into(db.families).insert(
              FamiliesCompanion.insert(name: 'Test Family'),
            );

        await db.into(db.familyMembers).insert(
              FamilyMembersCompanion.insert(
                familyId: familyId,
                userId: userId,
                role: const Value(0), // creator
              ),
            );

        final member = await db.select(db.familyMembers).getSingle();
        expect(member.familyId, equals(familyId));
        expect(member.userId, equals(userId));
        expect(member.role, equals(0));
      });
    });

    group('Babies Table Tests', () {
      test('Babies table should exist and be accessible', () async {
        final baby = BabiesCompanion.insert(
          name: 'Test Baby',
          birthDate: DateTime(2024, 1, 1),
        );
        expect(baby.name.value, equals('Test Baby'));
      });

      test('Babies table can insert and retrieve data', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
                gender: const Value(0), // male
                birthWeight: const Value(3.5),
                birthHeight: const Value(50.0),
              ),
            );

        final baby = await db.select(db.babies).getSingle();
        expect(baby.id, equals(babyId));
        expect(baby.name, equals('Test Baby'));
        expect(baby.gender, equals(0));
        expect(baby.birthWeight, equals(3.5));
      });

      test('Babies table has sync fields', () async {
        await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
                serverId: const Value('server-123'),
                deviceId: const Value('device-456'),
                syncStatus: const Value(1),
                version: const Value(2),
              ),
            );

        final baby = await db.select(db.babies).getSingle();
        expect(baby.serverId, equals('server-123'));
        expect(baby.deviceId, equals('device-456'));
        expect(baby.syncStatus, equals(1));
        expect(baby.version, equals(2));
      });
    });

    group('ActivityRecords Table Tests', () {
      test('ActivityRecords table should exist and be accessible', () async {
        final record = ActivityRecordsCompanion.insert(
          babyId: 1,
          type: 0,
          startTime: DateTime(2024, 6, 1),
        );
        expect(record.babyId.value, equals(1));
        expect(record.type.value, equals(0));
      });

      test('ActivityRecords table can insert eating record', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        await db.into(db.activityRecords).insert(
              ActivityRecordsCompanion.insert(
                babyId: babyId,
                type: 0, // Eat
                startTime: DateTime(2024, 6, 1, 10, 0),
                eatingMethod: const Value(0), // breast
                breastSide: const Value(0), // left
                breastDurationMinutes: const Value(15),
              ),
            );

        final record = await db.select(db.activityRecords).getSingle();
        expect(record.type, equals(0));
        expect(record.eatingMethod, equals(0));
        expect(record.breastSide, equals(0));
        expect(record.breastDurationMinutes, equals(15));
      });

      test('ActivityRecords table can insert sleep record', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        await db.into(db.activityRecords).insert(
              ActivityRecordsCompanion.insert(
                babyId: babyId,
                type: 2, // Sleep
                startTime: DateTime(2024, 6, 1, 14, 0),
                sleepQuality: const Value(2), // good
                sleepLocation: const Value(0), // crib
              ),
            );

        final record = await db.select(db.activityRecords).getSingle();
        expect(record.type, equals(2));
        expect(record.sleepQuality, equals(2));
        expect(record.sleepLocation, equals(0));
      });

      test('ActivityRecords table can insert activity record', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        await db.into(db.activityRecords).insert(
              ActivityRecordsCompanion.insert(
                babyId: babyId,
                type: 1, // Activity
                startTime: DateTime(2024, 6, 1, 16, 0),
                activityType: const Value(0), // tummy time
                mood: const Value(0), // happy
              ),
            );

        final record = await db.select(db.activityRecords).getSingle();
        expect(record.type, equals(1));
        expect(record.activityType, equals(0));
        expect(record.mood, equals(0));
      });

      test('ActivityRecords table can insert poop record', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        await db.into(db.activityRecords).insert(
              ActivityRecordsCompanion.insert(
                babyId: babyId,
                type: 3, // Poop
                startTime: DateTime(2024, 6, 1, 18, 0),
                diaperType: const Value(1), // poop
                stoolColor: const Value(0), // yellow
                stoolTexture: const Value(0), // normal
              ),
            );

        final record = await db.select(db.activityRecords).getSingle();
        expect(record.type, equals(3));
        expect(record.diaperType, equals(1));
        expect(record.stoolColor, equals(0));
        expect(record.stoolTexture, equals(0));
      });
    });

    group('GrowthRecords Table Tests', () {
      test('GrowthRecords table should exist and be accessible', () async {
        final record = GrowthRecordsCompanion.insert(
          babyId: 1,
          recordDate: DateTime(2024, 6, 1),
        );
        expect(record.babyId.value, equals(1));
      });

      test('GrowthRecords table can insert and retrieve data', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );

        await db.into(db.growthRecords).insert(
              GrowthRecordsCompanion.insert(
                babyId: babyId,
                recordDate: DateTime(2024, 6, 1),
                weight: const Value(7.5),
                height: const Value(65.0),
                headCircumference: const Value(42.0),
                context: const Value(1), // after meal
              ),
            );

        final record = await db.select(db.growthRecords).getSingle();
        expect(record.weight, equals(7.5));
        expect(record.height, equals(65.0));
        expect(record.headCircumference, equals(42.0));
        expect(record.context, equals(1));
      });
    });

    group('VaccineLibrary Table Tests', () {
      test('VaccineLibrary table should exist and be accessible', () async {
        final vaccine = VaccineLibraryCompanion.insert(
          name: '乙肝疫苗',
          fullName: '乙型肝炎疫苗',
          code: 'HepB',
          doseIndex: 1,
          totalDoses: 3,
          recommendedAgeDays: 0,
          ageDescription: '出生时',
        );
        expect(vaccine.name.value, equals('乙肝疫苗'));
      });

      test('VaccineLibrary table can insert and retrieve data', () async {
        await db.into(db.vaccineLibrary).insert(
              VaccineLibraryCompanion.insert(
                name: '乙肝疫苗',
                fullName: '乙型肝炎疫苗',
                code: 'HepB',
                doseIndex: 1,
                totalDoses: 3,
                recommendedAgeDays: 0,
                ageDescription: '出生时',
                vaccineType: const Value(0), // free
                isCombined: const Value(false),
              ),
            );

        final vaccine = await db.select(db.vaccineLibrary).getSingle();
        expect(vaccine.name, equals('乙肝疫苗'));
        expect(vaccine.doseIndex, equals(1));
        expect(vaccine.vaccineType, equals(0));
      });
    });

    group('VaccineRecords Table Tests', () {
      test('VaccineRecords table should exist and be accessible', () async {
        final record = VaccineRecordsCompanion.insert(
          babyId: 1,
          vaccineLibraryId: 1,
          actualDate: DateTime(2024, 1, 1),
        );
        expect(record.babyId.value, equals(1));
      });

      test('VaccineRecords table can insert and retrieve data', () async {
        final babyId = await db.into(db.babies).insert(
              BabiesCompanion.insert(
                name: 'Test Baby',
                birthDate: DateTime(2024, 1, 1),
              ),
            );
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

        await db.into(db.vaccineRecords).insert(
              VaccineRecordsCompanion.insert(
                babyId: babyId,
                vaccineLibraryId: vaccineId,
                actualDate: DateTime(2024, 1, 1),
                injectionSite: const Value(0), // left upper arm
                status: const Value(1), // completed
              ),
            );

        final record = await db.select(db.vaccineRecords).getSingle();
        expect(record.vaccineLibraryId, equals(vaccineId));
        expect(record.injectionSite, equals(0));
        expect(record.status, equals(1));
      });
    });

    group('AgeBenchmarkData Table Tests', () {
      test('AgeBenchmarkData table should exist and be accessible', () async {
        final data = AgeBenchmarkDataCompanion.insert(
          ageMonths: 0,
          gender: 0,
          weightMedian: 3.3,
          weightP3: 2.5,
          weightP97: 4.4,
          heightMedian: 49.9,
          heightP3: 46.1,
          heightP97: 53.7,
          headCircumferenceMedian: 34.5,
          headCircumferenceP3: 32.1,
          headCircumferenceP97: 36.9,
        );
        expect(data.ageMonths.value, equals(0));
      });

      test('AgeBenchmarkData table can insert and retrieve data', () async {
        await db.into(db.ageBenchmarkData).insert(
              AgeBenchmarkDataCompanion.insert(
                ageMonths: 0,
                gender: 0, // male
                weightMedian: 3.3,
                weightP3: 2.5,
                weightP97: 4.4,
                heightMedian: 49.9,
                heightP3: 46.1,
                heightP97: 53.7,
                headCircumferenceMedian: 34.5,
                headCircumferenceP3: 32.1,
                headCircumferenceP97: 36.9,
              ),
            );

        final data = await db.select(db.ageBenchmarkData).getSingle();
        expect(data.ageMonths, equals(0));
        expect(data.gender, equals(0));
        expect(data.weightMedian, equals(3.3));
      });
    });
  });
}