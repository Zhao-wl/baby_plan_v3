import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../utils/format_utils.dart';
import 'activity_card.dart';

/// 时间轴列表组件
///
/// 展示一天的活动记录列表，包含：
/// - 左侧时间轴线（CustomPainter 绘制）
/// - 活动节点（圆形，颜色对应活动类型）
/// - 活动卡片
/// - 空状态提示
/// - 自动滚动到最新记录
class TimelineList extends StatefulWidget {
  /// 活动记录列表
  final List<ActivityRecord> records;

  /// 点击活动回调
  final ValueChanged<ActivityRecord>? onActivityTap;

  /// 删除活动回调 - 返回 Future 以支持动画完成后再刷新数据
  final Future<void> Function(ActivityRecord)? onActivityDelete;

  /// 添加记录按钮回调
  final VoidCallback? onAddRecord;

  const TimelineList({
    super.key,
    required this.records,
    this.onActivityTap,
    this.onActivityDelete,
    this.onAddRecord,
  });

  /// 滚动到底部（外部调用）
  static void scrollToBottom(BuildContext context) {
    final state = context.findAncestorStateOfType<_TimelineListState>();
    state?._scrollToBottom();
  }

  @override
  State<TimelineList> createState() => _TimelineListState();
}

class _TimelineListState extends State<TimelineList> {
  final ScrollController _scrollController = ScrollController();

  /// AnimatedList 的 key，用于控制列表动画
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  /// 本地记录列表，用于 AnimatedList
  List<ActivityRecord> _records = [];

  /// 正在执行删除动画的记录 ID 集合
  final Set<int> _deletingIds = {};

  /// 本地已删除的记录 ID 集合（用于跳过同步）
  /// 当本地删除操作完成后，Provider 刷新时会检查这个集合，
  /// 如果 widget.records 中不包含这些 ID，说明删除已同步，可以清除
  final Set<int> _locallyDeletedIds = {};

  @override
  void initState() {
    super.initState();
    _records = List.from(widget.records);
    debugPrint('========== TimelineList.initState ==========');
    debugPrint('widget.records.length: ${widget.records.length}');
    debugPrint('_records.length: ${_records.length}');
    debugPrint('Stack trace:\n${StackTrace.current}');
  }

