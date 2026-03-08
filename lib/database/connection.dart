import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// 打开数据库连接
///
/// 使用 drift_flutter 提供的跨平台连接方案：
/// - Android/iOS: 使用 sqlite3 原生库
/// - Web: 使用 sql.js (IndexedDB 存储)
QueryExecutor openConnection() {
  return driftDatabase(
    name: 'baby_plan',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}