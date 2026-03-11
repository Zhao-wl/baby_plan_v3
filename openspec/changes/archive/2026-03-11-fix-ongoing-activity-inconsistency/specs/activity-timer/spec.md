## ADDED Requirements

### Requirement: 长按快捷按钮启动计时器

系统 SHALL 在用户长按快捷按钮时先启动计时器，再弹出详情编辑表单。

#### Scenario: 长按启动计时器
- **WHEN** 用户长按快捷按钮超过 500ms
- **AND** 当前没有其他进行中活动
- **THEN** 系统 SHALL 调用 timerProvider.start() 启动计时器
- **AND** 创建草稿记录（status=0）
- **AND** 弹出详情编辑表单
- **AND** 表单预填充活动类型和开始时间

#### Scenario: 长按时已有进行中活动
- **WHEN** 用户长按快捷按钮
- **AND** 已存在其他进行中活动
- **THEN** 系统 SHALL 显示提示"请先结束当前进行中的活动"
- **AND** 不启动新计时器

#### Scenario: 长按后取消编辑
- **WHEN** 用户在详情编辑表单中点击取消
- **THEN** 系统 SHALL 调用 timerProvider.cancel() 取消计时
- **AND** 删除草稿记录
- **AND** 关闭表单

#### Scenario: 长按后保存详情
- **WHEN** 用户在详情编辑表单中编辑并保存
- **THEN** 系统 SHALL 更新草稿记录的活动详情
- **AND** 计时器保持运行状态
- **AND** 关闭表单