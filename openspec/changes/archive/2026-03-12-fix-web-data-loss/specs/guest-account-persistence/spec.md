## MODIFIED Requirements

### Requirement: 游客账号通过设备标识恢复

系统 SHALL 支持根据设备标识查找并恢复现有的游客账号。

**修改点：设备标识作为辅助验证，优先从数据库恢复。**

#### Scenario: 设备标识匹配恢复
- **WHEN** 应用启动时 SharedPreferences 中的设备标识与数据库中游客用户的 `device_id` 匹配
- **THEN** 系统正常恢复该游客账号

#### Scenario: SharedPreferences 设备标识丢失但数据库有游客账号
- **WHEN** 应用启动时 SharedPreferences 中无设备标识，但数据库中存在游客用户
- **THEN** 系统恢复该游客账号，并将其 `device_id` 同步到 SharedPreferences

#### Scenario: 设备标识不匹配但数据库有游客账号
- **WHEN** 应用启动时 SharedPreferences 中的设备标识与数据库中游客用户的 `device_id` 不匹配
- **THEN** 系统优先恢复数据库中的游客账号，并将用户的 `device_id` 同步到 SharedPreferences

#### Scenario: 设备已有关联的游客账号
- **WHEN** 应用启动时检测到设备标识已关联现有游客账号
- **THEN** 系统恢复该游客账号作为当前用户

#### Scenario: 设备无关联的游客账号
- **WHEN** 应用启动时设备标识未关联任何游客账号，且数据库中无游客用户
- **THEN** 系统创建新的游客账号并关联当前设备标识

#### Scenario: 游客账号创建设备标识关联
- **WHEN** 系统创建新的游客用户
- **THEN** 将当前设备标识存储到用户记录的 `device_id` 字段

---

### Requirement: 设备标识在游客模式下的持久化

系统 SHALL 确保游客用户的设备标识在数据库中持久化存储。

**修改点：明确数据库是设备标识的主要存储，SharedPreferences 是缓存。**

#### Scenario: 查询游客用户设备标识
- **WHEN** 查询当前游客用户的 `device_id` 字段
- **THEN** 返回创建该用户时关联的设备标识

#### Scenario: 设备标识字段可为空
- **WHEN** 创建正式账号或历史数据迁移时
- **THEN** `device_id` 字段允许为 null，不影响现有功能

#### Scenario: Web 平台跨会话设备标识恢复
- **WHEN** Web 平台上 SharedPreferences 中的设备标识因 origin 变化而丢失
- **THEN** 系统从数据库中的游客用户记录恢复 `device_id`，并同步到 SharedPreferences