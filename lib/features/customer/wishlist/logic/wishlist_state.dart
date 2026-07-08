part of 'wishlist_cubit.dart';

sealed class WishListState {}

final class WishListInitial extends WishListState {}

final class WishlistLoading extends WishListState {}

final class WishlistSuccess extends WishListState {
  final List<ProductModel> products;
  WishlistSuccess({required this.products});
}

final class WishlistError extends WishListState {
  final String message;
  WishlistError({required this.message});
}

final class ToggleWishlistLoading extends WishListState {}

final class ToggleWishlistSuccess extends WishListState {}

final class ToggleWishlistError extends WishListState {
  final String message;
  ToggleWishlistError({required this.message});
}
