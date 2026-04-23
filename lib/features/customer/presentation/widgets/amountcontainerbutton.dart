import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';

class AmountContainerButton extends StatelessWidget {
  final Color? iconscolor;
  final ProductModel product;
  final double circularradius;
  final double verticalpadding;
  final double horizontalpadding;
  final double? spacingwidth;
  const AmountContainerButton({
    super.key,

    this.iconscolor = commonColor,

    this.circularradius = 12,
    this.verticalpadding = 12,
    this.horizontalpadding = 12,
    this.spacingwidth = 12,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalpadding.h,
        horizontal: horizontalpadding.w,
      ),
      decoration: BoxDecoration(
        color: commonColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(circularradius.r),
        border: Border.all(
          color: commonColor.withValues(alpha: .1),
          width: 1.5,
        ),
      ),

      child: Row(
        spacing: spacingwidth!.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              BlocProvider.of<CartCubit>(context).deleteCartProducts(product);
            },
            child: Icon(Icons.remove, color: iconscolor, size: 22.r),
          ),

          BlocBuilder<CartCubit, CartState>(
            buildWhen: (previous, current) {
              return current is AddcartproductSuccessedstate ||
                  current is GetcartSuccessedstate ||
                  current is DeletecartproductSuccessedstate;
            },
            builder: (context, state) {
              final quantity =
                  isItemExictedFun(
                    productslist: BlocProvider.of<CartCubit>(
                      context,
                    ).cartProductsList,
                    productID: product.id,
                  )
                  ? BlocProvider.of<CartCubit>(context).cartProductsList
                        .firstWhere((item) => item.id == product.id)
                        .quantity
                  : 0;

              return Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: AppTextStyles.t_14w600.copyWith(
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CartCubit>(context).addCartProducts(product);
            },
            child: Icon(Icons.add, color: iconscolor, size: 22.r),
          ),
        ],
      ),
    );
  }
}
