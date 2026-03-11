## 1. 数据层

- [x] 1.1 在 database.dart 添加疫苗库数据加载方法（loadVaccineLibraryFromJson）
- [x] 1.2 创建 VaccineProvider，包含疫苗计划查询和状态计算逻辑
- [x] 1.3 在 providers.dart 导出 VaccineProvider
- [x] 1.4 实现 VaccineDisplayStatus 枚举和 VaccineScheduleItem 数据类

## 2. UI 组件

- [x] 2.1 创建 ImmunityShieldCard 组件（免疫盾概览卡片）
- [x] 2.2 创建 VaccineGroupCard 组件（月龄分组容器）
- [x] 2.3 创建 VaccineItemCard 组件（单个疫苗卡片）
- [x] 2.4 创建 VaccineRecordSheet 组件（接种记录录入弹窗）
- [x] 2.5 实现接种部位快捷选择按钮组
- [x] 2.6 实现接种反应标签选择组

## 3. 页面集成

- [x] 3.1 重构 VaccinePage 页面主体结构
- [x] 3.2 集成 ImmunityShieldCard 到页面顶部
- [x] 3.3 实现疫苗列表按月龄分组显示
- [x] 3.4 实现时间轴布局（左侧贯穿线 + 节点）
- [x] 3.5 实现弹窗触发和保存逻辑

## 4. 业务逻辑

- [x] 4.1 实现疫苗状态计算函数（done/overdue/upcoming/pending）
- [x] 4.2 实现接种记录创建和保存
- [x] 4.3 实现保存后数据刷新

## 5. 验证测试

- [x] 5.1 验证疫苗库数据加载正确
- [x] 5.2 验证状态计算逻辑正确
- [x] 5.3 验证 UI 显示符合原型设计
- [x] 5.4 验证接种记录保存和显示