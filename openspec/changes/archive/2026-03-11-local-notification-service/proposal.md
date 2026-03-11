## Why

宝宝成长记录应用需要及时提醒家长重要事项，如疫苗接种时间和智能预测的日常活动。当前应用缺乏通知功能，用户可能错过关键的疫苗接种时间窗口，或无法获得基于历史数据的智能活动预测提醒。

本地通知是实现这一功能的最佳方案：
- 不依赖网络连接，确保提醒及时送达
- 无需服务端推送服务，降低开发和运维成本
- 符合项目计划 2.6 任务要求

## What Changes

- 添加 `flutter_local_notifications` 依赖包
- 配置 Android 通知权限（POST_NOTIFICATIONS for Android 13+）、通知图标和渠道
- 配置 iOS 通知权限描述和后台模式
- 实现 `NotificationService` 服务层，封装通知调度和管理逻辑
- 实现 `NotificationProvider` 状态管理，集成到 Riverpod 架构
- 实现疫苗计划自动生成（基于宝宝出生日期和疫苗库数据）
- 实现疫苗接种提醒（提前3天通知）
- 预留预测提醒接口，待预测引擎（任务 3.8）实现后集成

## Capabilities

### New Capabilities

- `notification-service`: 本地通知服务基础设施，包括通知调度、权限管理、通知渠道配置
- `vaccine-reminder`: 疫苗接种提醒功能，基于宝宝出生日期自动生成疫苗计划并在接种日期前3天发送提醒

### Modified Capabilities

- `vaccine-tab`: 疫苗页面需要与通知服务集成，显示已计划的提醒信息

## Impact

**新增文件：**
- `lib/services/notification_service.dart` - 通知服务核心实现
- `lib/providers/notification_provider.dart` - 通知状态管理
- Android 通知图标资源

**修改文件：**
- `pubspec.yaml` - 添加 flutter_local_notifications 依赖
- `android/app/src/main/AndroidManifest.xml` - 添加通知权限和配置
- `ios/Runner/Info.plist` - 添加通知权限描述
- `lib/providers/providers.dart` - 导出 notification_provider

**依赖关系：**
- 依赖现有 `VaccineLibrary` 和 `VaccineRecords` 数据
- 依赖 `CurrentBabyProvider` 获取当前宝宝信息
- 预测提醒功能依赖未实现的预测引擎（任务 3.8）