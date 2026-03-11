## Context

当前时间线页面 (`TimelinePage`) 展示宝宝的活动记录列表，用户需要从首页或其他入口进入才能新增记录。本设计将在时间线页面添加悬浮操作按钮 (FAB) 和对应的活动编辑界面，实现快速新增功能。

项目技术栈：Flutter + Riverpod + Drift (SQLite)

## Goals / Non-Goals

**Goals:**
- 在时间线页面右下角添加圆形 FAB 按钮（加号图标）
- 点击 FAB 弹出活动编辑界面（底部弹窗或独立页面）
- 编辑界面支持选择活动类型（吃/玩/睡/排泄）和设置时间
- 复用现有数据层，不修改数据库结构

**Non-Goals:**
- 不修改首页快捷按钮的现有行为
- 不添加"进行中"状态管理（由其他变更处理）
- 不实现复杂表单验证（使用基础验证）

## Decisions

### Decision 1: 使用底部弹窗 (BottomSheet) 而非新页面
**选择**: 使用 `showModalBottomSheet` 展示编辑表单
**理由**:
- 保持用户上下文（时间线页面仍可见）
- 更轻量的交互，适合快速录入
- 与 Flutter Material Design 规范一致
**替代方案**: 新页面 (`Navigator.push`) - 适用于复杂表单，但本场景较为简单

### Decision 2: FAB 位置和样式
**选择**: 右下角悬浮，圆形，主题色背景，白色加号图标
**理由**:
- 符合 Material Design FAB 规范
- 右下角落是 Flutter `Scaffold.floatingActionButton` 的默认位置
- 使用 `FloatingActionButton` 组件自带阴影和点击效果
**样式细节**:
- `mini: false` (标准大小)
- `elevation: 6.0`
- 图标: `Icons.add`

### Decision 3: 表单字段设计
**选择**: 分步表单 - 先选类型，再显示对应字段
**理由**:
- 不同活动类型的字段差异较大（喂养 vs 睡眠 vs 活动）
- 减少用户认知负担，一次只关注一个类型
- 复用首页快捷按钮的表单逻辑（如有）
**字段列表**:
- 所有类型: 活动类型选择器、开始时间、结束时间、备注
- 喂养(Eat): 喂养方式、奶量/时长、食物类型
- 睡眠(Sleep): 睡眠地点、入睡方式、睡眠质量
- 活动(Activity): 活动类型、情绪状态
- 排泄(Poop): 尿布类型、大便颜色、大便质地

### Decision 4: 时间选择器
**选择**: 使用 Flutter 内置 `showDatePicker` + `showTimePicker`
**理由**:
- 无需额外依赖
- 与系统 UI 风格一致
- 用户熟悉

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| 底部弹窗在横屏模式下显示空间不足 | 使用 `DraggableScrollableSheet` 或检测屏幕方向切换到全屏页面 |
| 表单字段过多导致弹窗过高 | 使用 `SingleChildScrollView` 包装，确保可滚动 |
| 与首页快捷按钮表单逻辑重复 | 提取共用表单组件到 `lib/widgets/activity_form.dart` |

## Migration Plan

无需数据迁移，本变更仅涉及 UI 层新增。

部署步骤:
1. 新增 `ActivityFormWidget` 组件
2. 修改 `TimelinePage` 添加 FAB
3. 测试所有活动类型的表单提交

## Open Questions

无
