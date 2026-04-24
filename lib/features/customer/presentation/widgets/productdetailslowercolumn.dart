import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customsellerlisttile.dart';
import 'package:handmade_ecommerce_app/features/reviews/presentation/widgets/productreviewscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/tagsrow.dart';
import 'package:handmade_ecommerce_app/features/reviews/cubit/reviews_cubit.dart';

class ProductDetailsLowerColumn extends StatefulWidget {
  const ProductDetailsLowerColumn({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsLowerColumn> createState() =>
      _ProductDetailsLowerColumnState();
}

class _ProductDetailsLowerColumnState extends State<ProductDetailsLowerColumn> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewsCubit>().loadProductReviews(widget.product.id);
  }

  @override
  void didUpdateWidget(covariant ProductDetailsLowerColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      context.read<ReviewsCubit>().loadProductReviews(widget.product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = widget.product.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSellerListTile(product: widget.product),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text('Description', style: AppTextStyles.t_18w700),
        ),
        Text(
          widget.product.description,
          style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
        ),
        SizedBox(height: 12.h),
        widget.product.tags != null && widget.product.tags!.isNotEmpty
            ? TagsRow(product: widget.product)
            : SizedBox(height: 16.h),
        SizedBox(height: 12.h),
        BlocBuilder<ReviewsCubit, ReviewsState>(
          buildWhen: (previous, current) {
            if (current is ReviewsLoadingState) {
              return current.productId == productId;
            }
            if (current is ReviewsLoadedState) {
              return current.productId == productId;
            }
            if (current is ReviewsErrorState) {
              return current.productId == productId;
            }
            return false;
          },
          builder: (context, state) {
            final reviewsCubit = context.read<ReviewsCubit>();
            final reviews = reviewsCubit.cachedReviewsFor(productId);
            final isLoadingCurrentProduct =
                state is ReviewsLoadingState && state.productId == productId;
            final isErrorCurrentProduct =
                state is ReviewsErrorState && state.productId == productId;

            if (isLoadingCurrentProduct && reviews.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (isErrorCurrentProduct && reviews.isEmpty) {
              return Text(
                'Unable to load reviews right now.',
                textAlign: TextAlign.center,
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              );
            }

            if (reviews.isEmpty) {
              return Text(
                'No reviews yet for this product. Be the first to share your thoughts!',
                textAlign: TextAlign.center,
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              );
            }

            return ProductReviewsColumn(
              reviews: reviews,
              productName: widget.product.name,
            );
          },
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
