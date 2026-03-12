## MODIFIED Requirements

### Requirement: 自动创建游客用户

当应用首次启动且本地无匹配的访客用户数据时，系统 SHALL 自动创建一个游客用户，并将设备标识与该用户关联。

**修改点：调整恢复优先级，优先从数据库查找现有游客账号。**

#### Scenario: 首次启动创建游客
- **WHEN** 应用首次启动且数据库中无游客用户
- **THEN** 系统创建新用户，设置 `isGuest = true`，`nickname = "游客"`，并记录 `device_id`

#### Scenario: 根据数据库中现有游客恢复
- **WHEN** 应用启动且数据库中存在游客用户
- **THEN** 系统恢复该游客用户，不创建新用户

#### Scenario: 设备标识同步恢复
- **WHEN** 数据库中存在游客用户但 SharedPreferences 中无设备标识
- **THEN** 系统恢复该游客用户，并将用户记录中的 `device_id` 同步到 SharedPreferences

#### Scenario: 已有正式用户不创建游客
- **WHEN** 应用启动且本地已有正式用户记录
- **THEN** 系统使用现有用户，不创建新游客