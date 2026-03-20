import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.productimage});

  final String productimage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(productimage, fit: BoxFit.fill),

        Positioned(
          right: 8.w,
          top: 8.h,
          child: CustomIconButton(
            backgroundColor: Colors.white.withValues(alpha: 0.8),
            icon: Icons.favorite_border,
            iconcolor: commonColor,
          ),
        ),
      ],
    );
  }
}
