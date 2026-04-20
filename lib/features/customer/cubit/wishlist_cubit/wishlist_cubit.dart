import 'package:flutter_bloc/flutter_bloc.dart';
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
  Future<void> addWishlistProducts(ProductModel product) async {
    emit(AddWishlistLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      wishlistProductsList.add(
        product,
      ); // Replace with actual logic to add product to wishlist in Firestore
      emit(AddWishlistSuccessedstate());
      emit(GetWishlistSuccessedstate(wishlistproducts: wishlistProductsList));
    } catch (e) {
      emit(AddWishlistFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> deleteWishlistProducts(ProductModel product) async {
    emit(DeleteWishlistLoadingstate());
    try {
      // Simulate a delay for loading wishlist products
      await Future.delayed(const Duration(seconds: 2), () {});
      wishlistProductsList.remove(
        product,
      ); // Replace with actual logic to add product to wishlist in Firestore
      emit(DeleteWishlistSuccessedstate());
      emit(GetWishlistSuccessedstate(wishlistproducts: wishlistProductsList));
    } catch (e) {
      emit(DeleteWishlistFailedstate(errorMessage: e.toString()));
    }
  }
}
