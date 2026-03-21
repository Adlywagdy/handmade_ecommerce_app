import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customstarsratingrow.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 16.0).h,
      child: Padding(
        padding: const EdgeInsets.all(16.0).h,
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.reviews![0].reviewer.name,
                  style: TextStyle(
                    color: blackDegree,
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                Text(
                  "${product.reviews![0].reviewDate.year.toString()}-${product.reviews![0].reviewDate.month.toString().padLeft(2, '0')}-${product.reviews![0].reviewDate.day.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: subTitleColor,
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            CustomStarsRatingRow(product: product),
            Text(
              '"${product.reviews![0].reviewText}"',
              style: TextStyle(
                color: subTitleColor,
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
