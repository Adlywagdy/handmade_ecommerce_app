import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/products/widgets/action_button.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../models/products_model.dart';

class ProductCard extends StatelessWidget {
  final ProductsModel product;
  final bool showActions;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ProductCard({
    super.key,
    required this.product,
    this.showActions = true,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.productImage,
                fit: BoxFit.cover,
                errorBuilder: (c, object, s) => Container(
                  color: Colors.grey.shade100,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 40.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
                loadingBuilder: (_, child, progress) => progress == null ? child : Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                              : null,
                          color: commonColor,
                          strokeWidth: 2,
                        ),
                      ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: blackDegree,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  'by ${product.vendorName}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: subTitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${product.currency} ${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: blackDegree,
                  ),
                ),
              ],
            ),
          ),

          if (showActions) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: ProductActionButton(
                      label: 'APPROVE',
                      color: greenDegree,
                      onTap: onApprove,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: ProductActionButton(
                      label: 'REJECT',
                      color: redDegree,
                      onTap: onReject,
                    ),
                  ),
                ],
              ),
            ),
          ] else
            SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

