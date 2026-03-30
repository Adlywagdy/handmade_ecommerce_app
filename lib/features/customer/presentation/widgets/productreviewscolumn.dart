import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
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
              style: TextStyle(
                color: blackDegree,
                fontSize: 18.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.56,
              ),
            ),
            Row(
              children: [
                RatingRow(
                  product: product,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
                Text(
                  ' (${product.reviews!.length})',
                  style: TextStyle(
                    color: subTitleColor,
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ],
        ),
        ReviewCard(product: product),
        InkWell(
          onTap: () {},
          child: CustomTextContainer(
            text: 'View all ${product.reviews!.length} reviews',
          ),
        ),
      ],
    );
  }
}
