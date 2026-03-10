## ADDED Requirements

### Requirement: 响应式断点系统

系统 SHALL 定义响应式断点用于适配不同屏幕尺寸。

**断点定义：**
| 名称 | 宽度范围 | 说明 |
|------|----------|------|
| compact | < 600px | 手机竖屏 |
| medium | 600-840px | 手机横屏/小平板 |
| expanded | > 840px | 平板 |

#### Scenario: 判断当前断点
- **WHEN** 系统需要判断当前设备属于哪个断点
- **THEN** 系统 SHALL 根据屏幕宽度返回对应的断点名称

---

### Requirement: 半屏弹窗响应式宽度

系统 SHALL 根据设备断点自动调整半屏弹窗的最大宽度。

**宽度规则：**
| 断点 | 弹窗最大宽度 |
|------|--------------|
| compact | 无限制（100% 屏幕宽度）|
| medium | 600px |
| expanded | 720px |

#### Scenario: 窄屏设备显示弹窗
- **WHEN** 设备宽度 < 600px
- **THEN** 弹窗 SHALL 占满屏幕宽度

#### Scenario: 中等宽度设备显示弹窗
- **WHEN** 设备宽度在 600-840px 之间
- **THEN** 弹窗 SHALL 最大宽度限制为 600px 并水平居中

#### Scenario: 宽屏设备显示弹窗
- **WHEN** 设备宽度 > 840px
- **THEN** 弹窗 SHALL 最大宽度限制为 720px 并水平居中

---

### Requirement: 半屏弹窗布局居中

系统 SHALL 在宽屏设备上水平居中显示弹窗。

#### Scenario: 宽屏设备弹窗居中
- **WHEN** 弹窗有最大宽度限制时
- **THEN** 弹窗 SHALL 水平居中对齐