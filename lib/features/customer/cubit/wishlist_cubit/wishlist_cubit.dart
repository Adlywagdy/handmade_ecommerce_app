import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

import 'package:handmade_ecommerce_app/features/customer/models/data/test_wishlistdata.dart';

part 'wishlist_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  List<ProductModel> wishlistProductsList = [];

  /* ------------------------------------------- */
  Future<void> getWishlistProducts() async {
    emit(GetWishlistLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      wishlistProductsList =
          wishlistProductsdata; // Replace with actual data from Firestore
      emit(GetWishlistSuccessedstate(wishlistproducts: wishlistProductsList));
    } catch (e) {
      emit(GetWishlistFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> addordeleteWishlistProducts(ProductModel product) async {
    emit(AddOrDeleteWishlistLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      if (isItemExictedFun(
        productslist: wishlistProductsList,
        productID: product.id,
      )) {
        wishlistProductsList.remove(
          product,
        ); // Replace with actual logic to add product to wishlist in Firestore
        showSnack(
          title: "product removed",
          message: "${product.name} has been removed from your wishlist.",
          bgColor: Colors.red,
          icon: Icons.check_circle_outline,
        );
      } else {
        wishlistProductsList.add(
          product,
        ); // Replace with actual logic to add product to wishlist in Firestore
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
