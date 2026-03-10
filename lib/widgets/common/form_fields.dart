import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 通用选项选择器字段
class OptionSelectorField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<(T, String)> options;
  final void Function(T?) onChanged;
  final bool isRequired;

  const OptionSelectorField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: colorScheme.error),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingSm),
        Wrap(
          spacing: AppSpacing.paddingSm,
          runSpacing: AppSpacing.paddingSm,
          children: options.map((option) {
            final isSelected = value == option.$1;
            return FilterChip(
              label: Text(option.$2),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onChanged(option.$1);
                } else {
                  onChanged(null);
                }
              },
              selectedColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
              ),
              checkmarkColor: colorScheme.onPrimaryContainer,
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.paddingMd),
      ],
    );
  }
}

/// 通用时间选择器字段
class TimePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final void Function(DateTime?) onChanged;
  final bool isRequired;
  final String? placeholder;

  const TimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: colorScheme.error),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingSm),
        InkWell(
          onTap: () => _selectDateTime(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? timeFormat.format(value!)
                      : (placeholder ?? '点击选择'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: value != null ? null : colorScheme.outline,
                      ),
                ),
                Icon(Icons.access_time, color: colorScheme.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingMd),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    // 先选日期
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null || !context.mounted) return;

    // 再选时间
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? now),
    );

    if (pickedTime == null || !context.mounted) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onChanged(newDateTime);
  }
}

/// 通用数字输入字段
class NumberInputField extends StatelessWidget {
  final String label;
  final int? value;
  final String unit;
  final void Function(int?) onChanged;
  final bool isRequired;

  const NumberInputField({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: colorScheme.error),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingSm),
        TextFormField(
          initialValue: value?.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            suffixText: unit,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (text) {
            final intValue = int.tryParse(text);
            onChanged(intValue);
          },
        ),
        const SizedBox(height: AppSpacing.paddingMd),
      ],
    );
  }
}

/// 通用文本输入字段
class TextInputField extends StatelessWidget {
  final String label;
  final String? value;
  final String hintText;
  final int maxLines;
  final void Function(String) onChanged;
  final bool isRequired;

  const TextInputField({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    this.maxLines = 1,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: colorScheme.error),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingSm),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.paddingMd),
      ],
    );
  }
}
