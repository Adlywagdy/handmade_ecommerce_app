import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomTextContainer extends StatelessWidget {
  const CustomTextContainer({
    super.key,
    required this.text,
    this.bordercolor = customerbackGroundColor,

    this.backGroundColor = customerbackGroundColor,

    this.verticalpadding = 0,
    this.horizontalpadding = 0,
    this.borderRadius = 10,
    this.textstyle,
  });

  final double? verticalpadding;
  final double? horizontalpadding;
  final Color backGroundColor;
  final Color bordercolor;
  final String text;

  final double? borderRadius;

  final TextStyle? textstyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalpadding!.h,
        horizontal: horizontalpadding!.w,
      ),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(borderRadius!.r),
        border: Border.all(color: bordercolor, width: 1.5),
      ),

      child: Text(text, style: textstyle),
    );
  }
}
