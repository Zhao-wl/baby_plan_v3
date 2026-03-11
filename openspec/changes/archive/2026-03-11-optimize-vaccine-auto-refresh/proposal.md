## Why

疫苗界面存在两个用户体验问题：
1. **数据不自动刷新**：首次添加宝宝后、切换宝宝时、下拉刷新界面后，疫苗数据都需要手动点击刷新按钮才能更新
2. **缺少自动定位**：打开疫苗界面时，用户需要手动滚动查找首个未完成的疫苗，不够便捷

这两个问题影响了用户体验，需要优化为自动响应和智能定位。

## What Changes

- 疫苗数据将在以下场景自动刷新，无需手动操作：
  - 首次添加宝宝后
  - 切换宝宝时
  - 界面重新获得焦点时
- 打开疫苗界面时，自动滚动到首个未完成（待接种/逾期/近期计划）的疫苗位置

## Capabilities

### New Capabilities

- `vaccine-auto-refresh`: 疫苗数据自动刷新机制，响应宝宝数据变化和页面焦点事件
- `vaccine-auto-scroll`: 疫苗列表自动定位功能，滚动到首个待处理疫苗

### Modified Capabilities

<!-- 无现有 capabilities 需要修改 -->

## Impact

- `lib/providers/vaccine_provider.dart` - 添加自动刷新逻辑
- `lib/pages/vaccine_page.dart` - 添加自动滚动和焦点监听
- 可能新增 `lib/widgets/vaccine/` 下的组件用于支持滚动定位