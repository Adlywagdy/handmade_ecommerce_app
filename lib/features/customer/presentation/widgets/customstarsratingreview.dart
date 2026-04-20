import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomStarsRatingReview extends StatefulWidget {
  const CustomStarsRatingReview({super.key, required this.product});

  final ProductModel product;

  @override
  State<CustomStarsRatingReview> createState() =>
      _CustomStarsRatingReviewState();
}

class _CustomStarsRatingReviewState extends State<CustomStarsRatingReview> {
  int? selectedRatingIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .center,

          children: List.generate(5, (rateindex) {
            final isSelected =
                selectedRatingIndex != null &&
                selectedRatingIndex! >= rateindex;

            return InkWell(
              borderRadius: BorderRadius.circular(999.r),
              onTap: () {
                setState(() {
                  selectedRatingIndex = rateindex;
                });
              },

              child: Padding(
                padding: EdgeInsets.all(2.r),
                child: Icon(
                  isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 50.r,
                  color: isSelected
                      ? orangedegree
                      : orangedegree.withValues(alpha: .25),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 10.h),
        Text(
          selectedRatingIndex != null
              ? getReviewLabel(selectedRatingIndex!).name.toUpperCase()
              : 'TAP TO RATE',
          textAlign: TextAlign.center,
          style: AppTextStyles.t_18w700.copyWith(
            color: selectedRatingIndex != null
                ? orangedegree.withValues(alpha: .9)
                : subTitleColor,
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
