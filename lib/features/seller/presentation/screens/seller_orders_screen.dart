import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_manage_order_card.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';
import 'package:handmade_ecommerce_app/features/seller/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_order_details_screen.dart';

class SellerOrdersScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const SellerOrdersScreen({super.key, this.onBackPressed});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 64.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 4.h, bottom: 4.h),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFCF3EB), // Very light soft brown
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: commonColor, size: 20.w),
              onPressed: () {
                if (widget.onBackPressed != null) {
                  widget.onBackPressed!();
                  return;
                }
                if (Get.key.currentState?.canPop() ?? false) {
                  Get.back();
                }
              },
            ),
          ),
        ),
        title: Text(
          'Orders',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: const Color(0xFF334155),
              size: 24.w,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: const Color(0xFF334155),
              size: 24.w,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: BlocBuilder<SellerCubit, SellerState>(
              builder: (context, state) {
                int pendingCount = 0;
                int shippedCount = 0;
                int completedCount = 0;
                int cancelledCount = 0;
                if (state is SellerLoaded) {
                  pendingCount = state.orders.where((o) => o.status.toLowerCase() == 'pending').length;
                  shippedCount = state.orders.where((o) => o.status.toLowerCase() == 'shipped').length;
                  completedCount = state.orders.where((o) => o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered').length;
                  cancelledCount = state.orders.where((o) => o.status.toLowerCase() == 'cancelled').length;
                }
                return TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: commonColor,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  indicatorColor: commonColor,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent, // manually added border below
                  tabs: [
                    Tab(text: pendingCount > 0 ? 'Pending ($pendingCount)' : 'Pending'),
                    Tab(text: shippedCount > 0 ? 'Shipped ($shippedCount)' : 'Shipped'),
                    Tab(text: completedCount > 0 ? 'Completed ($completedCount)' : 'Completed'),
                    Tab(text: cancelledCount > 0 ? 'Cancelled ($cancelledCount)' : 'Cancelled'),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading || state is SellerInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is SellerError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              ),
            );
          }
          
          if (state is SellerLoaded) {
            final pendingOrders = state.orders.where((o) => o.status.toLowerCase() == 'pending').toList();
            final shippedOrders = state.orders.where((o) => o.status.toLowerCase() == 'shipped').toList();
            final completedOrders = state.orders.where((o) => o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered').toList();
            final cancelledOrders = state.orders.where((o) => o.status.toLowerCase() == 'cancelled').toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(pendingOrders, 'Pending'),
                _buildOrdersList(shippedOrders, 'Shipped'),
                _buildOrdersList(completedOrders, 'Completed'),
                _buildOrdersList(cancelledOrders, 'Cancelled'),
              ],
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrdersList(List<SellerOrderModel> orders, String tabName) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<SellerCubit>().loadDashboard(showLoading: false);
        },
        color: const Color(0xff8B4513),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            Icon(
              Icons.inventory_2_outlined,
              size: 48.w,
              color: const Color(0xFF94A3B8),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                'No $tabName Orders',
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<SellerCubit>().loadDashboard(showLoading: false);
      },
      color: const Color(0xff8B4513),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final statusLower = order.status.toLowerCase();
        final canCancel = statusLower == 'pending' || statusLower == 'shipped';
        final isFinished = statusLower == 'completed' || statusLower == 'delivered' || statusLower == 'cancelled';

        final shortOrderId = order.orderId.length > 6 
            ? order.orderId.substring(0, 6).toUpperCase() 
            : order.orderId.toUpperCase();
            
        final displayCustomer = (order.customerName.length > 20 && !order.customerName.contains(' '))
            ? 'Customer'
            : order.customerName;

        String formattedDate = order.orderDate;
        try {
          final dt = DateTime.parse(order.orderDate).toLocal();
          formattedDate = '${dt.day}/${dt.month}/${dt.year} ${dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour)}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
        } catch (_) {}

        return SellerManageOrderCard(
          onTap: () {
            Get.to(() => SellerOrderDetailsScreen(order: order));
          },
          orderId: 'Order #$shortOrderId',
          customerName: displayCustomer,
          itemCount: order.items.length,
          totalAmount: order.totalAmount.toString(),
          status: order.status.toUpperCase(),
          timeAgo: formattedDate,
          buttonText: statusLower == 'pending' 
              ? 'Mark as Shipped' 
              : statusLower == 'shipped'
                  ? 'Mark as Completed'
                  : 'Archive',
          isButtonFilled: statusLower == 'pending' || statusLower == 'shipped',
          imageUrl: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=200&h=200&fit=crop',
          onCancelPressed: canCancel ? () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Cancel Order'),
                content: Text('Are you sure you want to cancel order ${order.orderId}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      try {
                        await context.read<SellerCubit>().updateOrderStatus(order.orderId, 'Cancelled');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order has been cancelled and stock restored'),
                              backgroundColor: Color(0xFFD32F2F),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to cancel order: $e'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Yes, Cancel', style: TextStyle(color: Color(0xFFD32F2F))),
                  ),
                ],
              ),
            );
          } : null,
          onButtonPressed: () {
            if (isFinished) {
              // Archive the order
              context.read<SellerCubit>().archiveOrder(order.orderId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order archived successfully'),
                  backgroundColor: Color(0xFF64748B),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            String newStatus = '';
            if (statusLower == 'pending') {
              newStatus = 'Shipped';
            } else if (statusLower == 'shipped') {
              newStatus = 'Completed';
            }
            
            if (newStatus.isNotEmpty) {
              context.read<SellerCubit>().updateOrderStatus(order.orderId, newStatus);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order status updated to $newStatus'),
                  backgroundColor: const Color(0xff07880E),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    ));
  }
}
