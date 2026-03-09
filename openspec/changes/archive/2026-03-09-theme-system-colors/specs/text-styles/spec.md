## ADDED Requirements

### Requirement: 文本样式层级定义

系统 SHALL 定义三级文本样式层级，确保视觉一致性。

**层级定义：**
| 层级 | 名称 | 用途 | 字重 |
|-----|------|------|------|
| H1 | displayLarge | 页面标题 | Bold (w700) |
| H2 | headlineMedium | 卡片标题 | SemiBold (w600) |
| H3 | titleMedium | 列表项标题 | Medium (w500) |
| Body | bodyMedium | 正文内容 | Regular (w400) |
| Caption | bodySmall | 辅助说明 | Regular (w400) |
| Label | labelMedium | 标签、按钮 | Medium (w500) |

#### Scenario: 标题样式使用
- **WHEN** 显示页面标题
- **THEN** 系统 SHALL 使用 `TextStyles.h1` 或 `Theme.of(context).textTheme.displayLarge`

#### Scenario: 正文样式使用
- **WHEN** 显示正文内容
- **THEN** 系统 SHALL 使用 `TextStyles.body` 或 `Theme.of(context).textTheme.bodyMedium`

---

### Requirement: 字体大小规范

系统 SHALL 定义标准字体大小。

**字体大小：**
| 名称 | 大小 | 用途 |
|-----|------|------|
| xs | 10.0 | 极小标签 |
| sm | 12.0 | 辅助文字、Caption |
| base | 14.0 | 正文 |
| md | 16.0 | 小标题 |
| lg | 18.0 | 卡片标题 |
| xl | 22.0 | 页面标题 |
| xxl | 28.0 | 大标题 |

#### Scenario: 字体大小一致性
- **WHEN** 使用文本样式
- **THEN** 所有文本 SHALL 使用预定义的字体大小，避免硬编码

---

### Requirement: 行高规范

系统 SHALL 定义标准行高比例。

**行高比例：**
- 标题类：1.2 倍行高
- 正文类：1.5 倍行高
- 多行文本：1.6 倍行高

#### Scenario: 多行文本可读性
- **WHEN** 显示多行正文
- **THEN** 系统 SHALL 使用 1.5-1.6 倍行高，确保可读性