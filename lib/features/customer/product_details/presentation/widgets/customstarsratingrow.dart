import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomStarsRatingRow extends StatelessWidget {
  final MainAxisAlignment? mainAxisAlignment;
  final double? spacing;
  final double? size;
  final Color? color;
  const CustomStarsRatingRow({
    super.key,
    required this.product,
    this.mainAxisAlignment = .start,
    this.spacing = 0,
    this.size = 15,
    this.color,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment!,
      spacing: spacing!,
      children: List.generate(5, (rateindex) {
        return product.reviews![0].rating >= rateindex + 1
            ? Icon(Icons.star, size: size!.r, color: color ?? goldColor)
            : Icon(
                Icons.star_border_outlined,
                size: size!.r,
                color: color ?? goldColor,
              );
      }),
    );
  }
}
