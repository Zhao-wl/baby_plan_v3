## 1. 数据层 - 月龄活动模式表

- [x] 1.1 创建 `age_activity_patterns.dart` 表定义
- [x] 1.2 创建 `age_activity_patterns.json` 数据文件（0-52周）
- [x] 1.3 在 `database.dart` 中添加表定义和数据加载方法
- [x] 1.4 升级数据库 schema 版本
- [x] 1.5 运行 `dart run build_runner build --delete-conflicting-outputs`

## 2. 模型层 - 预测结果

- [x] 2.1 创建 `prediction_result.dart` 数据模型
- [x] 2.2 定义 `PredictionType` 枚举（吃、睡、排泄）
- [x] 2.3 定义 `PredictionResult` 类

## 3. 服务层 - 预测算法

- [x] 3.1 创建 `prediction_service.dart` 服务接口
- [x] 3.2 实现历史数据查询方法（最近7天）
- [x] 3.3 实现历史模式计算（间隔、时长平均值）
- [x] 3.4 实现月龄基准查询方法
- [x] 3.5 实现加权融合算法（70% + 30%）
- [x] 3.6 实现预测合并逻辑（15分钟内）
- [x] 3.7 实现进行中活动检测和排除
- [x] 3.8 实现数据不足时的兜底逻辑

## 4. Provider 层 - 状态管理

- [x] 4.1 创建 `prediction_provider.dart`
- [x] 4.2 集成 `activityDataChangeProvider` 触发重新计算
- [x] 4.3 集成 `currentBabyProvider` 获取宝宝月龄
- [x] 4.4 实现已处理预测的内存标记
- [x] 4.5 在 `providers.dart` 中导出新 Provider

## 5. UI 层 - 预测卡片

- [x] 5.1 修改 `SmartPredictionCard` 接入 `predictionProvider`
- [x] 5.2 实现预测显示（时间、类型、描述）
- [x] 5.3 实现合并预测显示
- [x] 5.4 实现数据不足时的引导显示
- [x] 5.5 实现夜间模式显示（22:00-06:00）
- [x] 5.6 实现"打勾"标记已处理功能
- [x] 5.7 实现点击卡片查看预测详情

## 6. 测试与验证

- [x] 6.1 编写 `PredictionService` 单元测试
- [x] 6.2 测试历史数据分析算法
- [x] 6.3 测试加权融合算法
- [x] 6.4 测试预测合并逻辑
- [ ] 6.5 手动测试完整功能流程