## Context

本项目是一个 Flutter 跨平台宝宝成长记录应用，支持 Android、iOS 和 Web 三端。当前项目已完成基础架构和核心功能（阶段一、二），现在需要添加本地通知服务以支持疫苗接种提醒和未来的智能预测提醒。

**当前状态：**
- 已有 `VaccineLibrary` 表存储疫苗库数据（含推荐接种年龄）
- 已有 `VaccineRecords` 表存储接种记录
- 已有 `CurrentBabyProvider` 提供当前宝宝信息（含出生日期）
- 尚未实现疫苗页面和疫苗计划生成逻辑
- 尚未实现预测引擎

**约束：**
- 必须支持 Android 13+ 的运行时权限请求
- iOS 需要请求用户授权通知
- Web 平台不支持 flutter_local_notifications，需降级处理
- 预测提醒依赖未实现的预测引擎

## Goals / Non-Goals

**Goals:**
- 实现跨平台本地通知基础设施
- 实现疫苗计划自动生成（基于宝宝出生日期 + 疫苗库）
- 实现疫苗接种提醒（提前3天通知）
- 提供可扩展的通知服务架构，支持未来添加更多提醒类型
- 优雅处理各平台差异（Android/iOS/Web）

**Non-Goals:**
- 不实现云端推送服务（未来可选）
- 不实现预测提醒的具体逻辑（依赖预测引擎）
- 不实现通知的历史记录管理
- 不实现富媒体通知（图片、按钮等）

## Decisions

### 1. 通知库选择：flutter_local_notifications

**选择理由：**
- 官方推荐，社区活跃，维护良好
- 支持 Android、iOS、macOS、Linux、Windows
- 支持定时通知、重复通知
- 支持通知渠道（Android）和通知类别（iOS）

**备选方案：**
- `awesome_notifications`：功能更丰富，但包体积较大
- `flutter_local_notifications` + `workmanager`：需要额外依赖处理后台任务

**最终决定：** 使用 `flutter_local_notifications` 单一依赖，利用其内置的定时通知功能。

### 2. 通知调度策略：精确时间调度

**选择理由：**
- 疫苗提醒需要精确到具体日期
- `flutter_local_notifications` 支持 `DateTime` 精确调度
- iOS 使用 `UNCalendarNotificationTrigger`，Android 使用 `AlarmManager`

**备选方案：**
- 应用启动时检查 + 立即显示：用户不打开应用则无法收到提醒
- 后台定期轮询：耗电，且 iOS 限制严格

**最终决定：** 使用 `zonedSchedule` 方法进行精确时间调度。

### 3. 疫苗计划生成时机：添加宝宝时生成

**选择理由：**
- 数据提前准备好，提醒可立即调度
- 用户体验更好，添加宝宝后立即看到完整疫苗计划
- 避免用户忘记访问疫苗页面导致错过提醒

**备选方案：**
- 首次访问疫苗页面时生成：可能错过提前提醒
- 应用启动时检查生成：每次启动都要检查，效率低

**最终决定：** 在宝宝创建时自动生成疫苗计划，创建 `VaccineRecord` 记录。

### 4. 服务层架构：单一 NotificationService

**选择理由：**
- 当前规模不需要复杂的分层架构
- 便于统一管理所有通知渠道
- 简化权限管理和初始化流程

**架构设计：**
```
┌─────────────────────────────────────────────────────────────┐
│                    NotificationProvider                      │
│              (Riverpod State Management)                     │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    NotificationService                       │
│  - initialize()      初始化通知服务                          │
│  - requestPermission() 请求通知权限                          │
│  - scheduleVaccineReminder() 调度疫苗提醒                    │
│  - cancelReminder()  取消提醒                                │
│  - schedulePredictionReminder() 调度预测提醒（预留）         │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│               flutter_local_notifications                    │
│              (Platform-specific implementations)             │
└─────────────────────────────────────────────────────────────┘
```

### 5. 通知渠道配置（Android）

| 渠道 ID | 名称 | 重要性 | 描述 |
|---------|------|--------|------|
| `vaccine_reminder` | 疫苗提醒 | High | 疫苗接种提醒通知 |
| `prediction` | 智能预测 | Default | 智能预测提醒通知 |

### 6. Web 平台处理策略

Web 平台不支持 `flutter_local_notifications`，采用降级策略：
- 在服务初始化时检测平台
- Web 平台跳过通知初始化
- 提供 `isSupported` 属性供 UI 判断是否显示通知设置

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| Android 13+ 需要运行时请求 POST_NOTIFICATIONS 权限，用户可能拒绝 | 提供 UI 引导用户到设置开启通知；不授权时应用仍可正常使用 |
| iOS 后台任务限制，精确时间通知可能受限 | 使用 `UNCalendarNotificationTrigger` 确保可靠性；在文档中说明 iOS 限制 |
| 用户可能清除应用数据导致计划的通知丢失 | 每次应用启动时重新调度即将到来的疫苗提醒 |
| 预测提醒依赖未实现的预测引擎 | 预留接口，待预测引擎实现后集成 |
| Web 平台不支持本地通知 | 平台检测 + 降级处理，Web 用户无法使用通知功能 |