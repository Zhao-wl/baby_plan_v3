import 'package:flutter/material.dart';

import '../widgets/common/guest_status_bar.dart';
import '../widgets/dashboard/baby_info_card.dart';
import '../widgets/dashboard/quick_action_bar.dart';
import '../widgets/dashboard/recent_activities_list.dart';
import '../widgets/dashboard/smart_prediction_card.dart';
import '../widgets/dashboard/timer_card.dart';

/// 首页 Dashboard
///
/// 展示当前宝宝的基本信息、智能预测、计时器和最近活动。
/// 快捷操作台嵌入在页面内容流中。
/// 布局顺序：宝宝信息 → 智能预测 → 计时器 → 快捷按钮 → 最近记录
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

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // TODO: 添加刷新逻辑
          await Future.delayed(const Duration(seconds: 1));
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 游客状态提示栏
              GuestStatusBar(),
              SizedBox(height: 12),

              // 宝宝信息卡片
              BabyInfoCard(),
              SizedBox(height: 12),

              // 智能预测卡片
              SmartPredictionCard(),
              SizedBox(height: 12),

              // 计时器卡片
              TimerCard(),
              SizedBox(height: 12),

              // 快捷操作台
              QuickActionBar(),
              SizedBox(height: 12),

              // 最近动态列表
              RecentActivitiesList(limit: 2),
            ],
          ),
        ),
      ),
    );
  }
}