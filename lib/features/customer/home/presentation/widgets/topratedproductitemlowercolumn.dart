import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/checkout/presentation/widgets/amountcontainerbutton.dart';

class TopRatedProductItemLowerColumn extends StatelessWidget {
  final ProductModel product;
  const TopRatedProductItemLowerColumn({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: .start,
      children: [
        Text(
          product.category!.categorytitle,

          style: AppTextStyles.t_10w700.copyWith(color: commonColor),
        ),
        Text(
          product.name,
          overflow: .ellipsis,
          style: AppTextStyles.t_14w700.copyWith(color: blackDegree),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${product.price}",
              style: AppTextStyles.t_14w700.copyWith(color: commonColor),
            ),
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) {
                return current is GetcartSuccessedstate ||
                    current is AddcartproductSuccessedstate ||
                    current is DeletecartproductSuccessedstate;
              },
              builder: (context, state) {
                if (isItemExictedFun(
                  productslist: BlocProvider.of<CartCubit>(
                    context,
                  ).cartProductsList,
                  productID: product.id,
                )) {
                  return AmountContainerButton(
                    product: product,
                    verticalpadding: 8.h,
                  );
                }

                return CustomIconButton(
                  backgroundColor: commonColor,
                  icon: Icons.add_shopping_cart,
                  iconsize: 20.r,
                  iconcolor: customerbackGroundColor,
                  onPressed: () {
                    BlocProvider.of<CartCubit>(
                      context,
                    ).addCartProducts(product);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
