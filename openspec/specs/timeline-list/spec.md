## Purpose

时间轴列表组件，以纵向时间轴形式展示选定日期的所有活动记录，帮助用户直观了解宝宝一天的活动顺序。

## Requirements

### Requirement: 纵向时间轴列表展示

系统 SHALL 以纵向时间轴的形式展示选定日期的所有活动记录（包括进行中的活动），按时间顺序从上到下排列。

#### Scenario: 按时间排序显示
- **WHEN** 时间轴列表获取到活动记录数据
- **THEN** 系统 SHALL 按开始时间从早到晚排序显示
- **AND** 进行中的活动（status=0）和已完成的活动（status=1）都显示在列表中

#### Scenario: 进行中活动标记
- **WHEN** 时间轴列表中存在进行中的活动（status=0）
- **THEN** 系统 SHALL 为该活动显示"进行中"标签
- **AND** 显示实时已持续时间
- **AND** 活动节点显示呼吸动画效果

#### Scenario: 空状态显示
- **WHEN** 选中的日期没有活动记录
- **THEN** 系统 SHALL 显示空状态插图和引导文案（如"今天还没有记录，点击添加第一条记录"）

#### Scenario: 列表滚动加载
- **WHEN** 活动记录数量超过屏幕高度
- **THEN** 系统 SHALL 支持垂直滚动查看更多记录

### Requirement: 时间轴视觉样式

系统 SHALL 提供清晰的时间轴视觉指示，帮助用户理解活动的先后顺序。

#### Scenario: 绘制时间轴线
- **WHEN** 渲染时间轴列表
- **THEN** 系统 SHALL 在左侧绘制一条垂直的时间轴线

#### Scenario: 活动节点标记
- **WHEN** 渲染每个活动记录
- **THEN** 系统 SHALL 在时间轴线上以圆形节点标记该活动的开始时间点

#### Scenario: 节点颜色对应活动类型
- **WHEN** 渲染活动节点
- **THEN** 系统 SHALL 根据活动类型（E/A/S/P）显示对应的颜色
  - E (吃): 绿色 #4CAF50
  - A (玩): 黄色 #FFC107
  - S (睡): 蓝色 #2196F3
  - P (排泄): 橙色 #FF9800

### Requirement: 时间显示

系统 SHALL 清晰显示每个活动的发生时间。

#### Scenario: 显示开始时间
- **WHEN** 渲染活动记录
- **THEN** 系统 SHALL 显示该活动的开始时间（时:分格式）

#### Scenario: 跨天活动时间标注
- **WHEN** 活动跨越日期边界
- **THEN** 系统 SHALL 显示实际的开始或结束时间（如"昨天 23:00"）

### Requirement: 时间线进入时自动滚动到最新记录

系统 SHALL 在时间线页面进入时，自动滚动到列表底部，显示最新一条活动记录。

#### Scenario: 首次进入时间线页面
- **WHEN** 用户首次进入时间线页面且列表有数据
- **THEN** 系统 SHALL 自动滚动到列表底部，显示最新记录
- **AND** 滚动过程 SHALL 使用平滑动画效果

#### Scenario: 列表为空时不滚动
- **WHEN** 时间线页面进入但列表无活动记录
- **THEN** 系统 SHALL 不执行滚动操作

#### Scenario: 新增记录后自动滚动
- **WHEN** 用户在时间线页面新增一条活动记录
- **THEN** 系统 SHALL 自动滚动到新记录位置

### Requirement: 列表项删除动画

系统 SHALL 在删除活动记录时提供平滑的动画效果，确保用户体验流畅。

#### Scenario: 删除动画执行
- **WHEN** 用户确认删除一条活动记录
- **THEN** 系统 SHALL 执行删除动画
- **AND** 被删除的卡片 SHALL 以淡出+收缩动画消失
- **AND** 下方卡片 SHALL 平滑上移填补空白
- **AND** 动画时长 SHALL 在 250-350ms 范围内
- **AND** 动画曲线 SHALL 使用 easeInOut 或类似平滑曲线

#### Scenario: 上方卡片保持位置
- **WHEN** 删除动画执行过程中
- **THEN** 位于被删除项上方的卡片 SHALL 保持位置不变

#### Scenario: 动画完成后数据更新
- **WHEN** 删除动画完成
- **THEN** 系统 SHALL 更新数据源并从列表中移除该记录

#### Scenario: 滑动删除触发动画
- **WHEN** 用户在活动卡片上左滑并确认删除
- **THEN** 系统 SHALL 先收起滑动状态
- **AND** 然后执行删除动画

### Requirement: 删除操作完成后触发全局通知

系统 SHALL 在删除动画完成后触发全局数据变化通知，确保其他组件实时更新。

#### Scenario: 删除动画完成后通知
- **WHEN** 用户在时间线列表中删除一条活动记录
- **AND** 删除动画完成
- **AND** 数据库软删除操作成功
- **THEN** 系统 SHALL 触发 `activityDataChangeProvider` 通知
- **AND** 首页、统计页面等依赖组件实时刷新

#### Scenario: 删除失败不触发通知
- **WHEN** 数据库软删除操作失败
- **THEN** 系统 SHALL NOT 触发数据变化通知
- **AND** 显示错误提示
- **AND** 本地状态恢复（如果已更新）

### Requirement: 删除操作正确写入数据库

系统 SHALL 确保删除操作正确执行数据库软删除。

#### Scenario: 软删除成功
- **WHEN** 删除操作执行
- **THEN** 系统 SHALL 将记录的 `isDeleted` 设为 `true`
- **AND** 将 `deletedAt` 设为当前时间
- **AND** 将 `syncStatus` 设为 `1`（待上传）

#### Scenario: 已删除记录不在列表显示
- **WHEN** 时间线查询活动记录
- **THEN** 系统 SHALL 过滤掉 `isDeleted = true` 的记录
