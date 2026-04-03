import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/seller_model.dart';
import 'seller_status_badge.dart';

class SellerOrderCard extends StatelessWidget {
  final SellerOrderModel order;
  final VoidCallback? onTap;

  const SellerOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Order ID + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderId,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                SellerStatusBadge(status: order.status),
              ],
            ),
            SizedBox(height: 10.h),
            // Customer name
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  order.customerName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            // Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  order.orderDate,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Divider
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            SizedBox(height: 10.h),
            // Bottom row: Items count + Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff8B4513),
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
