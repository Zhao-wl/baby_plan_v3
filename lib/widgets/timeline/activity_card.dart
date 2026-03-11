import 'dart:async';

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
/// - 进行中状态指示（可选）
/// - 点击编辑 / 左划删除交互
class TimelineActivityCard extends StatefulWidget {
  /// 活动记录数据
  final ActivityRecord record;

  /// 点击回调
  final VoidCallback? onTap;

  /// 删除回调
  final VoidCallback? onDelete;

  /// 是否显示跨天标记
  final bool showCrossDayLabel;

  /// 跨天时间标注（如"昨天 23:00"）
  final String? crossDayLabel;

  /// 是否为进行中活动
  final bool isOngoing;

  const TimelineActivityCard({
    super.key,
    required this.record,
    this.onTap,
    this.onDelete,
    this.showCrossDayLabel = false,
    this.crossDayLabel,
    this.isOngoing = false,
  });

  @override
  State<TimelineActivityCard> createState() => _TimelineActivityCardState();
}

class _TimelineActivityCardState extends State<TimelineActivityCard>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  /// 滑动偏移量
  double _swipeOffset = 0;

  /// 删除按钮宽度
  static const double _deleteButtonWidth = 80.0;

  /// 滑动阈值，超过此值显示删除按钮
  static const double _swipeThreshold = 40.0;

  /// 是否处于删除模式（显示删除按钮）
  bool get _isDeleteMode => _swipeOffset <= -_swipeThreshold;

  @override
  void initState() {
    super.initState();
    if (widget.isOngoing) {
      _updateElapsed();
      // 每秒更新一次持续时间
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateElapsed();
      });
    }
  }

  @override
  void didUpdateWidget(TimelineActivityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果 isOngoing 状态变化，重新设置计时器
    if (widget.isOngoing != oldWidget.isOngoing) {
      _timer?.cancel();
      if (widget.isOngoing) {
        _updateElapsed();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          _updateElapsed();
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 更新已持续时间
  void _updateElapsed() {
    if (!mounted) return;
    setState(() {
      _elapsed = DateTime.now().difference(widget.record.startTime);
    });
  }

  /// 格式化开始时间显示
  String _formatStartTime() {
    final hour = widget.record.startTime.hour.toString().padLeft(2, '0');
    final minute = widget.record.startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 构建活动详情文本
  String _getActivityDetailsText() {
    final details = <String>[];

    switch (widget.record.type) {
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
    if (widget.record.eatingMethod != null) {
      final methodMap = {0: '母乳', 1: '奶粉', 2: '辅食'};
      details.add(methodMap[widget.record.eatingMethod] ?? '未知');

      if (widget.record.eatingMethod == 0) {
        // 母乳
        if (widget.record.breastSide != null) {
          final sideMap = {0: '左侧', 1: '右侧', 2: '双侧'};
          details.add(sideMap[widget.record.breastSide] ?? '');
        }
        if (widget.record.breastDurationMinutes != null) {
          details.add('${widget.record.breastDurationMinutes}分钟');
        }
      } else if (widget.record.eatingMethod == 1 &&
          widget.record.formulaAmountMl != null) {
        // 奶粉
        details.add('${widget.record.formulaAmountMl}ml');
      }
    }
    return details.join(' · ');
  }

  /// 构建活动详情
  String _buildActivityDetailsText(List<String> details) {
    if (widget.record.activityType != null) {
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
      details.add(activityTypes[widget.record.activityType!]);
    }
    if (widget.record.mood != null) {
      final moodMap = {0: '开心', 1: '一般', 2: '不开心'};
      details.add(moodMap[widget.record.mood] ?? '');
    }
    return details.join(' · ');
  }

  /// 构建睡眠详情
  String _buildSleepDetails(List<String> details) {
    if (widget.record.sleepQuality != null) {
      final qualityMap = {0: '差', 1: '一般', 2: '好'};
      details.add('质量${qualityMap[widget.record.sleepQuality]}');
    }
    if (widget.record.sleepLocation != null) {
      final locationMap = {0: '婴儿床', 1: '父母床', 2: '推车', 3: '其他'};
      details.add(locationMap[widget.record.sleepLocation] ?? '');
    }
    if (widget.record.sleepAssistMethod != null) {
      final methodMap = {0: '无', 1: '奶嘴', 2: '摇篮', 3: '怀抱'};
      details.add('辅助${methodMap[widget.record.sleepAssistMethod]}');
    }
    return details.join(' · ');
  }

  /// 构建排泄详情
  String _buildPoopDetails(List<String> details) {
    if (widget.record.diaperType != null) {
      final typeMap = {0: '尿', 1: '屎', 2: '混合'};
      details.add(typeMap[widget.record.diaperType] ?? '未知');
    }
    if (widget.record.stoolColor != null) {
      final colorMap = {0: '黄色', 1: '绿色', 2: '棕色', 3: '黑色', 4: '其他'};
      details.add(colorMap[widget.record.stoolColor] ?? '');
    }
    if (widget.record.stoolTexture != null) {
      final textureMap = {0: '正常', 1: '稀', 2: '干硬'};
      details.add(textureMap[widget.record.stoolTexture] ?? '');
    }
    return details.join(' · ');
  }

  /// 格式化进行中活动的持续时间
  String _formatOngoingDuration() {
    final hours = _elapsed.inHours;
    final minutes = _elapsed.inMinutes.remainder(60);

    if (hours > 0) {
      return '已持续 $hours 小时 $minutes 分钟';
    } else if (minutes > 0) {
      return '已持续 $minutes 分钟';
    } else {
      return '刚刚开始';
    }
  }

  /// 处理水平拖拽开始
  void _onHorizontalDragStart(DragStartDetails details) {
    // 开始拖拽
  }

  /// 处理水平拖拽更新
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _swipeOffset += details.primaryDelta ?? 0;
      // 限制滑动范围：最多滑出删除按钮宽度
      if (_swipeOffset < -_deleteButtonWidth) {
        _swipeOffset = -_deleteButtonWidth;
      }
      // 右滑限制：不能超过0
      if (_swipeOffset > 0) {
        _swipeOffset = 0;
      }
    });
  }

  /// 处理水平拖拽结束
  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      if (_isDeleteMode) {
        // 滑动超过阈值，显示删除按钮
        _swipeOffset = -_deleteButtonWidth;
      } else {
        // 未达到阈值，弹回原位
        _swipeOffset = 0;
      }
    });
  }

  /// 点击删除按钮
  void _onDeleteTap() async {
    if (widget.onDelete == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.onDelete!();
    }
  }

  /// 恢复卡片位置
  void _resetSwipe() {
    setState(() {
      _swipeOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activityColor = getActivityColor(widget.record.type);
    final activityLightColor = getActivityLightColor(widget.record.type);
    final details = _getActivityDetailsText();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 底层：删除按钮
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5252),
              borderRadius: AppBorderRadius.md,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: _deleteButtonWidth,
                child: IconButton(
                  onPressed: _onDeleteTap,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
        // 上层：可滑动的卡片内容
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(_swipeOffset, 0, 0),
          child: GestureDetector(
            onTap: _isDeleteMode ? _resetSwipe : widget.onTap,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: activityLightColor,
                borderRadius: AppBorderRadius.md,
                border: widget.isOngoing
                    ? Border.all(
                        color: activityColor.withAlpha(128),
                        width: 2,
                      )
                    : null,
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
                    // 顶部：图标 + 类型 + 进行中标签 + 时间
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
                            getActivityIcon(widget.record.type),
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
                            getActivityTypeName(widget.record.type),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: activityColor,
                            ),
                          ),
                        ),
                        // 进行中标签
                        if (widget.isOngoing) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: activityColor,
                              borderRadius: AppBorderRadius.xs,
                            ),
                            child: const Text(
                              '进行中',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        // 时间
                        Row(
                          children: [
                            if (widget.crossDayLabel != null) ...[
                              Text(
                                widget.crossDayLabel!,
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
                    // 持续时长（进行中活动显示实时计时）
                    if (widget.isOngoing)
                      Row(
                        children: [
                          Icon(
                            Icons.timelapse,
                            size: 14,
                            color: activityColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatOngoingDuration(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: activityColor,
                            ),
                          ),
                        ],
                      )
                    else if (widget.record.durationSeconds != null &&
                        widget.record.durationSeconds! > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.timelapse,
                            size: 14,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDuration(widget.record.durationSeconds),
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
                    if (widget.record.notes != null &&
                        widget.record.notes!.isNotEmpty) ...[
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
                                widget.record.notes!,
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
          ),
        ),
      ],
    );
  }
}