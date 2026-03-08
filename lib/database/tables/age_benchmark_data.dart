import 'package:drift/drift.dart';

/// 月龄基准数据表定义
///
/// 存储各月龄宝宝的生长基准数据（来自 WHO 标准），用于评估宝宝的生长发育情况。
/// 注意：此表不支持软删除和同步，因为是云端缓存的只读数据。
class AgeBenchmarkData extends Table {
  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 月龄（0-60个月）
  IntColumn get ageMonths => integer()();

  /// 性别：0=男、1=女
  IntColumn get gender => integer()();

  /// 体重中位数（kg）
  RealColumn get weightMedian => real()();

  /// 体重P3百分位（kg）
  RealColumn get weightP3 => real()();

  /// 体重P97百分位（kg）
  RealColumn get weightP97 => real()();

  /// 身高中位数（cm）
  RealColumn get heightMedian => real()();

  /// 身高P3百分位（cm）
  RealColumn get heightP3 => real()();

  /// 身高P97百分位（cm）
  RealColumn get heightP97 => real()();

  /// 头围中位数（cm）
  RealColumn get headCircumferenceMedian => real()();

  /// 头围P3百分位（cm）
  RealColumn get headCircumferenceP3 => real()();

  /// 头围P97百分位（cm）
  RealColumn get headCircumferenceP97 => real()();

  /// 数据版本号（用于判断是否需要更新）
  IntColumn get dataVersion => integer().withDefault(const Constant(1))();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {ageMonths, gender},
      ];
}