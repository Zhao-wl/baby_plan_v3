## 1. 数据库层

- [x] 1.1 Users 表新增 `isGuest` 字段（`lib/database/tables/users.dart`）
- [x] 1.2 更新数据库 schema 版本，添加迁移逻辑（`lib/database/database.dart`）
- [x] 1.3 运行 `dart run build_runner build --delete-conflicting-outputs` 生成代码

## 2. Provider 层

- [x] 2.1 创建 `AuthProvider`（`lib/providers/auth_provider.dart`）
  - 定义 `AuthState` 数据类（currentUser, isGuest, isLoading）
  - 实现 `AuthNotifier`：启动时自动检查/创建游客用户
  - 提供 `currentUser`、`isGuest` getter
  - 预留 `login()`、`logout()`、`upgradeToAccount()` 方法（占位实现）
- [x] 2.2 更新 `providers.dart` 导出 `AuthProvider`
- [x] 2.3 修改 `babiesProvider` 支持按用户过滤
- [x] 2.4 修改 `syncProvider` 在游客模式下返回禁用状态
- [x] 2.5 修改 `familyProvider` 在游客模式下返回 null

## 3. UI 层

- [x] 3.1 首页顶部添加游客状态提示组件（`lib/widgets/common/guest_status_bar.dart`）
- [x] 3.2 首页集成游客状态提示（`lib/pages/home_page.dart`）
- [x] 3.3 设置页添加登录入口（占位实现）
- [x] 3.4 云同步/家庭组功能入口添加游客限制提示

## 4. 测试与验证

- [x] 4.1 单元测试：AuthProvider 初始化逻辑
- [x] 4.2 集成测试：游客创建宝宝、记录活动
- [x] 4.3 手动验证：首次启动自动创建游客、游客状态显示正确