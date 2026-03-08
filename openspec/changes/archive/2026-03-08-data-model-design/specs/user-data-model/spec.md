## ADDED Requirements

### Requirement: 用户表结构定义
系统 SHALL 定义 Users 表存储用户账号信息，包含身份标识、个人信息和同步字段。

#### Scenario: 用户表字段完整
- **WHEN** 开发人员查看 Users 表定义
- **THEN** SHALL 找到 id、phone、email、nickname、avatarUrl、serverId、lastSyncAt、createdAt、updatedAt 字段

### Requirement: 家庭组表结构定义
系统 SHALL 定义 Families 表存储家庭组信息，支持家庭组共享宝宝数据。

#### Scenario: 家庭组表字段完整
- **WHEN** 开发人员查看 Families 表定义
- **THEN** SHALL 找到 id、name、inviteCode、ownerId、serverId、lastSyncAt、createdAt 字段

### Requirement: 家庭成员关联表结构定义
系统 SHALL 定义 FamilyMembers 表存储用户与家庭组的关联关系。

#### Scenario: 家庭成员关联表字段完整
- **WHEN** 开发人员查看 FamilyMembers 表定义
- **THEN** SHALL 找到 id、familyId、userId、role、serverId、joinedAt 字段

#### Scenario: 用户家庭唯一性约束
- **WHEN** 尝试添加重复的家庭成员关系
- **THEN** 数据库 SHALL 拒绝插入，保证一个用户在一个家庭只有一条记录

### Requirement: 家庭组角色定义
系统 SHALL 支持家庭成员角色区分，包括创建者、管理员和普通成员。

#### Scenario: 角色字段定义
- **WHEN** 查看家庭成员记录
- **THEN** role 字段 SHALL 支持 0=创建者、1=管理员、2=成员 三种值