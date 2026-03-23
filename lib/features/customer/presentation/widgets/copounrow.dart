import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class CopounRow extends StatelessWidget {
  const CopounRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        Expanded(
          flex: 3.w.toInt(),
          child: TextFormField(
            cursorColor: commonColor,

            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              filled: true,
              hint: Text(
                'Promo code',
                style: TextStyle(
                  color: subTitleColor,
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: commonColor),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: commonColor.withValues(alpha: .2),
                ),
              ),
              border: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: commonColor.withValues(alpha: .2),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1.w.toInt(),
          child: CustomTextContainer(
            buttontext: "Apply",
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            horizontalpadding: 24.w,
            verticalpadding: 12.h,
            backGroundColor: commonColor.withValues(alpha: .1),
          ),
        ),
      ],
    );
  }
}
