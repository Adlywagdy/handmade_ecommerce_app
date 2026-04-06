import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/seller_model.dart';
import 'seller_status_badge.dart';

class SellerProductCard extends StatelessWidget {
  final SellerProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggleActive;

  const SellerProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                product.images.isNotEmpty
                    ? product.images[0]
                    : 'assets/images/splash.jpeg',
                width: 72.w,
                height: 72.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72.w,
                  height: 72.h,
                  color: const Color(0xFF0F3460),
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 28.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff8B4513),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SellerStatusBadge(status: product.status),
                ],
              ),
            ),
            // Actions column
            Column(
              children: [
                // Active toggle
                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: product.isActive,
                    onChanged: (val) => onToggleActive?.call(val),
                    activeThumbColor: const Color(0xff8B4513),
                    activeTrackColor:
                        const Color(0xff8B4513).withValues(alpha: 0.3),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor:
                        Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _actionButton(
                      Icons.edit_outlined,
                      const Color(0xff8B4513),
                      onEdit,
                    ),
                    SizedBox(width: 4.w),
                    _actionButton(
                      Icons.delete_outline,
                      const Color(0xffD32F2F),
                      onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
    );
  }
}
