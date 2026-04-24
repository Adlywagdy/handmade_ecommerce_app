import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/reviews/presentation/widgets/addreviewedphotos.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customreviewdetailstextfield.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customstarsratingreview.dart';
import 'package:handmade_ecommerce_app/features/reviews/presentation/widgets/reviewedproduct.dart';
import 'package:handmade_ecommerce_app/features/reviews/cubit/reviews_cubit.dart';

class CustomerWriteReviewScreen extends StatefulWidget {
  final ProductModel product;
  const CustomerWriteReviewScreen({super.key, required this.product});

  @override
  State<CustomerWriteReviewScreen> createState() =>
      _CustomerWriteReviewScreenState();
}

class _CustomerWriteReviewScreenState extends State<CustomerWriteReviewScreen> {
  late final TextEditingController _reviewController;
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_selectedRating < 1) {
      showSnack(
        title: 'Review Missing',
        message: 'Please select a star rating before submitting.',
        bgColor: redDegree,
        icon: Icons.error_outline,
      );
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      showSnack(
        title: 'Review Missing',
        message: 'Please write a short comment before submitting.',
        bgColor: redDegree,
        icon: Icons.error_outline,
      );
      return;
    }

    context.read<ReviewsCubit>().submitReview(
      product: widget.product,
      comment: _reviewController.text,
      rating: _selectedRating,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listenWhen: (previous, current) {
        return current is SubmitReviewSuccessState ||
            current is SubmitReviewErrorState;
      },
      listener: (context, state) {
        if (state is SubmitReviewSuccessState) {
          showSnack(
            title: 'Thank You',
            message: 'Your review was submitted successfully.',
            bgColor: Colors.green,
            icon: Icons.check_circle_outline,
          );
          Get.back();
        }

        if (state is SubmitReviewErrorState) {
          showSnack(
            title: 'Submit Failed',
            message: state.errorMessage,
            bgColor: redDegree,
            icon: Icons.error_outline,
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is SubmitReviewLoadingState;

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
                ReviewedProduct(product: widget.product),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 32.h,
                  ),
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
                      CustomStarsRatingReview(
                        selectedRating: _selectedRating,
                        onChanged: (value) {
                          setState(() {
                            _selectedRating = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
                  child: CustomReviewDetailsTextField(
                    controller: _reviewController,
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
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
                        onPressed: isSubmitting ? null : _submitReview,
                        buttoncolor: commonColor,
                        child: isSubmitting
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
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
      },
    );
  }
}
