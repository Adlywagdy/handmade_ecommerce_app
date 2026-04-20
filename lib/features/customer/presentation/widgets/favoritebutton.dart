import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/wishlist_cubit/wishlist_cubit.dart';

class FavoriteButton extends StatefulWidget {
  final ProductModel product;
  const FavoriteButton({super.key, required this.product});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      buildWhen: (previous, current) {
        return current is GetWishlistSuccessedstate ||
            current is AddWishlistSuccessedstate ||
            current is DeleteWishlistSuccessedstate;
      },
      builder: (context, state) {
        return IconButton.filled(
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;

              if (isFavorite) {
                BlocProvider.of<WishListCubit>(
                  context,
                ).addWishlistProducts(widget.product);
              } else if (!isFavorite) {
                BlocProvider.of<WishListCubit>(
                  context,
                ).deleteWishlistProducts(widget.product);
              }
            });
          },
          padding: EdgeInsets.zero,

          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.white.withValues(alpha: 0.7),
            ),
            iconSize: WidgetStatePropertyAll(20.r),
          ),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: commonColor,
          ),
        );
      },
    );
  }
}
