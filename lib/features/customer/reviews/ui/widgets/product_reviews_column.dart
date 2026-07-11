import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_text_container.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/ui/widgets/review_card.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/data/models/reviews_model.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/ui/screens/reviews_screen.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

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
              context.l10n.reviews,
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
              text: context.l10n.viewAllReviews(reviews.length),
              textstyle: AppTextStyles.t_14w700.copyWith(color: commonColor),
            ),
          ),
      ],
    );
  }
}
