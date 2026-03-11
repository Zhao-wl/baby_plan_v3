import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';
import 'current_baby_provider.dart';

/// 疫苗显示状态枚举
enum VaccineDisplayStatus {
  /// 已完成（有接种记录）
  done,

  /// 已逾期（超过推荐日期30天未接种）
  overdue,

  /// 近期计划（推荐日期前后7天内）
  upcoming,

  /// 待接种（距离推荐日期超过7天）
  pending,
}

/// 疫苗计划项数据类
///
/// 包含疫苗库信息、接种记录（如有）和计算后的显示状态。
class VaccineScheduleItem {
  /// 疫苗库信息
  final VaccineLibraryData vaccine;

  /// 接种记录（如有）
  final VaccineRecord? record;

  /// 显示状态
  final VaccineDisplayStatus status;

  /// 月龄分组
  final String ageGroup;

  const VaccineScheduleItem({
    required this.vaccine,
    this.record,
    required this.status,
    required this.ageGroup,
  });

  /// 是否已完成
  bool get isDone => status == VaccineDisplayStatus.done;

  /// 是否已逾期
  bool get isOverdue => status == VaccineDisplayStatus.overdue;

  /// 是否近期计划
  bool get isUpcoming => status == VaccineDisplayStatus.upcoming;

  /// 是否待接种
  bool get isPending => status == VaccineDisplayStatus.pending;

  /// 获取状态描述文本
  String get statusText {
    switch (status) {
      case VaccineDisplayStatus.done:
        return '已完成';
      case VaccineDisplayStatus.overdue:
        return '已逾期';
      case VaccineDisplayStatus.upcoming:
        return '近期计划';
      case VaccineDisplayStatus.pending:
        return '待接种';
    }
  }
}

/// 疫苗统计数据
class VaccineStats {
  /// 已完成数量
  final int completedCount;

  /// 总数量
  final int totalCount;

  /// 逾期数量
  final int overdueCount;

  /// 近期计划数量
  final int upcomingCount;

  const VaccineStats({
    required this.completedCount,
    required this.totalCount,
    required this.overdueCount,
    required this.upcomingCount,
  });

  /// 保护比例（0.0 - 1.0）
  double get protectionRatio =>
      totalCount > 0 ? completedCount / totalCount : 0.0;

  /// 是否有逾期疫苗
  bool get hasOverdue => overdueCount > 0;
}

/// 疫苗计划状态
class VaccineScheduleState {
  /// 月龄分组列表
  final List<String> ageGroups;

  /// 按月龄分组的疫苗列表
  final Map<String, List<VaccineScheduleItem>> vaccinesByAge;

  /// 统计数据
  final VaccineStats stats;

  /// 是否正在加载
  final bool isLoading;

  /// 错误信息
  final String? error;

  const VaccineScheduleState({
    this.ageGroups = const [],
    this.vaccinesByAge = const {},
    this.stats = const VaccineStats(
      completedCount: 0,
      totalCount: 0,
      overdueCount: 0,
      upcomingCount: 0,
    ),
    this.isLoading = true,
    this.error,
  });

  /// 创建加载中状态
  const VaccineScheduleState.loading()
      : ageGroups = const [],
        vaccinesByAge = const {},
        stats = const VaccineStats(
          completedCount: 0,
          totalCount: 0,
          overdueCount: 0,
          upcomingCount: 0,
        ),
        isLoading = true,
        error = null;

  /// 创建错误状态
  VaccineScheduleState.error(String message)
      : ageGroups = const [],
        vaccinesByAge = const {},
        stats = const VaccineStats(
          completedCount: 0,
          totalCount: 0,
          overdueCount: 0,
          upcomingCount: 0,
        ),
        isLoading = false,
        error = message;

  /// 创建数据状态
  VaccineScheduleState.data({
    required this.ageGroups,
    required this.vaccinesByAge,
    required this.stats,
  })  : isLoading = false,
        error = null;
}

/// 疫苗计划 Notifier
class VaccineScheduleNotifier extends Notifier<VaccineScheduleState> {
  /// 上次刷新时间（用于防抖）
  DateTime? _lastRefreshTime;

  /// 防抖间隔（5秒）
  static const _debounceDuration = Duration(seconds: 5);

  @override
  VaccineScheduleState build() {
    // 监听当前宝宝变化，自动刷新数据
    ref.listen<CurrentBabyState>(
      currentBabyProvider,
      (previous, next) {
        // 当宝宝切换时刷新数据
        if (previous?.baby?.id != next.baby?.id) {
          refresh();
        }
      },
    );

    // 初始化时加载数据
    _loadData();
    return const VaccineScheduleState.loading();
  }

  /// 加载疫苗计划数据
  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final currentBaby = ref.read(currentBabyProvider).baby;

