## Why

宝宝疫苗接种是育儿过程中非常重要的健康管理环节。当前应用缺少专门的疫苗管理功能，家长无法在应用内追踪宝宝的疫苗接种计划、接种记录和接种提醒。作为 E.A.S.Y. 育儿助手的核心功能补充，疫苗模块将帮助家长更好地管理宝宝的健康档案。

## What Changes

- 新增底部导航栏"疫苗"页签，位于"统计"和"我的"之间
- 创建 `VaccinePage` 骨架页面组件
- 修改 `NavTab` 枚举，新增 `vaccine` 选项
- 更新 `MainPage` 的 `IndexedStack` 和 `NavigationBar` 配置

## Capabilities

### New Capabilities

- `vaccine-tab`: 底部导航疫苗页签，提供疫苗功能的入口页面

### Modified Capabilities

- `navigation-provider`: 修改 NavTab 枚举，新增 vaccine 选项

## Impact

**新增文件：**
- `lib/pages/vaccine_page.dart` - 疫苗页面骨架

**修改文件：**
- `lib/providers/navigation_provider.dart` - 新增 NavTab.vaccine
- `lib/pages/main_page.dart` - 更新导航配置
- `lib/providers/providers.dart` - 导出 navigation_provider（如未导出）