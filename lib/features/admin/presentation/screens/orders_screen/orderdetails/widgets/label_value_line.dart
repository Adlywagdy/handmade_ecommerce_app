import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'order_details_body.dart';

class LabelValueLine extends StatelessWidget {
  final InfoRow row;
  const LabelValueLine({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final String displayValue = row.value.isEmpty ? '—' : row.value;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            '${row.label}:',
            style: TextStyle(fontSize: 12.sp, color: subTitleColor),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: blackDegree,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
