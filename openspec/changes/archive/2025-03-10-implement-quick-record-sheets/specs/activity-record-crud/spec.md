## ADDED Requirements

### Requirement: 活动记录写入接口
系统 SHALL 提供统一的活动记录写入接口，支持新增任意类型的活动记录。

#### Scenario: 写入吃奶记录
- **WHEN** 调用写入接口传入吃奶类型的活动数据
- **THEN** 数据自动映射到`ActivityRecords`表的对应字段
- **AND** 返回新插入记录的ID

#### Scenario: 写入玩耍记录
- **WHEN** 调用写入接口传入玩耍类型的活动数据
- **THEN** 数据自动映射到`ActivityRecords`表的对应字段
- **AND** 返回新插入记录的ID

#### Scenario: 写入睡眠记录
- **WHEN** 调用写入接口传入睡眠类型的活动数据
- **THEN** 数据自动映射到`ActivityRecords`表的对应字段
- **AND** 返回新插入记录的ID

#### Scenario: 写入排泄记录
- **WHEN** 调用写入接口传入排泄类型的活动数据
- **THEN** 数据自动映射到`ActivityRecords`表的对应字段
- **AND** 返回新插入记录的ID

### Requirement: 数据合法性校验
写入接口 SHALL 在写入数据库前对数据进行合法性校验。

#### Scenario: 数据校验
- **WHEN** 传入的活动类型无效
- **THEN** 抛出异常，拒绝写入
- **WHEN** 传入的开始时间晚于结束时间
- **THEN** 抛出异常，拒绝写入
