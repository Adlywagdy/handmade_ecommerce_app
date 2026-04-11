import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/seller_cubit.dart';
import '../../cubit/seller_state.dart';
import '../../models/seller_model.dart';
import '../widgets/seller_order_card.dart';
import '../widgets/seller_status_badge.dart';

class SellerOrdersScreen extends StatelessWidget {
  const SellerOrdersScreen({super.key});

  static const _tabs = ['All', 'Pending', 'Delivered', 'Cancelled'];

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

            final cubit = context.read<SellerCubit>();
            final filteredOrders = cubit.filteredOrders;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),

                // Tabs
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildTabs(context, state),
                ),
                SizedBox(height: 16.h),

                // Orders list
                Expanded(
                  child: filteredOrders.isEmpty
                      ? _buildEmptyState(state.activeOrderFilter)
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            return SellerOrderCard(
                              order: filteredOrders[index],
                              onTap: () => _showOrderDetails(
                                  context, filteredOrders[index], cubit),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, SellerLoaded state) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = state.activeOrderFilter == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<SellerCubit>().filterOrders(tab);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff8B4513)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56.sp,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          SizedBox(height: 16.h),
          Text(
            'No ${filter.toLowerCase()} orders',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.4),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Orders will appear here when they arrive',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.3),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(
      BuildContext context, SellerOrderModel order, SellerCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Order ID + Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderId,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      SellerStatusBadge(status: order.status),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Customer info
                  _buildDetailRow(
                      Icons.person_outline, 'Customer', order.customerName),
                  SizedBox(height: 10.h),
                  _buildDetailRow(
                      Icons.calendar_today_outlined, 'Date', order.orderDate),
                  SizedBox(height: 16.h),

                  // Items
                  Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...order.items.map((item) => Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.productName} x${item.quantity}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 8.h),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff8B4513),
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Update Status buttons
                  if (order.status == 'Pending') ...[
                    Text(
                      'Update Status',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: () {
                                cubit.updateOrderStatus(
                                    order.orderId, 'Delivered');
                                Navigator.of(ctx).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff07880E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Mark Delivered',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: OutlinedButton(
                              onPressed: () {
                                cubit.updateOrderStatus(
                                    order.orderId, 'Cancelled');
                                Navigator.of(ctx).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xffD32F2F)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffD32F2F),
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.4),
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white.withValues(alpha: 0.5),
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.8),
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }
}
