## 1. 视觉风格调整

- [x] 1.1 更新 AppColors，添加淡化后的活动辅助色 (green-300, amber-300, blue-300, orange-300)
- [x] 1.2 删除 `lib/widgets/common/breathing_background.dart` 文件
- [x] 1.3 更新 SmartPredictionCard，移除紫粉渐变背景，改为白色背景 + Teal 强调色
- [x] 1.4 更新 QuickActionBar，移除悬浮样式背景，改为白色背景 + 浅灰边框

## 2. 计时器卡片重构

- [x] 2.1 移除 TimerCard 的固定高度 (`screenHeight * 0.28`)
- [x] 2.2 移除 TimerCard 的呼吸动画相关代码 (`_breathController`, `_breathAnimation`, `_buildBreathingRipples`)
- [x] 2.3 实现 TimerCard 内容自适应高度
- [x] 2.4 更新活动类型颜色为淡化色
- [ ] 2.5 测试不同屏幕尺寸下按钮不溢出

## 3. 首页布局重构

- [x] 3.1 重构 HomePage，移除 Stack + Positioned 布局
- [x] 3.2 调整模块顺序为：宝宝信息 → 智能预测 → 计时器 → 快捷按钮 → 最近记录
- [x] 3.3 将 QuickActionBar 从悬浮改为页面内嵌入
- [x] 3.4 调整各模块间距为 12px
- [ ] 3.5 验证一屏内可见核心模块

## 4. 成长记录入口

- [x] 4.1 创建 `lib/widgets/dashboard/growth_record_sheet.dart` 半屏弹窗组件
- [x] 4.2 实现身高和体重输入表单
- [x] 4.3 实现表单校验（至少填写一项）
- [x] 4.4 集成 growthRecordProvider 保存数据
- [x] 4.5 在 QuickActionBar 添加第五个"成长"按钮
- [x] 4.6 连接按钮点击与弹窗显示

## 5. 测试与验证

- [x] 5.1 在 Chrome 浏览器测试响应式布局
- [x] 5.2 测试长屏幕模拟器上计时器按钮不溢出
- [x] 5.3 测试成长记录保存功能
- [x] 5.4 运行 `flutter analyze` 确保无警告
- [ ] 5.5 验证深色模式下视觉正常（如已支持）