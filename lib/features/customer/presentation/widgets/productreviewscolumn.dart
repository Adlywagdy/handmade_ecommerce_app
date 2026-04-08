import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/reviewcard.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ratingrow.dart';

class ProductReviewsColumn extends StatelessWidget {
  const ProductReviewsColumn({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
            ),
            Row(
              children: [
                RatingRow(product: product),
                Text(
                  ' (${product.reviews!.length})',
                  style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
                ),
              ],
            ),
          ],
        ),
        ReviewCard(product: product),
        InkWell(
          onTap: () {
            // Handle view all reviews action
          },
          child: CustomTextContainer(
            text: 'View all ${product.reviews!.length} reviews',
            textstyle: AppTextStyles.t_14w700.copyWith(color: commonColor),
          ),
        ),
      ],
    );
  }
}
