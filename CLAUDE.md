# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter** mobile application (baby_plan_v3) - **E.A.S.Y. 育儿助手**，帮助父母记录和分析宝宝的日常活动。

> **Note**: Windows desktop requires Visual Studio toolchain. Use `flutter run -d chrome` (Web) for development.

## Common Commands

```bash
# Run the app (Web - default)
flutter run -d chrome

# Run on a specific platform
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
flutter run -d chrome

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart
flutter test test/database/database_test.dart

# Analyze code for errors
flutter analyze

# Build for release
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build windows      # Windows
flutter build macos        # macOS
flutter build linux        # Linux

# Get dependencies
flutter pub get

# Format code
dart format .

# Code generation (run after modifying models)
dart run build_runner build --delete-conflicting-outputs
```

## Code Architecture

### File Structure

```
lib/
  main.dart              # App entry point and root widget
  database/
    connection.dart      # Database connection setup
    database.dart        # AppDatabase class with migrations
    tables/              # Table definitions
      users.dart         # 用户表
      families.dart      # 家庭组表
      family_members.dart # 家庭成员关联表
      babies.dart        # 宝宝表
      activity_records.dart # 活动记录表（核心）
      growth_records.dart # 生长记录表
      vaccine_library.dart # 疫苗库表（内置）
      vaccine_records.dart # 接种记录表
      age_benchmark_data.dart # 月龄基准数据表
  providers/
    providers.dart              # Barrel export
    database_provider.dart      # 数据库单例
    settings_provider.dart      # SharedPreferences 设置
    babies_provider.dart        # 宝宝列表
    current_baby_provider.dart  # 当前宝宝状态
    family_provider.dart        # 家庭组状态
    timeline_provider.dart      # 时间线数据
    stats_provider.dart         # 统计数据
    sync_provider.dart          # 同步状态
  services/
    device_service.dart  # 设备标识服务
assets/
  data/
    vaccine_library.json # 内置疫苗数据
test/
  widget_test.dart       # Basic widget test
  database/
    database_test.dart   # Database tests
```

### Database Schema

The app uses **Drift** (SQLite ORM) for local data persistence. Current schema version: **2**

#### 表结构概览

| 表名 | 说明 | 软删除 | 同步支持 |
|------|------|--------|----------|
| Users | 用户账号信息 | ✓ | ✓ |
| Families | 家庭组信息 | ✓ | ✓ |
| FamilyMembers | 家庭成员关联 | ✓ | ✓ |
| Babies | 宝宝基本信息 | ✓ | ✓ |
| ActivityRecords | E.A.S.Y活动记录 | ✓ | ✓ |
| GrowthRecords | 生长记录 | ✓ | ✓ |
| VaccineLibrary | 疫苗库（内置只读）| ✗ | ✗ |
| VaccineRecords | 接种记录 | ✓ | ✓ |
| AgeBenchmarkData | 月龄基准数据 | ✗ | ✗ |

#### 活动记录表 (ActivityRecords)

核心表，采用混合设计（公共字段 + 专属字段）：

**公共字段：**
- `id`, `babyId`, `type`, `startTime`, `endTime`, `durationSeconds`, `notes`, `isVerified`

**活动类型 (type)：**
- 0 = Eat (吃/喂养)
- 1 = Activity (玩/活动)
- 2 = Sleep (睡眠)
- 3 = Poop (排泄)

**专属字段：**
- 喂养：`eatingMethod`, `breastSide`, `breastDurationMinutes`, `formulaAmountMl`, `foodType`
- 睡眠：`sleepQuality`, `sleepLocation`, `sleepAssistMethod`
- 活动：`activityType`, `mood`
- 排泄：`diaperType`, `stoolColor`, `stoolTexture`

#### 同步字段

需要同步的用户数据表包含以下字段：
- `serverId` - 服务器ID
- `deviceId` - 创建设备标识
- `syncStatus` - 同步状态 (0=已同步, 1=待上传, 2=待下载, 3=冲突)
- `version` - 数据版本号

#### 软删除字段

支持软删除的表包含以下字段：
- `isDeleted` - 是否已删除
- `deletedAt` - 删除时间

### Database Usage

```dart
// Initialize database
final db = AppDatabase();

// The database automatically creates tables on first run
// Schema version is managed in database.dart

// Don't forget to close when done
db.close();
```

**Code Generation**: After modifying database tables, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Key Patterns

