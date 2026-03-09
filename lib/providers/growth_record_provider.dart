import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';

/// 最新生长记录 Provider
///
/// 查询指定宝宝的最新一条生长记录（按 recordDate 降序）。
/// 排除已软删除的记录。
///
/// 参数：
/// - babyId: 宝宝 ID
///
/// 返回：
/// - 有记录时返回最新的 GrowthRecord
/// - 无记录时返回 null
final latestGrowthRecordProvider = FutureProvider.family<GrowthRecord?, int>((
  ref,
  babyId,
) async {
  final db = ref.watch(databaseProvider);
  final records = await (db.select(db.growthRecords)
        ..where((r) => r.babyId.equals(babyId) & r.isDeleted.equals(false))
        ..orderBy([(r) => OrderingTerm.desc(r.recordDate)])
        ..limit(1))
      .get();

  return records.isNotEmpty ? records.first : null;
});