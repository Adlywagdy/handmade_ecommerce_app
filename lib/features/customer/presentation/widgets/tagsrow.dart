import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class TagsRow extends StatelessWidget {
  const TagsRow({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33.h,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomTextContainer(
              text: product.tags![index],

              backGroundColor: customerbackGroundColor,
              bordercolor: commonColor.withValues(alpha: 0.1),
              verticalpadding: 4.h,
              horizontalpadding: 12,
              textstyle: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              borderRadius: 200.r,
            ),
          );
        },
        itemCount: product.tags!.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
