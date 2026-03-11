# Notification Service

## Purpose

本地通知服务基础设施，提供跨平台通知功能，支持 Android、iOS 和 Web 平台。

## Requirements

### Requirement: 通知服务初始化
系统 SHALL 在应用启动时初始化本地通知服务，包括创建通知渠道（Android）和请求必要权限。

#### Scenario: Android 初始化成功
- **WHEN** 应用在 Android 平台启动
- **THEN** 系统 SHALL 创建 `vaccine_reminder` 和 `prediction` 通知渠道
- **AND** 系统 SHALL 准备好接收通知调度请求

#### Scenario: iOS 初始化成功
- **WHEN** 应用在 iOS 平台启动
- **THEN** 系统 SHALL 请求用户授权通知权限
- **AND** 系统 SHALL 准备好接收通知调度请求

#### Scenario: Web 平台降级
- **WHEN** 应用在 Web 平台运行
- **THEN** 系统 SHALL 跳过通知初始化
- **AND** `isSupported` 属性 SHALL 返回 `false`

### Requirement: 通知权限管理
系统 SHALL 提供通知权限管理功能，支持检查权限状态和请求权限。

#### Scenario: 检查权限状态
- **WHEN** 调用权限检查方法
- **THEN** 系统 SHALL 返回当前通知权限状态（已授权/未授权/未确定）

#### Scenario: 请求权限（Android 13+）
- **WHEN** 在 Android 13+ 设备上请求通知权限
- **THEN** 系统 SHALL 显示系统权限请求对话框
- **AND** 用户选择后返回授权结果

#### Scenario: 请求权限（iOS）
- **WHEN** 在 iOS 设备上请求通知权限
- **THEN** 系统 SHALL 显示系统权限请求对话框
- **AND** 用户选择后返回授权结果

### Requirement: 通知调度
系统 SHALL 支持在指定时间调度本地通知。

#### Scenario: 调度精确时间通知
- **WHEN** 调用通知调度方法并传入目标时间
- **THEN** 系统 SHALL 在指定时间显示通知
- **AND** 通知 SHALL 包含标题、内容和可选的附加数据

#### Scenario: 取消已调度的通知
- **WHEN** 调用取消通知方法并传入通知 ID
- **THEN** 系统 SHALL 取消该通知
- **AND** 该通知 SHALL 不再在原定时间显示

#### Scenario: 通知点击处理
- **WHEN** 用户点击通知
- **THEN** 系统 SHALL 打开应用
- **AND** 系统 SHALL 触发通知点击回调，传递通知数据

### Requirement: 通知持久化恢复
系统 SHALL 在应用启动时恢复重要的待发送通知。

#### Scenario: 恢复疫苗提醒
- **WHEN** 应用启动时
- **THEN** 系统 SHALL 检查即将到来的疫苗提醒
- **AND** 如果通知丢失，系统 SHALL 重新调度

### Requirement: 平台适配
系统 SHALL 根据平台特性适配通知行为。

#### Scenario: Android 通知渠道
- **WHEN** 在 Android 平台调度通知
- **THEN** 通知 SHALL 关联到指定的通知渠道
- **AND** 用户可在系统设置中分别管理各渠道通知

#### Scenario: iOS 通知类别
- **WHEN** 在 iOS 平台调度通知
- **THEN** 通知 SHALL 关联到指定的通知类别