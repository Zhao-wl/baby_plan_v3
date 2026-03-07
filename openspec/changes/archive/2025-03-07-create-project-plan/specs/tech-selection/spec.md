## ADDED Requirements

### Requirement: 核心技术选型文档化
所有核心技术选型 SHALL 文档化，包含选择理由、备选方案和适用场景分析。

#### Scenario: 选型完整
- **WHEN** 开发人员查阅技术选型文档
- **THEN** SHALL 找到 Flutter、Riverpod、Isar、fl_chart、云服务等核心技术的选型说明

### Requirement: 中国网络环境验证
云服务选型 SHALL 完成中国网络环境验证，包括连通性、延迟和稳定性测试。

#### Scenario: UniCloud 验证
- **WHEN** 第1周进行云服务验证
- **THEN** SHALL 完成阿里云/腾讯云节点连通性测试（RTT < 100ms）
- **AND** SHALL 完成微信登录接口可用性检查
- **AND** SHALL 确认免费额度满足初期需求

#### Scenario: Laf 验证
- **WHEN** UniCloud 验证不通过时
- **THEN** SHALL 完成 Laf 函数冷启动时间测试（< 500ms）
- **AND** SHALL 完成数据库连接稳定性测试

### Requirement: 第三方登录方案
系统 SHALL 提供适合中国用户的登录方案，支持手机号验证码作为微信登录的备选。

#### Scenario: 个人开发者登录方案
- **WHEN** 开发者没有企业资质
- **THEN** 系统 SHALL 支持手机号验证码登录
- **AND** SHALL 支持匿名登录 + 绑定机制

#### Scenario: iOS 登录合规
- **WHEN** 应用在 iOS 运行
- **THEN** SHALL 支持 Apple Sign In（苹果登录）

### Requirement: 推送服务方案
系统 SHALL 使用本地通知优先，云端推送作为备选。

#### Scenario: 本地通知
- **WHEN** 需要提醒用户时
- **THEN** 优先使用 flutter_local_notifications 本地通知
- **AND** SHALL 不依赖网络即可触发

#### Scenario: 云端推送备选
- **WHEN** 需要跨设备提醒时
- **THEN** SHALL 支持极光/个推等国内推送服务（可选实现）

### Requirement: 资源加载策略
系统 SHALL 使用中国网络友好的资源加载策略。

#### Scenario: 字体加载
- **WHEN** 应用启动时
- **THEN** SHALL 使用系统字体或本地字体，避免 Google Fonts

#### Scenario: CDN 资源
- **WHEN** 加载外部资源时
- **THEN** SHALL 优先使用国内 CDN 或本地资源
