import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_plan_v3/database/tables/activity_records.dart';
import 'package:baby_plan_v3/providers/activity_data_change_provider.dart';
import 'package:baby_plan_v3/providers/current_baby_provider.dart';
import 'package:baby_plan_v3/providers/database_provider.dart';
import 'package:baby_plan_v3/providers/timeline_provider.dart';
import 'package:baby_plan_v3/providers/stats_provider.dart';
import 'package:baby_plan_v3/widgets/common/half_screen_sheet.dart';
import 'package:baby_plan_v3/widgets/common/form_fields.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';
import 'package:baby_plan_v3/database/database.dart';

/// 快捷记录弹窗
///
/// 支持新增和编辑模式：
/// - 新增模式：不传入 recordId，执行插入操作
/// - 编辑模式：传入 recordId，执行更新操作
class QuickRecordSheet extends ConsumerStatefulWidget {
  /// 活动类型
  final ActivityType activityType;

  /// 开始时间（可选，用于计时结束场景）
  final DateTime? startTime;

  /// 结束时间（可选，用于计时结束场景）
  final DateTime? endTime;

  /// 编辑模式：传入现有记录的 ID
  final int? recordId;

  /// 编辑模式：传入现有记录数据进行预填充
  final ActivityRecord? existingRecord;

  const QuickRecordSheet({
    super.key,
    required this.activityType,
    this.startTime,
    this.endTime,
    this.recordId,
    this.existingRecord,
  });

  /// 显示快捷记录弹窗（新增模式）
  static Future<void> show({
    required BuildContext context,
    required ActivityType activityType,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    final sheetKey = GlobalKey<_QuickRecordSheetState>();

    return HalfScreenSheet.show(
      context: context,
      builder: (context) => QuickRecordSheet(
        key: sheetKey,
        activityType: activityType,
        startTime: startTime,
        endTime: endTime,
      ),
      hasUnsavedChanges: () {
        return sheetKey.currentState?.hasUnsavedChanges ?? false;
      },
    );
  }

  /// 显示编辑弹窗（编辑模式）
  static Future<void> showEdit({
    required BuildContext context,
    required ActivityRecord record,
  }) {
    final sheetKey = GlobalKey<_QuickRecordSheetState>();
    final activityType = ActivityType.values.firstWhere(
      (t) => t.value == record.type,
      orElse: () => ActivityType.eat,
    );

    return HalfScreenSheet.show(
      context: context,
      builder: (context) => QuickRecordSheet(
        key: sheetKey,
        activityType: activityType,
        recordId: record.id,
        existingRecord: record,
      ),
      hasUnsavedChanges: () {
        return sheetKey.currentState?.hasUnsavedChanges ?? false;
      },
    );
  }

  @override
  ConsumerState<QuickRecordSheet> createState() => _QuickRecordSheetState();
}

class _QuickRecordSheetState extends ConsumerState<QuickRecordSheet> {
  final _formKey = GlobalKey<FormState>();

  // 公共字段
  late DateTime _startTime;
  DateTime? _endTime;
  String? _notes;

  // 喂养专属字段
  EatingMethod? _eatingMethod;
  BreastSide? _breastSide;
  int? _breastDurationMinutes;
  int? _formulaAmountMl;
  String? _foodType;

  // 睡眠专属字段
  int? _sleepQuality;
  int? _sleepLocation;
  int? _sleepAssistMethod;

  // 活动专属字段
  int? _activityType;
  int? _mood;

  // 排泄专属字段
  int? _diaperType;
  int? _stoolColor;
  int? _stoolTexture;

  // 初始值（用于检测变化）
  late final DateTime _initialStartTime;
  late final DateTime? _initialEndTime;

