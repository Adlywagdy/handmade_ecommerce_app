import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_state.dart';
import 'package:handmade_ecommerce_app/features/notifications/presentation/widgets/notification_badge.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_stat_card.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_best_selling_card.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_quick_action.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_order_card.dart';

class SellerDashboardScreen extends StatelessWidget {
  final VoidCallback? onAddProduct;
  final VoidCallback? onViewProducts;
  final VoidCallback? onViewOrders;

  const SellerDashboardScreen({
    super.key,
    this.onAddProduct,
    this.onViewProducts,
    this.onViewOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          builder: (context, state) {
            if (state is SellerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SellerError) {
              return Center(
                  child: Text(state.message, style: const TextStyle(color: Colors.red)));
            } else if (state is SellerLoaded) {
              final stats = state.stats;
              final products = state.products;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // ── Profile Header ──
                    _buildProfileHeader(),

                    SizedBox(height: 24.h),

                    // ── Welcome Text ──
                    Text(
                      'Welcome back, Aisha',
                      style: TextStyle(
                        color: const Color(0xFF0F172A),
                        fontSize: 22.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Here's what's happening with your shop today.",
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 14.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Stats Cards Row ──
                    Row(
                      children: [
                        Expanded(
                          child: SellerStatCard(
                            title: 'Total Revenue',
                            value: 'EGP ${stats.totalRevenue}',
                            percentage: '+12%',
                            icon: Icons.account_balance_wallet_outlined,
                            iconBackgroundColor: const Color(0xFFFFF3E0),
                            iconColor: const Color(0xFFD97706),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SellerStatCard(
                            title: 'Total Orders',
                            value: stats.totalOrders.toString(),
                            percentage: '+5.4%',
                            icon: Icons.shopping_cart_outlined,
                            iconBackgroundColor: const Color(0xFFE8F5E9),
                            iconColor: const Color(0xFF07880E),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // ── Best-Selling Product Card ──
                    if (products.isNotEmpty)
                      SellerBestSellingCard(
                        productName: products.first.name,
                        subtitle: 'Best selling item',
                        imageUrl: products.first.images.isNotEmpty
                            ? products.first.images.first
                            : 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?w=100&h=100&fit=crop',
                      ),

                    SizedBox(height: 24.h),

                    // ── Quick Actions ──
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: const Color(0xFF0F172A),
                        fontSize: 18.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SellerQuickAction(
                          icon: Icons.add_box_outlined,
                          label: 'Add Product',
                          onTap: () {
                            if (onAddProduct != null) {
                              onAddProduct!();
                              return;
                            }
                            Get.toNamed(AppRoutes.selleraddproduct);
                          },
                        ),
                        SizedBox(width: 12.w),
                        SellerQuickAction(
                          icon: Icons.inventory_2_outlined,
                          label: 'View Products',
                          onTap: () {
                            if (onViewProducts != null) {
                              onViewProducts!();
                              return;
                            }
                            Get.toNamed(AppRoutes.sellermanageproducts);
                          },
                        ),
                        SizedBox(width: 12.w),
                        SellerQuickAction(
                          icon: Icons.receipt_long_outlined,
                          label: 'View Orders',
                          onTap: () {
                            if (onViewOrders != null) {
                              onViewOrders!();
                              return;
                            }
                            Get.toNamed(AppRoutes.sellerorders);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // ── Recent Orders Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Orders',
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 18.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (onViewOrders != null) {
                              onViewOrders!();
                              return;
                            }
                            Get.toNamed(AppRoutes.sellerorders);
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: commonColor,
                              fontSize: 14.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // ── Recent Orders List ──
                    // For now, these are static UI representations, later we can map state.recentOrders here
                    SellerOrderCard(
                      orderId: '#ORD-2841',
                      status: 'PROCESSING',
                      productName: 'Leather Handbag',
                      timeAgo: '20 mins ago',
                      price: 'EGP 1,200',
                    ),
                    SizedBox(height: 10.h),
                    SellerOrderCard(
                      orderId: '#ORD-2839',
                      status: 'SHIPPED',
                      productName: 'Woven Rug',
                      timeAgo: '2 hours ago',
                      price: 'EGP 3,450',
                    ),
                    SizedBox(height: 10.h),
                    SellerOrderCard(
                      orderId: '#ORD-2835',
                      status: 'DELIVERED',
                      productName: 'Ceramic Vase',
                      timeAgo: '5 hours ago',
                      price: 'EGP 850',
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }
            return const Center(child: Text('Unexpected State'));
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Profile Avatar
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: commonColor.withValues(alpha: 0.1),
            border: Border.all(
              color: commonColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100&h=100&fit=crop&crop=face',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  color: commonColor,
                  size: 24.w,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Seller info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ayady Seller',
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 16.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'PREMIUM ARTISAN',
                style: TextStyle(
                  color: commonColor,
                  fontSize: 10.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        // Notification bell
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            final unreadCount =
                state is NotificationsLoaded ? state.unreadCount : 0;
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.notifications),
              child: NotificationBadge(
                unreadCount: unreadCount,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: const Color(0xFF334155),
                    size: 22.w,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
