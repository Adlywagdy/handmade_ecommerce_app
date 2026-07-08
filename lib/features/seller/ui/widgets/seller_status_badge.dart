import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellerStatusBadge extends StatelessWidget {
  final String status;

  const SellerStatusBadge({super.key, required this.status});

  Color get _backgroundColor {
    switch (status) {
      case 'In Stock':
      case 'Delivered':
        return const Color(0xff07880E).withValues(alpha: 0.15);
      case 'Pending':
        return const Color(0xffF59E0B).withValues(alpha: 0.15);
      case 'Out of Stock':
      case 'Cancelled':
        return const Color(0xffD32F2F).withValues(alpha: 0.15);
      case 'Low Stock':
        return const Color(0xffF59E0B).withValues(alpha: 0.15);
      default:
        return Colors.grey.withValues(alpha: 0.15);
    }
  }

  Color get _textColor {
    switch (status) {
      case 'In Stock':
      case 'Delivered':
        return const Color(0xff07880E);
      case 'Pending':
        return const Color(0xffF59E0B);
      case 'Out of Stock':
      case 'Cancelled':
        return const Color(0xffD32F2F);
      case 'Low Stock':
        return const Color(0xffF59E0B);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: _textColor,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }
}
