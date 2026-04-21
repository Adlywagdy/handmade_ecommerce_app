import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors.dart';
import '../../../cubit/admin_cubit.dart';
import '../../widgets/commission_editor_dialog.dart';
import '../../widgets/dashboard_commission_card.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/dashboard_pending_action_card.dart';
import '../../widgets/dashboard_stats_grid.dart';
import '../products/approve_products.dart';
import '../sellers/sellers_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<AdminCubit>().refreshDashboard(),
          child: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              final cubit = context.read<AdminCubit>();
              if (cubit.dashboardStats == null && state is GetDashboardDataLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (cubit.dashboardStats == null && state is GetDashboardDataError) {
                return ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    SizedBox(height: 200.h),
                    Center(child: Text(state.error)),
                  ],
                );
              }
              return _DashboardBody(cubit: cubit);
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final AdminCubit cubit;

  const _DashboardBody({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final stats = cubit.dashboardStats;
    final rate = cubit.settings.commissionRate;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
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
            status: [
              StatusItem(
                iconPath: 'assets/images/total_users_icon.svg',
                label: 'TOTAL USERS',
                value: _fmtInt(stats?.users ?? 0),
              ),
              StatusItem(
                iconPath: 'assets/images/sellers.svg',
                label: 'TOTAL SELLERS',
                value: _fmtInt(stats?.sellers ?? 0),
              ),
              StatusItem(
                iconPath: 'assets/images/total_orders_icon.svg',
                label: 'TOTAL ORDERS',
                value: _fmtInt(stats?.orders ?? 0),
              ),
              StatusItem(
                iconPath: 'assets/images/revenue_icon.svg',
                label: 'REVENUE',
                value: _fmtMoney(stats?.revenue ?? 0),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          DashboardCommissionCard(
            label: 'Platform Commission',
            value: '${(rate * 100).toStringAsFixed(1)}%',
            onEditTap: () => showCommissionEditor(context, rate),
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
          DashboardPendingActionCard(
            icon: Icons.warning_amber_rounded,
            title: '${cubit.pendingSellersCount} Sellers awaiting approval',
            subtitle: 'New artisan registrations',
            onButtonTap: () => Get.to(() => BlocProvider.value(
                  value: cubit,
                  child: const SellersScreen(),
                )),
          ),
          SizedBox(height: 10.h),
          DashboardPendingActionCard(
            icon: Icons.inventory_2_outlined,
            title: '${cubit.pendingProductsCount} Products awaiting review',
            subtitle: 'Quality control check required',
            onButtonTap: () => Get.to(() => BlocProvider.value(
                  value: cubit,
                  child: const ApproveProductsScreen(),
                )),
          ),
        ],
      ),
    );
  }

  static String _fmtInt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String _fmtMoney(double v) {
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }
}
