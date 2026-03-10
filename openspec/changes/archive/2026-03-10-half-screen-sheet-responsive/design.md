## Context

当前 `HalfScreenSheet` 组件使用固定尺寸，无法适应不同屏幕尺寸：
- 边距固定为 24px（左右、顶部）和 48px（底部）
- 拖拽指示条固定 48px 宽、6px 高
- 圆角固定 32px
- 弹窗宽度无上限，宽屏设备上铺满屏幕

Flutter 提供了 `MediaQuery` 和 `LayoutBuilder` 用于响应式设计，无需引入额外依赖。

## Goals / Non-Goals

**Goals:**
- 为半屏弹窗添加响应式宽度限制，宽屏设备上居中显示
- 定义简洁的断点系统，支持常见设备尺寸
- 保持现有 API 向后兼容

**Non-Goals:**
- 不实现全局响应式框架
- 不处理横竖屏切换的特殊布局
- 不改变弹窗高度逻辑（仍为屏幕 90% 最大高度）

## Decisions

### 决策 1：断点定义

**选择：** 使用 Material Design 推荐的断点值

| 断点 | 宽度范围 | 弹窗最大宽度 | 用途 |
|------|----------|--------------|------|
| compact | < 600px | 无限制 | 手机竖屏 |
| medium | 600-840px | 600px | 手机横屏/小平板 |
| expanded | > 840px | 720px | 平板 |

**备选方案：** 使用更细粒度的断点（如 480px, 720px, 960px）
**拒绝原因：** 过于复杂，Material Design 断点已覆盖主流设备

### 决策 2：实现位置

**选择：** 在 `HalfScreenSheet` 组件内部实现响应式逻辑，不创建独立的断点工具类

**备选方案：** 创建 `lib/core/responsive.dart` 提供全局断点工具
**拒绝原因：** 当前只有弹窗需要响应式，避免过度设计。后续如有多处使用再提取

### 决策 3：布局方式

**选择：** 使用 `Align` + `ConstrainedBox` 实现宽度限制和居中

```dart
Align(
  alignment: Alignment.bottomCenter,
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: sheetMaxWidth),
    child: // 弹窗内容
  ),
)
```

**备选方案：** 使用 `Center` 或 `FractionallySizedBox`
**拒绝原因：** `Align` + `ConstrainedBox` 更灵活，可以精确控制最大宽度

## Risks / Trade-offs

**[风险] 宽屏设备上弹窗可能显得过窄**
→ 缓解：将 expanded 断点最大宽度设为 720px，比 medium 的 600px 稍宽

**[风险] 现有弹窗内容可能需要调整以适应新宽度**
→ 缓解：最大宽度限制仅在宽屏生效，窄屏设备完全无影响