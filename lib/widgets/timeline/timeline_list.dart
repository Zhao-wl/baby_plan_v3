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

  /// 删除活动回调
  final ValueChanged<ActivityRecord>? onActivityDelete;

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

  /// 记录上一次的记录数量，用于检测新增记录
  int _previousRecordCount = 0;

  @override
  void initState() {
    super.initState();
    _previousRecordCount = widget.records.length;
  }

  @override
  void didUpdateWidget(TimelineList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 只在检测到新增记录时滚动（用户主动添加）
    if (widget.records.length > _previousRecordCount && widget.records.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
    _previousRecordCount = widget.records.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动到列表底部
  void _scrollToBottom() {
    if (_scrollController.hasClients && widget.records.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) {
      _previousRecordCount = 0;
      return _buildEmptyState(context);
    }

    return CustomPaint(
      painter: _TimelineAxisPainter(
        records: widget.records,
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16).copyWith(bottom: 88),
        itemCount: widget.records.length,
        itemBuilder: (context, index) {
          final record = widget.records[index];
          return _buildTimelineItem(context, record, index);
        },
      ),
    );
  }

  /// 构建时间轴项目
  Widget _buildTimelineItem(
    BuildContext context,
    ActivityRecord record,
    int index,
  ) {
    // 判断是否为进行中活动（status=0 表示进行中）
    final isOngoing = record.status == 0;

    return IntrinsicHeight(
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
                _buildTimelineNode(record, isOngoing),
                const SizedBox(height: 8),
              ],
            ),
          ),
          // 右侧活动卡片
          Expanded(
            child: TimelineActivityCard(
              key: ValueKey(record.id),
              record: record,
              isOngoing: isOngoing,
              onTap: widget.onActivityTap != null
                  ? () => widget.onActivityTap!(record)
                  : null,
              onDelete: widget.onActivityDelete != null
                  ? () => widget.onActivityDelete!(record)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建时间节点
  Widget _buildTimelineNode(ActivityRecord record, bool isOngoing) {
    final color = getActivityColor(record.type);

    // 进行中活动使用呼吸动画
    if (isOngoing) {
      return _BreathingNode(color: color);
    }

    return Container(
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
    );
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
