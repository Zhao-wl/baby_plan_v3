## 1. 项目结构准备

- [x] 1.1 创建 `lib/database/tables/` 目录下的表定义文件结构
- [x] 1.2 添加 uuid 包依赖用于设备标识生成

## 2. 用户与家庭组表

- [x] 2.1 创建 `lib/database/tables/users.dart` 用户表定义
- [x] 2.2 创建 `lib/database/tables/families.dart` 家庭组表定义
- [x] 2.3 创建 `lib/database/tables/family_members.dart` 家庭成员关联表定义

## 3. 宝宝相关表

- [x] 3.1 创建 `lib/database/tables/babies.dart` 宝宝表定义
- [x] 3.2 创建 `lib/database/tables/growth_records.dart` 生长记录表定义

## 4. 活动记录表（核心）

- [x] 4.1 创建 `lib/database/tables/activity_records.dart` 活动记录表定义
- [x] 4.2 定义活动类型枚举（E/A/S/P）
- [x] 4.3 定义喂养、睡眠、活动、排泄专属字段

## 5. 疫苗相关表

- [x] 5.1 创建 `lib/database/tables/vaccine_library.dart` 疫苗库表定义
- [x] 5.2 创建 `lib/database/tables/vaccine_records.dart` 接种记录表定义
- [x] 5.3 创建 `assets/data/vaccine_library.json` 内置疫苗数据文件

## 6. 月龄基准数据表

- [x] 6.1 创建 `lib/database/tables/age_benchmark_data.dart` 月龄基准数据表定义

## 7. 数据库类更新

- [x] 7.1 更新 `lib/database/database.dart` 注册所有新表
- [x] 7.2 将 schema 版本从 1 升级到 2
- [x] 7.3 实现 onUpgrade 迁移逻辑（从 v1 到 v2）
- [x] 7.4 定义数据库索引

## 8. 设备标识服务

- [x] 8.1 创建 `lib/services/device_service.dart` 设备标识服务
- [x] 8.2 实现 UUID 生成和 SharedPreferences 存储逻辑
- [x] 8.3 提供获取当前设备标识的接口

## 9. 代码生成与验证

- [x] 9.1 运行 `dart run build_runner build --delete-conflicting-outputs` 生成代码
- [x] 9.2 运行 `flutter analyze` 检查代码错误
- [x] 9.3 运行 `flutter run -d chrome` 验证 Web 端数据库初始化

## 10. 测试与文档

- [x] 10.1 创建数据库表定义的单元测试
- [x] 10.2 验证所有表的外键关联正确
- [x] 10.3 验证索引创建正确
- [x] 10.4 更新 CLAUDE.md 添加新表说明