import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/cubit/wishlist_cubit.dart';

class FavoriteButton extends StatelessWidget {
  final ProductModel product;
  const FavoriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        BlocProvider.of<WishListCubit>(
          context,
        ).addordeleteWishlistProducts(product);
      },
      padding: EdgeInsets.zero,

      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: 0.7),
        ),
        iconSize: WidgetStatePropertyAll(20.r),
      ),
      icon: BlocBuilder<WishListCubit, WishListState>(
        buildWhen: (previous, current) {
          return current is GetWishlistSuccessedstate ||
              current is AddOrDeleteWishlistSuccessedstate ||
              current is AddOrDeleteWishlistFailedstate;
        },
        builder: (context, state) {
          return Icon(
            isItemExictedFun(
                  productslist: BlocProvider.of<WishListCubit>(
                    context,
                  ).wishlistProductsList,
                  productID: product.id,
                )
                ? Icons.favorite
                : Icons.favorite_border,
            color: commonColor,
          );
        },
      ),
    );
  }
}
