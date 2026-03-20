import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextbutton.dart';

class CustomFeatureRow extends StatelessWidget {
  final String title;
  final String buttontext;
  const CustomFeatureRow({
    super.key,
    required this.title,
    required this.buttontext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: blackDegree,
              fontSize: 18,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
            ),
          ),

          CustomTextButton(buttontext: buttontext),
        ],
      ),
    );
  }
}
