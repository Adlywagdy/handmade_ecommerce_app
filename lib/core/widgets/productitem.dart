import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/presentation/widgets/productimagesscroll.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final Widget? lowercolumn;
  final int imageflex;
  final int lowercolumnflex;
  final double? elevation;
  final Clip imageclipBehavior;
  final Clip cardclipBehavior;
  final double lowercolumnleftpadding;
  final double lowercolumnrightpadding;
  final double lowercolumnbottompadding;
  final double lowercolumntoppadding;
  final double cardmargin;
  const ProductItem({
    super.key,
    required this.product,
    this.lowercolumn,
    required this.imageflex,
    required this.lowercolumnflex,
    this.elevation = 1,
    this.imageclipBehavior = Clip.none,
    this.lowercolumnleftpadding = 14.0,
    this.lowercolumnrightpadding = 14.0,
    this.lowercolumnbottompadding = 14.0,
    this.lowercolumntoppadding = 14.0,
    this.cardmargin = 0,
    required this.cardclipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.customerProductDetails, arguments: product);
      },
      child: Card(
        color: customerbackGroundColor,
        margin: EdgeInsets.all(cardmargin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12).r,
        ),
        clipBehavior: cardclipBehavior,

        elevation: elevation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: imageflex,
              child: Container(
                clipBehavior: imageclipBehavior,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12).r,
                ),
                child: ProductImagesScroll(product: product),
              ),
            ),
            Expanded(
              flex: lowercolumnflex,
              child: Padding(
                padding: EdgeInsets.only(
                  left: lowercolumnleftpadding,
                  right: lowercolumnrightpadding,
                  bottom: lowercolumnbottompadding,
                  top: lowercolumntoppadding,
                ),
                child: lowercolumn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
