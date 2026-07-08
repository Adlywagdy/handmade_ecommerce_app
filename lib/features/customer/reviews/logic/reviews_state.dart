part of 'reviews_cubit.dart';

sealed class ReviewsState {}

final class ReviewsInitial extends ReviewsState {}

final class ReviewsLoadingState extends ReviewsState {
  final String productId;

  ReviewsLoadingState({required this.productId});
}

final class ReviewsLoadedState extends ReviewsState {
  final String productId;
  final List<ReviewsModel> reviews;

  ReviewsLoadedState({required this.productId, required this.reviews});
}

final class ReviewsErrorState extends ReviewsState {
  final String productId;
  final String errorMessage;

  ReviewsErrorState({required this.productId, required this.errorMessage});
}

final class SubmitReviewLoadingState extends ReviewsState {}

final class SubmitReviewSuccessState extends ReviewsState {}

final class SubmitReviewErrorState extends ReviewsState {
  final String errorMessage;

  SubmitReviewErrorState({required this.errorMessage});
}
