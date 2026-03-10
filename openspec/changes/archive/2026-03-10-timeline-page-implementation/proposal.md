## Why

时间线页面是 E.A.S.Y 育儿助手的核心功能之一，用于按时间顺序展示宝宝全天的活动记录（吃/玩/睡/排泄）。当前项目已完成数据层（timeline_provider.dart）和页面骨架（timeline_page.dart），但缺少完整的 UI 实现。该页面是用户查看和回溯宝宝活动规律的主要入口，直接影响用户体验和产品的核心价值。

## What Changes

- 实现横向滑动日期选择器组件，支持快速切换日期
- 实现纵向瀑布流时间轴列表，展示全天活动记录
- 为不同活动类型（E-吃/A-玩/S-睡/P-排泄）应用语义化颜色标识
- 显示每条活动的持续时长和详细信息
- 支持跨天活动的正确处理（如前一天的睡眠延续到今天）
- 集成编辑和删除功能，支持点击卡片查看详情、长按删除记录
- 添加空状态提示，当某天无记录时显示友好引导

## Capabilities

### New Capabilities

- `timeline-date-picker`: 横向滑动日期选择器组件，支持左右滑动切换日期、显示一周日期、选中状态高亮
- `timeline-list`: 纵向时间轴列表组件，展示活动记录卡片、时间轴连线、持续时长
- `timeline-activity-card`: 活动记录卡片组件，显示活动类型、时间、时长、详情信息
- `timeline-cross-day`: 跨天记录处理逻辑，正确显示跨天活动的时间线和时长计算

### Modified Capabilities

- 无现有 spec 需要修改（基于已实现的 timeline_provider 数据层进行 UI 层开发）

## Impact

- **新增文件**:
  - `lib/pages/timeline_page.dart` - 重写为完整实现（当前为骨架页面）
  - `lib/widgets/timeline/` 目录 - 时间线相关组件
  - `lib/widgets/timeline/date_picker.dart` - 日期选择器
  - `lib/widgets/timeline/activity_card.dart` - 活动卡片
  - `lib/widgets/timeline/timeline_list.dart` - 时间轴列表

- **依赖**: 使用现有 `timeline_provider.dart` 数据层，无需修改数据库或 Provider
- **主题**: 复用已定义的 E.A.S.Y 颜色规范（AppColors.eat/activity/sleep/poop）
- **交互**: 复用现有 HalfScreenSheet 组件用于编辑弹窗
