import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../common/half_screen_sheet.dart';

/// 宝宝添加表单弹窗
///
/// 显示简化的宝宝信息表单，包含姓名、性别、出生日期三个字段。
class BabyAddSheet extends ConsumerStatefulWidget {
  const BabyAddSheet({super.key});

  /// 显示宝宝添加弹窗
  static Future<void> show(BuildContext context) {
    // 使用 GlobalKey 来访问内部状态
    final sheetKey = GlobalKey<_BabyAddSheetState>();

    return HalfScreenSheet.show(
      context: context,
      title: '放弃添加？',
      discardMessage: '您已填写了部分信息，关闭后将丢失这些数据。',
      hasUnsavedChanges: () {
        final state = sheetKey.currentState;
        return state?.hasUnsavedChanges() ?? false;
      },
      builder: (context) => BabyAddSheet(key: sheetKey),
    );
  }

  @override
  ConsumerState<BabyAddSheet> createState() => _BabyAddSheetState();
}

class _BabyAddSheetState extends ConsumerState<BabyAddSheet> {
  /// 姓名控制器
  final _nameController = TextEditingController();

  /// 性别选择（0=男、1=女）
  int _selectedGender = 0;

  /// 出生日期
  DateTime _selectedDate = DateTime.now();

  /// 表单键
  final _formKey = GlobalKey<FormState>();

  /// 是否正在保存
  bool _isSaving = false;

  /// 错误信息
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 检测是否有未保存数据
  bool hasUnsavedChanges() {
    return _nameController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            '添加宝宝',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // 姓名输入框
          _buildNameField(colorScheme),
          const SizedBox(height: 16),

          // 性别选择
          _buildGenderSelection(colorScheme, textTheme),
          const SizedBox(height: 16),

          // 出生日期选择
          _buildBirthDateField(colorScheme, textTheme),
          const SizedBox(height: 24),

          // 错误信息
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              style: TextStyle(color: colorScheme.error, fontSize: 14),
            ),
            const SizedBox(height: 16),
          ],

          // 保存按钮
          _buildSaveButton(colorScheme),
        ],
      ),
    );
  }

  /// 构建姓名输入框
  Widget _buildNameField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: '宝宝姓名',
        hintText: '请输入宝宝姓名',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.child_care_outlined),
        counterText: '${_nameController.text.length}/50',
      ),
      maxLength: 50,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '请输入宝宝姓名';
        }
        if (value.length > 50) {
          return '姓名不能超过50个字符';
        }
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }

  /// 构建性别选择
  Widget _buildGenderSelection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '性别',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                label: '男宝',
                icon: Icons.boy_outlined,
                isSelected: _selectedGender == 0,
                onTap: () => setState(() => _selectedGender = 0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _GenderOption(
                label: '女宝',
                icon: Icons.girl_outlined,
                isSelected: _selectedGender == 1,
                onTap: () => setState(() => _selectedGender = 1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建出生日期选择
  Widget _buildBirthDateField(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '出生日期',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: colorScheme.onSurface),
                const SizedBox(width: 12),
                Text(
                  _formatDate(_selectedDate),
                  style: textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: colorScheme.outline),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建保存按钮
  Widget _buildSaveButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _isSaving ? null : _handleSave,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('添加宝宝'),
      ),
    );
  }

  /// 选择日期
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 10), // 最小10年前
      lastDate: now, // 最大今天（禁止未来日期）
      locale: const Locale('zh', 'CN'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  /// 处理保存
  Future<void> _handleSave() async {
    // 验证表单
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 检查日期是否在未来
    if (_selectedDate.isAfter(DateTime.now())) {
      setState(() {
        _errorMessage = '出生日期不能晚于今天';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      // 调用 Provider 保存数据
      await ref.read(babiesProvider.notifier).addBaby(
            name: _nameController.text.trim(),
            gender: _selectedGender,
            birthDate: _selectedDate,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('宝宝添加成功')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '保存失败：$e';
        _isSaving = false;
      });
    }
  }
}

/// 性别选项组件
class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : null,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}