## 1. 数据模型扩展

- [x] 1.1 在 `lib/models/` 创建 `time_slot.dart`，定义 `TimeSlot` 枚举（morning/forenoon/afternoon/evening/night）
- [x] 1.2 在 `lib/models/` 创建 `awake_stage.dart`，定义 `AwakeStage` 枚举（awake-early/awake-mid/awake-late）
- [x] 1.3 在 `lib/models/prediction_result.dart` 增加 `timeSlot` 和 `awakeStage` 字段
- [x] 1.4 在 `lib/models/` 创建 `time_slot_pattern.dart`，定义时段模式数据类

## 2. 分时段基准数据

- [x] 2.1 更新 `assets/data/age_activity_patterns.json`，增加 `version: 2` 和 `timeSlots` 字段
- [x] 2.2 为 0-52 周的每种活动类型（吃/睡/排泄）添加 5 个时段的基准数据
- [x] 2.3 在 `lib/database/tables/age_activity_patterns.dart` 增加时段相关字段（可选，或使用 JSON 解析）
- [x] 2.4 更新 `lib/database/database.dart` 的数据加载逻辑，支持 v2 格式解析

## 3. 时段历史数据查询

- [x] 3.1 在 `lib/database/database.dart` 增加 `getTimeSlotActivities(babyId, activityType, timeSlot, days)` 方法
- [x] 3.2 实现时段边界活动的权重分配逻辑（±30分钟活动贡献给相邻时段）
- [x] 3.3 增加时段历史模式计算方法，返回时段平均间隔、时长、样本数量

## 4. 睡眠维度查询

- [x] 4.1 在 `lib/database/database.dart` 增加 `getLastCompletedSleep(babyId)` 方法
- [x] 4.2 在 `lib/services/` 创建或更新 `sleep_analysis_service.dart`，计算睡眠阶段
- [x] 4.3 实现睡眠阶段判定逻辑（距睡眠结束时间计算）

## 5. PredictionService 重构

- [x] 5.1 重构 `PredictionService._queryRecentActivities()`，扩展历史窗口到 14 天
- [x] 5.2 实现 `_getTimeSlotPrediction()` 方法，计算时段感知的历史模式
- [x] 5.3 实现三元加权融合算法 `_calculateWeightedInterval()`
- [x] 5.4 修改 `_predictActivity()` 方法，集成时段和睡眠维度
- [x] 5.5 更新 `_buildPredictionResult()` 方法，包含时段和睡眠阶段信息
- [x] 5.6 更新提示生成逻辑，根据时段和睡眠阶段生成针对性提示

## 6. Provider 层更新

- [x] 6.1 在 `prediction_provider.dart` 移除夜间模式禁用逻辑（`_isNightMode()`）
- [x] 6.2 增加睡眠阶段查询，传递给 PredictionService
- [x] 6.3 更新 `predictionStateProvider`，包含 `timeSlot` 和 `awakeStage` 字段

## 7. UI 层更新

- [x] 7.1 更新 `SmartPredictionCard` 显示时段信息（如"傍晚时段"）
- [x] 7.2 更新夜间预测的提示文案（"夜间长觉"、"睡前喂奶"等）
- [x] 7.3 显示睡眠阶段信息（如"刚醒来"、"疲劳期"）

## 8. 测试

- [x] 8.1 编写 `TimeSlot` 枚举单元测试
- [x] 8.2 编写 `AwakeStage` 枚举单元测试
- [x] 8.3 编写时段历史数据查询测试
- [x] 8.4 编写睡眠阶段计算测试
- [x] 8.5 编写三元加权融合算法测试
- [x] 8.6 编写时段感知预测集成测试

## 9. 文档与兼容性

- [x] 9.1 更新 CLAUDE.md 中关于预测引擎的说明
- [x] 9.2 验证 v1 JSON 数据的向后兼容性（使用 global 字段作为默认值）
- [x] 9.3 手动测试各时段预测准确性