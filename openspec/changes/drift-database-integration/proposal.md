## Why

E.A.S.Y. 育儿助手需要本地数据持久化来支持"本地优先"架构，确保断网可用。Drift 是一个类型安全的 SQLite ORM，需要在项目中完成集成和验证，为后续数据模型设计和业务功能开发奠定基础。

## What Changes

- 添加 Drift 相关依赖（drift、drift_flutter、drift_dev）
- 创建数据库初始化代码和连接管理
- 验证 Drift 在 Android、iOS、Web 三端的兼容性和性能
- 建立数据库 schema 版本管理和迁移机制

## Capabilities

### New Capabilities
- `database`: 本地数据库能力，包括数据库连接、表定义、CRUD 操作、迁移管理

### Modified Capabilities
无

## Impact

- 受影响文件：`pubspec.yaml`（依赖已添加）、`lib/database/`（新增目录）
- 新增依赖：drift、drift_flutter、drift_dev（已在 pubspec.yaml 中配置）
- 平台影响：Android、iOS、Web 三端需分别验证
- 后续影响：1.3 数据模型设计依赖此变更完成