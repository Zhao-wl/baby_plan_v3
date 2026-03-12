## Context

**当前状态：**
- 游客账号恢复逻辑位于 `AuthProvider._initializeUser()` 方法
- 使用 `DeviceService.getDeviceId()` 从 SharedPreferences 获取设备标识
- 然后根据 `deviceId` 查询匹配的游客用户
- Web 平台上，SharedPreferences 使用 localStorage 存储

**问题：**
- Flutter 开发服务器每次 `flutter run -d chrome` 可能使用不同端口
- 不同端口 = 不同 origin = localStorage 隔离
- 设备标识丢失 → 创建新游客账号 → 原有数据无法访问

**数据存储对比：**

| 存储方式 | Web 平台实现 | 持久性 |
|---------|-------------|-------|
| Drift 数据库 | IndexedDB | ✅ 跨会话持久 |
| SharedPreferences | localStorage | ❌ 受 origin 影响 |

## Goals / Non-Goals

**Goals:**
- Web 平台上跨会话保持游客账号数据
- 保持与现有 spec 的兼容性
- 最小化代码变更

**Non-Goals:**
- 不解决多设备同步问题（这是 server sync 的职责）
- 不改变正式账号的登录逻辑
- 不修改数据库 schema

## Decisions

### Decision 1: 优先从数据库恢复游客账号

**方案选择：**
- ✗ 方案 A：将设备标识也存入数据库 → 增加复杂度，需要新表或字段
- ✓ 方案 B：调整恢复优先级，先查数据库中的游客账号 → 简单有效

**选择理由：**
1. 数据库（IndexedDB）在 Web 上是真正持久的
2. 游客账号通常是单用户场景，数据库中有且仅有一个游客账号
3. 实现简单，不需要修改 schema

### Decision 2: 保留设备标识作为辅助验证

**实现方式：**
- 如果 SharedPreferences 中有设备标识，且与数据库中游客账号的 `deviceId` 匹配，则正常恢复
- 如果 SharedPreferences 中没有设备标识或匹配失败，但数据库中有游客账号，则：
  1. 恢复该游客账号
  2. 将数据库中的 `deviceId` 同步到 SharedPreferences

**好处：**
- 保持设备标识的一致性
- 为未来的多设备场景预留扩展点

## Risks / Trade-offs

**风险：多游客账号场景**
- 场景：用户曾删除账号后重新安装，数据库中可能存在多个游客账号
- 缓解：优先使用最新的（按创建时间）未删除游客账号

**风险：隐私清理**
- 场景：用户清理浏览器数据，但 IndexedDB 保留
- 缓解：这是预期行为，用户数据保留反而更好

**权衡：安全性 vs 便利性**
- 当前方案假设单用户场景
- 如果设备被他人使用，可能访问到原用户数据
- 这是游客模式的固有特性，不是此变更引入的新问题