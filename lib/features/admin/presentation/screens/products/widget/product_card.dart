import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../models/products_model.dart';
import 'action_button.dart';

class ProductCard extends StatelessWidget {
  final ProductsModel product;
  final String vendorName;
  final bool showActions;
  final bool isProcessing;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onPreview;

  const ProductCard({
    super.key,
    required this.product,
    required this.vendorName,
    this.showActions = true,
    this.isProcessing = false,
    this.onApprove,
    this.onReject,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPreview,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
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
            _ProductImage(imageUrl: product.productImage),
            _ProductInfo(product: product, vendorName: vendorName),
            if (showActions)
              _ProductCardActions(
                isProcessing: isProcessing,
                onApprove: onApprove,
                onReject: onReject,
              )
            else
              SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey.shade100,
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 40.sp,
              color: Colors.grey.shade400,
            ),
          ),
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
                    color: commonColor,
                    strokeWidth: 2,
                  ),
                ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
class _ProductInfo extends StatelessWidget {
  final ProductsModel product;
  final String vendorName;

  const _ProductInfo({required this.product, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            'by $vendorName',
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
    );
  }
}

//////////////////////////////////////////////////////////
class _ProductCardActions extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _ProductCardActions({
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: ProductActionButton(
              label: 'APPROVE',
              color: greenDegree,
              onTap: onApprove,
              isLoading: isProcessing,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: ProductActionButton(
              label: 'REJECT',
              color: redDegree,
              onTap: onReject,
              isLoading: isProcessing,
            ),
          ),
        ],
      ),
    );
  }
}
