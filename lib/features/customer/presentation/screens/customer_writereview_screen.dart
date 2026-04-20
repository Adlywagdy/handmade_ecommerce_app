import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/addreviewedphotos.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customreviewdetailstextfield.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customstarsratingreview.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/reviewedproduct.dart';

class CustomerWriteReviewScreen extends StatelessWidget {
  final ProductModel product;
  const CustomerWriteReviewScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: customerbackGroundColor,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Write Review',
          textAlign: TextAlign.center,
          style: AppTextStyles.t_18w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: commonColor.withValues(alpha: .2), height: 1.h),
            ReviewedProduct(product: product),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Column(
                children: [
                  Text(
                    'How was your experience?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_24w800,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your feedback helps our artisan community grow.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_14w400.copyWith(
                      color: subTitleColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomStarsRatingReview(product: product),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
              child: CustomReviewDetailsTextField(),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
              child: GestureDetector(
                onTap: () {}, // should open image picker in real app
                child: AddReviewedPhotos(),
              ),
            ),
            SizedBox(height: 32.h),
            Divider(color: commonColor.withValues(alpha: .2)),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
              child: Column(
                spacing: 16.h,
                children: [
                  CustomElevatedButton(
                    onPressed: () {},
                    buttoncolor: commonColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                          size: 16.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Submit Review',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.t_16w700.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "By submitting, you agree to Ayady's Terms of Service and Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_10w400.copyWith(
                      color: subTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
