import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class SellerProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String stock;
  final String status;
  final String? imageUrl;
  final bool isActive;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onMenuTap;

  const SellerProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.stock,
    required this.status,
    this.imageUrl,
    this.isActive = true,
    this.onToggle,
    this.onMenuTap,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF07880E);
      case 'pending review':
        return const Color(0xFFD97706);
      case 'inactive':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFFE8F5E9);
      case 'pending review':
        return const Color(0xFFFFF3E0);
      case 'inactive':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: const Color(0xFFF8F7F6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_outlined,
                          color: const Color(0xFF94A3B8),
                          size: 28.w,
                        );
                      },
                    )
                  : Icon(
                      Icons.image_outlined,
                      color: const Color(0xFF94A3B8),
                      size: 28.w,
                    ),
            ),
          ),
          SizedBox(width: 12.w),

          // Product Info (middle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
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
                    status,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 10.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Product Name
                Text(
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 15.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),

                // Price
                Text(
                  price,
                  style: TextStyle(
                    color: commonColor,
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                // Stock
                Text(
                  stock,
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

          // Right side: Toggle + Menu
          Column(
            children: [
              SizedBox(height: 4.h),
              // Toggle Switch
              SizedBox(
                height: 28.h,
                child: Switch(
                  value: isActive,
                  onChanged: onToggle,
                  activeThumbColor: Colors.white,
                  activeTrackColor: commonColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              SizedBox(height: 8.h),
              // Menu icon
              InkWell(
                onTap: onMenuTap,
                child: Icon(
                  Icons.format_list_bulleted,
                  color: const Color(0xFF94A3B8),
                  size: 20.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
