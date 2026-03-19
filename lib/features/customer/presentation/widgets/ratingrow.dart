import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({super.key, required this.product, this.iconsize = 20});

  final ProductModel product;
  final double? iconsize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_border_outlined, color: goldColor, size: iconsize!.sp),
        Text(
          "${product.rate}",
          style: TextStyle(
            color: blackDegree,
            fontSize: 12,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
