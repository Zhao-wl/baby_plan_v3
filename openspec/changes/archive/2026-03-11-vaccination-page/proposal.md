## Why

家长需要一个直观的方式来追踪宝宝的疫苗接种进度。当前国家免疫规划疫苗种类繁多、接种时间分散，家长难以记住每种疫苗的接种时间和状态。本功能将疫苗计划可视化展示，智能提示逾期疫苗，简化记录流程，帮助家长科学管理宝宝免疫计划。

## What Changes

- 创建疫苗接种页面（VaccinePage），按月龄分组展示国家免疫规划疫苗
- 实现疫苗状态显示（已完成/已逾期/近期计划/待接种），通过颜色和图标区分
- 创建顶部"免疫盾"概览卡片，显示已获得保护数量和逾期预警
- 实现时间轴布局，左侧贯穿线串联各月龄疫苗节点
- 创建接种记录录入弹窗（BottomSheet），支持快捷选择接种部位和不良反应
- 添加疫苗数据 Provider，管理疫苗库数据和接种记录

## Capabilities

### New Capabilities

- `vaccine-schedule-display`: 疫苗计划展示能力，按月龄分组显示疫苗列表，支持状态颜色区分和时间轴布局
- `vaccine-record-entry`: 接种记录录入能力，支持日期选择、接种部位快捷选择、不良反应标记、批号录入
- `vaccine-provider`: 疫苗数据管理能力，提供疫苗库数据加载、接种记录 CRUD、状态计算等功能

### Modified Capabilities

（无现有能力修改）

## Impact

**新增文件：**
- `lib/pages/vaccine_page.dart` - 疫苗接种页面
- `lib/providers/vaccine_provider.dart` - 疫苗数据 Provider
- `lib/widgets/vaccine/vaccine_group_card.dart` - 月龄分组卡片
- `lib/widgets/vaccine/vaccine_item_card.dart` - 疫苗项卡片
- `lib/widgets/vaccine/vaccine_record_sheet.dart` - 接种记录录入弹窗
- `lib/widgets/vaccine/immunity_shield_card.dart` - 免疫盾概览卡片

**修改文件：**
- `lib/providers/providers.dart` - 添加 vaccine_provider 导出
- `lib/database/database.dart` - 添加疫苗库数据加载方法

**依赖：**
- 复用现有 `HalfScreenSheet` 组件
- 复用现有 `databaseProvider` 和 `currentBabyProvider`