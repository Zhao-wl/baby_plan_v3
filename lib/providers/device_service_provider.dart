import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/device_service.dart';

/// 设备服务 Provider
///
/// 提供全局唯一的 DeviceService 实例。
/// 用于获取和管理设备唯一标识符。
final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

/// 当前设备标识 Provider
///
/// 异步获取当前设备的唯一标识符。
/// 在首次调用时会生成并持久化设备标识。
final deviceIdProvider = FutureProvider<String>((ref) async {
  final deviceService = ref.read(deviceServiceProvider);
  return await deviceService.getDeviceId();
});
