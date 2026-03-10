## Context

当前应用需要为用户提供便捷的宝宝数据录入入口。参考 `docs/原型界面设计/账号与家庭管理页原型.md` 中的邀请成员弹窗设计，我们将实现一个可复用的半屏弹窗组件，并基于此构建宝宝添加功能。

### 技术约束

- Flutter 框架，使用 Material Design 3
- 状态管理：Riverpod
- 已有的主题系统和设计规范

## Goals / Non-Goals

**Goals:**
- 创建可复用的半屏弹窗通用组件，支持动画、手势、数据变更检测
- 实现"宝宝管理"入口和快速添加宝宝表单
- 建立半屏弹窗的 UI 规范，供后续功能复用

**Non-Goals:**
- 不实现宝宝编辑功能（仅新增）
- 不实现宝宝列表管理界面
- 不实现头像上传功能

## Decisions

### 1. 半屏弹窗实现方式

**选择**: 使用 `showModalBottomSheet` + `isScrollControlled: true`

**理由**:
- Flutter 内置组件，稳定可靠
- 自动处理手势关闭、键盘弹出等边界情况
- 可通过 `constraints` 控制高度

**替代方案**:
- `DraggableScrollableSheet`: 更灵活，但实现复杂度高，当前需求不需要动态调整高度
- 自定义 Route: 完全可控，但工作量过大

### 2. 数据变更检测策略

**选择**: 简单比较策略 - 检测是否有任何输入

```dart
bool hasUnsavedChanges() {
  return _nameController.text.isNotEmpty ||
         _selectedGender != null ||
         _selectedDate != null;
}
```

**理由**: 对于"添加"场景，只需检测是否有输入，不需要与初始值比较

### 3. 二次确认对话框

**选择**: 使用 `AlertDialog` 确认放弃

**内容设计**:
- 标题: "放弃添加？"
- 正文: "您已填写了部分信息，关闭后将丢失这些数据。"
- 按钮: [继续编辑] [放弃]

### 4. 弹窗高度

**选择**: 自适应高度（wrap content）

**理由**: 表单内容固定且不多，不需要滚动，自适应高度确保刚好包住内容

### 5. 动画实现

**选择**: 使用 `showModalBottomSheet` 默认动画 + 自定义 `AnimationController` 微调

**动画参数**:
- 持续时间: 300ms
- 曲线: `Curves.easeOutCubic` (cubic-bezier(0.16, 1, 0.3, 1) 近似)

## Risks / Trade-offs

### Risk: 键盘弹出可能遮挡表单
**缓解**: 使用 `isScrollControlled: true` + `padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom)` 自动调整

### Risk: 不同设备屏幕尺寸差异
**缓解**: 自适应高度策略 + 设置最大高度限制

### Trade-off: 不支持编辑功能
**说明**: 本次仅实现新增，后续可通过扩展组件支持编辑场景