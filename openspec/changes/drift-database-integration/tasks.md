## 1. 项目结构创建

- [x] 1.1 创建 `lib/database/` 目录结构
- [x] 1.2 创建 `lib/database/connection.dart` 数据库连接文件

## 2. 数据库初始化代码

- [x] 2.1 实现 `openConnection()` 函数，使用 drift_flutter
- [x] 2.2 创建 `lib/database/database.dart`，定义 AppDatabase 类
- [x] 2.3 配置 schema 版本为 1
- [x] 2.4 实现 onCreate 迁移回调（创建空表占位）
- [x] 2.5 实现 onUpgrade 迁移回调框架

## 3. 代码生成配置

- [x] 3.1 创建 `build.yaml` 配置文件（如需要）
- [x] 3.2 运行 `dart run build_runner build` 验证代码生成

## 4. Android 平台验证

- [ ] 4.1 运行 `flutter run -d android` 启动应用
- [ ] 4.2 验证数据库文件创建成功
- [ ] 4.3 验证插入 1000 条记录性能（< 500ms）
- [ ] 4.4 验证应用重启后数据持久化

## 5. Web 平台验证

- [x] 5.1 运行 `flutter run -d chrome` 启动应用
- [x] 5.2 验证 IndexedDB 存储数据库文件
- [x] 5.3 验证插入 1000 条记录性能（< 1000ms）
- [x] 5.4 验证浏览器刷新后数据持久化

## 6. 文档更新

- [x] 6.1 更新 CLAUDE.md，添加数据库使用说明
- [x] 6.2 更新 create-project-plan 的 tasks.md，标记 1.2 完成