## Why

用户在记录宝宝的 E.A.S.Y 活动时，需要一种便捷的方式来实时记录活动时长。当前 QuickActionBar 的按钮都是 TODO 状态，用户只能手动输入时间，无法实现"一键开始、自动计时、结束保存"的流畅体验。

通过引入活动计时服务，用户可以点击"睡眠"按钮立即开始计时，在活动结束时或切换到其他活动时自动生成记录，大幅提升日常记录的效率和准确性。

## What Changes

- 新增 `TimerService`：管理活动计时状态（开始、暂停、继续、停止、取消）
- 新增 `TimerProvider`：Riverpod 状态管理，持久化计时状态
- 改造 `QuickActionBar`：点击按钮触发计时开始/切换
- 改造 `TimerCardPlaceholder` → `TimerCard`：显示实时计时状态和控制按钮
- 新增后台恢复机制：App 进入后台时保存时间戳，恢复时重新计算已计时时长
- 自动生成 `ActivityRecord`：计时结束时或切换活动时自动创建数据库记录

## Capabilities

### New Capabilities

- `activity-timer`: 活动计时核心服务，管理计时状态、后台持久化、记录生成
- `timer-ui`: 计时器 UI 组件，显示实时计时、提供控制操作
- `quick-action-integration`: 快捷操作栏与计时器联动，实现一键开始/切换活动

### Modified Capabilities

- `dashboard-baby-card`: 首页宝宝卡片需要根据计时状态更新显示（当有正在进行的活动时）