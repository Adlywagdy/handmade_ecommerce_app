import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
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

          style: TextStyle(
            color: commonColor,
            fontSize: 10,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
        Text(
          product.name,
          overflow: .ellipsis,
          style: TextStyle(
            color: blackDegree,
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${product.price}",
              style: TextStyle(
                color: commonColor,
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.43,
              ),
            ),
            CustomIconButton(
              backgroundColor: commonColor,
              icon: Icons.add_shopping_cart,
              iconcolor: customerbackGroundColor,
            ),
          ],
        ),
      ],
    );
  }
}
