import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

class TopRatedProductItemLowerColumn extends StatelessWidget {
  final ProductModel product;
  const TopRatedProductItemLowerColumn({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3.h,
      crossAxisAlignment: .start,
      children: [
        Text(
          product.category!.categorytitle,

          style: AppTextStyles.t_10w700.copyWith(color: commonColor),
        ),
        Text(
          product.name,
          overflow: .ellipsis,
          style: AppTextStyles.t_14w700.copyWith(color: blackDegree),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${product.price}",
              style: AppTextStyles.t_14w700.copyWith(color: commonColor),
            ),
            CustomIconButton(
              backgroundColor: commonColor,
              icon: Icons.add_shopping_cart,
              iconsize: 20.r,
              iconcolor: customerbackGroundColor,
            ),
          ],
        ),
      ],
    );
  }
}
