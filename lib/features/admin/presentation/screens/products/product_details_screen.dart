import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../models/products_model.dart';
import '../../widgets/custom_action_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final cubit = context.read<AdminCubit>();
        final product = cubit.productById(productId);
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product')),
            body: const Center(child: Text('Product not found')),
          );
        }
        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Product Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackDegree,
              ),
            ),
            centerTitle: true,
          ),
          body: _Body(product: product, cubit: cubit),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final ProductsModel product;
  final AdminCubit cubit;

  const _Body({required this.product, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final busy = cubit.isProcessing(product.id);
    final vendor = cubit.vendorNameFor(product);
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Image.network(
              product.productImage,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Colors.grey.shade100,
                child: Icon(Icons.image_not_supported_outlined,
                    size: 48.sp, color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
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
                'by $vendor',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: commonColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
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
              ),
              SizedBox(height: 10.h),
              _StatusPill(status: product.status),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _Section(title: 'Inventory', rows: [
          ('Stock', product.stock.toString()),
          ('Category', product.categoryId.isNotEmpty ? product.categoryId : '—'),
          ('Active', product.isActive ? 'Yes' : 'No'),
        ]),
        SizedBox(height: 12.h),
        _Section(title: 'Stats', rows: [
          ('Rating', product.rating.toStringAsFixed(1)),
          ('Reviews', product.reviewsCount.toString()),
          ('Sales', product.salesCount.toString()),
        ]),
        SizedBox(height: 12.h),
        if (product.description.isNotEmpty)
          Container(
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
                  'Description',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: blackDegree,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 13.sp, color: blackDegree),
                ),
              ],
            ),
          ),
        SizedBox(height: 20.h),
        if (product.status == 'pending')
          Row(
            children: [
              ActionButton(
                label: 'Approve',
                color: greenDegree,
                isLoading: busy,
                onTap: () => cubit.approveProduct(product.id),
              ),
              SizedBox(width: 12.w),
              ActionButton(
                label: 'Reject',
                color: redDegree,
                style: ActionButtonStyle.outlined,
                isLoading: busy,
                onTap: () => cubit.rejectProduct(product.id),
              ),
            ],
          ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'approved' => const Color(0xFF07880E),
      'rejected' => const Color(0xFFD32F2F),
      _ => const Color(0xFFD97706),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _Section({required this.title, required this.rows});

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
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 10.h),
          for (final row in rows)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Text('${row.$1}:',
                      style:
                          TextStyle(fontSize: 12.sp, color: subTitleColor)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      row.$2.isEmpty ? '—' : row.$2,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: blackDegree,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
