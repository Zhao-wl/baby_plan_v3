## Context

首页 Dashboard 是用户进入应用后看到的第一个界面，需要快速展示：
- 当前宝宝的基本信息（姓名、月龄）
- 最新的生长数据（体重、身高）
- 最近的活动记录

当前首页 `home_page.dart` 只是一个占位页面，显示 "首页" 文本。

**已有基础设施：**
- `currentBabyProvider` - 当前宝宝状态管理 ✅
- `todayTimelineProvider` - 今日活动记录 ✅
- `todayStatsProvider` - 今日统计 ✅
- 主题系统（AppColors、AppTheme）✅

**缺失：**
- 最新生长记录 Provider
- 最近活动记录 Provider（不限日期）
- Dashboard UI 组件

## Goals / Non-Goals

**Goals:**
- 实现宝宝信息卡片，展示姓名、月龄、最新体重身高
- 实现最近动态列表，展示最近 2 条活动记录
- 新增 `latestGrowthRecordProvider` 查询最新生长数据
- 新增 `recentActivitiesProvider` 查询最近活动
- 计时器组件做占位实现，等待任务 2.2 完整实现
- 呼吸动效背景作为独立组件实现

**Non-Goals:**
- 不实现计时器的完整功能（属于任务 2.2）
- 不实现快捷记录弹窗（属于任务 2.3）
- 不实现后台同步功能

## Decisions

### 1. 生长记录数据来源：使用最新记录（方案 B）

**选择理由：**
- Babies 表只存储出生时的体重身高，无法反映当前状态
- GrowthRecords 表记录每次测量数据，可获取最新值
- 更符合用户期望看到的"当前"数据

**实现方式：**
```dart
// 查询最新生长记录
final latestGrowthRecordProvider = FutureProvider.family<GrowthRecord?, int>((ref, babyId) async {
  final db = ref.watch(databaseProvider);
  final records = await (db.select(db.growthRecords)
    ..where((r) => r.babyId.equals(babyId) & r.isDeleted.equals(false))
    ..orderBy([(r) => OrderingTerm.desc(r.recordDate)])
    ..limit(1))
    .get();
  return records.isNotEmpty ? records.first : null;
});
```

### 2. 最近活动查询：不限日期，取最新 N 条

**选择理由：**
- Dashboard 需要显示"最近"的活动，可能是今天的，也可能是昨天的
- 使用 `limit(N)` 查询，性能更好
- 避免多次查询不同日期的时间线

**实现方式：**
```dart
final recentActivitiesProvider = FutureProvider.family<List<ActivityRecord>, ({int babyId, int limit})>((ref, query) async {
  final db = ref.watch(databaseProvider);
  return await (db.select(db.activityRecords)
    ..where((r) => r.babyId.equals(query.babyId) & r.isDeleted.equals(false))
    ..orderBy([(r) => OrderingTerm.desc(r.startTime)])
    ..limit(query.limit))
    .get();
});
```

### 3. 计时器组件：占位实现

**选择理由：**
- 任务 2.2 专门实现计时器功能
- 先做占位，避免阻塞 Dashboard 其他功能
- 占位组件显示"正在开发中"或简单状态提示

**实现方式：**
```dart
class TimerPlaceholder extends StatelessWidget {
  const TimerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('计时器功能开发中...'),
      ),
    );
  }
}
```

### 4. 呼吸动效背景：独立组件

**选择理由：**
- 可复用于其他需要动效的场景
- 不依赖业务数据，纯 UI 组件
- 使用 `AnimatedBuilder` + `AnimationController` 实现

### 5. 月龄计算：从出生日期计算

**实现方式：**
```dart
String calculateAge(DateTime birthDate) {
  final now = DateTime.now();
  int months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  if (now.day < birthDate.day) months--;

  if (months < 1) {
    final days = now.difference(birthDate).inDays;
    return '$days 天';
  } else if (months < 12) {
    return '$months 个月';
  } else {
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    return remainingMonths > 0 ? '$years 岁 $remainingMonths 个月' : '$years 岁';
  }
}
```

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 生长记录为空时显示空白 | 显示 "--" 占位符，提示用户添加记录 |
| 宝宝未选择时 Dashboard 崩溃 | 使用 `currentBabyProvider` 的 loading 状态处理 |
| 最近活动为空时显示空白 | 显示引导文案，鼓励用户记录第一条 |
| 呼吸动效影响性能 | 使用 `RepaintBoundary` 隔离重绘区域 |

**Trade-offs：**
- 使用单独的 `recentActivitiesProvider` 而非复用 `todayTimelineProvider`：增加少量代码，但逻辑更清晰，查询更高效
- 计时器占位而非完整实现：用户暂时无法使用计时功能，但可并行开发其他功能