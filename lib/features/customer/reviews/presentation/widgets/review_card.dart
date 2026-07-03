import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/models/reviews_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ReviewsModel review;

  String get _formattedDate {
    final date = review.createdAt;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

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
                  'User ${review.userId.substring(0, review.userId.length >= 6 ? 6 : review.userId.length)}',
                  style: AppTextStyles.t_14w700.copyWith(color: blackDegree),
                ),
                Text(
                  _formattedDate,
                  style: AppTextStyles.t_12w400.copyWith(color: subTitleColor),
                ),
              ],
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  review.rating >= index + 1
                      ? Icons.star
                      : Icons.star_border_outlined,
                  size: 15.r,
                  color: goldColor,
                );
              }),
            ),
            Text(
              '"${review.comment}"',
              style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
            ),
          ],
        ),
      ),
    );
  }
}
