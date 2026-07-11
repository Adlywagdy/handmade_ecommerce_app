import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/l10n/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class ReviewedProduct extends StatelessWidget {
  const ReviewedProduct({super.key, required this.product});

  final ProductModel product;

  String get _imageUrl =>
      product.images.isNotEmpty ? product.images.first : (product.image ?? '');

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleCubit>().state?.languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(12.w),
      child: Row(
        spacing: 16.w,

        children: [
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                _imageUrl,
                height: 70.h,
                width: 70.h,
                fit: BoxFit.fill,
                errorBuilder: (_, _, _) => Container(
                  height: 70.h,
                  width: 70.h,
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
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        product.localizedName(isArabic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.t_16w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  context.l10n.soldBy(
                    product.seller.name.isNotEmpty
                        ? product.seller.name
                        : (product.seller.id ?? ''),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.t_14w500.copyWith(color: commonColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
