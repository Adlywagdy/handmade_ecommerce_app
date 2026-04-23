import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerImageUpload extends StatelessWidget {
  final VoidCallback? onTap;
  final List<String> images;

  const SellerImageUpload({
    super.key,
    this.onTap,
    this.images = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) ...[
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + 1,
              itemBuilder: (context, index) {
                if (index == images.length) {
                  return _buildAddButton();
                }
                return _buildImageThumbnail(images[index]);
              },
            ),
          ),
          SizedBox(height: 12.h),
        ],
        if (images.isEmpty) _buildUploadArea(),
      ],
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xff8B4513).withValues(alpha: 0.4),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xff8B4513).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                color: const Color(0xff8B4513),
                size: 28.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Click to upload or drag and drop',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'PNG, JPG or PDF (max. 5MB)',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String imagePath) {
    return Container(
      width: 80.w,
      height: 80.h,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF0F3460),
          child: Icon(
            Icons.image_outlined,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xff8B4513).withValues(alpha: 0.4),
          ),
        ),
        child: Icon(
          Icons.add,
          color: const Color(0xff8B4513),
          size: 28.sp,
        ),
      ),
    );
  }
}
