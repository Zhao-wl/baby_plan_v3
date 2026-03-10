import 'package:flutter_riverpod/legacy.dart';

/// 全局活动数据变化通知 Provider
///
/// 用于在插入、更新、删除活动记录时通知所有依赖的 provider 刷新。
/// 使用 StateProvider<int> 实现，通过递增版本号触发监听者重建。
///
/// 使用方式：
/// 1. 在需要监听数据变化的 provider 中添加：`ref.watch(activityDataChangeProvider)`
/// 2. 在数据变更操作成功后触发：`ref.read(activityDataChangeProvider.notifier).state++`
///
/// 示例：
/// ```dart
/// // 在 Provider 中监听
/// final myProvider = FutureProvider((ref) async {
///   ref.watch(activityDataChangeProvider); // 数据变化时自动刷新
///   // ... 查询逻辑
/// });
///
/// // 在数据变更后触发通知
/// await db.insert(record);
/// ref.read(activityDataChangeProvider.notifier).state++;
/// ```
final activityDataChangeProvider = StateProvider<int>((ref) => 0);
