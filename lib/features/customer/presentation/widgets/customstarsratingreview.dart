import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomStarsRatingReview extends StatelessWidget {
  const CustomStarsRatingReview({
    super.key,
    required this.selectedRating,
    required this.onChanged,
  });

  final int selectedRating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .center,

          children: List.generate(5, (rateindex) {
            final starValue = rateindex + 1;
            final isSelected = selectedRating >= starValue;

            return InkWell(
              borderRadius: BorderRadius.circular(999.r),
              onTap: () {
                onChanged(starValue);
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
          selectedRating > 0
              ? getReviewLabel(selectedRating).name.toUpperCase()
              : 'TAP TO RATE',
          textAlign: TextAlign.center,
          style: AppTextStyles.t_18w700.copyWith(
            color: selectedRating > 0
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
    case 1:
      return Rating.poor;
    case 2:
      return Rating.bad;
    case 3:
      return Rating.average;
    case 4:
      return Rating.great;
    case 5:
      return Rating.excellent;
    default:
      throw ArgumentError('Invalid rating value: $rating');
  }
}
