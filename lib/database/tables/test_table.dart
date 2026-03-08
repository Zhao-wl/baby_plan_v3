import 'package:drift/drift.dart';

/// 测试表定义 - 用于验证数据库功能
class TestRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}