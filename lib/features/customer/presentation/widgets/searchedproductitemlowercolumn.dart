import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ratingrow.dart';

class SearchedProductItemLowerColumn extends StatelessWidget {
  final ProductModel product;
  const SearchedProductItemLowerColumn({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.name,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.t_14w700.copyWith(color: blackDegree),
        ),
        Text(
          'by Studio Zahra',
          style: AppTextStyles.t_12w400.copyWith(color: darkbrownColor),
        ),
        Row(
          children: [
            RatingRow(product: product, iconsize: 15),
            Text(
              ' (${product.quantity})',
              style: AppTextStyles.t_10w400.copyWith(color: darkbrownColor),
            ),
          ],
        ),
        Text(
          "\$${product.price}",
          style: AppTextStyles.t_14w700.copyWith(color: commonColor),
        ),
      ],
    );
  }
}
