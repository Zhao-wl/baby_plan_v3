# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目背景

**E.A.S.Y. 育儿助手** - Flutter 移动应用，帮助父母记录和分析宝宝的日常活动（吃、玩、睡、排泄）。

> 开发环境优先使用 Web：`flutter run -d chrome`

## 常用命令

```bash
flutter run -d chrome          # 运行应用 (Web)
flutter test                   # 运行测试
flutter analyze                # 代码分析
flutter pub get                # 获取依赖
dart format .                  # 格式化代码
dart run build_runner build --delete-conflicting-outputs  # 代码生成
```

## 技术选型

| 领域 | 技术 |
|------|------|
| 状态管理 | Riverpod (`flutter_riverpod`) |
| 数据库 | Drift (SQLite ORM) |
| 不可变模型 | Freezed |
| JSON 序列化 | json_serializable |
| 图表 | fl_chart |

## 功能入口

应用采用底部导航栏设计，主要页面：

| 页面 | 文件 | 功能 |
|------|------|------|
| 首页 | `lib/pages/home/` | 今日概览、智能预测、快捷记录 |
| 时间线 | `lib/pages/timeline/` | 按时间查看活动记录 |
| 统计 | `lib/pages/stats/` | 日/周/月数据分析、生长曲线 |
| 我的 | `lib/pages/profile/` | 宝宝管理、家庭设置、同步设置 |

## 架构概览

```
lib/
  main.dart                 # 入口
  database/                 # Drift 数据库定义
    database.dart           # AppDatabase + migrations
    tables/                 # 表定义（activity_records 核心表）
  providers/                # Riverpod 状态管理
    database_provider.dart  # 数据库单例
    current_baby_provider.dart  # 当前宝宝状态
    timeline_provider.dart  # 时间线数据
    stats_provider.dart     # 统计数据
  services/                 # 业务服务
    prediction_service.dart # 智能预测算法
  pages/                    # 页面
  models/                   # 数据模型
```

### 核心数据表

- **ActivityRecords**: 活动记录（吃/玩/睡/排泄），type 字段: 0=吃, 1=玩, 2=睡, 3=排泄
- **Babies**: 宝宝信息
- **GrowthRecords**: 生长记录

### Provider 依赖

```
databaseProvider → currentBabyProvider → timelineProvider / statsProvider
```

Provider 层直接调用 Database，无 Repository 层。

## 编码规范

### const 构造函数

必须使用 `const` 关键字声明编译时常量：

```dart
const Text('文本')
const SizedBox(height: 8)
```

### 避免重复导入

`flutter_test` 已包含 `matcher`，无需额外导入。使用 `drift` 时需 `hide isNotNull` 避免冲突：

```dart
import 'package:drift/drift.dart' hide isNotNull;
```

### 分析规则

- `prefer_const_constructors: warning`
- `avoid_relative_lib_imports: error`
- `avoid_print: warning`

## 注意事项

- **始终用中文回答**
- 使用浏览器时，优先使用 `playwright-cli` 技能
- Git/GitHub 操作优先使用 `gh-cli` 技能
- 修改数据库表后必须运行 `build_runner`