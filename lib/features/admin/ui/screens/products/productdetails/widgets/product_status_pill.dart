import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//////////////////////////////////////////////////////////////////
class ProductStatusPill extends StatelessWidget {
  final String status;

  const ProductStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = _colorForStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

//////////////////////////////////////////////////////////////////
Color _colorForStatus(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF07880E);
      case 'rejected':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFD97706);
    }
  }
}
