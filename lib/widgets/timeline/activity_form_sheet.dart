import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../database/tables/activity_records.dart';
import '../../providers/activity_data_change_provider.dart';
import '../../providers/current_baby_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/timeline_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../common/form_fields.dart';
import '../common/half_screen_sheet.dart';

/// 活动记录表单弹窗
///
/// 支持选择活动类型并填写完整表单，用于时间线页面的 FAB 新增功能
class ActivityFormSheet extends ConsumerStatefulWidget {
  const ActivityFormSheet({super.key});

  /// 显示活动表单弹窗
  static Future<void> show(BuildContext context) {
    final sheetKey = GlobalKey<_ActivityFormSheetState>();

    return HalfScreenSheet.show(
      context: context,
      builder: (context) => ActivityFormSheet(key: sheetKey),
      hasUnsavedChanges: () {
        return sheetKey.currentState?.hasUnsavedChanges ?? false;
      },
    );
  }

  @override
  ConsumerState<ActivityFormSheet> createState() => _ActivityFormSheetState();
}

class _ActivityFormSheetState extends ConsumerState<ActivityFormSheet> {
  final _formKey = GlobalKey<FormState>();

  // 当前选中的活动类型
  ActivityType? _selectedActivityType;

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

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _initialStartTime = _startTime;
  }

  /// 是否有未保存的数据
  bool get hasUnsavedChanges {
    if (_selectedActivityType != null) return true;
    if (_startTime != _initialStartTime) return true;
    if (_endTime != null) return true;
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

  /// 获取活动类型颜色
  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.eat:
        return AppColors.eat;
      case ActivityType.activity:
        return AppColors.activity;
      case ActivityType.sleep:
        return AppColors.sleep;
      case ActivityType.poop:
        return AppColors.poop;
    }
  }

  /// 获取活动类型名称
  String _getActivityTypeName(ActivityType type) {
    switch (type) {
      case ActivityType.eat:
        return '吃奶';
      case ActivityType.activity:
        return '玩耍';
      case ActivityType.sleep:
        return '睡眠';
      case ActivityType.poop:
        return '排泄';
    }
  }

  /// 获取活动类型图标
  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.eat:
        return Icons.restaurant;
      case ActivityType.activity:
        return Icons.toys;
      case ActivityType.sleep:
        return Icons.bedtime;
      case ActivityType.poop:
        return Icons.baby_changing_station;
    }
  }

  /// 保存记录
  Future<void> _saveRecord() async {
    if (_selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择活动类型'),
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
              type: _selectedActivityType!.value,
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
              syncStatus: const drift.Value(1), // 标记为待上传
            ),
          );

      if (mounted) {
        // 触发数据变化通知
        ref.read(activityDataChangeProvider.notifier).notify();
        _refreshData();
        Navigator.of(context).pop();
        _showSuccessMessage();
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

  /// 显示成功提示
  void _showSuccessMessage() {
    final typeName = _getActivityTypeName(_selectedActivityType!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('新增$typeName记录成功'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 构建活动类型选择器
  Widget _buildActivityTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '选择活动类型',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.paddingSm),
        Wrap(
          spacing: AppSpacing.paddingSm,
          runSpacing: AppSpacing.paddingSm,
          children: ActivityType.values.map((type) {
            final isSelected = _selectedActivityType == type;
            final color = _getActivityColor(type);
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getActivityIcon(type),
                    size: 18,
                    color: isSelected ? Colors.white : color,
                  ),
                  const SizedBox(width: 4),
                  Text(_getActivityTypeName(type)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedActivityType = selected ? type : null;
                  // 重置专属字段
                  _eatingMethod = null;
                  _breastSide = null;
                  _breastDurationMinutes = null;
                  _formulaAmountMl = null;
                  _foodType = null;
                  _sleepQuality = null;
                  _sleepLocation = null;
                  _sleepAssistMethod = null;
                  _activityType = null;
                  _mood = null;
                  _diaperType = null;
                  _stoolColor = null;
                  _stoolTexture = null;
                });
              },
              selectedColor: color,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: color.withAlpha(26),
              side: BorderSide(
                color: isSelected ? color : color.withAlpha(77),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.paddingMd),
      ],
    );
  }

  /// 构建表单字段
  List<Widget> _buildFormFields() {
    if (_selectedActivityType == null) {
      return [];
    }

    final commonFields = [
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
    ];

    final specificFields = switch (_selectedActivityType!) {
      ActivityType.eat => _buildEatFields(),
      ActivityType.activity => _buildActivityFields(),
      ActivityType.sleep => _buildSleepFields(),
      ActivityType.poop => _buildPoopFields(),
    };

    final noteField = TextInputField(
      label: '备注',
      value: _notes,
      hintText: '添加备注信息',
      maxLines: 2,
      onChanged: (value) => setState(() => _notes = value),
    );

    return [...commonFields, ...specificFields, noteField];
  }

  /// 构建喂养字段
  List<Widget> _buildEatFields() {
    return [
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
    ];
  }

  /// 构建睡眠字段
  List<Widget> _buildSleepFields() {
    return [
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
    ];
  }

  /// 构建活动字段
  List<Widget> _buildActivityFields() {
    return [
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
    ];
  }

  /// 构建排泄字段
  List<Widget> _buildPoopFields() {
    return [
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
          '新增活动记录',
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
                children: [
                  // 活动类型选择器
                  _buildActivityTypeSelector(),
                  // 动态表单字段
                  ..._buildFormFields(),
                ],
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
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('取消'),
              ),
            ),
            const SizedBox(width: AppSpacing.paddingMd),
            Expanded(
              child: FilledButton(
                onPressed: _saveRecord,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('保存'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