  @override
  void initState() {
    super.initState();
    // 编辑模式：预填充现有数据
    if (widget.existingRecord != null) {
      final record = widget.existingRecord!;
      _startTime = record.startTime;
      _endTime = record.endTime;
      _notes = record.notes;
      // 喂养字段
      if (record.eatingMethod != null) {
        _eatingMethod = EatingMethod.values.firstWhere(
          (e) => e.value == record.eatingMethod,
          orElse: () => EatingMethod.breast,
        );
      }
      if (record.breastSide != null) {
        _breastSide = BreastSide.values.firstWhere(
          (e) => e.value == record.breastSide,
          orElse: () => BreastSide.left,
        );
      }
      _breastDurationMinutes = record.breastDurationMinutes;
      _formulaAmountMl = record.formulaAmountMl;
      _foodType = record.foodType;
      // 睡眠字段
      _sleepQuality = record.sleepQuality;
      _sleepLocation = record.sleepLocation;
      _sleepAssistMethod = record.sleepAssistMethod;
      // 活动字段
      _activityType = record.activityType;
      _mood = record.mood;
      // 排泄字段
      _diaperType = record.diaperType;
      _stoolColor = record.stoolColor;
      _stoolTexture = record.stoolTexture;
    } else {
      // 新增模式
      _startTime = widget.startTime ?? DateTime.now();
      _endTime = widget.endTime;
    }
    _initialStartTime = _startTime;
    _initialEndTime = _endTime;
  }

  /// 是否有未保存的数据
  bool get hasUnsavedChanges {
    if (_startTime != _initialStartTime) return true;
    if (_endTime != _initialEndTime) return true;
    if (_notes != null && _notes!.isNotEmpty) return true;
    if (_eatingMethod != null) return true;
    if (_breastSide != null) return true;
    if (_breastDurationMinutes != null) return true;
    if (_formulaAmountMl != null) return true;
    if (_foodType != null && _foodType!.isNotEmpty) return true;
    if (_sleepQuality != null) return true;
    if (_sleepLocation != null) return true;
    if (_sleepAssistMethod != null) return true;
    if (_activityType != null) return true;
    if (_mood != null) return true;
    if (_diaperType != null) return true;
    if (_stoolColor != null) return true;
    if (_stoolTexture != null) return true;
    return false;
  }

  /// 获取活动类型名称（含新增/编辑前缀）
  String get _activityTypeName {
    final action = _isEditMode ? '编辑' : '新增';
    switch (widget.activityType) {
      case ActivityType.eat:
        return '$action吃奶记录';
      case ActivityType.activity:
        return '$action玩耍记录';
      case ActivityType.sleep:
        return '$action睡眠记录';
      case ActivityType.poop:
        return '$action排泄记录';
    }
  }

  /// 是否为编辑模式
  bool get _isEditMode => widget.recordId != null;

  /// 快速保存（仅保存时间）
  Future<void> _quickSave() async {
    if (_isEditMode) {
      await _quickUpdate();
    } else {
      await _quickInsert();
    }
  }

