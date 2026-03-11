import 'package:flutter/material.dart';

import '../../providers/stats_provider.dart';

/// 统计周期切换组件
///
/// 使用 Material 3 SegmentedButton 实现日/周/月视图切换。
class StatsPeriodTabs extends StatelessWidget {
  /// 当前选中的周期
  final StatsPeriod selectedPeriod;

  /// 周期切换回调
  final ValueChanged<StatsPeriod> onPeriodChanged;

  const StatsPeriodTabs({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<StatsPeriod>(
      segments: const [
        ButtonSegment(
          value: StatsPeriod.day,
          label: Text('日'),
        ),
        ButtonSegment(
          value: StatsPeriod.week,
          label: Text('周'),
        ),
        ButtonSegment(
          value: StatsPeriod.month,
          label: Text('月'),
        ),
      ],
      selected: {selectedPeriod},
      onSelectionChanged: (Set<StatsPeriod> selection) {
        onPeriodChanged(selection.first);
      },
    );
  }
}