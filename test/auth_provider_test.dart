import 'package:flutter_test/flutter_test.dart';
import 'package:baby_plan_v3/providers/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthState Tests', () {
    test('AuthState.initial() should have correct default values', () {
      const state = AuthState.initial();

      expect(state.currentUser, isNull);
      expect(state.isGuest, isFalse);
      expect(state.isLoading, isTrue);
      expect(state.errorMessage, isNull);
    });

    test('AuthState.loading() should have correct default values', () {
      const state = AuthState.loading();

      expect(state.currentUser, isNull);
      expect(state.isGuest, isFalse);
      expect(state.isLoading, isTrue);
      expect(state.errorMessage, isNull);
    });

    test('AuthState.copyWith() should update values correctly', () {
      const original = AuthState.initial();
      final updated = original.copyWith(
        isGuest: true,
        isLoading: false,
      );

      expect(updated.isGuest, isTrue);
      expect(updated.isLoading, isFalse);
      expect(updated.currentUser, isNull);
      expect(updated.errorMessage, isNull);
    });

    test('AuthState.copyWith() with clearError should clear errorMessage', () {
      const original = AuthState(
        errorMessage: 'Test error',
        isLoading: false,
      );
      final updated = original.copyWith(clearError: true);

      expect(updated.errorMessage, isNull);
    });
  });

  group('AuthProvider Behavior Tests', () {
    test('isGuest property should return correct value from state', () {
      // 这些是纯数据类的测试，验证状态模型
      const guestState = AuthState(isGuest: true, isLoading: false);
      const userState = AuthState(isGuest: false, isLoading: false);

      expect(guestState.isGuest, isTrue);
      expect(userState.isGuest, isFalse);
    });

    test('currentUser property should return correct value from state', () {
      // 测试状态模型中的 currentUser 属性
      const stateWithoutUser = AuthState.initial();
      expect(stateWithoutUser.currentUser, isNull);
    });
  });
}