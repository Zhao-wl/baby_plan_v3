## ADDED Requirements

### Requirement: E.A.S.Y 活动颜色定义

系统 SHALL 定义 E.A.S.Y 四种活动类型的专属颜色，代表各自的语义含义。

**颜色定义：**
| 活动类型 | 颜色名称 | 十六进制值 | 语义含义 |
|---------|---------|-----------|---------|
| E (Eat) | eat | #4CAF50 | 成长与能量 |
| A (Activity) | activity | #FFC107 | 活力与阳光 |
| S (Sleep) | sleep | #2196F3 | 沉静与修复 |
| P (Poop) | poop | #FF9800 | 排泄记录 |

**辅助颜色：**
- eatLight: #E8F5E9（绿色浅底）
- activityLight: #FFF8E1（黄色浅底）
- sleepLight: #E3F2FD（蓝色浅底）
- poopLight: #FFF3E0（橙色浅底）

#### Scenario: 活动颜色访问
- **WHEN** 开发者在代码中引用活动颜色
- **THEN** 系统 SHALL 通过 `AppColors.eat`、`AppColors.activity`、`AppColors.sleep`、`AppColors.poop` 访问对应颜色

#### Scenario: 浅色背景使用
- **WHEN** 需要活动类型的浅色背景
- **THEN** 系统 SHALL 提供对应的 Light 变体颜色（如 `AppColors.eatLight`）

---

### Requirement: 主色调定义

系统 SHALL 定义应用主色调（Teal）及完整的调色板。

**主色调：**
| 名称 | 十六进制值 | 用途 |
|-----|-----------|------|
| primary | #009688 | 主按钮、导航选中、强调元素 |
| primaryLight | #B2DFDB | 主色浅底 |
| primaryDark | #00796B | 主色深色变体 |

**中性色：**
| 名称 | 十六进制值 | 用途 |
|-----|-----------|------|
| background | #FAFAFA | 页面背景 |
| surface | #FFFFFF | 卡片背景 |
| onBackground | #1C1B1F | 背景上的文字 |
| onSurface | #1C1B1F | 表面上的文字 |
| outline | #79747E | 边框、分割线 |

#### Scenario: Material 3 调色板生成
- **WHEN** 创建 ThemeData
- **THEN** 系统 SHALL 使用 `ColorScheme.fromSeed(seedColor: primary)` 自动生成完整的 Material 3 调色板

#### Scenario: 主色调访问
- **WHEN** 开发者在代码中引用主色调
- **THEN** 系统 SHALL 通过 `AppColors.primary` 访问主色