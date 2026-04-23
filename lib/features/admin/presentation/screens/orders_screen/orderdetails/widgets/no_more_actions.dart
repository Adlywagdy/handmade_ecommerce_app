import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/models/orders_model.dart';

class NoMoreActions extends StatelessWidget {
  final OrderStatus status;
  const NoMoreActions({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16.sp, color: subTitleColor),
          SizedBox(width: 8.w),
          Text(
            'No further actions — ${status.name}',
            style: TextStyle(fontSize: 12.sp, color: subTitleColor),
          ),
        ],
      ),
    );
  }
}
