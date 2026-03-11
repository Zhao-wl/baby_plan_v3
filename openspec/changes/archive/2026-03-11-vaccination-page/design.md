## Context

当前项目已完成基础数据层建设：
- `VaccineLibrary` 表和 `vaccine_library.json` 已就绪，包含 18 种国家免疫规划疫苗
- `VaccineRecords` 表已定义，支持接种记录存储
- 现有架构使用 Riverpod 状态管理、Drift ORM、HalfScreenSheet 半屏弹窗组件

本次变更需要补全数据加载逻辑，并实现完整的 UI 层。

## Goals / Non-Goals

**Goals:**
- 实现按月龄分组的疫苗计划展示，支持时间轴可视化
- 实现 4 种疫苗状态的显示（已完成/已逾期/近期计划/待接种）
- 实现接种记录快捷录入弹窗，减少键盘输入
- 实现免疫盾概览卡片，显示保护数量和逾期预警
- 实现疫苗数据 Provider，支持数据加载和状态计算

**Non-Goals:**
- 疫苗接种提醒通知（任务 3.7）
- 疫苗计划自动生成（任务 3.7.1）
- 云同步功能

## Decisions

### 1. 数据分组方式：按月龄分组

**选择**: 按月龄分组（出生时、1月龄、2月龄...）

**理由**:
- 符合国家免疫规划的表达方式
- 家长更容易理解"宝宝这个月该打什么疫苗"
- 原型设计采用此方式

**替代方案**: 按疫苗类型分组（乙肝疫苗系列、脊灰疫苗系列...）
- **放弃原因**: 不符合用户心智模型，难以追踪接种进度

### 2. 状态计算逻辑

**选择**: 基于宝宝月龄 + 疫苗推荐年龄 + 接种记录计算状态

```
状态计算规则：
1. 有接种记录 (status=completed) → 已完成 ✓
2. 宝宝年龄 < 推荐年龄 - 7天 → 待接种（灰色）
3. 宝宝年龄 >= 推荐年龄 - 7天 且 < 推荐年龄 + 30天 → 近期计划（黄色）
4. 宝宝年龄 >= 推荐年龄 + 30天 → 已逾期（红色）
```

**理由**:
- 7 天提前量让家长有准备时间
- 30 天宽限期避免频繁逾期提示

### 3. Provider 设计

**选择**: 创建 `VaccineProvider` 统一管理疫苗数据

```dart
// 核心数据结构
class VaccineScheduleItem {
  final VaccineLibrary vaccine;      // 疫苗库信息
  final VaccineRecord? record;       // 接种记录（如有）
  final VaccineDisplayStatus status; // 显示状态
  final String ageGroup;             // 月龄分组
}

enum VaccineDisplayStatus { done, overdue, upcoming, pending }
```

**数据流**:
```
VaccineLibrary (JSON) → Database → VaccineProvider → UI
                              ↑
                        VaccineRecords
```

### 4. UI 组件拆分

**选择**: 按职责拆分为 4 个组件

| 组件 | 职责 |
|------|------|
| `ImmunityShieldCard` | 顶部概览卡片，显示保护数量和逾期预警 |
| `VaccineGroupCard` | 月龄分组容器，包含标题和疫苗列表 |
| `VaccineItemCard` | 单个疫苗卡片，显示名称、状态、操作按钮 |
| `VaccineRecordSheet` | 接种记录录入弹窗 |

**理由**: 单一职责，便于测试和复用

## Risks / Trade-offs

### 风险 1: 疫苗库数据加载时机
**风险**: 应用首次启动时疫苗库为空，需要从 JSON 加载数据
**缓解**: 在 Provider 初始化时检测并加载，使用 `FutureProvider` 处理异步

### 风险 2: 状态计算性能
**风险**: 每次打开页面需要计算所有疫苗状态
**缓解**:
- 疫苗数量有限（约 20 种），性能可接受
- 使用 `select` 缓存计算结果

### 风险 3: 月龄分组边界
**风险**: 同一种疫苗的不同剂次可能属于不同月龄分组
**缓解**: 每条疫苗库记录独立，按 `recommendedAgeDays` 分组即可