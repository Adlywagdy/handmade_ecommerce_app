part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class FeaturedLoading extends HomeState {}

final class FeaturedSuccess extends HomeState {
  final List<ProductModel> products;
  FeaturedSuccess({required this.products});
}

final class FeaturedError extends HomeState {
  final String message;
  FeaturedError({required this.message});
}

final class TopRatedLoading extends HomeState {}

final class TopRatedSuccess extends HomeState {
  final List<ProductModel> products;
  TopRatedSuccess({required this.products});
}

final class TopRatedError extends HomeState {
  final String message;
  TopRatedError({required this.message});
}