    if (currentBaby == null) {
      state = VaccineScheduleState.data(
        ageGroups: const [],
        vaccinesByAge: const {},
        stats: const VaccineStats(
          completedCount: 0,
          totalCount: 0,
          overdueCount: 0,
          upcomingCount: 0,
        ),
      );
      return;
    }

    try {
      // 确保疫苗库数据已加载
      await db.loadVaccineLibraryFromJson();

      // 获取所有疫苗库数据
      final allVaccines = await db.getAllVaccines();

      // 获取宝宝所有接种记录
      final records = await db.getVaccineRecordsByBaby(currentBaby.id);

      // 创建疫苗ID到记录的映射
      final recordMap = <int, VaccineRecord>{};
      for (final record in records) {
        recordMap[record.vaccineLibraryId] = record;
      }

      // 计算宝宝年龄（天数）
      final babyAgeDays = DateTime.now().difference(currentBaby.birthDate).inDays;

      // 计算每个疫苗的状态
      final items = <VaccineScheduleItem>[];
      for (final vaccine in allVaccines) {
        final record = recordMap[vaccine.id];
        final status = _calculateStatus(
          babyAgeDays: babyAgeDays,
          recommendedAgeDays: vaccine.recommendedAgeDays,
          record: record,
        );
        items.add(VaccineScheduleItem(
          vaccine: vaccine,
          record: record,
          status: status,
          ageGroup: vaccine.ageDescription,
        ));
      }

      // 按月龄分组
      final ageGroups = await db.getAgeGroups();
      final vaccinesByAge = <String, List<VaccineScheduleItem>>{};
      for (final ageGroup in ageGroups) {
        vaccinesByAge[ageGroup] = items
            .where((item) => item.ageGroup == ageGroup)
            .toList();
      }

      // 计算统计数据
      final stats = VaccineStats(
        completedCount: items.where((i) => i.isDone).length,
        totalCount: items.length,
        overdueCount: items.where((i) => i.isOverdue).length,
        upcomingCount: items.where((i) => i.isUpcoming).length,
      );

      state = VaccineScheduleState.data(
        ageGroups: ageGroups,
        vaccinesByAge: vaccinesByAge,
        stats: stats,
      );
    } catch (e) {
      state = VaccineScheduleState.error('加载疫苗数据失败: $e');
    }
  }

  /// 计算疫苗状态
  VaccineDisplayStatus _calculateStatus({
    required int babyAgeDays,
    required int recommendedAgeDays,
    VaccineRecord? record,
  }) {
    // 已有接种记录 -> 已完成
    if (record != null && record.status == 1) {
      return VaccineDisplayStatus.done;
    }

    // 计算与推荐日期的差距
    final daysDiff = babyAgeDays - recommendedAgeDays;

    // 超过推荐日期30天 -> 已逾期
    if (daysDiff > 30) {
      return VaccineDisplayStatus.overdue;
    }

    // 在推荐日期前后7天内 -> 近期计划
    if (daysDiff >= -7) {
      return VaccineDisplayStatus.upcoming;
    }

    // 距离推荐日期超过7天 -> 待接种
    return VaccineDisplayStatus.pending;
  }

  /// 刷新数据（带防抖）
  Future<void> refresh() async {
    final now = DateTime.now();

    // 防抖检查：如果距离上次刷新不足5秒，跳过本次刷新
    if (_lastRefreshTime != null &&
        now.difference(_lastRefreshTime!) < _debounceDuration) {
      return;
    }

    _lastRefreshTime = now;
    state = const VaccineScheduleState.loading();
    await _loadData();
  }

  /// 保存接种记录
  Future<bool> saveVaccineRecord({
    required int vaccineLibraryId,
    required DateTime actualDate,
    String? batchNumber,
    int? injectionSite,
    String? reactionDetail,
  }) async {
    final db = ref.read(databaseProvider);
    final currentBaby = ref.read(currentBabyProvider).baby;

    if (currentBaby == null) {
      return false;
    }

    try {
      await db.createVaccineRecord(
        babyId: currentBaby.id,
        vaccineLibraryId: vaccineLibraryId,
        actualDate: actualDate,
        batchNumber: batchNumber,
        injectionSite: injectionSite,
        reactionDetail: reactionDetail,
      );

      // 刷新数据
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// 疫苗计划 Provider
final vaccineScheduleProvider =
    NotifierProvider<VaccineScheduleNotifier, VaccineScheduleState>(() {
  return VaccineScheduleNotifier();
});

/// 疫苗统计 Provider（便捷访问）
final vaccineStatsProvider = Provider<VaccineStats>((ref) {
  return ref.watch(vaccineScheduleProvider).stats;
});