## Why

当前半屏弹窗组件 `HalfScreenSheet` 仅支持下拉手势关闭，用户交互方式较为单一。为了提供更直观的关闭体验，需要增加点击遮罩区域关闭弹窗的功能，让用户可以通过点击弹窗外部区域快速关闭。

## What Changes

- 修改 `HalfScreenSheet` 组件的关闭行为：
  - 移除下拉拖拽关闭功能
  - 新增点击遮罩区域关闭弹窗功能
  - 保留有未保存数据时的二次确认机制

## Capabilities

### New Capabilities

（无 - 这是现有组件的行为调整）

### Modified Capabilities

（无 - 仅修改实现细节，不涉及 spec-level 需求变更）

## Impact

- **受影响文件**：
  - `lib/widgets/common/half_screen_sheet.dart` - 主要修改
- **使用方式**：`HalfScreenSheet.show()` 的 API 保持不变，现有调用代码无需修改
- **用户体验**：用户现在可以点击弹窗外部（遮罩区域）来关闭弹窗，而不是必须下拉
