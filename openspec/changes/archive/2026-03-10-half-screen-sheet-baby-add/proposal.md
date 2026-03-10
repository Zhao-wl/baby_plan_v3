## Why

当前应用缺少便捷的宝宝数据录入入口。用户需要快速添加宝宝信息，但现有的交互方式不够流畅。同时，项目中已有"半屏弹窗"的设计原型（邀请成员弹窗），但没有通用组件，导致每次实现类似功能都需要重复编写。

本变更旨在：
1. 创建可复用的半屏弹窗通用组件，建立 UI 规范
2. 实现"宝宝管理"入口和快速添加宝宝功能

## What Changes

- **新增通用组件**: `HalfScreenSheet` - 可复用的半屏弹窗组件
  - 从下往上滑入动画
  - 遮罩层（半透明 + 模糊）
  - 支持下拉关闭手势
  - 数据变更检测 + 二次确认机制

- **新增功能**: "我的"页面添加"宝宝管理"菜单项
  - 点击弹出半屏表单
  - 表单字段：姓名、性别、出生日期（最小化字段）
  - 表单验证和保存逻辑

## Capabilities

### New Capabilities

- `half-screen-sheet`: 半屏弹窗通用组件，支持动画、手势关闭、数据变更检测、二次确认等功能
- `baby-quick-add`: 宝宝快速添加功能，包含表单 UI 和数据保存逻辑

### Modified Capabilities

- `profile-page`: "我的"页面新增"宝宝管理"菜单入口

## Impact

- **新增文件**:
  - `lib/widgets/common/half_screen_sheet.dart` - 通用半屏弹窗组件
  - `lib/widgets/profile/baby_add_sheet.dart` - 宝宝添加表单弹窗

- **修改文件**:
  - `lib/pages/profile_page.dart` - 添加"宝宝管理"菜单项
  - `lib/providers/babies_provider.dart` - 可能需要添加新增宝宝的方法

- **参考原型**: `docs/原型界面设计/账号与家庭管理页原型.md` 中邀请成员弹窗设计