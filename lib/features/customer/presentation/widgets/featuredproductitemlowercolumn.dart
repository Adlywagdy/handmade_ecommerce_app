import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ratingrow.dart';

class FeaturedProductItemLowerColumn extends StatelessWidget {
  const FeaturedProductItemLowerColumn({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 4.h,
      children: [
        Container(
          padding: const EdgeInsets.all(8),

          decoration: BoxDecoration(
            color: commonColor.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(20).r,
          ),
          child: Text(
            product.category!.categorytitle,

            style: AppTextStyles.t_10w700.copyWith(color: commonColor),
          ),
        ),
        Text(
          product.name,
          overflow: .ellipsis,
          style: AppTextStyles.t_16w700.copyWith(color: AppColors.textPrimary),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              '\$${product.price}',

              style: AppTextStyles.t_16w700.copyWith(color: commonColor),
            ),
            RatingRow(
              product: product,

              textstyle: AppTextStyles.t_12w500.copyWith(color: darkblue),
            ),
          ],
        ),
      ],
    );
  }
}
