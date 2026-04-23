import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class SellerRegistrationScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const SellerRegistrationScreen({super.key, this.onBackPressed});

  @override
  State<SellerRegistrationScreen> createState() =>
      _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: commonColor, size: 24.w),
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
              return;
            }
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            }
          },
        ),
        title: Text(
          'Seller Registration',
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
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Cards
              _buildInfoCard(
                icon: Icons.language,
                title: 'Global Reach',
                subtitle: 'Sell to customers worldwide',
              ),
              _buildInfoCard(
                icon: Icons.verified_user_outlined,
                title: 'Secure Sales',
                subtitle: 'Guaranteed safe payments',
              ),
              _buildInfoCard(
                icon: Icons.support_agent_outlined,
                title: '24/7 Support',
                subtitle: 'Dedicated artisan assistance',
              ),

              SizedBox(height: 24.h),

              // Shop Profile Section
              Text(
                'Shop Profile',
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              SizedBox(height: 20.h),

              // Shop Name
              _buildLabel('Shop Name'),
              _buildTextField(hint: 'e.g. Damascus Woodcrafts'),
              SizedBox(height: 16.h),

              // Craft Specialty
              _buildLabel('Craft Specialty'),
              _buildTextField(
                hint: 'Select your primary craft',
                suffixIcon: Icon(Icons.keyboard_arrow_down,
                    color: commonColor, size: 24.w),
              ),
              SizedBox(height: 16.h),

              // Artisan Bio
              _buildLabel('Artisan Bio'),
              _buildTextField(
                hint:
                    'Tell us about your journey, your craft, and\nwhat makes your products unique...',
                maxLines: 4,
              ),
              SizedBox(height: 16.h),

              // Portfolio
              _buildLabel('Portfolio & Product Samples'),
              _buildUploadBox(),
              _buildThumbnailsRow(),

              SizedBox(height: 24.h),

              // Terms & Conditions
              _buildTermsCheckbox(),

              SizedBox(height: 24.h),

              // Submit Button
              _buildSubmitButton(),

              // Footer Config
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    'Our curation team will review your application within 3–5\nbusiness days.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFC6A18C),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Plus Jakarta Sans',
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: commonColor, size: 24.w),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1E293B),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              color: const Color(0xFFC6A18C),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF1E293B),
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Plus Jakarta Sans',
        color: const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF94A3B8),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Plus Jakarta Sans',
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: maxLines > 1 ? 16.h : 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: commonColor),
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: const Color(0xFFD6C3B1),
        strokeWidth: 1.5,
        gap: 6.0,
        dashLength: 6.0,
        radius: 8.r,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8F4), // Light warm beige
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: commonColor, size: 32.w),
            SizedBox(height: 12.h),
            Text(
              'Click to upload or drag and drop',
              style: TextStyle(
                color: const Color(0xFF1E293B),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'PNG, JPG or PDF (max. 10MB)',
              style: TextStyle(
                color: const Color(0xFFC6A18C),
                fontSize: 12.sp,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailsRow() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          _buildThumbnail(
            'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=100&q=80',
          ),
          SizedBox(width: 12.w),
          _buildThumbnail(
            'https://images.unsplash.com/photo-1546213290-e1b492ab3ee4?w=100&q=80',
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(2.w),
            child: Icon(Icons.close, color: Colors.white, size: 10.w),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (val) {
              setState(() {
                _agreedToTerms = val ?? false;
              });
            },
            activeColor: commonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            side: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'I agree to the ',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 11.sp,
                height: 1.4,
                fontFamily: 'Plus Jakarta Sans',
              ),
              children: [
                TextSpan(
                  text: 'Seller Terms of Service',
                  style: TextStyle(
                    color: commonColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(
                  text: ' and acknowledge\nthe platform commission rates on sales.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: commonColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Submit Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.send_outlined, color: Colors.white, size: 20.w),
          ],
        ),
      ),
    );
  }
}

/// A custom painter to draw a dashed rounded rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashLength = 5.0,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius)));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = distance + dashLength;
        dashPath.addPath(metric.extractPath(distance, length), Offset.zero);
        distance = length + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
