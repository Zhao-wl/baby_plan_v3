## 1. 疫苗数据自动刷新

- [x] 1.1 在 `VaccineScheduleNotifier` 中添加 `ref.listen` 监听 `currentBabyProvider`
- [x] 1.2 实现宝宝切换时的自动刷新逻辑
- [x] 1.3 添加防抖机制，短时间内（5秒）避免重复刷新

## 2. 页面焦点监听

- [x] 2.1 为 `VaccinePage` 添加 `WidgetsBindingObserver` mixin
- [x] 2.2 在 `didChangeAppLifecycleState` 中处理 `resumed` 状态触发刷新
- [x] 2.3 在 `dispose` 中移除 observer 防止内存泄漏

## 3. 自动滚动定位

- [x] 3.1 在 `VaccinePage` 中添加 `ScrollController`
- [x] 3.2 为每个疫苗组卡片添加 `GlobalKey`
- [x] 3.3 实现查找首个未完成疫苗的逻辑（按优先级：逾期 > 近期计划 > 待接种）
- [x] 3.4 实现数据加载完成后的自动滚动功能
- [x] 3.5 添加滚动动画效果（300-500ms）

## 4. 测试验证

- [x] 4.1 测试切换宝宝后数据自动刷新
- [x] 4.2 测试首次添加宝宝后数据自动显示
- [x] 4.3 测试从后台返回应用时数据刷新
- [x] 4.4 测试自动滚动到首个未完成疫苗
- [x] 4.5 测试防抖机制避免频繁刷新