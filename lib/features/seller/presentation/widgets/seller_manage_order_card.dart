import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

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
  });

  Color _getStatusColor() {
    switch (status.toUpperCase()) {
      case 'PROCESSING':
        return const Color(0xFF2563EB); // blue text
      default: // NEW, URGENT
        return const Color(0xFFD97706); // amber text
    }
  }

  Color _getStatusBgColor() {
    switch (status.toUpperCase()) {
      case 'PROCESSING':
        return const Color(0xFFDBEAFE); // light blue bg
      default: // NEW, URGENT
        return const Color(0xFFFEF3C7); // light amber bg
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
                        'Customer: $customerName',
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
                              '$itemCount item${itemCount > 1 ? 's' : ''} • Total: ',
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
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                InkWell(
                  onTap: onButtonPressed,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
          ),
        ],
      ),
    );
  }
}
