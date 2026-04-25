import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/cubit/reviews_cubit.dart';

class ProductItemOfOrder extends StatelessWidget {
  const ProductItemOfOrder({
    super.key,
    required this.product,
    required this.order,
  });
  final CustomerOrderModel order;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: commonColor.withValues(alpha: .02),

        border: Border.all(color: commonColor.withValues(alpha: .05)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    product.images.isNotEmpty
                        ? product.images.first
                        : (product.image ?? ''),
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.fill,
                    errorBuilder: (_, _, _) => Container(
                      height: 100.h,
                      width: 100.w,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.t_16w600),
                    SizedBox(height: 4.h),
                    Text(
                      'Indigo Blue • Large',
                      style: AppTextStyles.t_12w400.copyWith(
                        color: subTitleColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toString()}',
                          style: AppTextStyles.t_16w700.copyWith(
                            color: commonColor,
                          ),
                        ),
                        Card(
                          color: Colors.white.withValues(alpha: .5),
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0).r,
                            child: Text(
                              'Qty: ${product.quantity}',
                              style: AppTextStyles.t_12w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          order.status == OrderStatus.delivered
              ? InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    ReviewsCubit? reviewsCubit;
                    try {
                      reviewsCubit = context.read<ReviewsCubit>();
                    } catch (_) {}

                    Get.toNamed(
                      AppRoutes.customerWriteReview,
                      arguments: {
                        'product': product,
                        'reviewsCubit': reviewsCubit,
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 44.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: commonColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: commonColor.withValues(alpha: .22),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          color: commonColor,
                          size: 16.r,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Write Review',
                          style: AppTextStyles.t_12w600.copyWith(
                            color: commonColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: commonColor,
                          size: 12.r,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 44.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: redDegree.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: redDegree.withValues(alpha: .22)),
                  ),
                  child: Text(
                    'You can review this product after delivery',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.t_12w600.copyWith(color: redDegree),
                  ),
                ),
        ],
      ),
    );
  }
}
