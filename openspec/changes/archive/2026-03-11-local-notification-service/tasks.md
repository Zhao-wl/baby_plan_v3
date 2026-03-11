## 1. 依赖配置与平台设置

- [x] 1.1 添加 `flutter_local_notifications` 依赖到 `pubspec.yaml`
- [x] 1.2 配置 Android 通知权限（`AndroidManifest.xml` 添加 `POST_NOTIFICATIONS` 权限）
- [x] 1.3 配置 Android 通知图标资源（`@mipmap/ic_notification`）
- [x] 1.4 配置 iOS 通知权限描述（`Info.plist` 添加 `NSUserNotificationUsageDescription`）
- [x] 1.5 运行 `flutter pub get` 验证依赖安装

## 2. 通知服务核心实现

- [x] 2.1 创建 `lib/services/notification_service.dart` 文件
- [x] 2.2 实现 `initialize()` 方法：初始化 FlutterLocalNotificationsPlugin
- [x] 2.3 实现 Android 通知渠道配置（`vaccine_reminder`、`prediction`）
- [x] 2.4 实现 iOS 通知设置配置
- [x] 2.5 实现 `isSupported` 平台检测属性
- [x] 2.6 实现 `requestPermission()` 方法：请求通知权限
- [x] 2.7 实现 `checkPermission()` 方法：检查权限状态
- [x] 2.8 实现 `scheduleNotification()` 方法：调度指定时间通知
- [x] 2.9 实现 `cancelNotification()` 方法：取消指定通知
- [x] 2.10 实现通知点击处理回调

## 3. 通知状态管理（Provider）

- [x] 3.1 创建 `lib/providers/notification_provider.dart` 文件
- [x] 3.2 实现 `NotificationProvider` 类，持有 `NotificationService` 实例
- [x] 3.3 实现通知权限状态管理
- [x] 3.4 实现疫苗提醒调度方法
- [x] 3.5 实现预测提醒调度方法（预留接口）
- [x] 3.6 在 `lib/providers/providers.dart` 中导出 `notification_provider.dart`

## 4. 疫苗计划生成

- [x] 4.1 创建 `lib/services/vaccine_plan_service.dart` 文件
- [x] 4.2 实现 `generateVaccinePlan()` 方法：根据宝宝出生日期生成疫苗计划
- [x] 4.3 加载 `assets/data/vaccine_library.json` 数据
- [x] 4.4 为每种疫苗计算推荐接种日期（出生日期 + recommendedAgeDays）
- [x] 4.5 创建待接种 `VaccineRecord` 记录并保存到数据库

## 5. 疫苗提醒集成

- [x] 5.1 在 `NotificationService` 中实现 `scheduleVaccineReminder()` 方法
- [x] 5.2 计算提醒时间：推荐接种日期 - 3 天，默认上午 9:00
- [x] 5.3 设置通知内容：标题、疫苗名称、剂次、接种日期
- [x] 5.4 在宝宝创建时触发疫苗计划生成和提醒调度
- [x] 5.5 实现已接种记录的提醒取消逻辑
- [x] 5.6 实现应用启动时的提醒恢复逻辑

## 6. 应用启动集成

- [x] 6.1 在 `main.dart` 中初始化 `NotificationService`
- [x] 6.2 请求通知权限（如尚未授权）
- [x] 6.3 恢复即将到来的疫苗提醒

## 7. 测试与验证

- [ ] 7.1 在 Android 真机测试通知显示（需要真机）
- [ ] 7.2 在 iOS 真机测试通知显示（需要真机）
- [ ] 7.3 测试 Web 平台降级处理（需要真机/模拟器）
- [ ] 7.4 测试通知点击跳转（需要真机/模拟器）
- [x] 7.5 测试疫苗计划生成正确性（代码逻辑已验证）
- [x] 7.6 测试提醒时间计算正确性（代码逻辑已验证）