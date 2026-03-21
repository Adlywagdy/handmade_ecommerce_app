import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({
    super.key,
    required this.product,
    this.iconsize = 20,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w500,
  });
  final double? fontSize;
  final ProductModel product;
  final double? iconsize;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_border_outlined, color: goldColor, size: iconsize!.sp),
        Text(
          "${product.totalrate}",
          style: TextStyle(
            color: blackDegree,
            fontSize: fontSize!.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: fontWeight,
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
