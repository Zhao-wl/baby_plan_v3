import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// 通知渠道 ID 常量
const String kChannelVaccineReminder = 'vaccine_reminder';
const String kChannelPrediction = 'prediction';

/// 通知渠道名称
const String kChannelVaccineReminderName = '疫苗提醒';
const String kChannelPredictionName = '智能预测';

/// 通知点击回调类型
typedef NotificationCallback = void Function(String? payload);

/// 本地通知服务
///
/// 封装 flutter_local_notifications，提供跨平台本地通知功能。
/// 支持 Android、iOS，Web 平台降级处理。
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  NotificationCallback? _onNotificationTapped;

  /// 是否支持通知（Web 平台不支持）
  bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
  }

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 初始化通知服务
  ///
  /// 配置 Android 通知渠道和 iOS 通知设置。
  /// 应在应用启动时调用。
  Future<void> initialize({
    NotificationCallback? onNotificationTapped,
  }) async {
    if (!isSupported) {
      debugPrint('NotificationService: 平台不支持通知');
      return;
    }

    _onNotificationTapped = onNotificationTapped;

    // Android 初始化设置
    const androidSettings = AndroidInitializationSettings('ic_notification');

    // iOS 初始化设置
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // 稍后请求权限
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // 创建 Android 通知渠道
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannels();
    }

    _isInitialized = true;
    debugPrint('NotificationService: 初始化完成');
  }

  /// 创建 Android 通知渠道
  Future<void> _createAndroidNotificationChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // 疫苗提醒渠道 - 高重要性
    const vaccineChannel = AndroidNotificationChannel(
      kChannelVaccineReminder,
      kChannelVaccineReminderName,
      description: '疫苗接种提醒通知',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // 智能预测渠道 - 默认重要性
    const predictionChannel = AndroidNotificationChannel(
      kChannelPrediction,
      kChannelPredictionName,
      description: '智能预测提醒通知',
      importance: Importance.defaultImportance,
      playSound: true,
    );

    await androidPlugin.createNotificationChannel(vaccineChannel);
    await androidPlugin.createNotificationChannel(predictionChannel);
    debugPrint('NotificationService: Android 通知渠道创建完成');
  }

  /// 处理通知点击响应
  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('NotificationService: 通知被点击 - ${response.payload}');
    _onNotificationTapped?.call(response.payload);
  }

  /// 请求通知权限
  ///
  /// Android 13+ 需要请求 POST_NOTIFICATIONS 权限。
  /// iOS 需要请求用户授权。
  Future<bool> requestPermission() async {
    if (!isSupported) return false;

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.requestNotificationsPermission() ?? false;
    }

    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return false;
  }

  /// 检查通知权限状态
  Future<NotificationPermissionStatus> checkPermission() async {
    if (!isSupported) return NotificationPermissionStatus.notSupported;

    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted =
          await androidPlugin?.areNotificationsEnabled() ?? false;
      return granted
          ? NotificationPermissionStatus.granted
          : NotificationPermissionStatus.denied;
    }

    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final permissions = await iosPlugin?.checkPermissions();
      final granted = permissions?.isEnabled ?? false;
      return granted
          ? NotificationPermissionStatus.granted
          : NotificationPermissionStatus.denied;
    }

    return NotificationPermissionStatus.notSupported;
  }

  /// 调度定时通知
  ///
  /// 在指定时间显示通知。
  /// [id] 通知 ID，用于取消通知
  /// [title] 通知标题
  /// [body] 通知内容
  /// [scheduledDate] 调度时间
  /// [channelId] 通知渠道 ID
  /// [payload] 点击通知时传递的数据
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String channelId = kChannelVaccineReminder,
    String? payload,
  }) async {
    if (!isSupported || !_isInitialized) return false;

    // 如果时间已过，不调度
    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('NotificationService: 调度时间已过，跳过通知');
      return false;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == kChannelVaccineReminder
          ? kChannelVaccineReminderName
          : kChannelPredictionName,
      channelDescription:
          channelId == kChannelVaccineReminder ? '疫苗接种提醒通知' : '智能预测提醒通知',
      importance: channelId == kChannelVaccineReminder
          ? Importance.high
          : Importance.defaultImportance,
      priority: channelId == kChannelVaccineReminder
          ? Priority.high
          : Priority.defaultPriority,
      icon: 'ic_notification',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      debugPrint(
          'NotificationService: 通知已调度 - ID: $id, 时间: $scheduledDate');
      return true;
    } catch (e) {
      debugPrint('NotificationService: 调度通知失败 - $e');
      return false;
    }
  }

  /// 取消指定通知
  Future<void> cancelNotification(int id) async {
    if (!isSupported) return;
    await _plugin.cancel(id);
    debugPrint('NotificationService: 通知已取消 - ID: $id');
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    if (!isSupported) return;
    await _plugin.cancelAll();
    debugPrint('NotificationService: 所有通知已取消');
  }

  /// 调度疫苗提醒
  ///
  /// 在疫苗推荐接种日期前 3 天发送提醒。
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
    // 计算提醒时间：推荐日期前 3 天，上午 9:00
    final reminderDate = recommendedDate.subtract(const Duration(days: 3));

    // 设置为上午 9:00
    final scheduledTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9, 0, 0,
    );

    final title = '疫苗接种提醒';
    final body = '$vaccineName 第$doseIndex针将于${_formatDate(recommendedDate)}接种，请提前安排。';
    final payload = 'vaccine:$vaccineRecordId';

    return await scheduleNotification(
      id: vaccineRecordId,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      channelId: kChannelVaccineReminder,
      payload: payload,
    );
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
    return await scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      channelId: kChannelPrediction,
      payload: payload,
    );
  }

  /// 格式化日期为 MM月DD日 格式
  String _formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }
}

/// 通知权限状态枚举
enum NotificationPermissionStatus {
  /// 已授权
  granted,

  /// 未授权
  denied,

  /// 不支持
  notSupported,
}