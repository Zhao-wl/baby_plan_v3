# dashboard-baby-card Specification (Delta)

## MODIFIED Requirements

### Requirement: 显示宝宝基本信息卡片

系统 SHALL 在首页显示当前选中宝宝的基本信息卡片，包含头像、姓名、月龄，当有正在进行的计时时显示计时状态。

#### Scenario: 正常显示宝宝信息
- **WHEN** 用户已选择一个宝宝
- **AND** 无正在进行的计时
- **THEN** 系统显示宝宝头像（或默认头像）、姓名、月龄

#### Scenario: 无宝宝时显示引导
- **WHEN** 用户未选择任何宝宝
- **THEN** 系统显示"添加宝宝"引导卡片

#### Scenario: 计时中显示计时状态
- **WHEN** 用户已选择一个宝宝
- **AND** 正在计时某活动
- **THEN** 系统在宝宝信息旁显示当前活动类型标签
- **AND** 显示已计时时长（如"睡眠 25:30"）
- **AND** 使用活动对应的主题色标识