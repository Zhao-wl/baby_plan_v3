import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'auth_provider.dart';
import 'database_provider.dart';
import 'family_provider.dart';

/// 宝宝列表 Provider
///
/// 返回当前用户可访问的宝宝列表：
/// - 游客模式：返回所有未删除的宝宝（游客没有家庭组）
/// - 正式用户：返回当前家庭组的宝宝
/// 使用 StreamProvider 实现实时更新。
final babiesProvider = StreamProvider<List<Baby>>((ref) {
  final db = ref.watch(databaseProvider);
  final isGuest = ref.watch(isGuestProvider);
  final familyAsync = ref.watch(familyProvider);

  // 游客模式：返回所有未删除的宝宝
  if (isGuest) {
    final query = db.select(db.babies)
      ..where((b) => b.isDeleted.equals(false));
    return query.watch();
  }

  // 正式用户：按家庭组过滤
  return familyAsync.when(
    data: (family) {
      final query = db.select(db.babies)
        ..where((b) => b.isDeleted.equals(false));
      if (family != null) {
        query.where((b) => b.familyId.equals(family.id));
      }
      return query.watch();
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
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