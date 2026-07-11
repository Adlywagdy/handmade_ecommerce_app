import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dashboard_stat_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  final List<StatusItem> status;

  const DashboardStatsGrid({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                iconPath: status[0].iconPath,
                label: status[0].label,
                value: status[0].value,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardStatCard(
                iconPath: status[1].iconPath,
                label: status[1].label,
                value: status[1].value,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                iconPath: status[2].iconPath,
                label: status[2].label,
                value: status[2].value,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardStatCard(
                iconPath: status[3].iconPath,
                label: status[3].label,
                value: status[3].value,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
class StatusItem {
  final String iconPath;
  final String label;
  final String value;

  const StatusItem({
    required this.iconPath,
    required this.label,
    required this.value,
  });
}
