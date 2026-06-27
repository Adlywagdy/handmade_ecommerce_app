import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
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
            context.l10n.goodMorningAdmin,
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
                label: context.l10n.totalUsers,
                value: "${stats?.users ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/sellers.svg',
                label: context.l10n.totalSellers,
                value: "${stats?.sellers ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/total_orders_icon.svg',
                label: context.l10n.totalOrders,
                value: "${stats?.orders ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/revenue_icon.svg',
                label: context.l10n.revenue,
                value: "${stats?.revenue ?? 0}",
              ),
            ],
          ),
          SizedBox(height: 12.h),
          DashboardCommissionCard(
            label: context.l10n.platformCommission,
            value: '${(rate * 100).toStringAsFixed(1)}%',
            onEditTap: () => showCommissionEditor(context, rate),
          ),
          SizedBox(height: 24.h),
          Text(
            context.l10n.pendingActions,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 12.h),
          DashboardPendingActionCard(
            icon: Icons.warning_amber_rounded,
            title: context.l10n.sellersAwaitingApproval(
              cubit.pendingSellersCount,
            ),
            subtitle: context.l10n.newArtisanRegistrations,
            buttonText: context.l10n.review,
            onButtonTap: () => Get.to(
              () => BlocProvider.value(
                value: cubit,
                child: const AdminSellersScreen(),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          DashboardPendingActionCard(
            icon: Icons.inventory_2_outlined,
            title: context.l10n.productsAwaitingReview(
              cubit.pendingProductsCount,
            ),
            subtitle: context.l10n.qualityControlCheckRequired,
            buttonText: context.l10n.review,
            onButtonTap: () => Get.to(
              () => BlocProvider.value(
                value: cubit,
                child: const AdminProductsScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
