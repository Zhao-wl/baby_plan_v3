## Why

Web 平台上，每次运行 `flutter run -d chrome` 都会丢失游客数据，变成新账号。

**根本原因：** Web 平台的设备标识使用 `SharedPreferences` 存储（底层为 `localStorage`），而 Flutter 开发服务器每次启动可能使用不同端口（如 `localhost:54321`）。不同端口意味着不同的 origin，`localStorage` 按 origin 隔离，导致设备标识丢失。新的设备标识使 AuthProvider 无法匹配现有游客账号，从而创建新账号。

**影响：** 数据库（IndexedDB）中的数据仍然存在，但因为创建了新游客账号，用户无法访问原有数据。

## What Changes

- 修改游客账号恢复逻辑：优先从数据库中查找游客账号，而不是依赖 SharedPreferences 中的设备标识
- 设备标识作为辅助验证手段，而非唯一依据
- 保持与现有 `guest-account-persistence` 规范的兼容性

## Capabilities

### New Capabilities

无新增能力，此变更修改现有行为的实现细节。

### Modified Capabilities

- `guest-auth`: 修改游客账号恢复逻辑，Web 平台上优先从数据库恢复而非依赖设备标识
- `guest-account-persistence`: 更新设备标识恢复策略，确保跨会话数据持久化在 Web 平台正常工作

## Impact

- **lib/providers/auth_provider.dart**: 修改 `_initializeUser()` 方法，调整游客账号恢复优先级
- **lib/services/device_service.dart**: 可选优化，将设备标识也存储到数据库作为备份
- **测试**: 需要验证 Web 平台上的跨会话数据持久化