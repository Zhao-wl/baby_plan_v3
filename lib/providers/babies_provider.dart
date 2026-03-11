import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../services/device_service.dart';
import 'auth_provider.dart';
import 'database_provider.dart';
import 'family_provider.dart';
import 'notification_provider.dart';

/// 宝宝列表状态
class BabiesState {
  final List<Baby> babies;
  final bool isLoading;
  final String? error;

  const BabiesState({
    this.babies = const [],
    this.isLoading = false,
    this.error,
  });

  BabiesState copyWith({
    List<Baby>? babies,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BabiesState(
      babies: babies ?? this.babies,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// 宝宝列表管理 Notifier
class BabiesNotifier extends Notifier<BabiesState> {
  @override
  BabiesState build() {
    // 监听数据库变化
    _watchBabies();
    return const BabiesState();
  }

  /// 监听宝宝列表变化
  void _watchBabies() {
    final db = ref.read(databaseProvider);
    final isGuest = ref.read(isGuestProvider);
    final familyAsync = ref.read(familyProvider);

    // 构建查询
    late final Stream<List<Baby>> stream;

    if (isGuest) {
      final query = db.select(db.babies)
        ..where((b) => b.isDeleted.equals(false));
      stream = query.watch();
    } else {
      final family = familyAsync.value;
      final query = db.select(db.babies)
        ..where((b) => b.isDeleted.equals(false));
      if (family != null) {
        query.where((b) => b.familyId.equals(family.id));
      }
      stream = query.watch();
    }

    // 监听流并更新状态
    stream.listen((babies) {
      state = state.copyWith(babies: babies);
    });
  }

  /// 添加宝宝
  ///
  /// [name] - 宝宝姓名
  /// [gender] - 性别（0=男、1=女）
  /// [birthDate] - 出生日期
  /// [generateVaccinePlan] - 是否生成疫苗计划（默认 true）
  Future<Baby> addBaby({
    required String name,
    required int gender,
    required DateTime birthDate,
    bool generateVaccinePlan = true,
  }) async {
    final db = ref.read(databaseProvider);
    final isGuest = ref.read(isGuestProvider);
    final familyAsync = ref.read(familyProvider);
    final deviceService = DeviceService();

    // 获取设备 ID
    final deviceId = await deviceService.getDeviceId();

    // 获取家庭 ID（正式用户）
    int? familyId;
    if (!isGuest) {
      familyId = familyAsync.value?.id;
    }

    // 插入数据
    final id = await db.into(db.babies).insert(
          BabiesCompanion.insert(
            name: name,
            birthDate: birthDate,
            gender: Value(gender),
            familyId: Value(familyId),
            deviceId: Value(deviceId),
            syncStatus: const Value(1), // 待上传
          ),
        );

    // 查询并返回创建的宝宝
    final baby = await (db.select(db.babies)..where((b) => b.id.equals(id)))
        .getSingle();

    // 生成疫苗计划并调度提醒
    if (generateVaccinePlan) {
      try {
        await ref.read(notificationOperationProvider.notifier)
            .generateVaccinePlanWithReminders(
          babyId: baby.id,
          birthDate: birthDate,
        );
      } catch (e) {
        // 疫苗计划生成失败不影响宝宝创建
        // 用户可以稍后手动生成
      }
    }

    return baby;
  }

  /// 更新宝宝信息
  Future<void> updateBaby(Baby baby) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.babies)).replace(baby);
  }

  /// 软删除宝宝
  Future<void> deleteBaby(int id) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.babies)..where((b) => b.id.equals(id))).write(
      BabiesCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(DateTime.now()),
      ),
    );
  }
}

/// 宝宝列表 Provider
///
/// 返回当前用户可访问的宝宝列表：
/// - 游客模式：返回所有未删除的宝宝（游客没有家庭组）
/// - 正式用户：返回当前家庭组的宝宝
final babiesProvider = NotifierProvider<BabiesNotifier, BabiesState>(() {
  return BabiesNotifier();
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
  final babiesState = ref.watch(babiesProvider);
  try {
    return babiesState.babies.firstWhere((b) => b.id == id);
  } catch (_) {
    return null;
  }
});