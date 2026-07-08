import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class ButtomText extends StatelessWidget {
  final String text;

  final VoidCallback? onTap;
  final bool? isLoading;
  const ButtomText({
    super.key,
    required this.text,

    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
