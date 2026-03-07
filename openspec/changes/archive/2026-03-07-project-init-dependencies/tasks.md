## 1. SDK 版本验证

- [x] 1.1 验证 Flutter 环境变量配置 (`flutter --version`)
- [x] 1.2 验证 Android SDK 路径配置 (`flutter doctor`)
- [x] 1.3 验证 Android API 级别配置 (android/app/build.gradle)
- [x] 1.4 验证 Web 平台支持 (检查 index.html 和 manifest.json)

> **注意**: iOS 暂不开发（无 Mac 环境），后续有环境时再配置

## 2. 核心依赖添加

- [x] 2.1 添加 flutter_riverpod 依赖到 pubspec.yaml
- [x] 2.2 添加 riverpod_annotation 依赖到 pubspec.yaml
- [x] 2.3 添加 riverpod_generator 开发依赖到 pubspec.yaml
- [x] 2.4 添加 isar 依赖到 pubspec.yaml (使用 isar_community)
- [x] 2.5 添加 isar_flutter_libs 依赖到 pubspec.yaml (使用 isar_community_flutter_libs)
- [x] 2.6 添加 isar_generator 开发依赖到 pubspec.yaml (使用 isar_community_generator)
- [x] 2.7 添加 fl_chart 依赖到 pubspec.yaml
- [x] 2.8 添加 freezed_annotation 依赖到 pubspec.yaml
- [x] 2.9 添加 freezed 开发依赖到 pubspec.yaml
- [x] 2.10 添加 build_runner 开发依赖到 pubspec.yaml

## 3. 分析选项配置

- [x] 3.1 更新 analysis_options.yaml，扩展 flutter_lints 规则
- [x] 3.2 添加 avoid_print 规则（警告级别）
- [x] 3.3 添加 prefer_const_constructors 规则（警告级别）
- [x] 3.4 添加 prefer_const_declarations 规则（警告级别）
- [x] 3.5 添加 avoid_relative_lib_imports 规则（错误级别）
- [x] 3.6 添加 always_declare_return_types 规则（警告级别）

## 4. 依赖安装与验证

- [x] 4.1 运行 flutter pub get 安装所有依赖
- [x] 4.2 运行 flutter analyze 验证无静态分析错误
- [x] 4.3 运行 flutter pub run build_runner build 验证代码生成工作
- [x] 4.4 运行 flutter build web 验证应用可正常构建

## 5. 文档更新

- [x] 5.1 更新 CLAUDE.md，添加新依赖的说明
- [x] 5.2 创建项目架构说明文档（可选 - 已合并到 CLAUDE.md）