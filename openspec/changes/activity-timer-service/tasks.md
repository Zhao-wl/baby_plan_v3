## 1. 数据模型与状态定义

- [x] 1.1 创建 `lib/providers/timer_provider.dart`
  - 定义 `TimerState` 数据类（activityType, startTime, isPaused, pausedDuration）
  - 定义 `TimerNotifier` 类
- [x] 1.2 实现 `TimerNotifier.build()` 初始化逻辑
  - 从 SharedPreferences 恢复计时状态
  - 处理后台恢复时的时间计算

## 2. 计时核心功能

- [x] 2.1 实现 `TimerNotifier.start(ActivityType)` 方法
  - 验证当前宝宝存在
  - 设置 startTime 和 activityType
  - 持久化到 SharedPreferences
- [x] 2.2 实现 `TimerNotifier.stop()` 方法
  - 计算时长并创建 ActivityRecord
  - 保存到数据库
  - 清除计时状态和持久化数据
- [x] 2.3 实现 `TimerNotifier.pause()` 和 `resume()` 方法
  - 记录暂停时间
  - 计算累计暂停时长
- [x] 2.4 实现 `TimerNotifier.cancel()` 方法
  - 清除状态，不保存记录
- [x] 2.5 实现 `TimerNotifier.switchActivity(ActivityType)` 方法
  - 自动调用 stop() 保存当前活动
  - 立即开始新活动

## 3. 持久化与恢复

- [x] 3.1 创建 `lib/services/timer_storage_service.dart`
  - 封装 SharedPreferences 的读写操作
  - 定义存储 key 常量
- [x] 3.2 实现计时状态持久化逻辑
  - 保存：activityType, startTime, isPaused, pausedDuration
  - 恢复：从存储读取并重建 TimerState
- [x] 3.3 实现 App 生命周期监听
  - App 进入后台时确保状态已持久化
  - App 恢复时重新计算时长

## 4. 计时器 UI 组件

- [x] 4.1 改造 `TimerCardPlaceholder` 为 `TimerCard`
  - 删除占位逻辑，保留呼吸动画
  - 添加计时状态监听（ref.watch(timerProvider)）
- [x] 4.2 实现计时显示 UI
  - HH:MM:SS 时间格式化
  - 活动类型标签和主题色
  - 今日累计时长显示
- [x] 4.3 实现控制按钮 UI
  - 暂停/继续按钮
  - 结束按钮
  - 取消按钮
- [x] 4.4 实现空闲状态 UI
  - 显示引导提示
  - 不显示控制按钮

## 5. 快捷操作栏集成

- [x] 5.1 改造 `QuickActionBar` 按钮逻辑
  - 点击未计时的按钮 → 开始计时
  - 点击正在计时的按钮 → 停止并保存
  - 点击其他按钮 → 切换活动
- [x] 5.2 实现按钮状态反馈
  - 计时中的按钮显示时长
  - 按钮颜色/动画区分状态
- [x] 5.3 实现防抖逻辑
  - 500ms 内不响应重复点击
- [x] 5.4 实现无宝宝时的提示
  - 检查 currentBabyProvider
  - 显示"请先添加宝宝"提示

## 6. 宝宝信息卡片集成

- [x] 6.1 改造 `BabyInfoCard`
  - 监听 timerProvider
  - 有计时时显示活动类型和时长

## 7. 测试与验证

- [x] 7.1 编写 `TimerNotifier` 单元测试
  - 测试开始、停止、暂停、继续、取消
  - 测试切换活动
  - 测试后台恢复
- [x] 7.2 手动验证完整流程
  - 前台计时准确性
  - 后台恢复准确性
  - 切换活动自动保存
  - 数据库记录正确性