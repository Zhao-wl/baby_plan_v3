import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/test_data_service.dart';
import 'database_provider.dart';

/// 测试数据状态
class TestDataState {
  /// 是否为测试数据账号
  final bool isTestAccount;

  /// 是否正在注入数据
  final bool isInjecting;

  /// 注入进度 (0.0 - 1.0)
  final double progress;

  /// 错误信息
  final String? errorMessage;

  const TestDataState({
    this.isTestAccount = false,
    this.isInjecting = false,
    this.progress = 0.0,
    this.errorMessage,
  });

  TestDataState copyWith({
    bool? isTestAccount,
    bool? isInjecting,
    double? progress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TestDataState(
      isTestAccount: isTestAccount ?? this.isTestAccount,
      isInjecting: isInjecting ?? this.isInjecting,
      progress: progress ?? this.progress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// 测试数据状态管理 Notifier
class TestDataNotifier extends Notifier<TestDataState> {
  static const String _testAccountKey = 'is_test_account';

  @override
  TestDataState build() {
    _loadTestAccountStatus();
    return const TestDataState();
  }

  /// 加载测试账号状态
  Future<void> _loadTestAccountStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isTestAccount = prefs.getBool(_testAccountKey) ?? false;
    state = state.copyWith(isTestAccount: isTestAccount);
  }

  /// 保存测试账号状态
  Future<void> _saveTestAccountStatus(bool isTestAccount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_testAccountKey, isTestAccount);
  }

  /// 注入测试数据
  ///
  /// 创建测试用户并注入预设的测试数据。
  /// 成功后自动切换到测试数据账号。
  Future<bool> injectTestData() async {
    state = state.copyWith(
      isInjecting: true,
      progress: 0.0,
      clearError: true,
    );

    try {
      final db = ref.read(databaseProvider);
      final service = TestDataService(db);

      // 更新进度
      state = state.copyWith(progress: 0.1);

      // 注入数据
      await service.injectTestData();

      // 更新进度
      state = state.copyWith(progress: 0.9);

      // 保存测试账号状态
      await _saveTestAccountStatus(true);

      // 完成
      state = state.copyWith(
        isTestAccount: true,
        isInjecting: false,
        progress: 1.0,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isInjecting: false,
        progress: 0.0,
        errorMessage: '注入测试数据失败: $e',
      );
      return false;
    }
  }

  /// 清除测试数据
  ///
  /// 删除所有测试数据并切换回游客账号。
  Future<bool> clearTestData() async {
    state = state.copyWith(
      isInjecting: true,
      progress: 0.0,
      clearError: true,
    );

    try {
      final db = ref.read(databaseProvider);
      final service = TestDataService(db);

      // 清除数据
      await service.clearTestData();

      // 清除测试账号状态
      await _saveTestAccountStatus(false);

      state = state.copyWith(
        isTestAccount: false,
        isInjecting: false,
        progress: 1.0,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isInjecting: false,
        progress: 0.0,
        errorMessage: '清除测试数据失败: $e',
      );
      return false;
    }
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// 测试数据 Provider
final testDataProvider = NotifierProvider<TestDataNotifier, TestDataState>(() {
  return TestDataNotifier();
});

/// 是否为测试账号 Provider（便捷访问）
final isTestAccountProvider = Provider<bool>((ref) {
  return ref.watch(testDataProvider).isTestAccount;
});