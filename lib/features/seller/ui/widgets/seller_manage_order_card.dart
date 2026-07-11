import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class SellerManageOrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final int itemCount;
  final String totalAmount;
  final String timeAgo;
  final String? imageUrl;
  final String status;
  final String buttonText;
  final bool isButtonFilled;
  final VoidCallback onButtonPressed;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onTap;

  const SellerManageOrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.itemCount,
    required this.totalAmount,
    required this.timeAgo,
    this.imageUrl,
    required this.status,
    required this.buttonText,
    required this.isButtonFilled,
    required this.onButtonPressed,
    this.onCancelPressed,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFD97706); // amber text
      case 'SHIPPED':
      case 'PROCESSING':
        return const Color(0xFF2563EB); // blue text
      case 'COMPLETED':
      case 'DELIVERED':
        return const Color(0xFF07880E); // green text
      case 'CANCELLED':
        return const Color(0xFFD32F2F); // red text
      default:
        return const Color(0xFF64748B); // grey text
    }
  }

  Color _getStatusBgColor() {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFFEF3C7); // light amber bg
      case 'SHIPPED':
      case 'PROCESSING':
        return const Color(0xFFDBEAFE); // light blue bg
      case 'COMPLETED':
      case 'DELIVERED':
        return const Color(0xFFE8F5E9); // light green bg
      case 'CANCELLED':
        return const Color(0xFFFFEBEE); // light red bg
      default:
        return const Color(0xFFF1F5F9); // light grey bg
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
          // Top Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Image
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xFFF1F5F9),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Icon(Icons.image_outlined,
                                color: Colors.grey, size: 24.w),
                          )
                        : Icon(Icons.image_outlined,
                            color: Colors.grey, size: 24.w),
                  ),
                ),
                SizedBox(width: 12.w),
                // Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              orderId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF0F172A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _getStatusBgColor(),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${context.l10n.customerLabel} $customerName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      RichText(
                        text: TextSpan(
                          text:
                              '$itemCount ${itemCount > 1 ? context.l10n.items : context.l10n.item} • ${context.l10n.totalLabel} ',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          children: [
                            TextSpan(
                              text: 'EGP $totalAmount',
                              style: TextStyle(
                                color: commonColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF8F5), // Light warm beige
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(11.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    timeAgo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onCancelPressed != null)
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: InkWell(
                          onTap: onCancelPressed,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: const Color(0xFFD32F2F), width: 1),
                            ),
                            child: Text(
                              context.l10n.cancel,
                              style: TextStyle(
                                color: const Color(0xFFD32F2F),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: onButtonPressed,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isButtonFilled ? commonColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: isButtonFilled
                              ? null
                              : Border.all(color: commonColor, width: 1),
                        ),
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            color: isButtonFilled ? Colors.white : commonColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
