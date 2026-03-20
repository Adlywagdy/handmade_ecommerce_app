import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productimage.dart';

class ProductImagesScroll extends StatelessWidget {
  const ProductImagesScroll({super.key, required this.list});
  final List list;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(initialPage: 0),
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ProductImage(productimage: list[index]),
            Positioned(
              bottom: 16.h,
              right: 0.w,
              left: 0.w,
              child: SizedBox(
                height: 12.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: List.generate(list.length, (dotIndex) {
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
