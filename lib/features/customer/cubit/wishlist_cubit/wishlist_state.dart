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

final class AddWishlistLoadingstate extends WishListState {}

final class AddWishlistSuccessedstate extends WishListState {}

final class AddWishlistFailedstate extends WishListState {
  final String errorMessage;

  AddWishlistFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class DeleteWishlistLoadingstate extends WishListState {}

final class DeleteWishlistSuccessedstate extends WishListState {}

final class DeleteWishlistFailedstate extends WishListState {
  final String errorMessage;

  DeleteWishlistFailedstate({required this.errorMessage});
}
