import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomTextContainer extends StatelessWidget {
  const CustomTextContainer({
    super.key,
    required this.text,
    this.bordercolor = customerbackGroundColor,
    this.fontSize = 14,
    this.backGroundColor = customerbackGroundColor,
    this.textcolor = commonColor,
    this.verticalpadding = 0,
    this.horizontalpadding = 0,
    this.borderRadius = 10,
    this.fontWeight = FontWeight.bold,
  });

  final double? verticalpadding;
  final double? horizontalpadding;
  final Color backGroundColor;
  final Color bordercolor;
  final String text;
  final Color? textcolor;
  final double? fontSize;
  final double? borderRadius;
  final FontWeight? fontWeight;

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

      child: Text(
        text,
        style: TextStyle(
          color: textcolor,
          fontSize: fontSize?.sp,
          fontWeight: fontWeight,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }
}
