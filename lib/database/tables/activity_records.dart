import 'package:drift/drift.dart';

/// 活动类型枚举
///
/// E.A.S.Y 育儿法的四种活动类型：
/// - Eat (0): 吃/喂养
/// - Activity (1): 玩/活动
/// - Sleep (2): 睡眠
/// - Poop (3): 排泄
enum ActivityType {
  eat(0),
  activity(1),
  sleep(2),
  poop(3);

  const ActivityType(this.value);
  final int value;
}

/// 喂养方式枚举
enum EatingMethod {
  breast(0), // 母乳
  formula(1), // 奶粉
  solid(2); // 辅食

  const EatingMethod(this.value);
  final int value;
}

/// 喂奶侧别枚举
enum BreastSide {
  left(0), // 左侧
  right(1), // 右侧
  both(2); // 双侧

  const BreastSide(this.value);
  final int value;
}

/// 接种部位枚举
enum InjectionSite {
  leftUpperArm(0), // 左上臂
  rightUpperArm(1), // 右上臂
  leftThigh(2), // 左大腿
  rightThigh(3), // 右大腿
  oral(4), // 口服
  other(5); // 其他

  const InjectionSite(this.value);
  final int value;
}

/// 活动记录表定义
///
/// 存储宝宝的 E.A.S.Y 活动记录，采用混合设计（公共字段 + 专属字段）。
/// 支持软删除和同步字段。
class ActivityRecords extends Table {
  // ============ 公共字段 ============

  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 宝宝ID
  IntColumn get babyId => integer()();

  /// 活动类型：0=E吃、1=A玩、2=S睡、3=P排泄
  IntColumn get type => integer()();

  /// 开始时间
  DateTimeColumn get startTime => dateTime()();

  /// 结束时间
  DateTimeColumn get endTime => dateTime().nullable()();

  /// 时长（秒）
  IntColumn get durationSeconds => integer().nullable()();

  /// 备注
  TextColumn get notes => text().nullable()();

  /// 是否已校对（用户编辑过）
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();

  /// 活动状态：0=进行中、1=已完成（默认）
  IntColumn get status => integer().withDefault(const Constant(1))();

  // ============ 喂养专属字段（type=0）============

  /// 喂养方式：0=母乳、1=奶粉、2=辅食
  IntColumn get eatingMethod => integer().nullable()();

  /// 母乳喂养侧：0=左、1=右、2=双侧
  IntColumn get breastSide => integer().nullable()();

  /// 母乳喂养时长（分钟）
  IntColumn get breastDurationMinutes => integer().nullable()();

  /// 奶粉量（ml）
  IntColumn get formulaAmountMl => integer().nullable()();

  /// 辅食类型
  TextColumn get foodType => text().nullable()();

  // ============ 睡眠专属字段（type=2）============

  /// 睡眠质量：0=差、1=一般、2=好
  IntColumn get sleepQuality => integer().nullable()();

  /// 睡眠地点：0=婴儿床、1=父母床、2=推车、3=其他
  IntColumn get sleepLocation => integer().nullable()();

  /// 入睡辅助方式：0=无、1=安抚奶嘴、2=摇篮、3=怀抱
  IntColumn get sleepAssistMethod => integer().nullable()();

  // ============ 活动专属字段（type=1）============

  /// 活动类型：0=趴着、1=翻身、2=坐、3=爬、4=站、5=走、6=户外、7=游泳、8=其他
  IntColumn get activityType => integer().nullable()();

  /// 心情：0=开心、1=一般、2=不开心
  IntColumn get mood => integer().nullable()();

  // ============ 排泄专属字段（type=3）============

  /// 尿布类型：0=尿、1=屎、2=混合
  IntColumn get diaperType => integer().nullable()();

  /// 大便颜色：0=黄色、1=绿色、2=棕色、3=黑色、4=其他
  IntColumn get stoolColor => integer().nullable()();

  /// 大便质地：0=正常、1=稀、2=干硬
  IntColumn get stoolTexture => integer().nullable()();

  // ============ 同步字段 ============

  /// 服务器ID（用于同步）
  TextColumn get serverId => text().nullable()();

  /// 设备ID（创建设备标识）
  TextColumn get deviceId => text().nullable()();

  /// 同步状态：0=已同步、1=待上传、2=待下载、3=冲突
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  /// 数据版本号
  IntColumn get version => integer().withDefault(const Constant(1))();

  // ============ 软删除字段 ============

  /// 是否已删除（软删除标记）
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// 删除时间
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ============ 时间戳字段 ============

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}