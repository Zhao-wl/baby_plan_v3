import 'package:drift/drift.dart';

/// 疫苗库表定义
///
/// 存储内置的疫苗信息，作为只读数据源。
/// 注意：此表不支持软删除和同步，因为是内置只读数据。
class VaccineLibrary extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 疫苗简称（如：乙肝疫苗）
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// 疫苗全称（如：乙型肝炎疫苗）
  TextColumn get fullName => text().withLength(min: 1, max: 100)();

  /// 疫苗编码（如：HepB）
  TextColumn get code => text().withLength(min: 1, max: 20)();

  /// 剂次序号（第几针，如：1、2、3）
  IntColumn get doseIndex => integer()();

  /// 总剂次数
  IntColumn get totalDoses => integer()();

  /// 推荐接种年龄（天数，如：0=出生当天、30=满月）
  IntColumn get recommendedAgeDays => integer()();

  /// 最小间隔天数（与上一针的间隔）
  IntColumn get minIntervalDays => integer().nullable()();

  /// 年龄描述（如："出生时"、"1月龄"、"6月龄"）
  TextColumn get ageDescription => text().withLength(max: 50)();

  /// 疫苗类型：0=一类（免费）、1=二类（自费）
  IntColumn get vaccineType => integer().withDefault(const Constant(0))();

  /// 是否为联合疫苗
  BoolColumn get isCombined => boolean().withDefault(const Constant(false))();

  /// 疫苗说明
  TextColumn get description => text().nullable()();

  /// 禁忌症
  TextColumn get contraindications => text().nullable()();

  /// 常见不良反应
  TextColumn get sideEffects => text().nullable()();

  /// 数据版本号（用于判断是否需要更新内置数据）
  IntColumn get dataVersion => integer().withDefault(const Constant(1))();
}