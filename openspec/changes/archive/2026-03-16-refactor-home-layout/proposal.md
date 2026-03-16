# 首页布局与视觉风格重构

## Why

当前首页存在三个核心问题：
1. **悬浮按钮遮挡内容** - QuickActionBar 悬浮在底部导航上方，导致最近记录内容被遮挡
2. **长屏幕适配问题** - 计时器使用屏幕高度百分比布局，在长屏幕手机上开始计时后按钮区域超框
3. **视觉风格过于花哨** - 多处使用渐变背景和呼吸动画，颜色过于丰富，分散用户注意力

## What Changes

- **布局重构**：将 QuickActionBar 从悬浮改为页面内嵌入，调整模块顺序为 宝宝信息 → 智能预测 → 计时器 → 快捷按钮 → 最近记录
- **计时器适配**：移除固定高度百分比，改为内容自适应高度，确保控制按钮在任何屏幕尺寸下不溢出
- **视觉简化**：取消渐变背景和呼吸动画，颜色回归朴素（方案 B：保留品牌 Teal 色作为主强调色，活动类型色淡化为辅助色）
- **功能新增**：快捷按钮新增"成长"入口，点击弹出半屏 Sheet 输入身高/体重
- **高度压缩**：确保核心模块（宝宝信息、智能预测、计时器、快捷按钮）在一屏内显示，最近记录可部分可见

## Capabilities

### New Capabilities

- `growth-quick-entry`：快捷记录成长数据（身高/体重）入口，点击弹出半屏表单

### Modified Capabilities

- `quick-action-bar`：从悬浮布局改为页面内嵌入，新增成长入口按钮，调整定位要求
- `timer-ui`：移除固定高度百分比要求，移除呼吸动画要求，改为内容自适应高度
- `smart-prediction-card`：移除紫粉渐变背景要求，改为朴素白色背景
- `breathing-animation`：**BREAKING** 移除该组件，不再使用呼吸动画

## Impact

### 直接影响的文件

| 文件 | 变更类型 |
|------|----------|
| `lib/pages/home_page.dart` | 重构布局结构，移除 Stack + Positioned |
| `lib/widgets/dashboard/timer_card.dart` | 移除固定高度，移除呼吸动画 |
| `lib/widgets/dashboard/quick_action_bar.dart` | 移除悬浮样式，新增成长按钮 |
| `lib/widgets/dashboard/smart_prediction_card.dart` | 移除渐变背景 |
| `lib/widgets/common/breathing_background.dart` | 删除文件 |

### 新增文件

| 文件 | 用途 |
|------|------|
| `lib/widgets/dashboard/growth_record_sheet.dart` | 成长记录半屏弹窗 |

### 依赖影响

- `theme-colors`：可能需要新增淡化后的活动辅助色
- `half-screen-sheet`：成长记录弹窗复用现有的半屏 Sheet 组件