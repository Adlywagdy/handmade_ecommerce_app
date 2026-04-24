import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/reviews/models/reviews_model.dart';
import 'package:handmade_ecommerce_app/features/reviews/presentation/widgets/reviews_widget.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({
    super.key,
    required this.productName,
    required this.reviews,
  });

  final String productName;
  final List<ReviewsModel> reviews;

  @override
  Widget build(BuildContext context) {
    final title = productName.trim().isEmpty ? 'Product' : productName.trim();

    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: customerbackGroundColor,
        title: Text('All Reviews', style: AppTextStyles.t_18w700),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.t_16w700,
            ),
            SizedBox(height: 4.h),
            Text(
              '${reviews.length} review${reviews.length == 1 ? '' : 's'}',
              style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
            ),
            SizedBox(height: 12.h),
            Expanded(child: ReviewsWidget(reviews: reviews)),
          ],
        ),
      ),
    );
  }
}
