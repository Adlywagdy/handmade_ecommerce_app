import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_wishlist_service.dart';

part 'wishlist_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit({FirebaseWishlistService? wishlistService})
    : _wishlistService = wishlistService ?? FirebaseWishlistService(),
      super(WishListInitial());

  final FirebaseWishlistService _wishlistService;

  List<ProductModel> wishlistProductsList = [];

  /* ------------------------------------------- */
  Future<void> getWishlistProducts() async {
    emit(GetWishlistLoadingstate());
    try {
      wishlistProductsList = await _wishlistService.getWishlistProducts();
      emit(GetWishlistSuccessedstate(wishlistproducts: wishlistProductsList));
    } catch (e) {
      emit(GetWishlistFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> addordeleteWishlistProducts(ProductModel product) async {
    emit(AddOrDeleteWishlistLoadingstate());
    try {
      final alreadyExists = isItemExictedFun(
        productslist: wishlistProductsList,
        productID: product.id,
      );

      await _wishlistService.toggleWishlistProduct(product);

      if (alreadyExists) {
        wishlistProductsList.removeWhere((item) => item.id == product.id);
        showSnack(
          title: "product removed",
          message: "${product.name} has been removed from your wishlist.",
          bgColor: Colors.red,
          icon: Icons.check_circle_outline,
        );
      } else {
        wishlistProductsList.add(product);
        showSnack(
          title: "Success",
          message: "${product.name} has been added to your wishlist.",
          bgColor: Colors.green,
          icon: Icons.check_circle_outline,
        );
      }

      emit(AddOrDeleteWishlistSuccessedstate());
      emit(GetWishlistSuccessedstate(wishlistproducts: wishlistProductsList));
    } catch (e) {
      emit(AddOrDeleteWishlistFailedstate(errorMessage: e.toString()));
    }
  }
}
