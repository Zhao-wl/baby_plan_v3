# responsive-sheet

## Purpose

提供响应式半屏弹窗能力，根据设备宽度自动调整弹窗尺寸和布局，在大屏设备上优化显示效果。

**Status**: ✅ Implemented

---

## Requirements

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