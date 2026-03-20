import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';

import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customsellerlisttile.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productdetailslowercolumn.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: customerbackGroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          CustomIconButton(
            backgroundColor: customerbackGroundColor,
            icon: Icons.share_outlined,
            iconcolor: darkblue,
          ),
        ],
        title: Text(
          'Product Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blackDegree,
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.45,
          ),
        ),
      ),
      body: ProductItem(
        product: product,
        imageflex: 6,
        lowercolumnflex: 4,
        cardclipBehavior: Clip.antiAlias,
        lowercolumn: ProductDetailsLowerColumn(product: product),
      ),
    );
  }
}
