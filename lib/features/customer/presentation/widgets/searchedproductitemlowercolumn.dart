import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
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
          style: TextStyle(
            color: blackDegree,
            fontSize: 14.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
        Text(
          'by Studio Zahra',
          style: TextStyle(
            color: darkbrownColor,
            fontSize: 12.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.33,
          ),
        ),
        Row(
          children: [
            RatingRow(product: product, iconsize: 15),
            Text(
              ' ${product.quantity ?? '0'}',
              style: TextStyle(
                color: darkbrownColor,
                fontSize: 10.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
        Text(
          "\$${product.price}",
          style: TextStyle(
            color: commonColor,
            fontSize: 14.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
      ],
    );
  }
}
