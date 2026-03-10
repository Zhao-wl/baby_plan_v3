## ADDED Requirements

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