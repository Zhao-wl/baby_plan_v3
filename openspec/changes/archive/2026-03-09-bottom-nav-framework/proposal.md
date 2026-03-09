## Why

用户需要一个稳定的应用主导航框架，支持在首页、时间线、统计、我的四个核心页面之间切换。当前项目已完成数据库层、Provider 层和主题系统，但缺少 UI 入口点。底部导航是应用的主要交互入口，需要在后续页面开发之前先搭建好框架。

## What Changes

- 新增底部导航组件（NavigationBar，Material 3 风格）
- 新增 4 个页面骨架作为占位（HomePage、TimelinePage、StatsPage、ProfilePage）
- 新增 NavigationProvider 管理导航状态
- 实现页面状态保持机制（IndexedStack），防止切换页签时页面重置
- 提供统一的页面导航接口供后续功能调用

## Capabilities

### New Capabilities

- `bottom-navigation`: 底部导航栏组件，支持 4 个 Tab 切换，Material 3 风格
- `navigation-state`: 导航状态管理，包含当前选中 Tab 和页面状态保持
- `page-placeholders`: 4 个页面骨架占位组件，为 1.8 路由配置提供基础

### Modified Capabilities

无现有能力需要修改。

## Impact

**新增文件：**
- `lib/pages/main_page.dart` - 主页面容器（导航栏 + IndexedStack）
- `lib/pages/home_page.dart` - 首页骨架
- `lib/pages/timeline_page.dart` - 时间线骨架
- `lib/pages/stats_page.dart` - 统计骨架
- `lib/pages/profile_page.dart` - 我的骨架
- `lib/providers/navigation_provider.dart` - 导航状态管理

**修改文件：**
- `lib/main.dart` - 将 home 指向 MainPage
- `lib/providers/providers.dart` - 添加 navigation_provider 导出

**依赖：**
- 无需新增依赖，使用 Flutter 内置 NavigationBar（Material 3）