  @override
  void didUpdateWidget(TimelineList oldWidget) {
    super.didUpdateWidget(oldWidget);

    debugPrint('========== TimelineList.didUpdateWidget ==========');
    debugPrint('widget.records.length: ${widget.records.length}');
    debugPrint('_records.length: ${_records.length}');
    debugPrint('_deletingIds: $_deletingIds');
    debugPrint('_locallyDeletedIds: $_locallyDeletedIds');

    // 如果有正在删除的记录，跳过同步（让动画完成）
    if (_deletingIds.isNotEmpty) {
      debugPrint('>>> 正在执行删除动画，跳过同步');
      return;
    }

    // 如果本地有已删除的记录，检查 Provider 是否已同步
    // 如果 widget.records 中不包含这些 ID，说明删除已同步到 Provider
    if (_locallyDeletedIds.isNotEmpty) {
      final syncedIds = _locallyDeletedIds
          .where((id) => !widget.records.any((r) => r.id == id))
          .toList();
      if (syncedIds.isNotEmpty) {
        debugPrint('>>> 本地删除已同步到 Provider: $syncedIds');
        _locallyDeletedIds.removeAll(syncedIds);
      }
      // 如果还有未同步的 ID，跳过本次更新
      if (_locallyDeletedIds.isNotEmpty) {
        debugPrint('>>> 本地删除未完全同步，跳过更新');
        return;
      }
    }

    // 计算新增的记录
    final newRecords = widget.records
        .where((r) => !_records.any((existing) => existing.id == r.id))
        .toList();

    if (newRecords.isNotEmpty) {
      debugPrint('>>> 检测到新增记录: ${newRecords.length} 条');
      for (final newRecord in newRecords) {
        final insertIndex = widget.records.indexOf(newRecord);
        _records.insert(insertIndex, newRecord);
        _animatedListKey.currentState?.insertItem(
          insertIndex,
          duration: const Duration(milliseconds: 300),
        );
      }

      // 滚动到底部
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }

    // 同步删除：从 widget.records 中移除已删除但本地还在的记录（非动画删除）
    final deletedIds = _records
        .where((r) => !widget.records.any((wr) => wr.id == r.id))
        .map((r) => r.id)
        .toList();

    if (deletedIds.isNotEmpty) {
      debugPrint('>>> 检测到外部删除: $deletedIds');
      for (final id in deletedIds) {
        _records.removeWhere((r) => r.id == id);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动到列表底部
  void _scrollToBottom() {
    if (_scrollController.hasClients && _records.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('========== TimelineList.build ==========');
    debugPrint('_records.length: ${_records.length}');
    debugPrint('_deletingIds: $_deletingIds');

    // 过滤掉正在删除的记录，用于时间轴线绘制
    final visibleRecords =
        _records.where((r) => !_deletingIds.contains(r.id)).toList();

    if (visibleRecords.isEmpty && widget.records.isEmpty) {
      return _buildEmptyState(context);
    }

    return CustomPaint(
      painter: _TimelineAxisPainter(
        records: visibleRecords,
      ),
      child: AnimatedList(
        key: _animatedListKey,
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16)
            .copyWith(bottom: 88),
        initialItemCount: _records.length,
        itemBuilder: (context, index, animation) {
          if (index >= _records.length) return const SizedBox.shrink();
          final record = _records[index];
          final isDeleting = _deletingIds.contains(record.id);
          return _AnimatedTimelineItem(
            record: record,
            animation: animation,
            index: index,
            isDeleting: isDeleting,
            onActivityTap: widget.onActivityTap,
            onActivityDelete: isDeleting ? null : _handleDelete,
          );
        },
      ),
    );
  }

  /// 处理删除请求 - 先动画，后通知调用者
  ///
  /// 返回一个 Future，在动画完成后 resolve。
  /// 如果数据库操作失败，会恢复本地状态并显示错误提示。
  Future<void> _handleDelete(ActivityRecord record) async {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index == -1) {
      // 记录不在列表中，直接调用删除
      await widget.onActivityDelete?.call(record);
      return;
    }

    debugPrint('========== _handleDelete 开始 ==========');
    debugPrint('record.id: ${record.id}');
    debugPrint('index: $index');

    // 标记为正在删除
    _deletingIds.add(record.id);
    final removedRecord = record;

    debugPrint('>>> 开始删除动画, index: $index, _deletingIds: $_deletingIds');

    // 触发 AnimatedList 删除动画
    _animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => _AnimatedTimelineItem(
        record: removedRecord,
        animation: animation,
        index: index,
        isDeleting: true,
        onActivityTap: null,
        onActivityDelete: null,
      ),
      duration: const Duration(milliseconds: 300),
    );

    // 等待动画完成
    await Future.delayed(const Duration(milliseconds: 300));

    debugPrint('>>> 动画完成');

    if (!mounted) return;

    // 从本地列表移除，并标记为本地删除
    setState(() {
      _records.removeWhere((r) => r.id == record.id);
      _deletingIds.remove(record.id);
      _locallyDeletedIds.add(record.id);
    });

    debugPrint('>>> 本地状态更新完成');
    debugPrint('>>> _records.length: ${_records.length}, _deletingIds: $_deletingIds, _locallyDeletedIds: $_locallyDeletedIds');

    // 通知父组件更新数据库和 Provider
    // 此时本地状态已更新，Provider 刷新不会导致动画被打断
    debugPrint('>>> 通知父组件更新数据库');

    try {
      await widget.onActivityDelete?.call(record);
      debugPrint('>>> _handleDelete 完成');
    } catch (e) {
      debugPrint('>>> 数据库操作失败，恢复本地状态: $e');
      // 数据库操作失败，恢复本地状态
      if (mounted) {
        setState(() {
          // 将记录重新插入到原来的位置
          _records.insert(index, removedRecord);
          // 从本地删除集合中移除
          _locallyDeletedIds.remove(record.id);
        });

        // 使用 AnimatedList 插入动画恢复显示
        _animatedListKey.currentState?.insertItem(
          index,
          duration: const Duration(milliseconds: 300),
        );

        // 显示错误提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 空状态插图
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              size: 48,
              color: AppColors.primary.withAlpha(179),
            ),
          ),
          const SizedBox(height: 24),
          // 引导文案
          Text(
            '今天还没有记录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击添加第一条记录',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),
          const SizedBox(height: 24),
          // 添加按钮
          if (widget.onAddRecord != null)
            FilledButton.icon(
              onPressed: widget.onAddRecord,
              icon: const Icon(Icons.add),
              label: const Text('添加记录'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.lg,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 时间轴连线绘制器
class _TimelineAxisPainter extends CustomPainter {
  final List<ActivityRecord> records;

  _TimelineAxisPainter({required this.records});

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.outline.withAlpha(77)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 绘制垂直时间轴线
    // 从第一个节点的中心到最后一个节点的中心
    const startX = 24.0; // 左侧区域宽度48的一半
    const startY = 32.0; // 第一个节点位置 (24 + 16/2 + 8)
    final endY = records.length * 120.0; // 估算每个项目的高度

    // 绘制虚线效果
    const dashHeight = 4.0;
    const dashSpace = 4.0;
    var currentY = startY;

    while (currentY < endY) {
      canvas.drawLine(
        Offset(startX, currentY),
        Offset(startX, currentY + dashHeight),
        paint,
      );
      currentY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 呼吸动画节点
///
/// 用于进行中活动的时间轴节点，具有呼吸动画效果
class _BreathingNode extends StatefulWidget {
  final Color color;

  const _BreathingNode({required this.color});

  @override
  State<_BreathingNode> createState() => _BreathingNodeState();
}

class _BreathingNodeState extends State<_BreathingNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: widget.color.withAlpha((_animation.value * 255).round()),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withAlpha((_animation.value * 100).round()),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 带动画的时间轴列表项
///
/// 封装单个列表项及其动画效果（淡出 + 高度收缩）
class _AnimatedTimelineItem extends StatelessWidget {
  final ActivityRecord record;
  final Animation<double> animation;
  final int index;
  final bool isDeleting;
  final ValueChanged<ActivityRecord>? onActivityTap;
  final Future<void> Function(ActivityRecord)? onActivityDelete;

  const _AnimatedTimelineItem({
    required this.record,
    required this.animation,
    required this.index,
    this.isDeleting = false,
    this.onActivityTap,
    this.onActivityDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 判断是否为进行中活动（status=0 表示进行中）
    final isOngoing = record.status == 0;
    final color = getActivityColor(record.type);

    // AnimatedList 的 animation:
    // - 插入时: 0 → 1 (从不可见到可见)
    // - 删除时: 1 → 0 (从可见到不可见)
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    // SizeTransition axisAlignment:
    // - -1.0: 顶部对齐，底部收缩（删除时下方内容上移）
    // - 0.0: 中心对齐
    // - 1.0: 底部对齐，顶部收缩
    return SizeTransition(
      sizeFactor: curvedAnimation,
      axis: Axis.vertical,
      axisAlignment: -1.0, // 顶部对齐，确保删除时下方内容向上移动
      child: FadeTransition(
        opacity: curvedAnimation,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧时间轴区域
              SizedBox(
                width: 48,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // 时间节点
                    isOngoing
                        ? _BreathingNode(color: color)
                        : Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withAlpha(77),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // 右侧活动卡片
              Expanded(
                child: TimelineActivityCard(
                  record: record,
                  isOngoing: isOngoing,
                  onTap: onActivityTap != null
                      ? () => onActivityTap!(record)
                      : null,
                  onDelete: onActivityDelete != null
                      ? () => onActivityDelete!(record)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}