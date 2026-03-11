import 'package:drift/drift.dart' hide isNotNull, Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/tables/activity_records.dart';
import '../../providers/activity_data_change_provider.dart';
import '../../providers/current_baby_provider.dart';
import '../../providers/database_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../common/form_fields.dart';
import '../common/half_screen_sheet.dart';

/// 创建/编辑进行中活动表单弹窗
///
/// 长按快捷按钮时弹出，允许用户编辑活动详情。
/// 支持两种模式：
/// 1. 编辑模式：传入 draftRecordId，更新现有记录
/// 2. 创建模式：不传 draftRecordId，创建新记录
class OngoingActivityFormSheet extends ConsumerStatefulWidget {
  /// 活动类型（预设）
  final ActivityType activityType;

  /// 草稿记录 ID（可选）
  ///
  /// 如果提供，则更新现有记录而非创建新记录。
  /// 这用于长按快捷按钮时，计时器已创建草稿记录的场景。
  final int? draftRecordId;

  const OngoingActivityFormSheet({
    super.key,
    required this.activityType,
    this.draftRecordId,
  });

  /// 显示创建/编辑进行中活动表单弹窗
  ///
  /// 返回 true 表示成功保存，false/null 表示取消
  static Future<bool?> show({
    required BuildContext context,
    required ActivityType activityType,
    int? draftRecordId,
  }) {
    final sheetKey = GlobalKey<_OngoingActivityFormSheetState>();

    return HalfScreenSheet.show(
      context: context,
      builder: (context) => OngoingActivityFormSheet(
        key: sheetKey,
        activityType: activityType,
        draftRecordId: draftRecordId,
      ),
      hasUnsavedChanges: () {
        return sheetKey.currentState?.hasUnsavedChanges ?? false;
      },
    );
  }

  @override
  ConsumerState<OngoingActivityFormSheet> createState() =>
      _OngoingActivityFormSheetState();
}

class _OngoingActivityFormSheetState
    extends ConsumerState<OngoingActivityFormSheet> {
  // 开始时间
  late DateTime _startTime;

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

  // 备注
  String? _notes;

  // 初始值（用于检测变化）
  late final DateTime _initialStartTime;

  // 是否正在保存
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _initialStartTime = _startTime;
  }

  /// 是否有未保存的数据
  bool get hasUnsavedChanges {
    if (_startTime != _initialStartTime) return true;
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
    return switch (type) {
      ActivityType.eat => AppColors.eat,
      ActivityType.activity => AppColors.activity,
      ActivityType.sleep => AppColors.sleep,
      ActivityType.poop => AppColors.poop,
    };
  }

  /// 获取活动类型名称
  String _getActivityTypeName(ActivityType type) {
    return switch (type) {
      ActivityType.eat => '吃奶',
      ActivityType.activity => '玩耍',
      ActivityType.sleep => '睡眠',
      ActivityType.poop => '排泄',
    };
  }

  /// 获取活动类型图标
  IconData _getActivityIcon(ActivityType type) {
    return switch (type) {
      ActivityType.eat => Icons.restaurant,
      ActivityType.activity => Icons.toys,
      ActivityType.sleep => Icons.bedtime,
      ActivityType.poop => Icons.baby_changing_station,
    };
  }

  /// 保存进行中活动
  ///
  /// 如果有 draftRecordId，则更新现有记录；否则创建新记录。
  Future<void> _saveOngoingActivity() async {
    if (_isSaving) return;

    final currentBaby = ref.read(currentBabyProvider).baby;
    if (currentBaby == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请先选择宝宝'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    final db = ref.read(databaseProvider);

    try {
      if (widget.draftRecordId != null) {
        // 更新模式：更新现有草稿记录
        final existing = await (db.select(db.activityRecords)
              ..where((t) => t.id.equals(widget.draftRecordId!)))
            .getSingleOrNull();

        if (existing != null) {
          await db.update(db.activityRecords).replace(
                existing.copyWith(
                  startTime: _startTime,
                  eatingMethod: Value(_eatingMethod?.value),
                  breastSide: Value(_breastSide?.value),
                  breastDurationMinutes: Value(_breastDurationMinutes),
                  formulaAmountMl: Value(_formulaAmountMl),
                  foodType: Value(_foodType),
                  sleepQuality: Value(_sleepQuality),
                  sleepLocation: Value(_sleepLocation),
                  sleepAssistMethod: Value(_sleepAssistMethod),
                  activityType: Value(_activityType),
                  mood: Value(_mood),
                  diaperType: Value(_diaperType),
                  stoolColor: Value(_stoolColor),
                  stoolTexture: Value(_stoolTexture),
                  notes: Value(_notes),
                  syncStatus: 1, // 标记为待上传
                ),
              );
        }
      } else {
        // 创建模式：创建新的进行中活动
        await db.createOngoingActivityWithDetails(
          babyId: currentBaby.id,
          type: widget.activityType.value,
          startTime: _startTime,
          eatingMethod: _eatingMethod?.value,
          breastSide: _breastSide?.value,
          breastDurationMinutes: _breastDurationMinutes,
          formulaAmountMl: _formulaAmountMl,
          foodType: _foodType,
          sleepQuality: _sleepQuality,
          sleepLocation: _sleepLocation,
          sleepAssistMethod: _sleepAssistMethod,
          activityType: _activityType,
          mood: _mood,
          diaperType: _diaperType,
          stoolColor: _stoolColor,
          stoolTexture: _stoolTexture,
          notes: _notes,
        );
      }

      // 触发数据变更通知
      ref.read(activityDataChangeProvider.notifier).notify();

      if (mounted) {
        Navigator.of(context).pop(true); // 返回 true 表示成功保存
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
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  /// 显示成功提示
  void _showSuccessMessage() {
    final typeName = _getActivityTypeName(widget.activityType);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已开始记录$typeName'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 构建表单字段
  List<Widget> _buildFormFields() {
    final commonFields = [
      TimePickerField(
        label: '开始时间',
        value: _startTime,
        onChanged: (value) => setState(() => _startTime = value ?? DateTime.now()),
        isRequired: true,
      ),
    ];

    final specificFields = switch (widget.activityType) {
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
        onChanged: (value) => setState(() {
          _eatingMethod = value;
          // 切换方式时重置相关字段
          _breastSide = null;
          _breastDurationMinutes = null;
          _formulaAmountMl = null;
          _foodType = null;
        }),
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
          label: '目标时长',
          value: _breastDurationMinutes,
          unit: '分钟',
          onChanged: (value) => setState(() => _breastDurationMinutes = value),
        ),
      ],
      if (_eatingMethod == EatingMethod.formula)
        NumberInputField(
          label: '目标奶量',
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
        onChanged: (value) => setState(() {
          _diaperType = value;
          // 切换类型时重置相关字段
          if (value != 1 && value != 2) {
            _stoolColor = null;
            _stoolTexture = null;
          }
        }),
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
    final activityColor = _getActivityColor(widget.activityType);
    final activityName = _getActivityTypeName(widget.activityType);
    final activityIcon = _getActivityIcon(widget.activityType);
    final isEditMode = widget.draftRecordId != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 标题
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(activityIcon, color: activityColor, size: 24),
            const SizedBox(width: 8),
            Text(
              isEditMode ? '编辑$activityName' : '开始$activityName',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingSm),
        Text(
          isEditMode ? '编辑活动详情' : '编辑详情后开始记录',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.paddingLg),

        // 表单内容
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildFormFields(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingLg),

        // 操作按钮
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
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
                onPressed: _isSaving ? null : _saveOngoingActivity,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: activityColor,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEditMode ? '保存' : '开始'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}