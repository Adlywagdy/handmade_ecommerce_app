import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerImageUpload extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(int)? onDelete;
  final List<String> images;

  const SellerImageUpload({
    super.key,
    this.onTap,
    this.onDelete,
    this.images = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) ...[
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + 1,
              itemBuilder: (context, index) {
                if (index == images.length) {
                  return _buildAddButton();
                }
                return _buildImageThumbnail(images[index], index);
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
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
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
                color: const Color(0xff8B4513).withOpacity(0.1),
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
                color: const Color(0xFF0F172A),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'PNG, JPG or PDF (max. 5MB)',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String imagePath, int index) {
    ImageProvider imageProvider;
    if (imagePath.startsWith('http')) {
      imageProvider = NetworkImage(imagePath);
    } else if (imagePath.startsWith('/') || imagePath.contains('Users/') || imagePath.contains('data/')) {
      imageProvider = FileImage(File(imagePath));
    } else {
      imageProvider = AssetImage(imagePath);
    }

    return Stack(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          margin: EdgeInsets.only(right: 12.w, top: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFF1F5F9),
              child: Icon(
                Icons.image_outlined,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: 0,
            right: 4.w,
            child: GestureDetector(
              onTap: () => onDelete!(index),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Color(0xffD32F2F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.h,
        margin: EdgeInsets.only(top: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
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
