## Why

开发过程中需要测试各个模块功能（统计页面、时间线、疫苗记录等），手动创建测试数据耗时且容易遗漏边界场景。需要一个测试数据账号功能，一键注入预设的完整测试数据，加速开发和测试流程。

## What Changes

- 在"我的"页面添加"测试数据登录"入口按钮
- 创建测试数据账号登录服务
- 注入预设测试数据：
  - 多个宝宝数据（不同月龄）
  - 90天以上的完整时间线数据（E.A.S.Y 活动记录）
  - 疫苗接种记录
  - 生长记录
- 测试数据账号标识和状态管理

## Capabilities

### New Capabilities

- `test-data-account`: 测试数据账号功能，提供一键登录测试账号并注入预设测试数据的能力

### Modified Capabilities

无。此功能为新增模块，不影响现有功能的规格要求。

## Impact

- **新增文件**:
  - `lib/services/test_data_service.dart` - 测试数据生成和注入服务
  - `lib/providers/test_data_provider.dart` - 测试数据状态管理
- **修改文件**:
  - `lib/pages/profile_page.dart` - 添加测试数据登录按钮入口
- **数据库**: 复用现有表结构，不新增表
- **依赖**: 无新增依赖