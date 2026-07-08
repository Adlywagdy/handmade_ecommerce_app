part of 'search_cubit.dart';

sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class CategoriesLoading extends SearchState {}

final class CategoriesSuccess extends SearchState {}

final class CategoriesError extends SearchState {
  final String message;
  CategoriesError({required this.message});
}

final class SearchProductsLoading extends SearchState {}

final class SearchProductsSuccess extends SearchState {}

final class SearchProductsError extends SearchState {
  final String message;
  SearchProductsError({required this.message});
}

final class FilterProductsLoading extends SearchState {}

final class FilterProductsSuccess extends SearchState {}

final class FilterProductsError extends SearchState {
  final String message;
  FilterProductsError({required this.message});
}
