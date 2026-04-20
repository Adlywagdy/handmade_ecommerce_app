import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class SellerBestSellingCard extends StatelessWidget {
  final String productName;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback? onStarTap;

  const SellerBestSellingCard({
    super.key,
    required this.productName,
    required this.subtitle,
    this.imageUrl,
    this.onStarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: commonColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: commonColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best-Selling Product',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: onStarTap,
                child: Icon(
                  Icons.star_outline,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Product info row
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_outlined,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 24.w,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.image_outlined,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 24.w,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
