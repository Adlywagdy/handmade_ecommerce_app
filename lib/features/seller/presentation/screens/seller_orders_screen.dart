import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_manage_order_card.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';
import 'package:handmade_ecommerce_app/features/seller/models/seller_model.dart';

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
                if (state is SellerLoaded) {
                  pendingCount = state.orders.where((o) => o.status.toLowerCase() == 'pending').length;
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
                    const Tab(text: 'Shipped'),
                    const Tab(text: 'Completed'),
                    const Tab(text: 'Cancelled'),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48.w,
              color: const Color(0xFF94A3B8),
            ),
            SizedBox(height: 12.h),
            Text(
              'No $tabName Orders',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return SellerManageOrderCard(
          orderId: order.orderId,
          customerName: order.customerName,
          itemCount: order.items.length,
          totalAmount: order.totalAmount.toString(),
          status: order.status.toUpperCase(),
          timeAgo: order.orderDate,
          buttonText: order.status.toLowerCase() == 'pending' 
              ? 'Mark as Shipped' 
              : order.status.toLowerCase() == 'shipped'
                  ? 'Mark as Completed'
                  : 'Order Completed',
          isButtonFilled: order.status.toLowerCase() == 'pending' || order.status.toLowerCase() == 'shipped',
          imageUrl: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=200&h=200&fit=crop', // Provide an actual image if order items have images
          onButtonPressed: () {
            String newStatus = '';
            if (order.status.toLowerCase() == 'pending') {
              newStatus = 'Shipped';
            } else if (order.status.toLowerCase() == 'shipped') {
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
    );
  }
}
