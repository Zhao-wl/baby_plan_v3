## Why

新手父母常常不知道宝宝下一刻需要什么，需要不断猜测宝宝的作息规律。通过分析宝宝的历史活动数据，结合月龄发育标准，可以智能预测宝宝的下一项活动（吃、睡、排泄），帮助父母提前准备，减少手忙脚乱的情况。

## What Changes

- 新增 `AgeActivityPatterns` 数据表，存储按周龄划分的活动模式基准数据
- 新增 `prediction_service.dart`，实现预测算法（历史数据70% + 月龄基准30%）
- 新增 `prediction_provider.dart`，提供预测状态管理
- 修改 `SmartPredictionCard`，从静态占位变为动态预测展示
- 预测卡片支持"打勾"操作，标记后不再推送该预测
- 每次活动记录变更自动触发重新计算

## Capabilities

### New Capabilities

- `prediction-engine`: 基于历史数据和月龄基准的活动预测能力，包含预测算法、数据模型、服务层和 Provider

### Modified Capabilities

- `smart-prediction-card`: 从静态占位 UI 变为动态预测展示，接入真实预测数据，支持交互操作

## Impact

**新增文件：**
- `lib/database/tables/age_activity_patterns.dart` - 月龄活动模式表定义
- `lib/services/prediction_service.dart` - 预测服务
- `lib/providers/prediction_provider.dart` - 预测 Provider
- `lib/models/prediction_result.dart` - 预测结果模型
- `assets/data/age_activity_patterns.json` - 月龄活动模式数据（0-52周）

**修改文件：**
- `lib/database/database.dart` - 添加新表和数据加载
- `lib/widgets/dashboard/smart_prediction_card.dart` - 接入预测数据
- `lib/providers/providers.dart` - 导出新 Provider

**数据变更：**
- 数据库 schema 版本升级（+1）
- 新增 `age_activity_patterns` 表