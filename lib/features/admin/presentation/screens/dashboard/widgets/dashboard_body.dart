import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/cubit/admin_cubit.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/products/products_screen.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/sellers/sellers_screen.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/widgets/commission_editor_dialog.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/widgets/dashboard_commission_card.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/widgets/dashboard_header.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/widgets/dashboard_pending_action_card.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/widgets/dashboard_stats_grid.dart';

class DashboardBody extends StatelessWidget {
  final AdminCubit cubit;

  const DashboardBody({super.key, required this.cubit});

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
           TextButton(
            onPressed: () => throw Exception('Test Crash'),
            child: const Text('Throw Test Exception'),
          ),
          SizedBox(height: 20.h),
          DashboardStatsGrid(
            status: [
              StatusItem(
                iconPath: 'assets/images/total_users_icon.svg',
                label: 'TOTAL USERS',
                value: "${stats?.users ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/sellers.svg',
                label: 'TOTAL SELLERS',
                value: "${stats?.sellers ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/total_orders_icon.svg',
                label: 'TOTAL ORDERS',
                value:  "${stats?.orders ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/revenue_icon.svg',
                label: 'REVENUE',
                value: "${stats?.revenue ?? 0}",
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
            onButtonTap: () => Get.to( () => BlocProvider.value(
                  value: cubit,
                  child: const AdminSellersScreen(),
                )),
          ),
          SizedBox(height: 10.h),
          DashboardPendingActionCard(
            icon: Icons.inventory_2_outlined,
            title: '${cubit.pendingProductsCount} Products awaiting review',
            subtitle: 'Quality control check required',
            onButtonTap: () => Get.to(() => BlocProvider.value(
                  value: cubit,
                  child: const AdminProductsScreen(),
                )),
          ),
        ],
      ),
    );
  }
}
