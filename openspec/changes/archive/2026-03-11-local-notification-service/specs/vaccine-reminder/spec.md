## ADDED Requirements

### Requirement: 疫苗计划自动生成
系统 SHALL 在创建宝宝时自动生成完整的疫苗计划，基于宝宝出生日期和国家免疫规划疫苗库。

#### Scenario: 创建宝宝时生成计划
- **WHEN** 用户添加新宝宝并填写出生日期
- **THEN** 系统 SHALL 根据出生日期和疫苗库数据生成所有待接种记录
- **AND** 每条记录 SHALL 包含疫苗名称、推荐接种日期、剂次信息

#### Scenario: 疫苗计划完整性
- **WHEN** 生成疫苗计划
- **THEN** 计划 SHALL 包含国家免疫规划一类疫苗（免费）
- **AND** 每种疫苗的各剂次 SHALL 按推荐年龄正确计算日期

#### Scenario: 计算接种日期
- **WHEN** 疫苗库中疫苗的推荐年龄为 N 天
- **THEN** 推荐接种日期 SHALL 为宝宝出生日期 + N 天
- **AND** 如有最小间隔要求，系统 SHALL 根据上一剂日期计算

### Requirement: 疫苗接种提醒调度
系统 SHALL 在疫苗推荐接种日期前 3 天发送提醒通知。

#### Scenario: 调度提醒通知
- **WHEN** 生成疫苗计划时
- **THEN** 系统 SHALL 为每剂疫苗调度提前 3 天的提醒通知
- **AND** 通知时间 SHALL 默认为上午 9:00

#### Scenario: 提醒通知内容
- **WHEN** 发送疫苗提醒通知
- **THEN** 通知标题 SHALL 为 "疫苗接种提醒"
- **AND** 通知内容 SHALL 包含疫苗名称、剂次和接种日期
- **AND** 点击通知 SHALL 跳转到疫苗详情页

#### Scenario: 已接种记录跳过提醒
- **WHEN** 某剂疫苗已标记为已接种
- **THEN** 系统 SHALL 取消该剂的提醒通知
- **AND** 不再发送该剂的提醒

#### Scenario: 推迟接种处理
- **WHEN** 用户推迟某剂疫苗
- **THEN** 系统 SHALL 取消原提醒
- **AND** 系统 SHALL 根据新的预约日期重新调度提醒

### Requirement: 提醒状态管理
系统 SHALL 提供疫苗提醒状态管理功能，支持查看和管理已计划的提醒。

#### Scenario: 查看待提醒疫苗
- **WHEN** 用户查看疫苗提醒列表
- **THEN** 系统 SHALL 显示所有未发送的待发送提醒
- **AND** 每条提醒 SHALL 显示疫苗名称、提醒时间、状态

#### Scenario: 手动开关提醒
- **WHEN** 用户关闭某剂疫苗的提醒
- **THEN** 系统 SHALL 取消该提醒通知
- **AND** 该剂疫苗标记为"提醒已关闭"

#### Scenario: 重新开启提醒
- **WHEN** 用户重新开启已关闭的提醒
- **THEN** 系统 SHALL 重新调度提醒通知
- **AND** 如果已过提醒时间，系统 SHALL 提示用户

### Requirement: 逾期疫苗特殊处理
系统 SHALL 对逾期未接种的疫苗提供特殊提醒。

#### Scenario: 逾期检测
- **WHEN** 当前日期超过推荐接种日期
- **AND** 该剂疫苗尚未接种
- **THEN** 系统 SHALL 标记该剂疫苗为"已逾期"
- **AND** 系统 SHALL 在次日发送逾期提醒

#### Scenario: 逾期提醒内容
- **WHEN** 发送逾期提醒
- **THEN** 通知内容 SHALL 强调"已逾期"
- **AND** 通知 SHALL 建议尽快安排接种