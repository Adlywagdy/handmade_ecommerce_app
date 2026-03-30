import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomStarsRatingReview extends StatefulWidget {
  const CustomStarsRatingReview({super.key, required this.product});

  final ProductModel product;

  @override
  State<CustomStarsRatingReview> createState() =>
      _CustomStarsRatingReviewState();
}

int? index;

class _CustomStarsRatingReviewState extends State<CustomStarsRatingReview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .center,

          children: List.generate(5, (rateindex) {
            return InkWell(
              onTap: () {
                setState(() {
                  index = rateindex;
                });
              },

              child: index != null && index! >= rateindex
                  ? Icon(
                      Icons.star_border,
                      size: 50.w,
                      fill: 0,
                      color: orangedegree,
                    )
                  : Icon(
                      Icons.star_border,
                      size: 50.w,
                      color: orangedegree.withValues(alpha: .2),
                    ),
            );
          }),
        ),
        SizedBox(height: 10.h),
        Text(
          index != null ? getReviewLabel(index!).name.toUpperCase() : "",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: orangedegree.withValues(alpha: .9),
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.56,
            letterSpacing: 1.80,
          ),
        ),
      ],
    );
  }
}

enum Rating { poor, bad, average, great, excellent }

Rating getReviewLabel(int rating) {
  switch (rating) {
    case 0:
      return Rating.poor;
    case 1:
      return Rating.bad;
    case 2:
      return Rating.average;
    case 3:
      return Rating.great;
    case 4:
      return Rating.excellent;
    default:
      throw ArgumentError('Invalid rating value: $rating');
  }
}
