import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cubit/admin_cubit.dart';
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
          title: 'Inventory',
          rows: [
            InfoRow(label: 'Stock', value: product.stock.toString()),
            InfoRow(label: 'Category', value: product.categoryId.isNotEmpty ? product.categoryId : '—'),
            InfoRow(label: 'Active', value: product.isActive ? 'Yes' : 'No'),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: 'Stats',
          rows: [
            InfoRow(label: 'Rating', value: product.rating.toStringAsFixed(1)),
            InfoRow(label: 'Reviews', value: product.reviewsCount.toString()),
            InfoRow(label: 'Sales', value: product.salesCount.toString()),
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
