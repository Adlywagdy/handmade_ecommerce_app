part of 'search_cubit.dart';

sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class GetCategoriesLoadingstate extends SearchState {}

final class GetCategoriesSuccessedstate extends SearchState {}

final class GetCategoriesFailedstate extends SearchState {
  final String errorMessage;

  GetCategoriesFailedstate({required this.errorMessage});
}

/* ------------------------------------------- */
final class SearchProductsLoadingstate extends SearchState {}

final class SearchProductsSuccessedstate extends SearchState {
  SearchProductsSuccessedstate();
}

final class SearchProductsFailedstate extends SearchState {
  final String errorMessage;

  SearchProductsFailedstate({required this.errorMessage});
}

/* ------------------------------------------- */
final class FilterProductsLoadingstate extends SearchState {}

final class FilterProductsSuccessedstate extends SearchState {
  FilterProductsSuccessedstate();
}

final class FilterProductsFailedstate extends SearchState {
  final String errorMessage;

  FilterProductsFailedstate({required this.errorMessage});
}
