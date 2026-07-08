import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/data/models/seller_model.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class SellerOrderDetailsScreen extends StatelessWidget {
  final SellerOrderModel order;

  const SellerOrderDetailsScreen({super.key, required this.order});

  Color _getStatusColor() {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFD97706);
      case 'SHIPPED':
      case 'PROCESSING':
        return const Color(0xFF2563EB);
      case 'COMPLETED':
      case 'DELIVERED':
        return const Color(0xFF07880E);
      case 'CANCELLED':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBgColor() {
    switch (order.status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFFEF3C7);
      case 'SHIPPED':
      case 'PROCESSING':
        return const Color(0xFFDBEAFE);
      case 'COMPLETED':
      case 'DELIVERED':
        return const Color(0xFFE8F5E9);
      case 'CANCELLED':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour)}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortOrderId = order.orderId.length > 6
        ? order.orderId.substring(0, 6).toUpperCase()
        : order.orderId.toUpperCase();

    final displayCustomer =
        (order.customerName.length > 20 && !order.customerName.contains(' '))
        ? context.l10n.selCustomerFallback
        : order.customerName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: commonColor, size: 24.w),
          onPressed: () => Get.back(),
        ),
        title: Text(
          context.l10n.selOrderDetails,
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFCF3EB), // Very light soft brown
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Order #$shortOrderId',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          order.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 20.w,
                        color: const Color(0xFF64748B),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          displayCustomer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF334155),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20.w,
                        color: const Color(0xFF64748B),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _formatDate(order.orderDate),
                          style: TextStyle(
                            color: const Color(0xFF334155),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Order Items
            Text(
              context.l10n.selOrderItems,
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (context, index) =>
                  Divider(color: const Color(0xFFE2E8F0), height: 24.h),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(
                              color: const Color(0xFF0F172A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            context.l10n.qty(item.quantity),
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'EGP ${item.price}',
                      style: TextStyle(
                        color: commonColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 24.h),
            Divider(color: const Color(0xFFE2E8F0), height: 1.h),
            SizedBox(height: 16.h),

            // Payment Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.selTotalEarnings,
                  style: TextStyle(
                    color: const Color(0xFF334155),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                Text(
                  'EGP ${order.totalAmount}',
                  style: TextStyle(
                    color: commonColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
