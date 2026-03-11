import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/database.dart';

/// 疫苗库 JSON 数据模型
///
/// 用于从 JSON 文件加载疫苗数据。
class VaccineJsonData {
  final String name;
  final String fullName;
  final String code;
  final int doseIndex;
  final int totalDoses;
  final int recommendedAgeDays;
  final int? minIntervalDays;
  final String ageDescription;
  final int vaccineType;
  final bool isCombined;
  final String? description;
  final String? contraindications;
  final String? sideEffects;

  const VaccineJsonData({
    required this.name,
    required this.fullName,
    required this.code,
    required this.doseIndex,
    required this.totalDoses,
    required this.recommendedAgeDays,
    this.minIntervalDays,
    required this.ageDescription,
    required this.vaccineType,
    required this.isCombined,
    this.description,
    this.contraindications,
    this.sideEffects,
  });

  factory VaccineJsonData.fromJson(Map<String, dynamic> json) {
    return VaccineJsonData(
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      code: json['code'] as String,
      doseIndex: json['doseIndex'] as int,
      totalDoses: json['totalDoses'] as int,
      recommendedAgeDays: json['recommendedAgeDays'] as int,
      minIntervalDays: json['minIntervalDays'] as int?,
      ageDescription: json['ageDescription'] as String,
      vaccineType: json['vaccineType'] as int,
      isCombined: json['isCombined'] as bool,
      description: json['description'] as String?,
      contraindications: json['contraindications'] as String?,
      sideEffects: json['sideEffects'] as String?,
    );
  }
}

/// 疫苗计划服务
///
/// 根据宝宝出生日期和国家免疫规划疫苗库生成疫苗计划。
/// 在宝宝创建时调用，自动生成所有待接种记录。
class VaccinePlanService {
  final AppDatabase _db;

  VaccinePlanService(this._db);

  /// 缓存的疫苗库数据
  List<VaccineJsonData>? _vaccineLibraryCache;

  /// 加载疫苗库数据
  ///
  /// 从 assets/data/vaccine_library.json 加载疫苗库数据。
  Future<List<VaccineJsonData>> _loadVaccineLibrary() async {
    if (_vaccineLibraryCache != null) {
      return _vaccineLibraryCache!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/vaccine_library.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final vaccines = jsonData['vaccines'] as List<dynamic>;

      _vaccineLibraryCache = vaccines
          .map((v) => VaccineJsonData.fromJson(v as Map<String, dynamic>))
          .toList();

      debugPrint('VaccinePlanService: 加载了 ${_vaccineLibraryCache!.length} 条疫苗数据');
      return _vaccineLibraryCache!;
    } catch (e) {
      debugPrint('VaccinePlanService: 加载疫苗库失败 - $e');
      return [];
    }
  }

  /// 生成疫苗计划
  ///
  /// 根据宝宝出生日期生成完整的疫苗计划。
  /// 每种疫苗的各剂次按推荐年龄计算接种日期。
  ///
  /// [babyId] 宝宝 ID
  /// [birthDate] 宝宝出生日期
  /// 返回生成的疫苗记录数量
  Future<int> generateVaccinePlan({
    required int babyId,
    required DateTime birthDate,
  }) async {
    final vaccines = await _loadVaccineLibrary();
    if (vaccines.isEmpty) {
      debugPrint('VaccinePlanService: 疫苗库为空，无法生成计划');
      return 0;
    }

    // 检查是否已经生成过计划（避免重复生成）
    final existingCount = await _countVaccineRecords(babyId);
    if (existingCount > 0) {
      debugPrint('VaccinePlanService: 宝宝已有 $existingCount 条疫苗记录，跳过生成');
      return 0;
    }

    // 计算每剂疫苗的推荐接种日期并创建记录
    int createdCount = 0;

    for (final vaccine in vaccines) {
      final recommendedDate = _calculateRecommendedDate(
        birthDate: birthDate,
        recommendedAgeDays: vaccine.recommendedAgeDays,
      );

      // 创建待接种记录
      await _createVaccineRecord(
        babyId: babyId,
        vaccine: vaccine,
        recommendedDate: recommendedDate,
      );

      createdCount++;
    }

    debugPrint('VaccinePlanService: 为宝宝 $babyId 生成了 $createdCount 条疫苗计划');
    return createdCount;
  }

