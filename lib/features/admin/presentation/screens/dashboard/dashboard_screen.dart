import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/dashboard_stats_grid.dart';
import '../../widgets/dashboard_commission_card.dart';
import '../../widgets/dashboard_pending_action_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              SizedBox(height: 20.h),
              Text(
                'Good morning, Admin',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: blackDegree,
                ),
              ),
              SizedBox(height: 20.h),
              DashboardStatsGrid(
                status: const [
                  StatusItem(
                    iconPath: 'assets/images/total_users_icon.svg',
                    label: 'TOTAL USERS',
                    value: '12,450',
                  ),
                  StatusItem(
                    iconPath: 'assets/images/sellers.svg',
                    label: 'TOTAL SELLERS',
                    value: '1,205',
                  ),
                  StatusItem(
                    iconPath: 'assets/images/total_orders_icon.svg',
                    label: 'TOTAL ORDERS',
                    value: '45,670',
                  ),
                  StatusItem(
                    iconPath: 'assets/images/revenue_icon.svg',
                    label: 'REVENUE',
                    value: '\$128.4K',
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const DashboardCommissionCard(
                label: 'Platform Commission',
                value: '15.0%',
              ),
              SizedBox(height: 24.h),
              Text(
                'Pending Actions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: blackDegree,
                ),
              ),
              SizedBox(height: 12.h),
              const DashboardPendingActionCard(
                icon: Icons.warning_amber_rounded,
                title: '12 Sellers awaiting approval',
                subtitle: 'New artisan registrations',
              ),
              SizedBox(height: 10.h),
              const DashboardPendingActionCard(
                icon: Icons.inventory_2_outlined,
                title: '28 Products awaiting review',
                subtitle: 'Quality control check required',
              ),
            ],
          ),
        ),
      ),
    );
  }
}