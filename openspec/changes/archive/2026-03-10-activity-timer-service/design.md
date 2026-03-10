## Context

当前应用使用 Riverpod 进行状态管理，数据通过 Drift (SQLite) 持久化。首页 HomePage 包含：
- `BabyInfoCard`：显示宝宝信息
- `TimerCardPlaceholder`：计时器占位组件（仅有呼吸动画，无实际功能）
- `QuickActionBar`：四个快捷操作按钮（吃奶、玩耍、睡眠、便便），目前都是 TODO 状态

用户需求：点击快捷按钮后能立即开始计时，结束时自动生成活动记录。

## Goals / Non-Goals

**Goals:**
- 实现正计时（Stopwatch）模式的活动计时
- 支持 App 进入后台后恢复计时的准确性
- 点击快捷按钮开始计时，再次点击同类按钮结束并保存记录
- 切换到不同活动类型时自动保存当前活动并开始新活动
- 提供暂停、继续、取消等操作

**Non-Goals:**
- 不实现倒计时（Timer）模式
- 不实现 App 完全关闭后的计时恢复（仅支持后台挂起状态）
- 不实现计时过程的本地通知提醒

## Decisions

### 1. 后台计时策略：时间戳计算

**选择方案**：保存 `startTime` 到 SharedPreferences，App 恢复时重新计算时长。

**理由**：
- 轻量级，无需原生代码
- 跨平台通用（Android/iOS/Web）
- 对于育儿记录场景，秒级精度足够

**替代方案**：`flutter_background_service` 创建前台服务
- 过于重量级，需要通知栏常驻
- iOS 后台执行受限（15-30秒）
- 不适合"记录时长"场景

### 2. 状态管理：TimerNotifier

**选择方案**：创建 `TimerNotifier` 继承 `Notifier<TimerState>`，使用 Riverpod 管理。

```dart
class TimerState {
  final ActivityType? activityType;  // null = 无计时
  final DateTime? startTime;         // 开始时间
  final bool isPaused;               // 是否暂停
  final Duration pausedDuration;     // 暂停累计时长
}
```

**理由**：
- 与现有 Riverpod 架构一致
- 便于与其他 Provider（如 currentBabyProvider）集成
- 自动触发 UI 重建

### 3. 持久化策略

**选择方案**：使用 SharedPreferences 保存计时状态。

```dart
// 保存的 key
const kTimerActivityType = 'timer_activity_type';
const kTimerStartTime = 'timer_start_time';      // ISO8601 字符串
const kTimerPausedDuration = 'timer_paused_duration'; // 秒数
```

**理由**：
- 项目已依赖 SharedPreferences
- 数据量小，无需数据库
- App 启动时可快速恢复状态

### 4. 切换活动的行为

**选择方案**：切换活动时自动保存当前活动记录，然后开始新活动。

**理由**：
- 用户切换意味着上一个活动已经结束
- 避免用户忘记结束计时导致数据丢失
- 提供流畅的操作体验

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 用户误触快捷按钮开始计时 | 提供"取消"选项，不保存记录 |
| App 被系统杀死后状态丢失 | 启动时检查 SharedPreferences，恢复未完成的计时 |
| 长时间后台后时间不准确 | 显示"已计时 X 小时 Y 分钟"，用户可编辑调整 |
| 多次快速点击 | 记录开始时间后禁用按钮 500ms |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI Layer                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   TimerCard                QuickActionBar                       │
│   ├── 时间显示 (00:00:00)  ├── 吃奶按钮 ─────────┐              │
│   ├── 活动类型标签         ├── 玩耍按钮          │              │
│   ├── 暂停/继续按钮        ├── 睡眠按钮 ─────────┼──▶ 开始/结束 │
│   └── 结束/取消按钮        └── 便便按钮          │    计时      │
│                                                       │          │
├─────────────────────────────────────────────────────────────────┤
│                      Provider Layer                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   timerProvider (TimerNotifier)                                 │
│   ├── TimerState: activityType, startTime, isPaused...         │
│   ├── start(ActivityType) → 开始计时                           │
│   ├── stop() → ActivityRecord                                  │
│   ├── pause() / resume()                                       │
│   ├── cancel()                                                 │
│   └── switchActivity(ActivityType) → 自动保存 + 开始新计时     │
│                                                                 │
│   依赖:                                                         │
│   ├── currentBabyProvider (获取 babyId)                        │
│   ├── databaseProvider (保存 ActivityRecord)                   │
│   └── settingsProvider (持久化计时状态)                        │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                      Storage Layer                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   SharedPreferences (计时状态持久化)                            │
│   └── key: timer_activity_type, timer_start_time...            │
│                                                                 │
│   Drift Database (活动记录持久化)                               │
│   └── ActivityRecords 表                                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

### 开始计时
```
用户点击"睡眠"
    → QuickActionBar.onPressed()
    → ref.read(timerProvider.notifier).start(ActivityType.sleep)
    → TimerState 更新: { activityType: sleep, startTime: now, isPaused: false }
    → SharedPreferences 保存状态
    → TimerCard 显示计时中状态
```

### 切换活动
```
用户点击"吃奶"（当前正在计时睡眠）
    → QuickActionBar.onPressed()
    → ref.read(timerProvider.notifier).switchActivity(ActivityType.eat)
    → 自动调用 stop() 创建睡眠记录
    → 保存到 Drift: ActivityRecords { type: sleep, startTime, endTime, durationSeconds }
    → 开始新的吃奶计时
    → TimerState 更新: { activityType: eat, startTime: now }
```

### App 后台恢复
```
App 从后台恢复
    → TimerNotifier 初始化时检查 SharedPreferences
    → 存在未结束的计时？
        → 是: 计算已计时时长 = now - startTime - pausedDuration
        → 更新 TimerState
    → TimerCard 显示正确的时间
```