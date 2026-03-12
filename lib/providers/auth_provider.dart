import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';
import 'device_service_provider.dart';

/// 认证状态数据类
class AuthState {
  /// 当前用户
  final User? currentUser;

  /// 是否为游客模式
  final bool isGuest;

  /// 是否正在加载
  final bool isLoading;

  /// 错误信息
  final String? errorMessage;

  const AuthState({
    this.currentUser,
    this.isGuest = false,
    this.isLoading = true,
    this.errorMessage,
  });

  /// 创建初始化状态
  const AuthState.initial()
      : currentUser = null,
        isGuest = false,
        isLoading = true,
        errorMessage = null;

  /// 创建加载中状态
  const AuthState.loading()
      : currentUser = null,
        isGuest = false,
        isLoading = true,
        errorMessage = null;

  AuthState copyWith({
    User? currentUser,
    bool? isGuest,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      isGuest: isGuest ?? this.isGuest,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// 认证状态管理 Notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // 启动时自动初始化用户
    _initializeUser();
    return const AuthState.loading();
  }

  /// 初始化用户：检查现有用户或创建游客用户
  ///
  /// 恢复优先级：
  /// 1. 数据库中的游客账号（按创建时间降序，取最新的）
  /// 2. 本地正式用户
  /// 3. 创建新游客账号
  Future<void> _initializeUser() async {
    try {
      final db = ref.read(databaseProvider);
      final deviceService = ref.read(deviceServiceProvider);

      debugPrint('[AuthProvider] 开始初始化用户...');

      // 1. 优先从数据库查询游客账号（按创建时间降序）
      // 这是解决 Web 平台数据丢失的关键：IndexedDB 跨会话持久，而 localStorage 可能因 origin 变化而丢失
      final guestUsers = await (db.select(db.users)
            ..where((u) => u.isGuest.equals(true) & u.isDeleted.equals(false))
            ..orderBy([(u) => OrderingTerm.desc(u.createdAt)]))
          .get();

      debugPrint('[AuthProvider] 查询到 ${guestUsers.length} 个游客账号');
      for (final u in guestUsers) {
        debugPrint('[AuthProvider] 游客账号: id=${u.id}, nickname=${u.nickname}, deviceId=${u.deviceId}, createdAt=${u.createdAt}');
      }

      if (guestUsers.isNotEmpty) {
        // 恢复最新的游客账号
        final guestUser = guestUsers.first;
        debugPrint('[AuthProvider] 恢复游客账号: id=${guestUser.id}');
        state = AuthState(
          currentUser: guestUser,
          isGuest: true,
          isLoading: false,
        );

        // 同步设备标识：如果游客账号有 deviceId，确保 SharedPreferences 也同步
        if (guestUser.deviceId != null) {
          await deviceService.setDeviceId(guestUser.deviceId!);
          debugPrint('[AuthProvider] 已同步设备标识到 SharedPreferences: ${guestUser.deviceId}');
        }

        return;
      }

      // 2. 查询本地正式用户（排除已删除）
      final existingUsers = await (db.select(db.users)
            ..where((u) => u.isDeleted.equals(false) & u.isGuest.equals(false)))
          .get();

      debugPrint('[AuthProvider] 查询到 ${existingUsers.length} 个正式用户');

      if (existingUsers.isNotEmpty) {
        // 使用现有正式用户
        final user = existingUsers.first;
        debugPrint('[AuthProvider] 使用正式用户: id=${user.id}');
        state = AuthState(
          currentUser: user,
          isGuest: user.isGuest,
          isLoading: false,
        );
        return;
      }

      // 3. 创建新的游客用户，关联 deviceId
      final deviceId = await deviceService.getDeviceId();
      debugPrint('[AuthProvider] 创建新游客账号，deviceId=$deviceId');
      final guestUser = await _createGuestUser(db, deviceId);
      state = AuthState(
        currentUser: guestUser,
        isGuest: true,
        isLoading: false,
      );
    } catch (e, stack) {
      debugPrint('[AuthProvider] 初始化用户失败: $e');
      debugPrint('[AuthProvider] 堆栈: $stack');
      state = AuthState(
        isLoading: false,
        errorMessage: '初始化用户失败: $e',
      );
    }
  }

  /// 创建游客用户
  Future<User> _createGuestUser(AppDatabase db, String deviceId) async {
    final id = await db.into(db.users).insert(
          UsersCompanion.insert(
            nickname: '游客',
            isGuest: const Value(true),
            deviceId: Value(deviceId),
          ),
        );

    // 查询并返回创建的用户
    return await (db.select(db.users)..where((u) => u.id.equals(id)))
        .getSingle();
  }

  /// 获取当前用户
  User? get currentUser => state.currentUser;

  /// 是否为游客
  bool get isGuest => state.isGuest;

  /// 登录（占位实现）
  ///
  /// TODO: 实现实际的登录逻辑
  Future<void> login(String phone, String password) async {
    // 占位实现
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      isLoading: false,
      errorMessage: '登录功能暂未开放',
    );
  }

  /// 登出（占位实现）
  ///
  /// TODO: 实现实际的登出逻辑
  Future<void> logout() async {
    // 占位实现
    state = state.copyWith(
      isLoading: false,
      errorMessage: '登出功能暂未开放',
    );
  }

  /// 升级为正式账号（占位实现）
  ///
  /// TODO: 实现实际的升级逻辑
  /// 游客用户可升级为正式账号，保留已有数据
  Future<void> upgradeToAccount(String phone, String password) async {
    if (!isGuest) {
      state = state.copyWith(errorMessage: '当前已是正式账号');
      return;
    }

    // 占位实现
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      isLoading: false,
      errorMessage: '升级功能暂未开放',
    );
  }

  /// 刷新用户状态
  Future<void> refresh() async {
    await _initializeUser();
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// 认证状态 Provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

/// 当前用户 Provider（便捷访问）
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).currentUser;
});

/// 是否为游客 Provider（便捷访问）
final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isGuest;
});