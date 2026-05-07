import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/features/admin/cubit/admin_cubit.dart';
import '../../../../../models/products_model.dart';
import 'info_row.dart';
import 'product_action_buttons.dart';
import 'product_description_card.dart';
import 'product_image_header.dart';
import 'section_widget.dart';

class ProductDetailsBody extends StatelessWidget {
  final ProductsModel product;
  final AdminCubit cubit;

  const ProductDetailsBody({
    super.key,
    required this.product,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    // True while an approve/reject is running for this product
    final bool isBusy = cubit.isProcessing(product.id);
    final String vendorName = cubit.vendorNameFor(product);

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        ProductImageHeader(product: product, vendorName: vendorName),
        SizedBox(height: 12.h),

        SectionWidget(
          title: context.l10n.inventory,
          rows: [
            InfoRow(label: context.l10n.stock, value: product.stock.toString()),
            InfoRow(
              label: context.l10n.category,
              value: product.categoryId.isNotEmpty ? product.categoryId : '—',
            ),
            InfoRow(
              label: context.l10n.active,
              value: product.isActive ? context.l10n.yes : context.l10n.no,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: context.l10n.stats,
          rows: [
            InfoRow(
              label: context.l10n.rating,
              value: product.rating.toStringAsFixed(1),
            ),
            InfoRow(
              label: context.l10n.reviews,
              value: product.reviewsCount.toString(),
            ),
            InfoRow(
              label: context.l10n.sales,
              value: product.salesCount.toString(),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (product.description.isNotEmpty)
          ProductDescriptionCard(description: product.description),
        SizedBox(height: 20.h),
        if (product.status == 'pending')
          ProductActionButtons(
            isBusy: isBusy,
            onApprove: () => cubit.approveProduct(product.id),
            onReject: () => cubit.rejectProduct(product.id),
          ),
      ],
    );
  }
}
