## Why

首页 Dashboard 是用户打开应用后看到的第一个界面，需要快速展示宝宝当前状态和最近活动。当前首页只是一个占位页面，无法提供任何有价值的信息。

这是阶段二核心功能实现的起点，需要先完成数据层 Provider 补全，再实现 UI 组件。

## What Changes

- 新增宝宝信息卡片组件，显示头像、月龄、最新体重身高
- 新增最近动态列表组件，显示最近 2 条活动记录
- 新增数据层 Provider：`latestGrowthRecordProvider`、`recentActivitiesProvider`
- 计时器组件先做占位实现，后续任务 2.2 再完整实现
- 呼吸动效背景作为独立 UI 组件实现

## Capabilities

### New Capabilities

- `dashboard-baby-card`: 宝宝信息卡片组件，显示当前宝宝基本信息和最新生长数据
- `dashboard-recent-activities`: 最近动态列表组件，显示最近 N 条活动记录
- `growth-record-provider`: 最新生长记录数据 Provider，查询宝宝最新体重身高数据
- `recent-activities-provider`: 最近活动记录数据 Provider，查询最近 N 条活动（不限日期）
- `breathing-animation`: 呼吸动效背景组件，用于计时器状态的视觉反馈

### Modified Capabilities

- `current-baby-provider`: 扩展支持计算月龄显示

## Impact

**新增文件：**
- `lib/providers/growth_record_provider.dart`
- `lib/providers/recent_activities_provider.dart`
- `lib/widgets/dashboard/baby_info_card.dart`
- `lib/widgets/dashboard/recent_activities_list.dart`
- `lib/widgets/dashboard/timer_placeholder.dart`
- `lib/widgets/common/breathing_background.dart`

**修改文件：**
- `lib/pages/home_page.dart` - 集成 Dashboard 组件
- `lib/providers/providers.dart` - 导出新 Provider