  /// 计算推荐接种日期
  ///
  /// 推荐日期 = 出生日期 + 推荐年龄（天数）
  DateTime _calculateRecommendedDate({
    required DateTime birthDate,
    required int recommendedAgeDays,
  }) {
    return birthDate.add(Duration(days: recommendedAgeDays));
  }

  /// 创建疫苗记录
  Future<void> _createVaccineRecord({
    required int babyId,
    required VaccineJsonData vaccine,
    required DateTime recommendedDate,
  }) async {
    // 检查疫苗库中是否已有该疫苗数据
    int? vaccineLibraryId = await _findOrCreateVaccineLibraryEntry(vaccine);

    // 创建待接种记录
    await _db.into(_db.vaccineRecords).insert(
      VaccineRecordsCompanion.insert(
        babyId: babyId,
        vaccineLibraryId: vaccineLibraryId,
        actualDate: recommendedDate,
        status: const Value(0), // 待接种
      ),
    );
  }

  /// 查找或创建疫苗库条目
  Future<int> _findOrCreateVaccineLibraryEntry(VaccineJsonData vaccine) async {
    // 先查找是否已存在
    final existing = await (_db.select(_db.vaccineLibrary)
          ..where((v) =>
              v.code.equals(vaccine.code) & v.doseIndex.equals(vaccine.doseIndex)))
        .getSingleOrNull();

    if (existing != null) {
      return existing.id;
    }

    // 不存在则创建
    return await _db.into(_db.vaccineLibrary).insert(
      VaccineLibraryCompanion.insert(
        name: vaccine.name,
        fullName: vaccine.fullName,
        code: vaccine.code,
        doseIndex: vaccine.doseIndex,
        totalDoses: vaccine.totalDoses,
        recommendedAgeDays: vaccine.recommendedAgeDays,
        minIntervalDays: vaccine.minIntervalDays != null
            ? Value(vaccine.minIntervalDays)
            : const Value.absent(),
        ageDescription: vaccine.ageDescription,
        vaccineType: Value(vaccine.vaccineType),
        isCombined: Value(vaccine.isCombined),
        description: vaccine.description != null
            ? Value(vaccine.description)
            : const Value.absent(),
        contraindications: vaccine.contraindications != null
            ? Value(vaccine.contraindications)
            : const Value.absent(),
        sideEffects: vaccine.sideEffects != null
            ? Value(vaccine.sideEffects)
            : const Value.absent(),
      ),
    );
  }

  /// 获取宝宝的疫苗记录数量
  Future<int> _countVaccineRecords(int babyId) async {
    final count = (_db.select(_db.vaccineRecords)
          ..where((v) => v.babyId.equals(babyId) & v.isDeleted.equals(false)))
        .get();
    return (await count).length;
  }

  /// 获取宝宝的待接种疫苗列表
  ///
  /// 返回所有待接种状态的疫苗记录。
  Future<List<VaccineRecord>> getPendingVaccines(int babyId) async {
    return await (_db.select(_db.vaccineRecords)
          ..where((v) =>
              v.babyId.equals(babyId) &
              v.status.equals(0) & // 待接种
              v.isDeleted.equals(false)))
        .get();
  }

  /// 获取宝宝的即将到期疫苗列表
  ///
  /// 返回未来 N 天内需要接种的疫苗。
  Future<List<VaccineRecord>> getUpcomingVaccines(
    int babyId, {
    int days = 30,
  }) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    return await (_db.select(_db.vaccineRecords)
          ..where((v) =>
              v.babyId.equals(babyId) &
              v.status.equals(0) & // 待接种
              v.actualDate.isBiggerOrEqualValue(now) &
              v.actualDate.isSmallerOrEqualValue(endDate) &
              v.isDeleted.equals(false)))
        .get();
  }

  /// 获取宝宝的逾期疫苗列表
  ///
  /// 返回推荐接种日期已过但尚未接种的疫苗。
  Future<List<VaccineRecord>> getOverdueVaccines(int babyId) async {
    final now = DateTime.now();

    return await (_db.select(_db.vaccineRecords)
          ..where((v) =>
              v.babyId.equals(babyId) &
              v.status.equals(0) & // 待接种
              v.actualDate.isSmallerThanValue(now) &
              v.isDeleted.equals(false)))
        .get();
  }

  /// 清除缓存
  void clearCache() {
    _vaccineLibraryCache = null;
  }
}