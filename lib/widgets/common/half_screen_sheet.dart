import 'package:flutter/material.dart';
import 'package:baby_plan_v3/theme/app_spacing.dart';

/// 响应式断点枚举
enum _Breakpoint { compact, medium, expanded }

/// 半屏弹窗通用组件
///
/// 提供可复用的半屏弹窗功能，支持：
/// - 从下往上滑入动画（300ms, easeOutCubic）
/// - 遮罩层（半透明 + 模糊）
/// - 点击遮罩关闭
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
      isDismissible: true,
      enableDrag: false,
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
  /// 是否正在显示确认对话框
  bool _isShowingDialog = false;

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

  /// 检查是否有未保存的数据
  bool get _hasUnsavedChanges {
    return widget.hasUnsavedChanges?.call() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final breakpoint = _getBreakpoint(screenWidth);
    final sheetMaxWidth = _getSheetMaxWidth(breakpoint);

    // 构建弹窗底部内容
    Widget sheetContent = Container(
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
          // 拖拽指示条（仅作为视觉指示）
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
    );

    // 宽屏设备：限制最大宽度
    if (sheetMaxWidth != null) {
      sheetContent = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: sheetMaxWidth),
        child: sheetContent,
      );
    }

    // 使用 Column 将内容推到底部，上方留空区域不拦截点击
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 上方可点击区域（遮罩关闭）
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              // 检查是否有未保存数据
              if (_hasUnsavedChanges && !_isShowingDialog) {
                _isShowingDialog = true;
                final shouldClose = await _showDiscardDialog();
                _isShowingDialog = false;
                if (shouldClose && mounted) {
                  Navigator.of(context).pop();
                }
              } else if (!_hasUnsavedChanges) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        // 弹窗内容
        PopScope(
          canPop: !_hasUnsavedChanges,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (_hasUnsavedChanges && !_isShowingDialog) {
              _isShowingDialog = true;
              final shouldClose = await _showDiscardDialog();
              _isShowingDialog = false;
              if (shouldClose && mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Material(
            color: Colors.transparent,
            child: sheetContent,
          ),
        ),
      ],
    );
  }

  /// 构建拖拽指示条（视觉指示）
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
