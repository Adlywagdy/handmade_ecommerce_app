import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/favoritebutton.dart';

class ProductImagesScroll extends StatelessWidget {
  const ProductImagesScroll({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(initialPage: 0),
      scrollDirection: Axis.horizontal,
      itemCount: product.images.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(product.images[index], fit: BoxFit.fill),

            Positioned(
              right: 8.w,
              top: 8.h,
              child: FavoriteButton(product: product),
            ),

            Positioned(
              bottom: 16.h,
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
                            radius: 4.r,
                            backgroundColor: Colors.white,
                          )
                        : CircleAvatar(
                            radius: 4.r,
                            backgroundColor: Colors.white.withValues(alpha: .4),
                          );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
