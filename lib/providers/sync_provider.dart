import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'database_provider.dart';
import 'settings_provider.dart';

/// 同步状态数据模型
class SyncState {
  /// 网络连接状态
  final bool isOnline;

  /// 待上传记录数
  final int pendingCount;

  /// 上次同步时间
  final DateTime? lastSyncTime;

  /// 是否正在同步
  final bool isSyncing;

  /// 同步错误信息
  final String? errorMessage;

  /// 是否禁用（游客模式）
  final bool isDisabled;

  const SyncState({
    this.isOnline = true,
    this.pendingCount = 0,
    this.lastSyncTime,
    this.isSyncing = false,
    this.errorMessage,
    this.isDisabled = false,
  });

  SyncState copyWith({
    bool? isOnline,
    int? pendingCount,
    DateTime? lastSyncTime,
    bool? isSyncing,
    String? errorMessage,
    bool? isDisabled,
  }) {
    return SyncState(
      isOnline: isOnline ?? this.isOnline,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage ?? this.errorMessage,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}

/// 同步状态 Notifier
class SyncNotifier extends Notifier<SyncState> {
  @override
  SyncState build() {
    _initSyncState();
    return const SyncState();
  }

  Future<void> _initSyncState() async {
    // 检查是否为游客模式
    final isGuest = ref.read(isGuestProvider);
    if (isGuest) {
      // 游客模式下禁用同步
      state = const SyncState(isDisabled: true);
      return;
    }

    // 从设置恢复上次同步时间
    final settingsAsync = ref.read(settingsProvider);
    DateTime? lastSyncTime;

    settingsAsync.when(
      data: (settings) {
        lastSyncTime = settings.lastSyncTime;
      },
      loading: () {},
      error: (_, __) {},
    );

    // 查询待上传记录数
    final pendingCount = await _getPendingCount();

    state = SyncState(
      lastSyncTime: lastSyncTime,
      pendingCount: pendingCount,
    );
  }

  /// 查询待上传记录数
  Future<int> _getPendingCount() async {
    final db = ref.read(databaseProvider);

    // 统计所有需要同步表的待上传记录数
    int count = 0;

    // 活动记录
    final activityRecords = await (db.select(db.activityRecords).get());
    count += activityRecords.where((r) => r.syncStatus == 1).length;

    // 宝宝记录
    final babyRecords = await (db.select(db.babies).get());
    count += babyRecords.where((r) => r.syncStatus == 1).length;

    // 生长记录
    final growthRecords = await (db.select(db.growthRecords).get());
    count += growthRecords.where((r) => r.syncStatus == 1).length;

    // 疫苗记录
    final vaccineRecords = await (db.select(db.vaccineRecords).get());
    count += vaccineRecords.where((r) => r.syncStatus == 1).length;

    return count;
  }

  /// 刷新待上传记录数
  Future<void> refreshPendingCount() async {
    final pendingCount = await _getPendingCount();
    state = state.copyWith(pendingCount: pendingCount);
  }

  /// 设置网络状态
  void setOnline(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  /// 触发同步
  ///
  /// 预留方法，实际云同步逻辑在阶段四实现。
  /// 游客模式下不执行同步，显示升级提示。
  Future<void> syncNow() async {
    // 游客模式禁用同步
    if (state.isDisabled) {
      state = state.copyWith(errorMessage: '游客模式暂不支持云同步，请升级为正式账号');
      return;
    }

    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, errorMessage: null);

    try {
      // TODO: 实现实际的同步逻辑
      // 1. 上传本地变更
      // 2. 下载服务器变更
      // 3. 处理冲突

      // 模拟同步完成
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      await ref.read(settingsProvider.notifier).setLastSyncTime(now);

      state = SyncState(
        isOnline: true,
        pendingCount: 0,
        lastSyncTime: now,
        isSyncing: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// 同步状态 Provider
final syncProvider = NotifierProvider<SyncNotifier, SyncState>(() {
  return SyncNotifier();
});

/// 待上传记录数 Provider
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);

  // 统计活动记录的待上传记录数
  final records = await (db.select(db.activityRecords).get());
  return records.where((r) => r.syncStatus == 1).length;
});