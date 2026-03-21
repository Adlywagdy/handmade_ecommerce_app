import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class TagsRow extends StatelessWidget {
  const TagsRow({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0).h,
      child: Row(
        spacing: 8.w,
        children: [
          CustomTextContainer(
            buttontext: product.tags![0],

            backGroundColor: customerbackGroundColor,
            bordercolor: commonColor.withValues(alpha: 0.1),
            verticalpadding: 4.h,
            horizontalpadding: 12.w,
            textcolor: subTitleColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            borderRadius: 200,
          ),
          CustomTextContainer(
            buttontext: product.tags![1],

            backGroundColor: customerbackGroundColor,
            bordercolor: commonColor.withValues(alpha: 0.1),
            verticalpadding: 4.h,
            horizontalpadding: 12.w,
            textcolor: subTitleColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            borderRadius: 200,
          ),
          CustomTextContainer(
            buttontext: product.tags![2],

            backGroundColor: customerbackGroundColor,
            bordercolor: commonColor.withValues(alpha: 0.1),
            verticalpadding: 4.h,
            horizontalpadding: 12.w,
            textcolor: subTitleColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            borderRadius: 200,
          ),
        ],
      ),
    );
  }
}
