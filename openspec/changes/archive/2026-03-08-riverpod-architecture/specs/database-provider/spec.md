## ADDED Requirements

### Requirement: 数据库单例 Provider

系统 SHALL 提供 `databaseProvider` 作为 AppDatabase 的全局单例。

#### Scenario: 数据库实例唯一
- **WHEN** 多次调用 `ref.read(databaseProvider)`
- **THEN** 返回同一个 AppDatabase 实例

#### Scenario: 数据库正确初始化
- **WHEN** 应用启动并首次访问 databaseProvider
- **THEN** 数据库连接成功创建

### Requirement: 数据库资源清理

数据库 Provider SHALL 在 Provider 销毁时关闭数据库连接。

#### Scenario: 数据库正确关闭
- **WHEN** ProviderScope 销毁
- **THEN** 数据库连接正确关闭

### Requirement: 数据库访问接口

databaseProvider SHALL 返回完整的 AppDatabase 实例供其他 Provider 使用。

#### Scenario: Provider 可访问数据库方法
- **WHEN** Provider 依赖 databaseProvider
- **THEN** 可调用 AppDatabase 的所有查询方法