## Context

当前 `HalfScreenSheet` 组件使用 `showModalBottomSheet` 显示半屏弹窗，并通过内部的 `GestureDetector` 实现下拉拖拽关闭功能。用户反馈希望改为点击遮罩区域关闭，这更符合常见的弹窗交互模式。

**当前实现**：
- 使用 `GestureDetector` 监听垂直拖拽手势
- 拖拽超过阈值（100px）时触发关闭
- 支持有未保存数据时的二次确认

## Goals / Non-Goals

**Goals:**
- 实现点击遮罩区域关闭弹窗
- 移除下拉拖拽关闭功能
- 保留未保存数据检测和二次确认机制

**Non-Goals:**
- 不修改弹窗内容区域的交互
- 不改变动画效果和样式
- 不修改 `HalfScreenSheet.show()` API

## Decisions

### 使用 `showModalBottomSheet` 的 `barrierDismissible` 参数

**决策**: 将 `showModalBottomSheet` 的 `isDismissible` 参数设为 `true`（或保持默认），并移除内部的下拉手势检测。

**理由**:
- Flutter 的 `showModalBottomSheet` 原生支持点击遮罩关闭（通过 `barrierDismissible` 参数控制）
- 无需自定义遮罩层点击检测逻辑
- 保持代码简洁，利用框架内置功能

**替代方案考虑**:
- 自定义 `ModalBarrier` 并监听点击事件 - 过于复杂，不必要
- 在 `GestureDetector` 中添加点击检测 - 需要处理手势冲突，增加复杂度

### 保留二次确认机制

**决策**: 继续支持 `hasUnsavedChanges` 回调和二次确认对话框。

**理由**:
- 用户体验一致：无论何种关闭方式，都应在有未保存数据时提示确认
- `showModalBottomSheet` 支持通过 `willPopCallback` 或类似的机制拦截关闭

**实现方式**:
- 使用 `PopScope` widget 包裹内容区域
- 在 `onPopInvoked` 中检查未保存数据状态
- 如需确认则显示对话框，阻止立即关闭

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|----------|
| 用户习惯改变：原习惯下拉关闭的用户需要适应新方式 | 这是预期内的改变，点击遮罩是更普遍的交互模式 |
| `PopScope` 与 `showModalBottomSheet` 的兼容性 | 测试确认 Flutter 3.x 版本支持良好 |

## Migration Plan

**无需迁移** - 这是纯内部实现变更，API 完全兼容，所有现有调用代码无需修改。

**验证步骤**:
1. 打开任意使用 `HalfScreenSheet.show()` 的弹窗
2. 点击弹窗外部区域，确认弹窗关闭
3. 填写数据后点击外部区域，确认显示二次确认对话框
4. 确认下拉拖拽不再触发关闭
