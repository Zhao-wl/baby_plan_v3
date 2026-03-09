## Context

当前应用底部导航栏包含 4 个页签：首页、时间线、统计、我的。导航状态通过 `NavigationProvider` 管理，使用 `NavTab` 枚举定义页签类型。每个页面使用 `StatefulWidget` + `AutomaticKeepAliveClientMixin` 保持页面状态。

**现有架构：**
- `NavTab` 枚举定义页签索引
- `NavigationState` 存储当前选中页签
- `MainPage` 使用 `IndexedStack` 管理页面切换
- `NavigationBar` 提供底部导航 UI

## Goals / Non-Goals

**Goals:**
- 在"统计"和"我的"之间插入"疫苗"页签
- 创建符合现有架构风格的 `VaccinePage` 骨架页面
- 保持页面状态保持（KeepAlive）特性

**Non-Goals:**
- 疫苗功能的具体实现（仅创建骨架页面）
- 数据库表结构变更
- Provider 业务逻辑实现

## Decisions

### 1. 页签位置选择

**决定：** 疫苗页签放在"统计"和"我的"之间（索引 3）

**理由：**
- 用户需求明确指定位置
- 疫苗属于健康管理功能，与"统计"（数据分析）相邻合理
- "我的"作为设置入口保持在最后

### 2. 页面组件设计

**决定：** 使用 `StatefulWidget` + `AutomaticKeepAliveClientMixin`

**理由：**
- 与现有页面（`StatsPage`、`TimelinePage`）保持一致
- KeepAlive 确保页面切换时状态不丢失
- 为后续功能扩展预留结构

### 3. 导航图标选择

**决定：** 使用 `Icons.vaccines_outlined` / `Icons.vaccines`

**理由：**
- Material Icons 提供了专门的疫苗图标
- 与现有图标风格一致（outlined/selected 双状态）

## Risks / Trade-offs

**风险：页签数量增加影响用户体验**
→ 缓解：5 个页签仍在可接受范围内，Material NavigationBar 支持自适应布局

**风险：枚举值变更可能影响现有代码**
→ 缓解：使用枚举名称而非硬编码索引，降低耦合