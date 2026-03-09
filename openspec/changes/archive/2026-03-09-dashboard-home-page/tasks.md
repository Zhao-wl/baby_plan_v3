## 1. 数据层 Provider 实现

- [x] 1.1 创建 `lib/providers/growth_record_provider.dart`
- [x] 1.2 实现 `latestGrowthRecordProvider` - 查询最新生长记录
- [x] 1.3 创建 `lib/providers/recent_activities_provider.dart`
- [x] 1.4 实现 `recentActivitiesProvider` - 查询最近 N 条活动
- [x] 1.5 在 `lib/providers/providers.dart` 中导出新 Provider

## 2. 辅助工具方法

- [x] 2.1 在 `current_baby_provider.dart` 添加 `calculateAge()` 月龄计算方法
- [x] 2.2 添加 `formatAge()` 格式化月龄显示方法

## 3. Dashboard 组件实现

- [x] 3.1 创建 `lib/widgets/dashboard/` 目录
- [x] 3.2 实现 `baby_info_card.dart` - 宝宝信息卡片
- [x] 3.3 实现 `recent_activities_list.dart` - 最近动态列表
- [x] 3.4 实现 `timer_placeholder.dart` - 计时器占位组件

## 4. 通用 UI 组件

- [x] 4.1 创建 `lib/widgets/common/` 目录
- [x] 4.2 实现 `breathing_background.dart` - 呼吸动效背景组件

## 5. 首页集成

- [x] 5.1 重构 `lib/pages/home_page.dart` 集成所有 Dashboard 组件
- [x] 5.2 实现无宝宝时的引导状态
- [x] 5.3 实现加载状态和错误状态处理

## 6. 测试验证

- [x] 6.1 在 Web 平台验证 Dashboard 显示
- [x] 6.2 验证无数据时的占位显示
- [x] 6.3 验证活动类型颜色正确显示
- [x] 6.4 运行 `flutter analyze` 检查代码质量