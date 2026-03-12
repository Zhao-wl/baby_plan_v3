## Context

时间线页面的活动卡片 (`TimelineActivityCard`) 使用 `Stack` 布局实现滑动删除功能。当前结构为：
- 底层：`Positioned.fill` + 删除按钮
- 上层：`AnimatedContainer` + 卡片内容

问题在于 `Positioned.fill` 会尝试填满 Stack 的整个空间，当上层内容高度计算与 Stack 高度不一致时，会导致溢出警告 `BOTTOM OVERFLOWED BY 2.0 PIXELS`。

## Goals / Non-Goals

**Goals:**
- 修复卡片布局溢出问题
- 确保滑动删除功能正常工作
- 保持现有视觉样式不变

**Non-Goals:**
- 不修改滑动删除的交互逻辑
- 不修改卡片的视觉设计
- 不影响其他组件

## Decisions

### 决策 1：移除 `Positioned.fill`，使用 `LayoutBuilder` + `ConstrainedBox`

**问题根源**：`Positioned.fill` 会强制子元素填满 Stack 的约束空间，但 Stack 的高度由上层 AnimatedContainer 决定，两者可能存在微小差异。

**解决方案**：将 `Positioned.fill` 改为普通的 `Positioned`，并使用 `ConstrainedBox` 确保删除按钮层的高度与卡片内容一致。

```dart
// 修改前
Positioned.fill(
  child: Container(...), // 删除按钮层
)

// 修改后
Positioned(
  top: 0,
  left: 0,
  right: 0,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: 0,
      maxHeight: _cardHeight, // 需要获取卡片高度
    ),
    child: Container(...), // 删除按钮层
  ),
)
```

**替代方案考虑**：
- 方案 A：使用 `Clip.hardEdge` 裁剪溢出 - 仅隐藏问题，不解决根本原因
- 方案 B：将删除按钮层移出 Stack - 会破坏滑动删除的视觉效果
- 方案 C（选择）：使用 `IntrinsicHeight` 让 Stack 高度自适应 - 会影响性能

### 决策 2：使用 `LayoutBuilder` 动态获取卡片高度

使用 `LayoutBuilder` 包裹上层卡片内容，获取实际高度后设置删除按钮层的高度约束。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 布局重建可能导致性能下降 | 仅在需要时重建，避免不必要的 setState |
| 高度计算可能仍有微小误差 | 使用 `Clip.hardEdge` 作为最终保障 |

## Migration Plan

1. 修改 `activity_card.dart` 文件
2. 测试各种卡片内容场景（短内容、长内容、有备注、无备注）
3. 测试滑动删除功能
4. 发布修复

## Open Questions

无。