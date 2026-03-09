## 1. 导航状态更新

- [x] 1.1 修改 NavTab 枚举，在 stats 和 profile 之间插入 vaccine 值
- [x] 1.2 更新 providers.dart 导出 navigation_provider（如未导出）

## 2. 疫苗页面创建

- [x] 2.1 创建 `lib/pages/vaccine_page.dart` 骨架页面
- [x] 2.2 使用 StatefulWidget + AutomaticKeepAliveClientMixin 保持页面状态

## 3. 主页面更新

- [x] 3.1 在 MainPage 的 IndexedStack 中添加 VaccinePage
- [x] 3.2 在 NavigationBar 的 destinations 中添加疫苗导航项

## 4. 验证

- [x] 4.1 运行 `flutter analyze` 确保无 lint 错误
- [x] 4.2 运行应用验证疫苗页签显示和切换功能