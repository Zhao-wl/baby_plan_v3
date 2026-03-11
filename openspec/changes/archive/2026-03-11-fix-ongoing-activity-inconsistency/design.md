## Context

当前存在两套独立的"进行中活动"机制：

**短按流程：**
```
用户短按 → timerProvider.start() → 创建数据库记录(status=0) + 更新 TimerState
         → 首页快捷按钮显示计时状态
         → 时间线页面通过 ongoingActivityProvider 监听数据库记录
```

**长按流程（当前问题）：**
```
用户长按 → OngoingActivityFormSheet → db.createOngoingActivityWithDetails()
         → 只创建数据库记录(status=0)，不更新 TimerState
         → 首页快捷按钮状态不变化
         → 时间线页面显示进行中活动卡片
```

**数据流问题：**
- `timerProvider` 管理内存中的计时状态，同时也会创建数据库记录
- `ongoingActivityProvider` 监听数据库中的 `status=0` 记录
- 两套数据源不同步

## Goals / Non-Goals

**Goals:**
- 统一长按和短按的底层逻辑，确保状态一致性
- 删除时间线页面顶部单独的进行中活动卡片
- 在时间线列表中直观标记进行中的活动
- 长按行为变更为：先启动计时器 → 编辑详情 → 更新记录

**Non-Goals:**
- 不修改数据库表结构
- 不影响已完成活动记录的显示逻辑
- 不修改暂停/继续计时功能

## Decisions

### Decision 1: 统一使用 timerProvider 管理所有进行中活动

**方案：** 所有进行中活动都通过 `timerProvider` 管理，确保单一数据源。

**理由：**
- `timerProvider` 已经实现了持久化、状态恢复等核心功能
- 避免两套状态管理机制导致的不一致问题
- 首页快捷按钮状态可以正确反映所有进行中活动

**替代方案：** 废弃 `timerProvider`，全部使用数据库状态
- 问题：失去内存中的实时计时能力，用户体验下降

### Decision 2: 长按流程重构

**方案：** 长按时先启动计时器，再弹出表单编辑详情

**新流程：**
```
用户长按 → timerProvider.start() 创建草稿记录
         → 弹出 OngoingActivityFormSheet（预填充草稿记录 ID）
         → 用户编辑详情后保存 → 更新草稿记录
         → 用户取消 → 删除草稿记录 + 清除 timerProvider
```

**理由：**
- 与短按行为一致，都先创建计时状态
- 用户可以在表单中补充活动详情
- 取消时清理干净，不留垃圾数据

### Decision 3: 时间线列表显示进行中活动

**方案：** 在 `TimelineList` 中包含进行中活动，用视觉标记区分

**实现：**
- `TimelineQuery` 返回所有活动（包括进行中）
- `TimelineActivityCard` 添加 `isOngoing` 参数
- 进行中活动显示：呼吸动画 + "进行中"标签 + 实时计时

**理由：**
- 用户可以一眼看到所有活动，包括正在进行的
- 减少顶部组件的复杂度
- 时间线更直观完整

## Risks / Trade-offs

### Risk: 长按取消时计时器状态清理
- **风险：** 用户长按后取消，可能留下脏数据
- **缓解：** 在 `OngoingActivityFormSheet` 关闭时检查，如果是取消操作，调用 `timerProvider.cancel()` 清理

### Risk: 列表中进行中活动的实时更新
- **风险：** 进行中活动需要实时显示计时，可能影响性能
- **缓解：** 使用 `Timer.periodic` 每秒更新一次，与现有的 `OngoingActivityCard` 逻辑一致

### Risk: 删除 OngoingActivityCard 后用户习惯改变
- **风险：** 用户习惯了顶部卡片，可能觉得不适应
- **缓解：** 在列表中用明显的视觉标记替代，确保用户能识别进行中活动