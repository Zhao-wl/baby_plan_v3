import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';

/// 家庭组 Provider
///
/// 返回当前家庭组信息。
/// TODO: 在用户认证实现后，返回当前用户所属的家庭。
final familyProvider = StreamProvider<Family?>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.families)
    ..where((f) => f.isDeleted.equals(false));
  return query.watch().map((families) => families.isNotEmpty ? families.first : null);
});

/// 所有家庭列表 Provider
final familiesListProvider = StreamProvider<List<Family>>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.families)
    ..where((f) => f.isDeleted.equals(false));
  return query.watch();
});

/// 家庭成员列表 Provider
///
/// 参数化的 Provider，返回指定家庭的成员列表。
final familyMembersProvider = StreamProvider.family<List<FamilyMember>, int>((ref, familyId) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.familyMembers)
    ..where((fm) => fm.familyId.equals(familyId) & fm.isDeleted.equals(false));
  return query.watch();
});

/// 根据 ID 获取家庭 Provider
final familyByIdProvider = Provider.family<Family?, int>((ref, id) {
  final asyncFamilies = ref.watch(familiesListProvider);
  return asyncFamilies.when(
    data: (families) {
      try {
        return families.firstWhere((f) => f.id == id);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});