- **State management**: Riverpod (`flutter_riverpod`) for reactive state management
- **Database**: Drift (SQLite ORM) for local data persistence
- **Immutable models**: Freezed for immutable data classes with code generation
- **JSON serialization**: json_serializable for JSON encoding/decoding
- **Device ID**: UUID v4 stored in SharedPreferences
- **Testing**: Uses `flutter_test` package with `WidgetTester` for widget tests

### Provider Architecture

应用使用 Riverpod 进行状态管理，Provider 层直接调用 Database，不引入额外的 Repository 层。

#### Provider 依赖关系

```
databaseProvider (AppDatabase 单例)
    │
    ├── settingsProvider (SharedPreferences 设置)
    │       │
    │       └── currentBabyProvider (当前宝宝状态)
    │               │
    │               ├── timelineProvider (时间线数据)
    │               └── statsProvider (统计数据)
    │
    ├── babiesProvider (宝宝列表)
    ├── familyProvider (家庭组信息)
    └── syncProvider (同步状态)
```

#### 核心 Provider

| Provider | 类型 | 说明 |
|----------|------|------|
| `databaseProvider` | `Provider<AppDatabase>` | 数据库单例，自动管理生命周期 |
| `settingsProvider` | `NotifierProvider<SettingsNotifier, AsyncValue<Settings>>` | 应用设置（当前宝宝ID、上次同步时间） |
| `babiesProvider` | `StreamProvider<List<Baby>>` | 宝宝列表（实时更新） |
| `currentBabyProvider` | `NotifierProvider<CurrentBabyNotifier, CurrentBabyState>` | 当前选中的宝宝 |
| `familyProvider` | `StreamProvider<Family?>` | 当前家庭组信息 |
| `timelineProvider` | `FutureProvider.family<List<ActivityRecord>, TimelineQuery>` | 时间线数据（按日期查询） |
| `statsProvider` | `FutureProvider.family<StatsData, StatsQuery>` | 统计数据（日/周/月） |
| `syncProvider` | `NotifierProvider<SyncNotifier, SyncState>` | 同步状态管理 |

#### Provider 使用示例

```dart
// 在 Widget 中使用 Provider
class BabyListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final babiesAsync = ref.watch(babiesProvider);

    return babiesAsync.when(
      data: (babies) => ListView.builder(
        itemCount: babies.length,
        itemBuilder: (context, index) => ListTile(title: Text(babies[index].name)),
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

// 选择当前宝宝
await ref.read(currentBabyProvider.notifier).selectBaby(baby);

// 查询今日时间线
final timeline = await ref.read(timelineProvider(TimelineQuery(
  babyId: 1,
  date: DateTime.now(),
)).future);

// 获取今日统计
final stats = await ref.read(todayStatsProvider(1).future);
```

#### 文件结构

```
lib/
  providers/
    providers.dart              # Barrel export
    database_provider.dart      # 数据库单例
    settings_provider.dart      # SharedPreferences 设置
    babies_provider.dart        # 宝宝列表
    current_baby_provider.dart  # 当前宝宝状态
    family_provider.dart        # 家庭组状态
    timeline_provider.dart      # 时间线数据
    stats_provider.dart         # 统计数据
    sync_provider.dart          # 同步状态
```

### Dependencies

#### Core Dependencies
- `flutter` (SDK) - core framework
- `cupertino_icons` - iOS-style icons
- `flutter_riverpod` - state management
- `drift` + `drift_flutter` - SQLite ORM database
- `fl_chart` - charts and graphs
- `freezed_annotation` - immutable data class annotations
- `json_annotation` - JSON serialization annotations
- `flutter_skill` - MCP Server SDK for AI-driven automation
- `uuid` - UUID generation for device identifiers
- `shared_preferences` - persistent key-value storage

#### Development Dependencies
- `flutter_test` - testing framework
- `flutter_lints` - code analysis (see `analysis_options.yaml`)
- `build_runner` - code generation runner
- `drift_dev` - Drift code generator
- `freezed` - Freezed code generator
- `json_serializable` - JSON serialization generator

### Analysis

Code uses `flutter_lints` preset with additional rules (see `analysis_options.yaml`):
- `avoid_print: warning`
- `prefer_const_constructors: warning`
- `prefer_const_declarations: warning`
- `avoid_relative_lib_imports: error`
- `always_declare_return_types: warning`

Run `flutter analyze` to check for issues.

总是用中文回答！