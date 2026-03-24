import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class CustomFeatureRow extends StatelessWidget {
  final String title;
  final String buttontext;
  final FontWeight? buttontextfontWeight;

  const CustomFeatureRow({
    super.key,
    required this.title,
    required this.buttontext,
    this.buttontextfontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: blackDegree,
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),

        InkWell(
          child: CustomTextContainer(
            buttontext: buttontext,
            fontWeight: buttontextfontWeight,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
