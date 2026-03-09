import 'package:flutter/material.dart';

import '../widgets/dashboard/baby_info_card.dart';
import '../widgets/dashboard/quick_action_bar.dart';
import '../widgets/dashboard/recent_activities_list.dart';
import '../widgets/dashboard/smart_prediction_card.dart';
import '../widgets/dashboard/timer_card_placeholder.dart';

/// 首页 Dashboard
///
/// 展示当前宝宝的基本信息、计时器占位、智能预测和最近活动。
/// 快捷操作台悬浮在底部导航上方。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 获取底部导航栏高度（NavigationBar 默认高度约 80px）
    const bottomNavHeight = kBottomNavigationBarHeight;
    // 快捷操作台高度 + 间距
    const actionBarSpace = 120.0;

    return Stack(
      children: [
        // 主内容区域
        SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // TODO: 添加刷新逻辑
              await Future.delayed(const Duration(seconds: 1));
            },
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              // 底部留出足够空间给快捷操作台 + 底部导航栏
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                actionBarSpace + bottomNavHeight,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 宝宝信息卡片
                  BabyInfoCard(),
                  SizedBox(height: 16),

                  // 计时器卡片占位
                  TimerCardPlaceholder(),
                  SizedBox(height: 16),

                  // 智能预测卡片
                  SmartPredictionCard(),
                  SizedBox(height: 16),

                  // 最近动态列表
                  RecentActivitiesList(limit: 2),
                ],
              ),
            ),
          ),
        ),

        // 快捷操作台（固定在底部导航栏上方）
        const Positioned(
          left: 0,
          right: 0,
          // 紧贴底部导航栏
          bottom: bottomNavHeight,
          child: IgnorePointer(
            ignoring: false,
            child: QuickActionBar(),
          ),
        ),
      ],
    );
  }
}