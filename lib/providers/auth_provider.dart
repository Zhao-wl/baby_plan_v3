import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'database_provider.dart';

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
  Future<void> _initializeUser() async {
    try {
      final db = ref.read(databaseProvider);

      // 查询本地用户（排除已删除）
      final existingUsers = await (db.select(db.users)
            ..where((u) => u.isDeleted.equals(false)))
          .get();

      if (existingUsers.isNotEmpty) {
        // 使用现有用户
        final user = existingUsers.first;
        state = AuthState(
          currentUser: user,
          isGuest: user.isGuest,
          isLoading: false,
        );
      } else {
        // 创建游客用户
        final guestUser = await _createGuestUser(db);
        state = AuthState(
          currentUser: guestUser,
          isGuest: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = AuthState(
        isLoading: false,
        errorMessage: '初始化用户失败: $e',
      );
    }
  }

  /// 创建游客用户
  Future<User> _createGuestUser(AppDatabase db) async {
    final id = await db.into(db.users).insert(
          UsersCompanion.insert(
            nickname: '游客',
            isGuest: const Value(true),
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