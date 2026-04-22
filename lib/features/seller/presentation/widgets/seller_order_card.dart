import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerOrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String productName;
  final String timeAgo;
  final String price;
  final VoidCallback? onTap;

  const SellerOrderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.productName,
    required this.timeAgo,
    required this.price,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status.toUpperCase()) {
      case 'PROCESSING':
        return const Color(0xFFD97706);
      case 'SHIPPED':
        return const Color(0xFF2563EB);
      case 'DELIVERED':
        return const Color(0xFF07880E);
      case 'CANCELLED':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBackgroundColor() {
    switch (status.toUpperCase()) {
      case 'PROCESSING':
        return const Color(0xFFFFF3E0);
      case 'SHIPPED':
        return const Color(0xFFE3F2FD);
      case 'DELIVERED':
        return const Color(0xFFE8F5E9);
      case 'CANCELLED':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side: Order info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        orderId,
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 14.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusBackgroundColor(),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(),
                            fontSize: 10.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$productName • $timeAgo',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Right side: Price and arrow
            Row(
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF94A3B8),
                  size: 20.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
