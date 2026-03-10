# Database Specification

## Purpose

Drift (SQLite) 数据库连接和基础操作层，提供跨平台的数据持久化能力。

## Requirements

### Requirement: 数据库连接初始化

系统 SHALL 提供 Drift 数据库连接初始化功能，支持 Android、iOS、Web 三端。

#### Scenario: Android 平台初始化
- **WHEN** 应用在 Android 平台启动并调用数据库连接
- **THEN** 系统创建 SQLite 数据库文件 `baby_plan.sqlite`
- **AND** 数据库文件存储在应用沙盒目录

#### Scenario: iOS 平台初始化
- **WHEN** 应用在 iOS 平台启动并调用数据库连接
- **THEN** 系统创建 SQLite 数据库文件 `baby_plan.sqlite`
- **AND** 数据库文件存储在应用 Documents 目录

#### Scenario: Web 平台初始化
- **WHEN** 应用在 Web 平台启动并调用数据库连接
- **THEN** 系统使用 IndexedDB 存储 SQLite 数据库文件
- **AND** 数据库在浏览器会话间持久化

### Requirement: Schema 版本管理

系统 SHALL 支持 schema 版本管理和迁移机制，确保数据库结构可升级。

#### Scenario: 首次创建数据库
- **WHEN** 数据库文件不存在
- **THEN** 系统创建版本号为 1 的数据库
- **AND** 执行 onCreate 迁移回调

#### Scenario: 数据库版本升级
- **WHEN** 检测到数据库版本低于当前 schema 版本
- **THEN** 系统执行 onUpgrade 迁移回调
- **AND** 更新数据库版本号

### Requirement: 基本 CRUD 操作

系统 SHALL 支持基本的数据创建、读取、更新、删除操作。

#### Scenario: 插入数据
- **WHEN** 向数据库插入一条记录
- **THEN** 记录被持久化存储
- **AND** 返回插入记录的 ID

#### Scenario: 查询数据
- **WHEN** 根据条件查询数据
- **THEN** 返回符合条件的记录列表

#### Scenario: 更新数据
- **WHEN** 更新已有记录
- **THEN** 数据库中的记录被更新

#### Scenario: 删除数据
- **WHEN** 删除指定记录
- **THEN** 记录从数据库中移除

### Requirement: 跨平台性能

系统 SHALL 在各平台满足基本性能要求。

#### Scenario: Android 批量插入性能
- **WHEN** 在 Android 平台插入 1000 条记录
- **THEN** 操作在 500ms 内完成

#### Scenario: iOS 批量插入性能
- **WHEN** 在 iOS 平台插入 1000 条记录
- **THEN** 操作在 500ms 内完成

#### Scenario: Web 批量插入性能
- **WHEN** 在 Web 平台插入 1000 条记录
- **THEN** 操作在 1000ms 内完成
