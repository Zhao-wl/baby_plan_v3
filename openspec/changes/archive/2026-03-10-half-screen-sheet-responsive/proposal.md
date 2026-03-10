## Why

当前的半屏弹窗组件 (`HalfScreenSheet`) 使用固定尺寸（边距 24px、拖拽条 48px），在平板等宽屏设备上显示效果不佳。弹窗宽度没有上限限制，在大屏设备上会铺满整个屏幕，不符合 Material Design 的响应式设计原则，用户体验较差。

## What Changes

- 为半屏弹窗添加响应式宽度适配
- 定义断点系统，根据设备宽度自动调整弹窗最大宽度
- 在宽屏设备上居中显示弹窗，并添加最大宽度限制
- 调整弹窗内部间距，在大屏设备上适当增加内边距

## Capabilities

### New Capabilities

- `responsive-sheet`: 响应式半屏弹窗能力，根据设备宽度自适应弹窗尺寸和布局

### Modified Capabilities

- `spacing-radius`: 扩展间距规范，支持响应式断点相关的间距变量

## Impact

- **影响文件**: `lib/widgets/common/half_screen_sheet.dart`
- **可能新增**: `lib/core/responsive.dart` 或 `lib/theme/breakpoints.dart`（断点定义）
- **依赖**: 无新增外部依赖，使用 Flutter 内置的 `MediaQuery` 和 `LayoutBuilder`
- **兼容性**: 完全向后兼容，现有调用方式无需修改