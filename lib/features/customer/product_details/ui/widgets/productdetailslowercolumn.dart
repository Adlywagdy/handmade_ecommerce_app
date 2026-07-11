import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/l10n/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/ui/widgets/customsellerlisttile.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/ui/widgets/productreviewscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/ui/widgets/tagsrow.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/logic/reviews_cubit.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

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
    final isArabic = context.watch<LocaleCubit>().state?.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSellerListTile(product: widget.product),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(context.l10n.description, style: AppTextStyles.t_18w700),
        ),
        Text(
          widget.product.localizedDescription(isArabic),
          style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
        ),
        SizedBox(height: 12.h),
        widget.product.tags != null && widget.product.tags!.isNotEmpty
            ? TagsRow(product: widget.product)
            : SizedBox(height: 16.h),
        SizedBox(height: 20.h),
        BlocBuilder<ReviewsCubit, ReviewsState>(
          buildWhen: (previous, current) {
            return current is ReviewsLoading ||
                current is ReviewsLoaded ||
                current is ReviewsError;
          },
          builder: (context, state) {
            final reviewsCubit = context.read<ReviewsCubit>();
            final reviews = reviewsCubit.cachedReviewsFor(productId);
            final isLoadingCurrentProduct =
                state is ReviewsLoading && state.productId == productId;
            final isErrorCurrentProduct =
                state is ReviewsError && state.productId == productId;

            if (isLoadingCurrentProduct && reviews.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (isErrorCurrentProduct && reviews.isEmpty) {
              return Text(
                context.l10n.unableToLoadReviews,
                textAlign: TextAlign.center,
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              );
            }

            if (reviews.isEmpty) {
              return Text(
                context.l10n.noReviewsYetForProduct,
                textAlign: TextAlign.center,
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              );
            }

            return ProductReviewsColumn(
              reviews: reviews,
              productName: widget.product.localizedName(isArabic),
            );
          },
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
