import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customsellerlisttile.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productreviewscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/tagsrow.dart';

class ProductDetailsLowerColumn extends StatelessWidget {
  const ProductDetailsLowerColumn({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSellerListTile(product: product),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text('Description', style: AppTextStyles.t_18w700),
        ),
        Text(
          product.description,
          style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
        ),
        SizedBox(height: 12.h),
        product.tags != null && product.tags!.isNotEmpty
            ? TagsRow(product: product)
            : SizedBox(height: 16.h),
        SizedBox(height: 12.h),
        product.reviews != null && product.reviews!.isNotEmpty
            ? ProductReviewsColumn(product: product)
            : Text(
                "No reviews yet for this product. Be the first to share your thoughts!",
                textAlign: TextAlign.center,
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
