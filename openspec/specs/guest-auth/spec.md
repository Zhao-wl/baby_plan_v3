# guest-auth

## Purpose

提供游客身份管理功能，包括自动创建游客用户、游客状态查询、登录入口和升级预留逻辑。

## Requirements

### Requirement: 自动创建游客用户

当应用首次启动且本地无匹配的访客用户数据时，系统 SHALL 自动创建一个游客用户，并将设备标识与该用户关联。

#### Scenario: 首次启动创建游客
- **WHEN** 应用首次启动且设备标识未关联任何现有游客用户
- **THEN** 系统创建新用户，设置 `isGuest = true`，`nickname = "游客"`，并记录 `device_id`

#### Scenario: 根据设备标识恢复游客
- **WHEN** 应用启动且设备标识已关联现有游客用户
- **THEN** 系统恢复该游客用户，不创建新用户

#### Scenario: 已有正式用户不创建游客
- **WHEN** 应用启动且本地已有正式用户记录
- **THEN** 系统使用现有用户，不创建新游客

---

### Requirement: 游客状态可查询

系统 SHALL 提供查询当前用户是否为游客的能力。

#### Scenario: 查询游客状态
- **WHEN** 调用 AuthProvider 的 isGuest 属性
- **THEN** 返回当前用户的 `isGuest` 字段值

---

### Requirement: 游客可使用离线功能

游客用户 SHALL 可以使用完整的离线功能。

#### Scenario: 游客创建宝宝
- **WHEN** 游客用户点击添加宝宝
- **THEN** 系统创建宝宝记录并关联到当前游客用户

#### Scenario: 游客记录活动
- **WHEN** 游客用户记录喂养/睡眠/活动/排泄
- **THEN** 系统保存活动记录并关联到对应宝宝

#### Scenario: 游客使用计时器
- **WHEN** 游客用户启动计时器
- **THEN** 计时器正常运行并可保存为活动记录

---

### Requirement: 游客无法使用云端功能

游客用户 SHALL NOT 能够使用云端同步和家庭组功能。

#### Scenario: 游客访问云同步
- **WHEN** 游客用户尝试触发云同步
- **THEN** 系统显示升级提示，不执行同步操作

#### Scenario: 游客创建家庭组
- **WHEN** 游客用户尝试创建家庭组
- **THEN** 系统显示升级提示，不执行创建操作

#### Scenario: 游客加入家庭组
- **WHEN** 游客用户尝试通过邀请码加入家庭组
- **THEN** 系统显示升级提示，不执行加入操作

---

### Requirement: 游客状态 UI 展示

系统 SHALL 在界面上清晰展示当前游客状态。

#### Scenario: 首页显示游客状态
- **WHEN** 当前用户为游客
- **THEN** 首页顶部显示"游客模式"标识

#### Scenario: 设置页显示登录入口
- **WHEN** 当前用户为游客且进入设置页
- **THEN** 显示"登录账号"入口

---

### Requirement: 登录入口占位

系统 SHALL 提供登录入口，但登录逻辑可作为占位实现。

#### Scenario: 点击登录入口
- **WHEN** 游客用户点击"登录账号"
- **THEN** 显示登录界面或占位提示（当前迭代可简化）

---

### Requirement: 账号升级预留

系统 SHALL 为账号升级功能预留扩展点，当前迭代可暂不实现完整逻辑。

#### Scenario: 升级入口预留
- **WHEN** 需要实现升级功能时
- **THEN** 可通过 AuthProvider 的 upgradeToAccount 方法扩展