import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/seller_cubit.dart';
import '../../cubit/seller_state.dart';
import '../widgets/seller_stat_card.dart';
import '../widgets/seller_order_card.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          builder: (context, state) {
            if (state is! SellerLoaded) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff8B4513),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  SizedBox(height: 24.h),

                  // Stats Grid
                  _buildStatsGrid(state),
                  SizedBox(height: 24.h),

                  // Sales Chart
                  _buildSalesChart(state),
                  SizedBox(height: 24.h),

                  // Recent Orders
                  _buildRecentOrders(state),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Artisan Studio ✨',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
        Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xff8B4513).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xff8B4513).withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.person_outline,
            color: const Color(0xff8B4513),
            size: 22.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(SellerLoaded state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.45,
      children: [
        SellerStatCard(
          icon: Icons.attach_money,
          label: 'TOTAL SALES',
          value: state.stats.totalSales,
          iconColor: const Color(0xff07880E),
        ),
        SellerStatCard(
          icon: Icons.shopping_bag_outlined,
          label: 'TOTAL ORDERS',
          value: state.stats.totalOrders,
          iconColor: const Color(0xffF59E0B),
        ),
        SellerStatCard(
          icon: Icons.trending_up,
          label: 'REVENUE',
          value: state.stats.totalRevenue,
          iconColor: const Color(0xff8B4513),
        ),
        SellerStatCard(
          icon: Icons.inventory_2_outlined,
          label: 'PRODUCTS',
          value: state.stats.totalProducts,
          iconColor: const Color(0xff6366F1),
        ),
      ],
    );
  }

  Widget _buildSalesChart(SellerLoaded state) {
    final maxSale = state.stats.weeklySales
        .reduce((a, b) => a > b ? a : b);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Performance',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'This week\'s revenue overview',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.5),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 140.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final ratio = state.stats.weeklySales[index] / maxSale;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(state.stats.weeklySales[index] / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        SizedBox(height: 6.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: (100 * ratio).h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff8B4513),
                                const Color(0xff8B4513)
                                    .withValues(alpha: 0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.4),
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(SellerLoaded state) {
    final recentOrders = state.orders.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff8B4513),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...recentOrders.map((order) => SellerOrderCard(order: order)),
      ],
    );
  }
}
