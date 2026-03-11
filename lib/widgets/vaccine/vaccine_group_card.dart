import 'package:flutter/material.dart';
import 'package:baby_plan_v3/providers/vaccine_provider.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';
import 'vaccine_item_card.dart';

/// 月龄分组容器
///
/// 包含月龄标题和该月龄下的疫苗列表。
class VaccineGroupCard extends StatelessWidget {
  /// 月龄分组名称
  final String ageGroup;

  /// 该月龄下的疫苗列表
  final List<VaccineScheduleItem> vaccines;

  /// 是否是最后一个分组（用于控制时间轴贯穿线）
  final bool isLast;

  /// 点击疫苗记录按钮的回调
  final void Function(VaccineScheduleItem item)? onRecordTap;

  const VaccineGroupCard({
    super.key,
    required this.ageGroup,
    required this.vaccines,
    this.isLast = false,
    this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧时间轴
        SizedBox(
          width: 48,
          child: Column(
            children: [
              // 月龄标题左侧的标识
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 贯穿线（连接各疫苗卡片）
              if (vaccines.isNotEmpty)
                Container(
                  width: 2,
                  height: vaccines.length * 72.0 - 16,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),

        // 右侧内容
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 月龄标题
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.paddingSm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingMd,
                  vertical: AppSpacing.paddingXs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  ageGroup,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

              // 疫苗列表
              ...vaccines.map((item) => VaccineItemCard(
                    item: item,
                    onRecordTap: onRecordTap != null
                        ? () => onRecordTap!(item)
                        : null,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}