  /// 快速插入（新增模式）
  Future<void> _quickInsert() async {
    final currentBaby = ref.read(currentBabyProvider).baby;
    if (currentBaby == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择宝宝'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final db = ref.read(databaseProvider);

    try {
      await db.into(db.activityRecords).insert(
            ActivityRecordsCompanion.insert(
              babyId: currentBaby.id,
              type: widget.activityType.value,
              startTime: _startTime,
              endTime: drift.Value(_endTime),
              durationSeconds: drift.Value(
                _endTime != null ? _endTime!.difference(_startTime).inSeconds : null,
              ),
              isVerified: const drift.Value(false),
            ),
          );

      if (mounted) {
        // 触发数据变化通知
        ref.read(activityDataChangeProvider.notifier).state++;
        _refreshData();
        Navigator.of(context).pop();
        _showSuccessMessage(isUpdate: false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 快速更新（编辑模式）
  Future<void> _quickUpdate() async {
    final db = ref.read(databaseProvider);

    try {
      // 获取现有记录以保留其他字段
      final existing = widget.existingRecord;
      if (existing == null) return;

      await db.update(db.activityRecords).replace(
            existing.copyWith(
              startTime: _startTime,
              endTime: drift.Value(_endTime ?? _startTime),
              durationSeconds: drift.Value(
                _endTime != null ? _endTime!.difference(_startTime).inSeconds : null,
              ),
              syncStatus: 1, // 标记为待上传
            ),
          );

      if (mounted) {
        // 触发数据变化通知
        ref.read(activityDataChangeProvider.notifier).state++;
        _refreshData();
        Navigator.of(context).pop();
        _showSuccessMessage(isUpdate: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新失败: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 完整保存（保存所有字段）
  Future<void> _fullSave() async {
    if (_isEditMode) {
      await _fullUpdate();
    } else {
      await _fullInsert();
    }
  }

  /// 完整插入（新增模式）
  Future<void> _fullInsert() async {
    // 表单校验
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
    } else {
      // 校验失败，显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写必填项'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentBaby = ref.read(currentBabyProvider).baby;
    if (currentBaby == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择宝宝'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final db = ref.read(databaseProvider);

    try {
      await db.into(db.activityRecords).insert(
            ActivityRecordsCompanion.insert(
              babyId: currentBaby.id,
              type: widget.activityType.value,
              startTime: _startTime,
              endTime: drift.Value(_endTime),
              durationSeconds: drift.Value(
                _endTime != null ? _endTime!.difference(_startTime).inSeconds : null,
              ),
              notes: drift.Value(_notes),
              isVerified: const drift.Value(true),
              eatingMethod: drift.Value(_eatingMethod?.value),
              breastSide: drift.Value(_breastSide?.value),
              breastDurationMinutes: drift.Value(_breastDurationMinutes),
              formulaAmountMl: drift.Value(_formulaAmountMl),
              foodType: drift.Value(_foodType),
              sleepQuality: drift.Value(_sleepQuality),
              sleepLocation: drift.Value(_sleepLocation),
              sleepAssistMethod: drift.Value(_sleepAssistMethod),
              activityType: drift.Value(_activityType),
              mood: drift.Value(_mood),
              diaperType: drift.Value(_diaperType),
              stoolColor: drift.Value(_stoolColor),
              stoolTexture: drift.Value(_stoolTexture),
            ),
          );

      if (mounted) {
        // 触发数据变化通知
        ref.read(activityDataChangeProvider.notifier).state++;
        _refreshData();
        Navigator.of(context).pop();
        _showSuccessMessage(isUpdate: false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 完整更新（编辑模式）
  Future<void> _fullUpdate() async {
    // 表单校验
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写必填项'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final db = ref.read(databaseProvider);

    try {
      final existing = widget.existingRecord;
      if (existing == null) return;

      await db.update(db.activityRecords).replace(
            existing.copyWith(
              startTime: _startTime,
              endTime: drift.Value(_endTime ?? _startTime),
              durationSeconds: drift.Value(
                _endTime != null ? _endTime!.difference(_startTime).inSeconds : null,
              ),
              notes: drift.Value(_notes),
              isVerified: true,
              eatingMethod: drift.Value(_eatingMethod?.value),
              breastSide: drift.Value(_breastSide?.value),
              breastDurationMinutes: drift.Value(_breastDurationMinutes),
              formulaAmountMl: drift.Value(_formulaAmountMl),
              foodType: drift.Value(_foodType),
              sleepQuality: drift.Value(_sleepQuality),
              sleepLocation: drift.Value(_sleepLocation),
              sleepAssistMethod: drift.Value(_sleepAssistMethod),
              activityType: drift.Value(_activityType),
              mood: drift.Value(_mood),
              diaperType: drift.Value(_diaperType),
              stoolColor: drift.Value(_stoolColor),
              stoolTexture: drift.Value(_stoolTexture),
              syncStatus: 1, // 标记为待上传
            ),
          );

      if (mounted) {
        // 触发数据变化通知
        ref.read(activityDataChangeProvider.notifier).state++;
        _refreshData();
        Navigator.of(context).pop();
        _showSuccessMessage(isUpdate: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新失败: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 刷新相关数据
  void _refreshData() {
    final currentBaby = ref.read(currentBabyProvider).baby;
    if (currentBaby == null) return;

    // 刷新今日时间线
    final query = TimelineQuery(
      babyId: currentBaby.id,
      date: DateTime.now(),
    );
    ref.invalidate(timelineProvider(query));

    // 刷新今日统计
    final statsQuery = StatsQuery(
      babyId: currentBaby.id,
      date: DateTime.now(),
      period: StatsPeriod.day,
    );
    ref.invalidate(statsProvider(statsQuery));
  }
  void _showSuccessMessage({bool isUpdate = false}) {
    final action = isUpdate ? '更新' : '保存';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_activityTypeName${action}成功'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 构建表单字段
  List<Widget> _buildFormFields() {
    switch (widget.activityType) {
      case ActivityType.eat:
        return _buildEatFields();
      case ActivityType.activity:
        return _buildActivityFields();
      case ActivityType.sleep:
        return _buildSleepFields();
      case ActivityType.poop:
        return _buildPoopFields();
    }
  }

  /// 构建吃奶活动字段
  List<Widget> _buildEatFields() {
    return [
      TimePickerField(
        label: '开始时间',
        value: _startTime,
        onChanged: (value) => setState(() => _startTime = value ?? DateTime.now()),
        isRequired: true,
      ),
      TimePickerField(
        label: '结束时间',
        value: _endTime,
        placeholder: '未结束（可选）',
        onChanged: (value) => setState(() => _endTime = value),
      ),
      OptionSelectorField<EatingMethod>(
        label: '喂养方式',
        value: _eatingMethod,
        options: const [
          (EatingMethod.breast, '母乳'),
          (EatingMethod.formula, '奶粉'),
          (EatingMethod.solid, '辅食'),
        ],
        onChanged: (value) => setState(() => _eatingMethod = value),
      ),
      if (_eatingMethod == EatingMethod.breast) ...[
        OptionSelectorField<BreastSide>(
          label: '喂奶侧别',
          value: _breastSide,
          options: const [
            (BreastSide.left, '左侧'),
            (BreastSide.right, '右侧'),
            (BreastSide.both, '双侧'),
          ],
          onChanged: (value) => setState(() => _breastSide = value),
        ),
        NumberInputField(
          label: '喂养时长',
          value: _breastDurationMinutes,
          unit: '分钟',
          onChanged: (value) => setState(() => _breastDurationMinutes = value),
        ),
      ],
      if (_eatingMethod == EatingMethod.formula)
        NumberInputField(
          label: '奶粉量',
          value: _formulaAmountMl,
          unit: 'ml',
          onChanged: (value) => setState(() => _formulaAmountMl = value),
        ),
      if (_eatingMethod == EatingMethod.solid)
        TextInputField(
          label: '辅食类型',
          value: _foodType,
          hintText: '例如：米粉、蔬菜泥等',
          onChanged: (value) => setState(() => _foodType = value),
        ),
      TextInputField(
        label: '备注',
        value: _notes,
        hintText: '添加备注信息',
        maxLines: 2,
        onChanged: (value) => setState(() => _notes = value),
      ),
    ];
  }

  /// 构建玩耍活动字段
  List<Widget> _buildActivityFields() {
    return [
      TimePickerField(
        label: '开始时间',
        value: _startTime,
        onChanged: (value) => setState(() => _startTime = value ?? DateTime.now()),
        isRequired: true,
      ),
      TimePickerField(
        label: '结束时间',
        value: _endTime,
        placeholder: '未结束（可选）',
        onChanged: (value) => setState(() => _endTime = value),
      ),
      OptionSelectorField<int>(
        label: '活动类型',
        value: _activityType,
        options: const [
          (0, '趴着'),
          (1, '翻身'),
          (2, '坐'),
          (3, '爬'),
          (4, '站'),
          (5, '走'),
          (6, '户外'),
          (7, '游泳'),
          (8, '其他'),
        ],
        onChanged: (value) => setState(() => _activityType = value),
      ),
      OptionSelectorField<int>(
        label: '心情',
        value: _mood,
        options: const [
          (0, '开心'),
          (1, '一般'),
          (2, '不开心'),
        ],
        onChanged: (value) => setState(() => _mood = value),
      ),
      TextInputField(
        label: '备注',
        value: _notes,
        hintText: '添加备注信息',
        maxLines: 2,
        onChanged: (value) => setState(() => _notes = value),
      ),
    ];
  }

  /// 构建睡眠活动字段
  List<Widget> _buildSleepFields() {
    return [
      TimePickerField(
        label: '开始时间',
        value: _startTime,
        onChanged: (value) => setState(() => _startTime = value ?? DateTime.now()),
        isRequired: true,
      ),
      TimePickerField(
        label: '结束时间',
        value: _endTime,
        placeholder: '未结束（可选）',
        onChanged: (value) => setState(() => _endTime = value),
      ),
      OptionSelectorField<int>(
        label: '睡眠质量',
        value: _sleepQuality,
        options: const [
          (0, '差'),
          (1, '一般'),
          (2, '好'),
        ],
        onChanged: (value) => setState(() => _sleepQuality = value),
      ),
      OptionSelectorField<int>(
        label: '睡眠地点',
        value: _sleepLocation,
        options: const [
          (0, '婴儿床'),
          (1, '父母床'),
          (2, '推车'),
          (3, '其他'),
        ],
        onChanged: (value) => setState(() => _sleepLocation = value),
      ),
      OptionSelectorField<int>(
        label: '入睡辅助',
        value: _sleepAssistMethod,
        options: const [
          (0, '无'),
          (1, '安抚奶嘴'),
          (2, '摇篮'),
          (3, '怀抱'),
        ],
        onChanged: (value) => setState(() => _sleepAssistMethod = value),
      ),
      TextInputField(
        label: '备注',
        value: _notes,
        hintText: '添加备注信息',
        maxLines: 2,
        onChanged: (value) => setState(() => _notes = value),
      ),
    ];
  }

  /// 构建排泄活动字段
  List<Widget> _buildPoopFields() {
    return [
      TimePickerField(
        label: '时间',
        value: _startTime,
        onChanged: (value) => setState(() => _startTime = value ?? DateTime.now()),
        isRequired: true,
      ),
      OptionSelectorField<int>(
        label: '尿布类型',
        value: _diaperType,
        options: const [
          (0, '尿'),
          (1, '屎'),
          (2, '混合'),
        ],
        onChanged: (value) => setState(() => _diaperType = value),
      ),
      if (_diaperType == 1 || _diaperType == 2) ...[
        OptionSelectorField<int>(
          label: '大便颜色',
          value: _stoolColor,
          options: const [
            (0, '黄色'),
            (1, '绿色'),
            (2, '棕色'),
            (3, '黑色'),
            (4, '其他'),
          ],
          onChanged: (value) => setState(() => _stoolColor = value),
        ),
        OptionSelectorField<int>(
          label: '大便质地',
          value: _stoolTexture,
          options: const [
            (0, '正常'),
            (1, '稀'),
            (2, '干硬'),
          ],
          onChanged: (value) => setState(() => _stoolTexture = value),
        ),
      ],
      TextInputField(
        label: '备注',
        value: _notes,
        hintText: '添加备注信息',
        maxLines: 2,
        onChanged: (value) => setState(() => _notes = value),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 标题
        Text(
          _activityTypeName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.paddingLg),

        // 表单内容
        Flexible(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _buildFormFields(),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingLg),

        // 操作按钮
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _quickSave,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.lg,
                  ),
                ),
                child: Text(_isEditMode ? '快速更新' : '快速保存'),
              ),
            ),
            const SizedBox(width: AppSpacing.paddingMd),
            Expanded(
              child: FilledButton(
                onPressed: _fullSave,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.lg,
                  ),
                ),
                child: Text(_isEditMode ? '完整更新' : '完整保存'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
