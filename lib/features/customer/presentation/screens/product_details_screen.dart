import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productimage.dart';

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
      body: PageView.builder(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.horizontal,
        itemCount: product.images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ProductImage(productimage: product.images[index]),
              Positioned(
                bottom: 24.h,
                right: 0.w,
                left: 0.w,
                child: SizedBox(
                  height: 12.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.w,
                    children: List.generate(product.images.length, (dotIndex) {
                      return index == dotIndex
                          ? CircleAvatar(
                              radius: 6.r,
                              backgroundColor: Colors.white,
                            )
                          : CircleAvatar(
                              radius: 6.r,
                              backgroundColor: Colors.white.withValues(
                                alpha: .4,
                              ),
                            );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
