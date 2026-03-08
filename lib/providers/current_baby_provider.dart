import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'babies_provider.dart';
import 'settings_provider.dart';

/// 当前宝宝状态
///
/// 包含当前选中的宝宝和加载状态。
class CurrentBabyState {
  final Baby? baby;
  final bool isLoading;

  const CurrentBabyState({
    this.baby,
    this.isLoading = true,
  });

  CurrentBabyState copyWith({
    Baby? baby,
    bool? isLoading,
  }) {
    return CurrentBabyState(
      baby: baby ?? this.baby,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 当前宝宝状态 Notifier
class CurrentBabyNotifier extends Notifier<CurrentBabyState> {
  @override
  CurrentBabyState build() {
    // 监听宝宝列表变化，自动更新当前宝宝
    ref.listen<AsyncValue<List<Baby>>>(babiesProvider, (prev, next) {
      next.whenData((babies) => _validateCurrentBaby(babies));
    });

    // 初始化时从设置恢复宝宝选择
    _initCurrentBaby();
    return const CurrentBabyState();
  }

  Future<void> _initCurrentBaby() async {
    final settingsAsync = ref.read(settingsProvider);

    settingsAsync.when(
      data: (settings) async {
        final savedBabyId = settings.currentBabyId;
        if (savedBabyId != null) {
          // 验证保存的宝宝 ID 是否有效
          final asyncBabies = ref.read(babiesProvider);
          asyncBabies.when(
            data: (babies) async {
              try {
                final baby = babies.firstWhere((b) => b.id == savedBabyId);
                state = CurrentBabyState(baby: baby, isLoading: false);
              } catch (_) {
                // 宝宝不存在，选择第一个可用宝宝
                await _selectFirstBaby(babies);
              }
            },
            loading: () {
              state = const CurrentBabyState(isLoading: true);
            },
            error: (_, __) {
              state = const CurrentBabyState(isLoading: false);
            },
          );
        } else {
          // 没有保存的宝宝，选择第一个
          final asyncBabies = ref.read(babiesProvider);
          asyncBabies.when(
            data: (babies) async => await _selectFirstBaby(babies),
            loading: () {
              state = const CurrentBabyState(isLoading: true);
            },
            error: (_, __) {
              state = const CurrentBabyState(isLoading: false);
            },
          );
        }
      },
      loading: () {
        state = const CurrentBabyState(isLoading: true);
      },
      error: (_, __) {
        state = const CurrentBabyState(isLoading: false);
      },
    );
  }

  /// 验证当前宝宝是否仍然有效
  void _validateCurrentBaby(List<Baby> babies) {
    if (state.isLoading) return;

    final currentBaby = state.baby;
    if (currentBaby == null) {
      // 当前没有选中宝宝，尝试选择第一个
      if (babies.isNotEmpty) {
        selectBaby(babies.first);
      }
      return;
    }

    // 检查当前宝宝是否仍存在且未删除
    try {
      final existingBaby = babies.firstWhere(
        (b) => b.id == currentBaby.id && !b.isDeleted,
      );
      // 宝宝仍然有效，更新引用
      state = CurrentBabyState(baby: existingBaby, isLoading: false);
    } catch (_) {
      // 宝宝已被删除，自动切换到第一个可用宝宝
      _selectFirstBaby(babies);
    }
  }

  /// 选择第一个可用宝宝
  Future<void> _selectFirstBaby(List<Baby> babies) async {
    if (babies.isNotEmpty) {
      await selectBaby(babies.first);
    } else {
      // 没有可用宝宝
      state = const CurrentBabyState(baby: null, isLoading: false);
      await ref.read(settingsProvider.notifier).setCurrentBabyId(null);
    }
  }

  /// 选择宝宝
  Future<void> selectBaby(Baby baby) async {
    state = CurrentBabyState(baby: baby, isLoading: false);
    await ref.read(settingsProvider.notifier).setCurrentBabyId(baby.id);
  }

  /// 清除当前宝宝选择
  Future<void> clearCurrentBaby() async {
    state = const CurrentBabyState(baby: null, isLoading: false);
    await ref.read(settingsProvider.notifier).setCurrentBabyId(null);
  }
}

/// 当前宝宝 Provider
final currentBabyProvider = NotifierProvider<CurrentBabyNotifier, CurrentBabyState>(() {
  return CurrentBabyNotifier();
});

/// 当前宝宝 ID Provider
///
/// 便捷访问当前宝宝 ID，可能为 null。
final currentBabyIdProvider = Provider<int?>((ref) {
  return ref.watch(currentBabyProvider).baby?.id;
});