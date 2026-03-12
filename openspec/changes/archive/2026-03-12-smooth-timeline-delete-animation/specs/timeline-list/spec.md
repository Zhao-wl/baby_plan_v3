## MODIFIED Requirements

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