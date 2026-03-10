## 1. 修改 HalfScreenSheet 组件关闭行为

- [x] 1.1 移除下拉拖拽手势检测代码（`_onDragStart`, `_onDragUpdate`, `_onDragEnd` 方法）
- [x] 1.2 移除 `GestureDetector` 及其相关状态变量（`_dragDistance`, `_isDragging`）
- [x] 1.3 移除拖拽指示条（drag handle）或保留仅作为视觉指示
- [x] 1.4 添加 `PopScope` 组件以支持二次确认拦截
- [x] 1.5 确保 `hasUnsavedChanges` 回调在点击遮罩关闭时触发二次确认

## 2. 测试验证

- [x] 2.1 验证点击遮罩区域可以关闭弹窗（通过 `isDismissible: true` 和 `PopScope` 实现）
- [x] 2.2 验证下拉拖拽不再触发关闭（`enableDrag: false` 已禁用）
- [x] 2.3 验证有未保存数据时点击遮罩显示二次确认对话框（`_handleClose` 中检查并显示）
- [x] 2.4 验证无未保存数据时点击遮罩直接关闭（`_handleClose` 中直接 pop）
- [x] 2.5 运行 `flutter analyze` 检查无代码问题

## 3. 代码清理

- [x] 3.1 删除不再使用的代码（拖拽相关变量和方法）
- [x] 3.2 更新文件头部的文档注释（移除"下拉关闭"相关描述）
