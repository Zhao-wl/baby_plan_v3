import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_skill/flutter_skill.dart';
import 'database/database.dart';
import 'providers/providers.dart';
import 'theme/app_theme.dart';

void main() {
  if (kDebugMode) FlutterSkillBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'E.A.S.Y. 育儿助手',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const DatabaseTestPage(),
    );
  }
}

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({super.key});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  AppDatabase? _db;
  String _status = '正在初始化数据库...';
  int _recordCount = 0;
  String? _performanceResult;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      _db = AppDatabase();
      // 触发数据库创建
      await _db!.getTestRecordCount();
      setState(() {
        _status = '数据库初始化成功';
      });
      await _refreshRecordCount();
    } catch (e) {
      setState(() {
        _status = '数据库初始化失败: $e';
      });
    }
  }

  Future<void> _refreshRecordCount() async {
    if (_db == null) return;
    final count = await _db!.getTestRecordCount();
    setState(() {
      _recordCount = count;
    });
  }

  Future<void> _testPerformance() async {
    if (_db == null) return;

    setState(() {
      _isLoading = true;
      _performanceResult = null;
    });

    try {
      // 先清空现有记录
      await _db!.clearTestRecords();

      // 测试插入 1000 条记录
      final elapsed = await _db!.testInsertPerformance(1000);
      await _refreshRecordCount();

      const targetMs = kIsWeb ? 1000 : 500;
      final passed = elapsed < targetMs;

      setState(() {
        _performanceResult =
            '插入 1000 条记录耗时: ${elapsed}ms\n'
            '目标: < ${targetMs}ms\n'
            '结果: ${passed ? "✓ 通过" : "✗ 未达标"}';
      });
    } catch (e) {
      setState(() {
        _performanceResult = '测试失败: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearRecords() async {
    if (_db == null) return;
    await _db!.clearTestRecords();
    await _refreshRecordCount();
    setState(() {
      _performanceResult = null;
    });
  }

  @override
  void dispose() {
    _db?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据库集成测试'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '数据库状态',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('状态: $_status'),
                    const Text('平台: Web'),
                    Text('测试记录数: $_recordCount'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_performanceResult != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '性能测试结果',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(_performanceResult!),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testPerformance,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.speed),
                  label: const Text('性能测试 (1000条)'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _clearRecords,
                  icon: const Icon(Icons.delete),
                  label: const Text('清空记录'),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '数据库文件: baby_plan.sqlite',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}