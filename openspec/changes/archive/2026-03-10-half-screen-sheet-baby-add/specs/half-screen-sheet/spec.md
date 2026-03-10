## ADDED Requirements

### Requirement: 半屏弹窗动画
系统 SHALL 提供从下往上滑入的半屏弹窗动画，持续时间 300ms，使用 easeOutCubic 曲线。

#### Scenario: 打开弹窗时动画
- **WHEN** 调用 showHalfScreenSheet 方法
- **THEN** 弹窗从底部滑入，动画持续 300ms

#### Scenario: 关闭弹窗时动画
- **WHEN** 用户关闭弹窗（点击遮罩、下拉、或确认关闭）
- **THEN** 弹窗向下滑出，动画持续 300ms

---

### Requirement: 遮罩层交互
系统 SHALL 显示半透明模糊遮罩层，点击遮罩可关闭弹窗。

#### Scenario: 显示遮罩层
- **WHEN** 弹窗打开
- **THEN** 显示半透明深色遮罩层（透明度 40%）带模糊效果

#### Scenario: 点击遮罩关闭
- **WHEN** 用户点击遮罩区域
- **THEN** 触发关闭流程（可能触发二次确认）

---

### Requirement: 下拉关闭手势
系统 SHALL 支持用户通过下拉手势关闭弹窗。

#### Scenario: 下拉关闭
- **WHEN** 用户在弹窗顶部区域下拉超过阈值（100px）
- **THEN** 弹窗开始跟随手指移动，释放后关闭

#### Scenario: 下拉未达阈值
- **WHEN** 用户下拉但未超过阈值
- **THEN** 弹窗弹回原位

---

### Requirement: 数据变更检测
系统 SHALL 检测表单是否有未保存的数据变更。

#### Scenario: 检测到数据变更
- **WHEN** 用户在表单中输入了任何数据（姓名、性别、日期任一字段有值）
- **THEN** hasUnsavedChanges 返回 true

#### Scenario: 无数据变更
- **WHEN** 表单所有字段为空
- **THEN** hasUnsavedChanges 返回 false

---

### Requirement: 二次确认机制
当表单有未保存数据时，系统 SHALL 在关闭前显示确认对话框。

#### Scenario: 有数据时尝试关闭
- **WHEN** 用户在有未保存数据时尝试关闭（点击遮罩、下拉、点击关闭按钮）
- **THEN** 显示确认对话框，询问是否放弃

#### Scenario: 确认放弃
- **WHEN** 用户在确认对话框中点击"放弃"
- **THEN** 关闭弹窗，丢弃数据

#### Scenario: 继续编辑
- **WHEN** 用户在确认对话框中点击"继续编辑"
- **THEN** 关闭确认对话框，保持弹窗打开

---

### Requirement: 拖拽指示条
系统 SHALL 在弹窗顶部显示拖拽指示条。

#### Scenario: 显示指示条
- **WHEN** 弹窗打开
- **THEN** 顶部显示灰色圆角横条（宽 48px，高 6px，圆角 3px）

---

### Requirement: 弹窗样式规范
系统 SHALL 遵循统一的半屏弹窗样式规范。

#### Scenario: 顶部圆角
- **WHEN** 弹窗打开
- **THEN** 内容容器顶部圆角为 32px

#### Scenario: 内边距
- **WHEN** 弹窗打开
- **THEN** 内容区域内边距为水平 24px、顶部 24px、底部 48px