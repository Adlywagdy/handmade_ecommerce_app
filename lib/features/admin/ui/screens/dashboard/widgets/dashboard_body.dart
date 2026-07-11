import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/logic/admin_cubit.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/categories/categories_screen.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/coupons/coupons_screen.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/products/products_screen.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/sellers/sellers_screen.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/widgets/commission_editor_dialog.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/widgets/dashboard_commission_card.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/widgets/dashboard_header.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/widgets/dashboard_pending_action_card.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/widgets/dashboard_stats_grid.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

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
          DashboardHeader(
            onNotificationTap: () => Get.toNamed(AppRoutes.notifications),
          ),
          SizedBox(height: 20.h),
          Text(
            AppLocalizations.of(context)!.admGreetingMorning,
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
                label: AppLocalizations.of(context)!.admStatLabelTotalUsers,
                value: "${stats?.users ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/sellers.svg',
                label: AppLocalizations.of(context)!.admStatLabelTotalSellers,
                value: "${stats?.sellers ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/total_orders_icon.svg',
                label: AppLocalizations.of(context)!.admStatLabelTotalOrders,
                value: "${stats?.orders ?? 0}",
              ),
              StatusItem(
                iconPath: 'assets/images/revenue_icon.svg',
                label: AppLocalizations.of(context)!.admStatLabelRevenue,
                value: "${stats?.revenue ?? 0}",
              ),
            ],
          ),
          SizedBox(height: 12.h),
          DashboardCommissionCard(
            label: AppLocalizations.of(context)!.admLabelPlatformCommission,
            value: '${(rate * 100).toStringAsFixed(1)}%',
            onEditTap: () => showCommissionEditor(context, rate),
          ),
          SizedBox(height: 24.h),
          Text(
            AppLocalizations.of(context)!.admSectionPendingActions,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 12.h),
          DashboardPendingActionCard(
            icon: Icons.warning_amber_rounded,
            title: AppLocalizations.of(
              context,
            )!.admPendingSellersTitle(cubit.pendingSellersCount),
            subtitle: AppLocalizations.of(context)!.admPendingSellersSubtitle,
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
            title: AppLocalizations.of(
              context,
            )!.admPendingProductsTitle(cubit.pendingProductsCount),
            subtitle: AppLocalizations.of(context)!.admPendingProductsSubtitle,
            onButtonTap: () => Get.to(
              () => BlocProvider.value(
                value: cubit,
                child: const AdminProductsScreen(),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          DashboardPendingActionCard(
            icon: Icons.category_outlined,
            title: AppLocalizations.of(
              context,
            )!.admCategoriesCount(cubit.categoriesList.length),
            subtitle: AppLocalizations.of(context)!.admManageCategories,
            onButtonTap: () => Get.to(
              () => BlocProvider.value(
                value: cubit,
                child: const AdminCategoriesScreen(),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          DashboardPendingActionCard(
            icon: Icons.local_offer_outlined,
            title: '${cubit.couponsList.length} Coupons',
            subtitle: AppLocalizations.of(context)!.admManageCoupons,
            onButtonTap: () => Get.to(
              () => BlocProvider.value(
                value: cubit,
                child: const AdminCouponsScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
