import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';

/// 宝宝列表 Provider
///
/// 返回当前家庭的所有未删除宝宝列表。
/// 使用 StreamProvider 实现实时更新。
final babiesProvider = StreamProvider<List<Baby>>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.babies)
    ..where((b) => b.isDeleted.equals(false));
  return query.watch();
});

/// 所有宝宝列表 Provider（包括已删除）
///
/// 用于管理页面显示所有宝宝记录。
final allBabiesProvider = StreamProvider<List<Baby>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.babies).watch();
});

/// 根据 ID 获取宝宝 Provider
///
/// 参数化的 Provider，用于获取单个宝宝信息。
final babyByIdProvider = Provider.family<Baby?, int>((ref, id) {
  final asyncBabies = ref.watch(babiesProvider);
  return asyncBabies.when(
    data: (babies) {
      try {
        return babies.firstWhere((b) => b.id == id);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});