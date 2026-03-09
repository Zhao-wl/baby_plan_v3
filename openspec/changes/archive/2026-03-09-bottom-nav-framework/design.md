## Context

当前项目已完成基础设施搭建：
- **主题系统**：AppTheme 已配置 Material 3，包含 BottomNavigationBarTheme 预设
- **状态管理**：Riverpod 架构完备，支持 Provider 持久化
- **数据层**：Drift 数据库、Provider 层已就绪

当前 `main.dart` 指向 `DatabaseTestPage`（测试页面），需要替换为正式的应用入口。

## Goals / Non-Goals

**Goals:**
- 搭建底部导航框架，支持 4 个 Tab 切换
- 实现页面状态保持，防止切换时重置
- 创建页面骨架占位，为 1.8 路由配置提供基础
- 提供统一的导航接口

**Non-Goals:**
- 不实现页面的具体业务逻辑（由 1.8 完成）
- 不配置深层链接或动态路由（由 1.8 完成）
- 不实现登录流程或权限控制

## Decisions

### D1: 使用 NavigationBar（Material 3）替代 BottomNavigationBar

**选择**：`NavigationBar`

**理由**：
- Material 3 推荐组件，与项目 `useMaterial3: true` 一致
- 选中时显示文字，未选中时隐藏，视觉更简洁
- 自动应用 surface tint，符合 Material 3 设计规范
- AppTheme 中已预配置 `bottomNavigationBarTheme`，可直接复用

**替代方案**：
- `BottomNavigationBar`：Material 2 风格，功能相似但不符合 Material 3 规范

### D2: 使用 IndexedStack 保持页面状态

**选择**：`IndexedStack` + `AutomaticKeepAliveClientMixin`

**理由**：
- 4 个页面数量少，内存占用可接受
- 保持所有页面状态（滚动位置、表单输入等）
- 切换时无重建，流畅度高
- 符合"状态保持"任务要求

**替代方案**：
- 直接切换 Widget：每次重建，状态丢失 ❌
- PageView：支持滑动切换，但本需求不需要滑动 ❌

### D3: 路由方案推荐 — 保持简单，1.8 再决定

**当前策略**：不引入额外路由库

**理由**：
- 1.6 只需 Tab 切换，`IndexedStack` 足够
- 1.8 任务明确提到"配置 GoRouter 或 Navigator 2.0"，届时再选型
- 过早引入路由库可能限制后续设计

**1.8 路由选型建议**：

| 方案 | 适用场景 | 推荐度 |
|------|----------|--------|
| **Navigator 2.0** | 简单应用，无深层链接需求 | ⭐⭐⭐⭐ |
| **GoRouter** | 需要 URL 路由、深层链接、Web 支持 | ⭐⭐⭐⭐⭐ |

**推荐**：如果 Web 端需要 URL 路由或支持深层链接，选择 GoRouter；否则 Navigator 2.0 足够。

### D4: 导航状态管理

**选择**：新建 `NavigationProvider`（Notifier）

**理由**：
- 与现有 Provider 架构一致
- 可扩展：未来支持程序化导航、深层链接
- 不持久化：用户习惯从首页开始

## Risks / Trade-offs

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| IndexedStack 内存占用 | 4 个页面常驻内存 | 页面数量少，骨架页内容简单，影响可控 |
| 1.6 与 1.8 任务边界模糊 | 可能重复工作 | 1.6 只创建骨架占位，1.8 填充内容 |
| 导航主题不一致 | AppTheme 已有预设，可能与新组件冲突 | 使用 Material 3 的 NavigationBar，主题自动适配 |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         MyApp                                    │
│                           │                                      │
│                    MainPage (新增)                               │
│                    ┌──────┴──────┐                               │
│                    │             │                               │
│              IndexedStack    NavigationBar                       │
│                    │                                             │
│    ┌───────┬───────┼───────┬───────┐                            │
│    │       │       │       │       │                            │
│ HomePage TimelinePage StatsPage ProfilePage                      │
│    │       │       │       │       │                            │
│    └───────┴───────┴───────┴───────┘                            │
│              骨架页面（1.6）→ 具体实现（1.8）                      │
└─────────────────────────────────────────────────────────────────┘
```

**文件结构**：
```
lib/
├── main.dart                    # home: const MainPage()
├── pages/                       # 新建目录
│   ├── main_page.dart          # 导航栏 + IndexedStack
│   ├── home_page.dart          # 首页骨架
│   ├── timeline_page.dart      # 时间线骨架
│   ├── stats_page.dart         # 统计骨架
│   └── profile_page.dart       # 我的骨架
└── providers/
    ├── providers.dart          # export navigation_provider.dart
    └── navigation_provider.dart # 导航状态
```