## ADDED Requirements

### Requirement: 圆角规范

系统 SHALL 定义标准圆角尺寸。

**圆角定义：**
| 名称 | 大小 | 用途 |
|-----|------|------|
| xs | 4.0 | 小元素、标签 |
| sm | 8.0 | 按钮、输入框 |
| md | 12.0 | 列表项 |
| lg | 16.0 | 大按钮、弹窗 |
| xl | 24.0 | 卡片、底部弹窗 |
| xxl | 32.0 | 大卡片、计时器卡片 |
| full | 9999.0 | 圆形头像、悬浮按钮 |

#### Scenario: 卡片圆角一致性
- **WHEN** 使用卡片组件
- **THEN** 系统 SHALL 使用 `AppSpacing.radiusXl`（24px）圆角

#### Scenario: 按钮圆角一致性
- **WHEN** 使用按钮组件
- **THEN** 系统 SHALL 使用 `AppSpacing.radiusLg`（16px）圆角

---

### Requirement: 间距规范

系统 SHALL 定义标准间距尺寸。

**间距定义：**
| 名称 | 大小 | 用途 |
|-----|------|------|
| xs | 4.0 | 紧凑元素间距 |
| sm | 8.0 | 相关元素间距 |
| md | 16.0 | 标准内边距 |
| lg | 24.0 | 卡片内边距 |
| xl | 32.0 | 区块间距 |
| xxl | 48.0 | 页面边距 |

#### Scenario: 页面内边距
- **WHEN** 布局页面内容
- **THEN** 系统 SHALL 使用 `AppSpacing.paddingMd`（16px）作为水平内边距

#### Scenario: 卡片内边距
- **WHEN** 布局卡片内容
- **THEN** 系统 SHALL 使用 `AppSpacing.paddingLg`（24px）作为内边距

---

### Requirement: 图标尺寸规范

系统 SHALL 定义标准图标尺寸。

**图标尺寸：**
| 名称 | 大小 | 用途 |
|-----|------|------|
| sm | 16.0 | 行内图标 |
| md | 20.0 | 列表图标 |
| lg | 24.0 | 导航图标、按钮图标 |
| xl | 32.0 | 强调图标 |
| xxl | 48.0 | 空状态图标 |

#### Scenario: 导航图标尺寸
- **WHEN** 使用底部导航栏图标
- **THEN** 系统 SHALL 使用 `AppSpacing.iconLg`（24px）尺寸

---

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

### Requirement: 响应式间距变量
系统 SHALL 定义响应式断点相关的间距辅助变量。

**响应式间距：**
| 变量名 | 用途 |
|--------|------|
| sheetMaxWidthCompact | 窄屏弹窗最大宽度（null，无限制）|
| sheetMaxWidthMedium | 中屏弹窗最大宽度（600.0）|
| sheetMaxWidthExpanded | 宽屏弹窗最大宽度（720.0）|

#### Scenario: 获取弹窗最大宽度
- **WHEN** 系统需要根据断点获取弹窗最大宽度
- **THEN** 系统 SHALL 返回对应断点的最大宽度值