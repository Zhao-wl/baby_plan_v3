import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_plan_v3/database/database.dart';
import 'package:baby_plan_v3/providers/vaccine_provider.dart';
import 'package:baby_plan_v3/widgets/common/half_screen_sheet.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 接种部位选项
enum InjectionSite {
  leftThigh(0, '左大腿'),
  rightThigh(1, '右大腿'),
  leftArm(2, '左上臂'),
  rightArm(3, '右上臂'),
  oral(4, '口服'),
  other(5, '其他');

  const InjectionSite(this.value, this.label);
  final int value;
  final String label;
}

/// 接种反应选项
const List<String> kReactionOptions = [
  '低烧',
  '嗜睡',
  '发热不退',
  '接种处红肿',
];

/// 接种记录录入弹窗
class VaccineRecordSheet extends ConsumerStatefulWidget {
  /// 疫苗信息
  final VaccineLibraryData vaccine;

  /// 接种记录（编辑模式）
  final VaccineRecord? existingRecord;

  const VaccineRecordSheet({
    super.key,
    required this.vaccine,
    this.existingRecord,
  });

  /// 显示接种记录弹窗
  static Future<bool?> show({
    required BuildContext context,
    required VaccineLibraryData vaccine,
    VaccineRecord? existingRecord,
  }) {
    final sheetKey = GlobalKey<_VaccineRecordSheetState>();

    return HalfScreenSheet.show<bool>(
      context: context,
      builder: (context) => VaccineRecordSheet(
        key: sheetKey,
        vaccine: vaccine,
        existingRecord: existingRecord,
      ),
      hasUnsavedChanges: () {
        return sheetKey.currentState?.hasUnsavedChanges ?? false;
      },
    );
  }

  @override
  ConsumerState<VaccineRecordSheet> createState() => _VaccineRecordSheetState();
}

class _VaccineRecordSheetState extends ConsumerState<VaccineRecordSheet> {
  // 表单字段
  late DateTime _actualDate;
  InjectionSite? _injectionSite;
  final Set<String> _selectedReactions = {};
  final _batchNumberController = TextEditingController();
  final _notesController = TextEditingController();

  // 初始值（用于检测变化）
  late final DateTime _initialDate;

  @override
  void initState() {
    super.initState();
    // 初始化默认值
    _actualDate = widget.existingRecord?.actualDate ?? DateTime.now();
    _initialDate = _actualDate;

    // 编辑模式：预填充数据
    if (widget.existingRecord != null) {
      final record = widget.existingRecord!;
      if (record.injectionSite != null) {
        _injectionSite = InjectionSite.values.firstWhere(
          (s) => s.value == record.injectionSite,
          orElse: () => InjectionSite.leftThigh,
        );
      }
      _batchNumberController.text = record.batchNumber ?? '';
      _notesController.text = record.notes ?? '';
    }
  }

  @override
  void dispose() {
    _batchNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// 是否有未保存的数据
  bool get hasUnsavedChanges {
    return _actualDate != _initialDate ||
        _injectionSite != null ||
        _selectedReactions.isNotEmpty ||
        _batchNumberController.text.isNotEmpty ||
        _notesController.text.isNotEmpty;
  }

  /// 保存接种记录
  Future<void> _saveRecord() async {
    final success = await ref.read(vaccineScheduleProvider.notifier).saveVaccineRecord(
          vaccineLibraryId: widget.vaccine.id,
          actualDate: _actualDate,
          batchNumber: _batchNumberController.text.isEmpty
              ? null
              : _batchNumberController.text,
          injectionSite: _injectionSite?.value,
          reactionDetail: _selectedReactions.isEmpty
              ? null
              : _selectedReactions.join('、'),
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('接种记录保存成功'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('保存失败，请重试'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 选择接种日期
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _actualDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _actualDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 标题
        Text(
          '${widget.vaccine.name}（第${widget.vaccine.doseIndex}针）',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.paddingLg),

        // 接种日期
        _buildSection(
          '接种日期',
          Row(
            children: [
              Text(
                '${_actualDate.year}年${_actualDate.month}月${_actualDate.day}日',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: _selectDate,
                child: const Text('修改'),
              ),
            ],
          ),
        ),

        // 接种部位
        _buildSection(
          '接种部位',
          Wrap(
            spacing: AppSpacing.paddingSm,
            runSpacing: AppSpacing.paddingSm,
            children: InjectionSite.values.map((site) {
              final isSelected = _injectionSite == site;
              return _buildSelectChip(
                label: site.label,
                isSelected: isSelected,
                onTap: () => setState(() => _injectionSite = site),
              );
            }).toList(),
          ),
        ),

        // 接种反应
        _buildSection(
          '接种反应（可选）',
          Wrap(
            spacing: AppSpacing.paddingSm,
            runSpacing: AppSpacing.paddingSm,
            children: kReactionOptions.map((reaction) {
              final isSelected = _selectedReactions.contains(reaction);
              return _buildSelectChip(
                label: reaction,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedReactions.remove(reaction);
                    } else {
                      _selectedReactions.add(reaction);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),

        // 疫苗批号
        _buildSection(
          '疫苗批号（可选）',
          TextField(
            controller: _batchNumberController,
            decoration: InputDecoration(
              hintText: '可在此输入或扫码录入疫苗批号',
              hintStyle: TextStyle(
                color: colorScheme.outline,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMd,
                vertical: AppSpacing.paddingSm,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.paddingLg),

        // 保存按钮
        FilledButton(
          onPressed: _saveRecord,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
          ),
          child: const Text('保存接种记录'),
        ),
      ],
    );
  }

  /// 构建表单区块
  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppSpacing.paddingSm),
          child,
        ],
      ),
    );
  }

  /// 构建选择芯片
  Widget _buildSelectChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}