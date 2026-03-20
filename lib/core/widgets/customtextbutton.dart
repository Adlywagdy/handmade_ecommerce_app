import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.buttontext,
    this.bordercolor = customerbackGroundColor,
    this.fontSize = 14,
    this.backGroundColor = customerbackGroundColor,
    this.textcolor = commonColor,
    this.verticalpadding = 0,
    this.horizontalpadding = 0,
  });

  final String buttontext;
  final Color bordercolor;
  final Color backGroundColor;
  final Color? textcolor;
  final double? fontSize;
  final double? verticalpadding;
  final double? horizontalpadding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalpadding!.h,
          horizontal: horizontalpadding!.w,
        ),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: bordercolor, width: 1.5),
        ),

        child: Text(
          buttontext,
          style: TextStyle(
            color: textcolor,
            fontSize: fontSize?.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
