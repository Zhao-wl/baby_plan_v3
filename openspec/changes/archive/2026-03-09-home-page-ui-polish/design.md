## Context

基于原型代码 `docs/原型界面设计/首页原型.md` 和 PRD 文档，当前首页实现与设计差距较大：

**当前状态：**
- 计时器占位只是简单图标+文字
- 缺少智能预测卡片
- 缺少快捷操作台
- 布局与原型不一致

**原型设计亮点：**
- 计时器卡片：渐变背景 + 呼吸波纹动效
- 智能预测：紫色渐变卡片 + 时间圆圈
- 快捷操作台：悬浮在底部导航上方，吃/玩/睡/排泄四个大按钮
- 单手友好设计

## Goals / Non-Goals

**Goals:**
- 实现计时器卡片占位组件，包含渐变背景和呼吸动效
- 实现智能预测卡片占位组件（UI 框架，功能待开发）
- 实现悬浮快捷操作台组件
- 优化整体视觉风格，对齐原型设计
- 将"排泄"按钮文案改为"便便"

**Non-Goals:**
- 不实现计时器的实际计时功能（属于任务 2.2）
- 不实现智能预测的算法逻辑
- 不实现快捷按钮的弹窗交互（属于任务 2.3）
- 不修改数据层逻辑

## Decisions

### 1. 计时器卡片：使用 AnimatedBuilder 实现呼吸动效

**选择理由：**
- 符合 Flutter 动画最佳实践
- 可复用 `BreathingBackground` 组件的动画逻辑
- 性能优化：使用 `RepaintBoundary` 隔离重绘区域

**实现方式：**
```dart
// 渐变背景
decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE3F2FD), Color(0xFFE8EAF6)], // blue-50 to indigo-50
  ),
  borderRadius: BorderRadius.circular(32),
),

// 呼吸波纹（两个叠加的圆形）
AnimatedBuilder(
  animation: _pulseAnimation,
  builder: (context, child) {
    return Container(
      width: 128 * _pulseAnimation.value,
      height: 128 * _pulseAnimation.value,
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
    );
  },
)
```

### 2. 智能预测卡片：占位 UI，显示示例数据

**选择理由：**
- 让用户感知功能存在，增强期待感
- 后续只需替换数据源即可实现完整功能
- 不影响现有业务逻辑

**实现方式：**
```dart
// 固定显示一条示例预测
// 紫色渐变背景
decoration: BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFFF3E5F5), Color(0xFFFCE4EC)], // purple-50 to pink-50
  ),
  borderRadius: BorderRadius.circular(24),
),

// 占位内容
Column(
  children: [
    Row(children: [
      Icon(Sparkles, color: Colors.purple),
      Text('智能预测'),
    ]),
    Container(
      child: Row([
        // 时间圆圈
        CircleAvatar(child: Text('14:30')),
        // 预测内容
        Text('预计即将醒来'),
        Text('醒后可能会有便便哦'),
      ]),
    ),
  ],
)
```

### 3. 快捷操作台：固定在底部导航上方

**选择理由：**
- 符合单手操作习惯（拇指舒适区）
- 与底部导航栏视觉分离
- 不影响页面滚动

**实现方式：**
```dart
// 使用 Stack + Positioned 定位
Stack(
  children: [
    // 主内容区域
    SingleChildScrollView(...),

    // 快捷操作台
    Positioned(
      left: 0,
      right: 0,
      bottom: 80, // 底部导航高度
      child: _QuickActionBar(),
    ),
  ],
)

// 快捷操作台组件
Container(
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha: 0.9),
    borderRadius: BorderRadius.circular(32),
    boxShadow: [...],
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _ActionButton(label: '吃奶', icon: Icons.restaurant, color: Colors.green),
      _ActionButton(label: '玩耍', icon: Icons.sentiment_satisfied, color: Colors.yellow),
      _ActionButton(label: '睡眠', icon: Icons.nightlight, color: Colors.blue),
      _ActionButton(label: '便便', icon: Icons.water_drop, color: Colors.orange),
    ],
  ),
)
```

### 4. 顶部个人信息区：优化为一行展示

**选择理由：**
- 节省垂直空间
- 信息密度适中
- 符合原型设计

**实现方式：**
```dart
// 固定在顶部，半透明背景
Container(
  padding: EdgeInsets.only(top: 48, bottom: 16, left: 24, right: 24),
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha: 0.6),
    // 毛玻璃效果需要 backdrop_filter 包，暂时用半透明替代
  ),
  child: Row(
    children: [
      CircleAvatar(radius: 24, ...),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(babyName, style: titleMedium),
            Text('$ageString · ${weight}kg · ${height}cm', style: bodySmall),
          ],
        ),
      ),
      IconButton(onPressed: ..., icon: Icon(Icons.settings)),
    ],
  ),
)
```

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 智能预测占位数据可能误导用户 | 添加"示例数据"标签，或使用更明显的占位样式 |
| 快捷操作台可能与键盘冲突 | 弹窗时隐藏操作台，或调整布局 |
| 呼吸动效影响性能 | 使用 `RepaintBoundary` 隔离，限制动画帧率 |
| "便便"文案可能过于口语化 | 符合育儿场景，用户反馈可调整 |

**Trade-offs：**
- 使用占位 UI 而非完整功能：用户体验部分提升，但需后续完善
- 快捷按钮暂不实现弹窗：降低开发复杂度，但交互不完整
- 不使用真正的毛玻璃效果：避免引入额外依赖，用半透明替代