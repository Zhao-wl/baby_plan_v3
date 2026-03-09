## 1. 导航状态管理

- [x] 1.1 创建 `lib/providers/navigation_provider.dart`，定义 NavTab 枚举（home, timeline, stats, profile）
- [x] 1.2 实现 NavigationNotifier，管理当前选中 Tab 状态
- [x] 1.3 提供 setTab(NavTab tab) 方法和 currentTab 状态
- [x] 1.4 在 `lib/providers/providers.dart` 中导出 navigation_provider

## 2. 页面骨架创建

- [x] 2.1 创建 `lib/pages/` 目录
- [x] 2.2 创建 `lib/pages/home_page.dart`，首页骨架页面（支持状态保持）
- [x] 2.3 创建 `lib/pages/timeline_page.dart`，时间线骨架页面（支持状态保持）
- [x] 2.4 创建 `lib/pages/stats_page.dart`，统计骨架页面（支持状态保持）
- [x] 2.5 创建 `lib/pages/profile_page.dart`，我的骨架页面（支持状态保持）

## 3. 主页面容器

- [x] 3.1 创建 `lib/pages/main_page.dart`，包含 Scaffold 结构
- [x] 3.2 实现 IndexedStack 作为页面容器，包裹 4 个页面骨架
- [x] 3.3 实现 Material 3 NavigationBar 底部导航栏
- [x] 3.4 配置 4 个 NavigationDestination（图标 + 文字标签）
- [x] 3.5 绑定 NavigationProvider 实现选中状态同步

## 4. 应用入口更新

- [x] 4.1 修改 `lib/main.dart`，将 home 指向 MainPage
- [x] 4.2 移除或注释 DatabaseTestPage 相关代码

## 5. 验证与测试

- [x] 5.1 运行 `flutter analyze` 确保无代码问题
- [x] 5.2 运行 `flutter run -d chrome` 验证导航功能
- [x] 5.3 验证 Tab 切换时页面状态保持（滚动位置不重置）
- [x] 5.4 验证浅色/深色主题切换时导航栏适配