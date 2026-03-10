import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../theme/app_spacing.dart';
import '../../utils/format_utils.dart';

/// 时间线活动卡片
///
/// 展示单条活动记录的卡片组件，包含：
/// - 活动类型图标和标签
/// - 时间显示
/// - 持续时长
/// - 活动详情
/// - 备注信息
/// - 点击编辑 / 长按删除交互
class TimelineActivityCard extends StatelessWidget {
  /// 活动记录数据
  final ActivityRecord record;

  /// 点击回调
  final VoidCallback? onTap;

  /// 长按回调
  final VoidCallback? onLongPress;

  /// 是否显示跨天标记
  final bool showCrossDayLabel;

  /// 跨天时间标注（如"昨天 23:00"）
  final String? crossDayLabel;

  const TimelineActivityCard({
    super.key,
    required this.record,
    this.onTap,
    this.onLongPress,
    this.showCrossDayLabel = false,
    this.crossDayLabel,
  });

  /// 格式化开始时间显示
  String _formatStartTime() {
    final hour = record.startTime.hour.toString().padLeft(2, '0');
    final minute = record.startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 构建活动详情文本
  String _getActivityDetailsText() {
    final details = <String>[];

    switch (record.type) {
      case 0: // Eat
        return _buildEatDetails(details);
      case 1: // Activity
        return _buildActivityDetailsText(details);
      case 2: // Sleep
        return _buildSleepDetails(details);
      case 3: // Poop
        return _buildPoopDetails(details);
    }

    return details.join(' · ');
  }

  /// 构建吃奶详情
  String _buildEatDetails(List<String> details) {
    if (record.eatingMethod != null) {
      final methodMap = {0: '母乳', 1: '奶粉', 2: '辅食'};
      details.add(methodMap[record.eatingMethod] ?? '未知');

      if (record.eatingMethod == 0) {
        // 母乳
        if (record.breastSide != null) {
          final sideMap = {0: '左侧', 1: '右侧', 2: '双侧'};
          details.add(sideMap[record.breastSide] ?? '');
        }
        if (record.breastDurationMinutes != null) {
          details.add('${record.breastDurationMinutes}分钟');
        }
      } else if (record.eatingMethod == 1 && record.formulaAmountMl != null) {
        // 奶粉
        details.add('${record.formulaAmountMl}ml');
      }
    }
    return details.join(' · ');
  }

  /// 构建活动详情
  String _buildActivityDetailsText(List<String> details) {
    if (record.activityType != null) {
      const activityTypes = [
        '趴着',
        '翻身',
        '坐',
        '爬',
        '站',
        '走',
        '户外',
        '游泳',
        '其他'
      ];
      details.add(activityTypes[record.activityType!]);
    }
    if (record.mood != null) {
      final moodMap = {0: '开心', 1: '一般', 2: '不开心'};
      details.add(moodMap[record.mood] ?? '');
    }
    return details.join(' · ');
  }

  /// 构建睡眠详情
  String _buildSleepDetails(List<String> details) {
    if (record.sleepQuality != null) {
      final qualityMap = {0: '差', 1: '一般', 2: '好'};
      details.add('质量${qualityMap[record.sleepQuality]}');
    }
    if (record.sleepLocation != null) {
      final locationMap = {0: '婴儿床', 1: '父母床', 2: '推车', 3: '其他'};
      details.add(locationMap[record.sleepLocation] ?? '');
    }
    if (record.sleepAssistMethod != null) {
      final methodMap = {0: '无', 1: '奶嘴', 2: '摇篮', 3: '怀抱'};
      details.add('辅助${methodMap[record.sleepAssistMethod]}');
    }
    return details.join(' · ');
  }

  /// 构建排泄详情
  String _buildPoopDetails(List<String> details) {
    if (record.diaperType != null) {
      final typeMap = {0: '尿', 1: '屎', 2: '混合'};
      details.add(typeMap[record.diaperType] ?? '未知');
    }
    if (record.stoolColor != null) {
      final colorMap = {0: '黄色', 1: '绿色', 2: '棕色', 3: '黑色', 4: '其他'};
      details.add(colorMap[record.stoolColor] ?? '');
    }
    if (record.stoolTexture != null) {
      final textureMap = {0: '正常', 1: '稀', 2: '干硬'};
      details.add(textureMap[record.stoolTexture] ?? '');
    }
    return details.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activityColor = getActivityColor(record.type);
    final activityLightColor = getActivityLightColor(record.type);
    final details = _getActivityDetailsText();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: activityLightColor,
          borderRadius: AppBorderRadius.md,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部：图标 + 类型 + 时间
              Row(
                children: [
                  // 活动图标
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: activityColor.withAlpha(51),
                      borderRadius: AppBorderRadius.sm,
                    ),
                    child: Icon(
                      getActivityIcon(record.type),
                      size: 18,
                      color: activityColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 活动类型名称
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: activityColor.withAlpha(26),
                      borderRadius: AppBorderRadius.xs,
                    ),
                    child: Text(
                      getActivityTypeName(record.type),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: activityColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 时间
                  Row(
                    children: [
                      if (crossDayLabel != null) ...[
                        Text(
                          crossDayLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatStartTime(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 持续时长
              if (record.durationSeconds != null && record.durationSeconds! > 0)
                Row(
                  children: [
                    Icon(
                      Icons.timelapse,
                      size: 14,
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatDuration(record.durationSeconds),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 4),
              // 活动详情
              if (details.isNotEmpty)
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withAlpha(179),
                  ),
                ),
              // 备注
              if (record.notes != null && record.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withAlpha(128),
                    borderRadius: AppBorderRadius.xs,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notes,
                        size: 14,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          record.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}