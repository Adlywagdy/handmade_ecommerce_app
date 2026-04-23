import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/amountcontainerbutton.dart';

class CartProductItem extends StatelessWidget {
  const CartProductItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: commonColor.withValues(alpha: .05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        spacing: 16.w,

        children: [
          Expanded(
            flex: 1,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                product.images.isNotEmpty
                    ? product.images.first
                    : (product.image ?? ''),
                height: 100.h,
                width: 100.w,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Container(
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
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        product.name,
                        style: AppTextStyles.t_16w600.copyWith(
                          color: blackDegree,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomIconButton(
                        backgroundColor: Colors.white,
                        icon: CupertinoIcons.delete,
                        iconcolor: subTitleColor,
                        iconsize: 20.r,
                        onPressed: () {
                          BlocProvider.of<CartCubit>(
                            context,
                          ).deleteCartProducts(product);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "By ${product.seller.specialty}${product.seller.name}",
                  style: AppTextStyles.t_12w500.copyWith(color: commonColor),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toString()}',
                      style: AppTextStyles.t_18w700,
                    ),

                    AmountContainerButton(
                      product: product,
                      circularradius: 50.r,
                      verticalpadding: 4.h,
                      horizontalpadding: 8.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
