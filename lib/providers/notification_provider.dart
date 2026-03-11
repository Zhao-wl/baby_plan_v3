import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../services/notification_service.dart';
import '../services/vaccine_plan_service.dart';
import 'database_provider.dart';

/// 通知权限状态
enum NotificationPermissionState {
  /// 已授权
  granted,

  /// 未授权
  denied,

  /// 未确定
  notDetermined,

  /// 不支持
  notSupported,
}

/// 通知服务 Provider
///
/// 提供通知服务的单例实例。
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// 疫苗计划服务 Provider
///
/// 提供疫苗计划服务的单例实例。
final vaccinePlanServiceProvider = Provider<VaccinePlanService>((ref) {
  final db = ref.watch(databaseProvider);
  return VaccinePlanService(db);
});

/// 通知权限状态 Notifier
class NotificationPermissionNotifier extends Notifier<NotificationPermissionState> {
  @override
  NotificationPermissionState build() {
    return NotificationPermissionState.notDetermined;
  }

  /// 获取通知服务实例
  NotificationService get _service => ref.read(notificationServiceProvider);

  /// 检查权限状态
  Future<void> checkPermission() async {
    final status = await _service.checkPermission();
    state = switch (status) {
      NotificationPermissionStatus.granted => NotificationPermissionState.granted,
      NotificationPermissionStatus.denied => NotificationPermissionState.denied,
      NotificationPermissionStatus.notSupported => NotificationPermissionState.notSupported,
    };
  }

  /// 请求权限
  Future<bool> requestPermission() async {
    final granted = await _service.requestPermission();
    state = granted ? NotificationPermissionState.granted : NotificationPermissionState.denied;
    return granted;
  }
}

/// 通知权限状态 Provider
final notificationPermissionProvider =
    NotifierProvider<NotificationPermissionNotifier, NotificationPermissionState>(() {
  return NotificationPermissionNotifier();
});

/// 通知操作 Notifier
///
/// 封装通知调度和取消操作。
class NotificationOperationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // 初始化时不做任何操作
  }

  /// 获取通知服务实例
  NotificationService get _service => ref.read(notificationServiceProvider);

  /// 获取疫苗计划服务实例
  VaccinePlanService get _vaccinePlanService => ref.read(vaccinePlanServiceProvider);

  /// 获取数据库实例
  AppDatabase get _db => ref.read(databaseProvider);

  /// 生成疫苗计划并调度提醒
  ///
  /// 在宝宝创建时调用。
  /// [babyId] 宝宝 ID
  /// [birthDate] 宝宝出生日期
  Future<int> generateVaccinePlanWithReminders({
    required int babyId,
    required DateTime birthDate,
  }) async {
    // 1. 生成疫苗计划
    final count = await _vaccinePlanService.generateVaccinePlan(
      babyId: babyId,
      birthDate: birthDate,
    );

    if (count == 0) {
      return 0;
    }

    // 2. 获取所有待接种疫苗并调度提醒
    final pendingVaccines = await _vaccinePlanService.getPendingVaccines(babyId);

    for (final record in pendingVaccines) {
      // 获取疫苗信息
      final vaccineInfo = await _getVaccineInfo(record.vaccineLibraryId);
      if (vaccineInfo != null) {
        await _service.scheduleVaccineReminder(
          vaccineRecordId: record.id,
          vaccineName: vaccineInfo.name,
          doseIndex: vaccineInfo.doseIndex,
          recommendedDate: record.actualDate,
        );
      }
    }

    return count;
  }

  /// 获取疫苗信息
  Future<VaccineLibraryData?> _getVaccineInfo(int vaccineLibraryId) async {
    return await (_db.select(_db.vaccineLibrary)
          ..where((v) => v.id.equals(vaccineLibraryId)))
        .getSingleOrNull();
  }

  /// 取消疫苗提醒并标记为已接种
  ///
  /// 当疫苗被标记为已接种时调用。
  Future<void> cancelVaccineReminderOnCompleted(int vaccineRecordId) async {
    await _service.cancelNotification(vaccineRecordId);
  }

  /// 恢复即将到来的疫苗提醒
  ///
  /// 在应用启动时调用，重新调度可能丢失的提醒。
  Future<void> restoreUpcomingReminders(int babyId) async {
    // 获取未来 30 天内的待接种疫苗
    final upcomingVaccines = await _vaccinePlanService.getUpcomingVaccines(
      babyId,
      days: 30,
    );

    for (final record in upcomingVaccines) {
      final vaccineInfo = await _getVaccineInfo(record.vaccineLibraryId);
      if (vaccineInfo != null) {
        // 重新调度提醒（如果已存在会覆盖）
        await _service.scheduleVaccineReminder(
          vaccineRecordId: record.id,
          vaccineName: vaccineInfo.name,
          doseIndex: vaccineInfo.doseIndex,
          recommendedDate: record.actualDate,
        );
      }
    }
  }

  /// 调度疫苗提醒
  ///
  /// [vaccineRecordId] 疫苗记录 ID（用作通知 ID）
  /// [vaccineName] 疫苗名称
  /// [doseIndex] 剂次
  /// [recommendedDate] 推荐接种日期
  Future<bool> scheduleVaccineReminder({
    required int vaccineRecordId,
    required String vaccineName,
    required int doseIndex,
    required DateTime recommendedDate,
  }) async {
    return await _service.scheduleVaccineReminder(
      vaccineRecordId: vaccineRecordId,
      vaccineName: vaccineName,
      doseIndex: doseIndex,
      recommendedDate: recommendedDate,
    );
  }

  /// 取消疫苗提醒
  Future<void> cancelVaccineReminder(int vaccineRecordId) async {
    await _service.cancelNotification(vaccineRecordId);
  }

  /// 调度预测提醒（预留接口）
  ///
  /// 用于未来的智能预测功能。
  Future<bool> schedulePredictionReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    return await _service.schedulePredictionReminder(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
    );
  }

  /// 取消预测提醒
  Future<void> cancelPredictionReminder(int id) async {
    await _service.cancelNotification(id);
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    await _service.cancelAllNotifications();
  }
}

/// 通知操作 Provider
final notificationOperationProvider =
    AsyncNotifierProvider<NotificationOperationNotifier, void>(() {
  return NotificationOperationNotifier();
});