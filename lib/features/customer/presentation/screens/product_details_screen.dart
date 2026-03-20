import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productdetailslowercolumn.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
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
          SliverToBoxAdapter(
            child: Container(
              height: 490.h,
              constraints: BoxConstraints(maxHeight: 550.h, minHeight: 350.h),
              child: ProductItem(
                product: product,
                imageflex: 3.h.toInt(),
                lowercolumnflex: 1.h.toInt(),
                elevation: 0,
                lowercolumnbottompadding: 0.h,
                lowercolumnleftpadding: 16.w,
                lowercolumnrightpadding: 16.w,
                cardclipBehavior: Clip.none,
                lowercolumn: Column(
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
                    Divider(
                      color: commonColor.withValues(alpha: .1),
                      height: 24.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
              child: ProductDetailsLowerColumn(product: product),
            ),
          ),
        ],
      ),
    );
  }
}
