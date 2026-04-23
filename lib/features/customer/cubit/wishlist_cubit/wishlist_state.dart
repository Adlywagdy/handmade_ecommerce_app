part of 'wishlist_cubit.dart';

sealed class WishListState {}

final class WishListInitial extends WishListState {}
/* ------------------------------------------- */

final class GetWishlistLoadingstate extends WishListState {}

final class GetWishlistSuccessedstate extends WishListState {
  final List<ProductModel> wishlistproducts;

  GetWishlistSuccessedstate({required this.wishlistproducts});
}

final class GetWishlistFailedstate extends WishListState {
  final String errorMessage;

  GetWishlistFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class AddOrDeleteWishlistLoadingstate extends WishListState {}

final class AddOrDeleteWishlistSuccessedstate extends WishListState {}

final class AddOrDeleteWishlistFailedstate extends WishListState {
  final String errorMessage;

  AddOrDeleteWishlistFailedstate({required this.errorMessage});
}

/* ------------------------------------------- */
