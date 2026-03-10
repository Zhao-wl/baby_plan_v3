import 'package:flutter/material.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 响应式断点枚举
enum _Breakpoint { compact, medium, expanded }

/// 半屏弹窗通用组件
///
/// 提供可复用的半屏弹窗功能，支持：
/// - 从下往上滑入动画（300ms, easeOutCubic）
/// - 遮罩层（半透明 + 模糊）
/// - 下拉关闭手势
/// - 数据变更检测 + 二次确认机制
class HalfScreenSheet {
  /// 显示半屏弹窗
  ///
  /// [context] - BuildContext
  /// [builder] - 弹窗内容构建器
  /// [hasUnsavedChanges] - 检测是否有未保存数据的回调
  /// [title] - 二次确认对话框标题
  /// [discardMessage] - 二次确认对话框正文
  /// [isScrollControlled] - 是否支持滚动控制
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool Function()? hasUnsavedChanges,
    String title = '放弃修改？',
    String discardMessage = '您已填写了部分信息，关闭后将丢失这些数据。',
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      transitionAnimationController: _createAnimationController(context),
      builder: (context) => _HalfScreenSheetContent(
        hasUnsavedChanges: hasUnsavedChanges,
        title: title,
        discardMessage: discardMessage,
        child: builder(context),
      ),
    );
  }

  /// 创建动画控制器
  ///
  /// 动画参数：
  /// - 持续时间: 300ms
  /// - 曲线: easeOutCubic
  static AnimationController _createAnimationController(BuildContext context) {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: Navigator.of(context),
    )..drive(CurveTween(curve: Curves.easeOutCubic));
  }
}

/// 半屏弹窗内容组件
class _HalfScreenSheetContent extends StatefulWidget {
  final Widget child;
  final bool Function()? hasUnsavedChanges;
  final String title;
  final String discardMessage;

  const _HalfScreenSheetContent({
    required this.child,
    this.hasUnsavedChanges,
    required this.title,
    required this.discardMessage,
  });

  @override
  State<_HalfScreenSheetContent> createState() =>
      _HalfScreenSheetContentState();
}

class _HalfScreenSheetContentState extends State<_HalfScreenSheetContent> {
  /// 下拉距离
  double _dragDistance = 0;

  /// 是否正在拖拽
  bool _isDragging = false;

  /// 下拉关闭阈值
  static const double _dragThreshold = 100.0;

  /// 根据屏幕宽度判断当前断点
  _Breakpoint _getBreakpoint(double width) {
    if (width < AppSpacing.breakpointCompact) {
      return _Breakpoint.compact;
    } else if (width < AppSpacing.breakpointExpanded) {
      return _Breakpoint.medium;
    } else {
      return _Breakpoint.expanded;
    }
  }

  /// 根据断点获取弹窗最大宽度
  double? _getSheetMaxWidth(_Breakpoint breakpoint) {
    switch (breakpoint) {
      case _Breakpoint.compact:
        return null; // 无限制
      case _Breakpoint.medium:
        return AppSpacing.sheetMaxWidthMedium;
      case _Breakpoint.expanded:
        return AppSpacing.sheetMaxWidthExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final breakpoint = _getBreakpoint(screenWidth);
    final sheetMaxWidth = _getSheetMaxWidth(breakpoint);

    Widget sheetContent = GestureDetector(
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: AnimatedContainer(
        duration: _isDragging ? Duration.zero : const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _dragDistance, 0),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示条
              _buildDragHandle(colorScheme),

              // 内容区域
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 48 + bottomPadding,
                  ),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // 宽屏设备：居中并限制最大宽度
    if (sheetMaxWidth != null) {
      sheetContent = Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: sheetMaxWidth),
          child: sheetContent,
        ),
      );
    }

    return sheetContent;
  }

  /// 构建拖拽指示条
  Widget _buildDragHandle(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 48,
        height: 6,
        decoration: BoxDecoration(
          color: colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  /// 开始拖拽
  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  /// 更新拖拽
  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDistance = (_dragDistance + details.delta.dy).clamp(0.0, double.infinity);
    });
  }

  /// 结束拖拽
  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    if (_dragDistance > _dragThreshold) {
      // 超过阈值，关闭弹窗
      _handleClose();
    } else {
      // 未达阈值，弹回原位
      setState(() {
        _dragDistance = 0;
      });
    }
  }

  /// 处理关闭
  Future<void> _handleClose() async {
    final hasChanges = widget.hasUnsavedChanges?.call() ?? false;

    if (hasChanges) {
      // 有未保存数据，显示确认对话框
      final shouldClose = await _showDiscardDialog();
      if (shouldClose && mounted) {
        Navigator.of(context).pop();
      } else {
        // 用户取消，重置拖拽距离
        setState(() {
          _dragDistance = 0;
        });
      }
    } else {
      // 无未保存数据，直接关闭
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  /// 显示放弃确认对话框
  Future<bool> _showDiscardDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(widget.title),
            content: Text(widget.discardMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('继续编辑'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('放弃'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

/// 扩展方法：检测点击遮罩关闭
extension HalfScreenSheetStateExtension on State<_HalfScreenSheetContent> {
  /// 检查并处理关闭（供外部调用）
  Future<void> checkAndClose() async {
    await (this as _HalfScreenSheetContentState)._handleClose();
  }
}