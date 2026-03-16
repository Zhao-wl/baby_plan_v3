import 'package:drift/drift.dart' hide isNotNull, Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers/providers.dart';
import '../common/half_screen_sheet.dart';

/// 成长记录半屏弹窗
///
/// 提供快捷录入身高和体重的入口。
/// 至少需要填写一项才能保存。
class GrowthRecordSheet extends ConsumerStatefulWidget {
  const GrowthRecordSheet({super.key});

  /// 显示成长记录弹窗
  static Future<bool?> show(BuildContext context) {
    final sheetKey = GlobalKey<_GrowthRecordSheetState>();

    return HalfScreenSheet.show<bool>(
      context: context,
      builder: (context) => GrowthRecordSheet(key: sheetKey),
      title: '放弃填写？',
      discardMessage: '您已填写了部分信息，关闭后将丢失这些数据。',
      hasUnsavedChanges: () {
        return sheetKey.currentState?.hasUnsavedChanges ?? false;
      },
    );
  }

  @override
  ConsumerState<GrowthRecordSheet> createState() => _GrowthRecordSheetState();
}

class _GrowthRecordSheetState extends ConsumerState<GrowthRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  /// 是否有未保存的数据
  bool get hasUnsavedChanges {
    return _heightController.text.isNotEmpty ||
        _weightController.text.isNotEmpty;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final currentBabyId = ref.read(currentBabyIdProvider);
    if (currentBabyId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先添加宝宝')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final height = _heightController.text.isNotEmpty
          ? double.tryParse(_heightController.text)
          : null;
      final weight = _weightController.text.isNotEmpty
          ? double.tryParse(_weightController.text)
          : null;

      await db.into(db.growthRecords).insert(
            GrowthRecordsCompanion.insert(
              babyId: currentBabyId,
              recordDate: DateTime.now(),
              height: Value(height),
              weight: Value(weight),
            ),
          );

      if (mounted) {
        // 刷新相关 provider
        ref.invalidate(latestGrowthRecordProvider(currentBabyId));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('成长记录已保存'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '记录成长',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155), // slate-700
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '记录宝宝的身高体重，追踪成长曲线',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B), // slate-500
            ),
          ),
          const SizedBox(height: 24),

          // 身高输入
          TextFormField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: '身高',
              suffixText: 'cm',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final height = double.tryParse(value);
              if (height == null || height <= 0 || height > 200) {
                return '请输入有效身高 (1-200 cm)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 体重输入
          TextFormField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: '体重',
              suffixText: 'kg',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                // 至少填写一项的验证
                if (_heightController.text.isEmpty) {
                  return '请至少填写一项';
                }
                return null;
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0 || weight > 100) {
                return '请输入有效体重 (0.1-100 kg)';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // 保存按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF009688), // Teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                  : const Text(
                      '保存',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}