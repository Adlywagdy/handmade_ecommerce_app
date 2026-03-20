import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customsellerlisttile.dart';

class ProductDetailsLowerColumn extends StatelessWidget {
  const ProductDetailsLowerColumn({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            color: blackDegree,
            fontSize: 30.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.75,
          ),
        ),
        Text(
          '\$${product.price}',
          style: TextStyle(
            color: commonColor,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.33,
          ),
        ),
        Divider(color: commonColor.withValues(alpha: .1)),
        CustomSellerListTile(product: product),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            'Description',
            style: TextStyle(
              color: blackDegree,
              fontSize: 18.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
        ),
        Text(
          'This exquisite Terra Vase is hand-thrown by master\nartisans using traditional Mediterranean techniques.\nEach piece is unique, featuring a natural matte finish\nand subtle variations in texture that celebrate the\norganic beauty of locally sourced clay. Perfect for\ndried botanicals or as a standalone sculptural piece.',
          style: TextStyle(
            color: subTitleColor,
            fontSize: 14.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.63,
          ),
        ),
      ],
    );
  }
}
