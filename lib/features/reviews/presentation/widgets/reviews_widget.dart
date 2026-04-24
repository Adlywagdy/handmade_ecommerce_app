import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ReviewCard.dart';
import 'package:handmade_ecommerce_app/features/reviews/models/reviews_model.dart';

class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget({super.key, required this.reviews});

  final List<ReviewsModel> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Center(
        child: Text(
          'No reviews available.',
          style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: reviews[index]);
      },
    );
  }
}
