import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            product.category!.categorytitle,

            style: TextStyle(
              color: const Color(0xFF8B4513),
              fontSize: 10,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: 0.50,
            ),
          ),
        ),
        Text(
          product.name,
          overflow: .ellipsis,
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              '\$${product.price}',
              style: TextStyle(
                color: const Color(0xFF8B4513),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
            RatingRow(product: product),
          ],
        ),
      ],
    );
  }
}
