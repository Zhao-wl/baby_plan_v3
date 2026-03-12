# time-slot-pattern Specification

## Purpose
定义时间段划分和分时段活动模式，为预测引擎提供时段感知的基础能力。

## Requirements

### Requirement: 系统提供时间段划分

系统 SHALL 将一天划分为 5 个固定时段，用于活动模式分析。

#### Scenario: 时段划分定义
- **WHEN** 系统需要确定活动所属时段
- **THEN** 系统使用以下时段划分
- **AND** 早晨(morning): 06:00-09:00
- **AND** 上午(forenoon): 09:00-12:00
- **AND** 下午(afternoon): 12:00-18:00
- **AND** 傍晚(evening): 18:00-22:00
- **AND** 夜间(night): 22:00-06:00

#### Scenario: 根据时间确定时段
- **WHEN** 当前时间为 14:30
- **THEN** 系统确定当前时段为下午(afternoon)

#### Scenario: 夜间跨日处理
- **WHEN** 当前时间为 23:00
- **THEN** 系统确定当前时段为夜间(night)
- **AND** 时段归属于当日

### Requirement: 系统提供分时段月龄基准数据

系统 SHALL 提供按周龄和时段划分的活动模式基准数据。

#### Scenario: 分时段基准数据查询
- **WHEN** 系统需要获取月龄基准数据
- **THEN** 系统根据宝宝周龄和时段查询对应的基准数据
- **AND** 基准数据包含：时段间隔、时段时长、时段每日次数

#### Scenario: 时段基准缺失时回退
- **WHEN** 指定时段没有基准数据
- **THEN** 系统使用该周龄的全局(global)基准数据

#### Scenario: 周龄缺失时向下取近
- **WHEN** 指定周龄没有基准数据
- **THEN** 系统使用小于该周龄的最大周龄数据

### Requirement: 系统提供睡眠阶段划分

系统 SHALL 基于"距离上次睡眠结束的时间"划分睡眠阶段。

#### Scenario: 睡眠阶段定义
- **WHEN** 系统需要确定宝宝的睡眠阶段
- **THEN** 系统使用以下阶段划分
- **AND** 刚醒期(awake-early): 距睡眠结束 0-2 小时
- **AND** 活动期(awake-mid): 距睡眠结束 2-4 小时
- **AND** 疲劳期(awake-late): 距睡眠结束 4+ 小时

#### Scenario: 根据时间确定睡眠阶段
- **WHEN** 宝宝最后一次睡眠于 10:00 结束
- **AND** 当前时间为 12:30
- **THEN** 系统确定当前睡眠阶段为活动期(awake-mid)

#### Scenario: 无睡眠数据时降级
- **WHEN** 宝宝没有已完成的睡眠记录
- **THEN** 系统不使用睡眠阶段维度
- **AND** 仅使用时段维度进行预测

### Requirement: 系统按时段分析历史数据

系统 SHALL 将历史活动数据按时段分组进行分析。

#### Scenario: 时段历史数据查询
- **WHEN** 系统需要分析历史活动模式
- **THEN** 系统查询最近 14 天的活动记录
- **AND** 按活动类型和时段分组统计

#### Scenario: 时段边界活动处理
- **WHEN** 活动时间距离时段边界 ±30 分钟
- **THEN** 该活动贡献权重 0.5 给相邻两个时段
- **AND** 贡献权重 1.0 给原时段

#### Scenario: 时段样本统计
- **WHEN** 系统计算时段历史模式
- **THEN** 返回时段平均间隔、时段平均时长、样本数量

### Requirement: 分时段基准数据加载

系统 SHALL 在首次启动时从 JSON 文件加载分时段月龄基准数据。

#### Scenario: JSON 数据格式
- **WHEN** 系统加载 age_activity_patterns.json
- **THEN** 数据格式包含 version 字段标识版本
- **AND** 每个模式包含 global 字段（全局基准）
- **AND** 每个模式包含 timeSlots 字段（分时段基准）

#### Scenario: 版本升级处理
- **WHEN** JSON 数据版本高于已加载版本
- **THEN** 系统更新数据库中的基准数据
- **AND** 保留 version 字段记录当前版本