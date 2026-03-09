import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 底部导航 Tab 枚举
enum NavTab {
  home,
  timeline,
  stats,
  vaccine,
  profile,
}

/// 导航状态
class NavigationState {
  final NavTab currentTab;

  const NavigationState({
    this.currentTab = NavTab.home,
  });

  NavigationState copyWith({
    NavTab? currentTab,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
    );
  }
}

/// 导航状态管理 Notifier
class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    return const NavigationState();
  }

  /// 切换 Tab
  void setTab(NavTab tab) {
    if (state.currentTab != tab) {
      state = state.copyWith(currentTab: tab);
    }
  }
}

/// 导航状态 Provider
final navigationProvider =
    NotifierProvider<NavigationNotifier, NavigationState>(
  NavigationNotifier.new,
);