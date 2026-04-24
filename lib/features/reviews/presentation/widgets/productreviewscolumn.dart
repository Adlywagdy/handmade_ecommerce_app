import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/reviews/presentation/widgets/ReviewCard.dart';
import 'package:handmade_ecommerce_app/features/reviews/models/reviews_model.dart';
import 'package:handmade_ecommerce_app/features/reviews/presentation/screens/reviews_screen.dart';

class ProductReviewsColumn extends StatelessWidget {
  const ProductReviewsColumn({
    super.key,
    required this.reviews,
    this.productName = 'Product',
  });

  final List<ReviewsModel> reviews;
  final String productName;

  double get _averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final displayedReviews = reviews.take(2).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
            ),
            Row(
              children: [
                Icon(Icons.star_border_outlined, color: goldColor, size: 20),
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: AppTextStyles.t_14w400,
                ),
                Text(
                  ' (${reviews.length})',
                  style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
                ),
              ],
            ),
          ],
        ),
        ...displayedReviews.map((review) => ReviewCard(review: review)),
        if (reviews.length > 2)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      ReviewsScreen(productName: productName, reviews: reviews),
                ),
              );
            },
            child: CustomTextContainer(
              text: 'View all ${reviews.length} reviews',
              textstyle: AppTextStyles.t_14w700.copyWith(color: commonColor),
            ),
          ),
      ],
    );
  }
}
