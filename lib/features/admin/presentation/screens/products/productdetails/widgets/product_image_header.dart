import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/colors.dart';
import '../../../../../models/products_model.dart';
import 'product_status_pill.dart';

class ProductImageHeader extends StatelessWidget {
  final ProductsModel product;
  final String vendorName;

  const ProductImageHeader({
    super.key,
    required this.product,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProductImage(imageUrl: product.productImage),
        SizedBox(height: 16.h),
        _ProductInfoCard(product: product, vendorName: vendorName),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////
class _ProductImage extends StatelessWidget {
  final String imageUrl;
  const _ProductImage({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey.shade100,
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 48.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
class _ProductInfoCard extends StatelessWidget {
  final ProductsModel product;
  final String vendorName;
  const _ProductInfoCard({required this.product, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'by $vendorName',
            style: TextStyle(
              fontSize: 13.sp,
              color: commonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          _PriceRow(product: product),
          SizedBox(height: 10.h),
          ProductStatusPill(status: product.status),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
class _PriceRow extends StatelessWidget {
  final ProductsModel product;

  const _PriceRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${product.currency} ${product.price.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: blackDegree,
          ),
        ),
        if (product.discountedPrice != null) ...[
          SizedBox(width: 8.w),
          Text(
            '${product.currency} ${product.discountedPrice!.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14.sp,
              color: subTitleColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}
