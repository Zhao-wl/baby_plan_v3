## 1. 移除脉冲动画

- [x] 1.1 在 `lib/widgets/timeline/ongoing_activity_card.dart` 中移除 `_PulsingIcon` 组件
- [x] 1.2 将脉冲图标替换为静态图标容器，保持相同的视觉样式（48x48 圆形背景 + 居中图标）

## 2. 验证

- [x] 2.1 运行 `flutter analyze` 确保代码无错误
- [x] 2.2 在浏览器中验证进行中活动卡片显示正常，无动画效果