import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// 设备标识服务
///
/// 负责生成和管理唯一的设备标识符，用于数据同步时的设备识别。
/// 设备标识在首次启动时生成，并持久化存储在 SharedPreferences 中。
class DeviceService {
  /// SharedPreferences 键名
  static const String _deviceIdKey = 'device_id';

  /// UUID 生成器
  final Uuid _uuid = const Uuid();

  /// 缓存的设备标识
  String? _cachedDeviceId;

  /// 获取当前设备标识
  ///
  /// 如果设备标识不存在（首次启动），则生成新的 UUID v4 并存储。
  /// 后续启动将返回已存储的设备标识。
  Future<String> getDeviceId() async {
    // 如果已缓存，直接返回
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      // 首次启动，生成新的设备标识
      deviceId = _uuid.v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    // 缓存设备标识
    _cachedDeviceId = deviceId;
    return deviceId;
  }

  /// 检查设备标识是否存在
  Future<bool> hasDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_deviceIdKey);
  }

  /// 清除设备标识（用于测试或重置）
  Future<void> clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceIdKey);
    _cachedDeviceId = null;
  }

  /// 重新生成设备标识
  ///
  /// 警告：这将生成新的设备标识，可能导致同步问题。
  Future<String> regenerateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final newDeviceId = _uuid.v4();
    await prefs.setString(_deviceIdKey, newDeviceId);
    _cachedDeviceId = newDeviceId;
    return newDeviceId;
  }
}