// DailyTrackingView 
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/presentation/home/widgets/activity/recent_activity_list.dart';
import 'package:gradution_project_smart_sip/presentation/home/widgets/layout/home_header.dart';
import 'package:gradution_project_smart_sip/presentation/home/widgets/progress/water_progress_card.dart';


class DailyTrackingView extends StatelessWidget {
  const DailyTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 17),
                WaterProgressCard(),
                SizedBox(height: 25),
                RecentActivitySection(),
                SizedBox(height: 100), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}