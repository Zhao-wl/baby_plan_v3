## 1. 添加响应式断点和间距常量

- [x] 1.1 在 `lib/theme/app_spacing.dart` 中添加断点常量（compact: 600, expanded: 840）
- [x] 1.2 在 `lib/theme/app_spacing.dart` 中添加弹窗最大宽度常量（medium: 600.0, expanded: 720.0）

## 2. 实现半屏弹窗响应式逻辑

- [x] 2.1 在 `_HalfScreenSheetContentState` 中添加 `_getBreakpoint()` 方法判断当前断点
- [x] 2.2 在 `_HalfScreenSheetContentState` 中添加 `_getSheetMaxWidth()` 方法获取弹窗最大宽度
- [x] 2.3 修改 `build()` 方法，使用 `Align` + `ConstrainedBox` 实现宽度限制和居中

## 3. 测试验证

- [x] 3.1 在 Chrome 开发者工具中测试不同设备宽度的弹窗表现
- [x] 3.2 验证窄屏设备（< 600px）弹窗占满宽度
- [x] 3.3 验证中屏设备（600-840px）弹窗最大宽度 600px 并居中
- [x] 3.4 验证宽屏设备（> 840px）弹窗最大宽度 720px 并居中