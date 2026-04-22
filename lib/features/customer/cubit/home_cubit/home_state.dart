part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

/* ------------------------------------------- */
final class GetFeaturedLoadingstate extends HomeState {}

final class GetFeaturedSuccessedstate extends HomeState {
  final List<ProductModel> products;
  GetFeaturedSuccessedstate({required this.products});
}

final class GetFeaturedFailedstate extends HomeState {
  final String errorMessage;

  GetFeaturedFailedstate({required this.errorMessage});
} /* ------------------------------------------- */

final class GetTopRatedLoadingstate extends HomeState {}

final class GetTopRatedSuccessedstate extends HomeState {
  final List<ProductModel> products;
  GetTopRatedSuccessedstate({required this.products});
}

final class GetTopRatedFailedstate extends HomeState {
  final String errorMessage;

  GetTopRatedFailedstate({required this.errorMessage});
}
