## ADDED Requirements

### Requirement: 接种记录录入弹窗
系统 SHALL 提供底部弹窗用于录入接种记录。

#### Scenario: 弹窗触发
- **WHEN** 用户点击未完成疫苗的"记录"或"补录"按钮
- **THEN** 系统 SHALL 从底部弹出接种记录录入弹窗

#### Scenario: 弹窗标题显示疫苗名称
- **WHEN** 接种记录弹窗打开
- **THEN** 系统 SHALL 显示疫苗名称和剂次信息

#### Scenario: 关闭弹窗
- **WHEN** 用户点击弹窗外部区域或关闭按钮
- **THEN** 系统 SHALL 关闭弹窗，不保存数据

### Requirement: 接种日期选择
系统 SHALL 允许用户选择或修改接种日期。

#### Scenario: 默认日期
- **WHEN** 接种记录弹窗打开
- **THEN** 系统 SHALL 默认显示当天日期

#### Scenario: 修改日期
- **WHEN** 用户点击"修改"按钮
- **THEN** 系统 SHALL 允许用户选择其他日期

### Requirement: 接种部位快捷选择
系统 SHALL 提供接种部位的快捷选择按钮。

#### Scenario: 部位选项显示
- **WHEN** 接种记录弹窗打开
- **THEN** 系统 SHALL 显示左大腿、右大腿、左上臂、右上臂四个快捷按钮

#### Scenario: 部位选择状态
- **WHEN** 用户点击某个部位按钮
- **THEN** 系统 SHALL 高亮该按钮，取消其他按钮的高亮

#### Scenario: 部位保存
- **WHEN** 用户保存接种记录
- **THEN** 系统 SHALL 将选中的部位保存到接种记录

### Requirement: 接种反应标记
系统 SHALL 允许用户标记接种后的不良反应。

#### Scenario: 反应选项显示
- **WHEN** 接种记录弹窗打开
- **THEN** 系统 SHALL 显示常见反应标签：低烧、嗜睡、发热不退、接种处红肿

#### Scenario: 反应多选
- **WHEN** 用户点击一个或多个反应标签
- **THEN** 系统 SHALL 高亮所有选中的标签

#### Scenario: 反应保存
- **WHEN** 用户保存接种记录
- **THEN** 系统 SHALL 将选中的反应保存到接种记录

### Requirement: 疫苗批号录入
系统 SHALL 允许用户输入疫苗批号。

#### Scenario: 批号输入框
- **WHEN** 接种记录弹窗打开
- **THEN** 系统 SHALL 显示批号输入框，提示"可在此输入或扫码录入疫苗批号"

#### Scenario: 批号保存
- **WHEN** 用户输入批号并保存
- **THEN** 系统 SHALL 将批号保存到接种记录

### Requirement: 保存接种记录
系统 SHALL 允许用户保存接种记录。

#### Scenario: 保存成功
- **WHEN** 用户点击"保存接种记录"按钮
- **THEN** 系统 SHALL 保存接种记录，关闭弹窗，显示成功提示

#### Scenario: 记录状态更新
- **WHEN** 接种记录保存成功
- **THEN** 系统 SHALL 更新该疫苗状态为"已完成"

### Requirement: 已完成疫苗不可编辑
系统 SHALL 禁止编辑已完成的接种记录。

#### Scenario: 已完成疫苗点击无响应
- **WHEN** 用户点击已完成状态的疫苗卡片
- **THEN** 系统 SHALL 不打开编辑弹窗