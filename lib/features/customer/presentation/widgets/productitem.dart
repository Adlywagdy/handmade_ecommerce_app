import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productimage.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final Widget? lowercolumn;
  final int imageflex;
  final int lowercolumnflex;
  final double? elevation;
  final Clip imageclipBehavior;
  final double lowercolumnpadding;
  const ProductItem({
    super.key,
    required this.product,
    this.lowercolumn,
    required this.imageflex,
    required this.lowercolumnflex,
    this.elevation = 1,
    this.imageclipBehavior = Clip.none,
    this.lowercolumnpadding = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: customerbackGroundColor,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: .antiAlias,

      elevation: elevation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: imageflex,
            child: Container(
              clipBehavior: imageclipBehavior,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ProductImage(productimage: product.images[0]),
            ),
          ),
          Expanded(
            flex: lowercolumnflex,
            child: Padding(
              padding: EdgeInsets.all(lowercolumnpadding).h,
              child: lowercolumn,
            ),
          ),
        ],
      ),
    );
  }
}
