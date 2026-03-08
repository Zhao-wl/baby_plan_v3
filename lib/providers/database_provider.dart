import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';

/// 数据库单例 Provider
///
/// 提供全局唯一的 AppDatabase 实例。
/// 在 Provider 销毁时自动关闭数据库连接。
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(() {
    database.close();
  });

  return database;
});