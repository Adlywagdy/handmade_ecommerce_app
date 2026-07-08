part of 'reviews_cubit.dart';

sealed class ReviewsState {}

final class ReviewsInitial extends ReviewsState {}

final class ReviewsLoading extends ReviewsState {
  final String productId;
  ReviewsLoading({required this.productId});
}

final class ReviewsLoaded extends ReviewsState {
  final String productId;
  final List<ReviewsModel> reviews;
  ReviewsLoaded({required this.productId, required this.reviews});
}

final class ReviewsError extends ReviewsState {
  final String productId;
  final String message;
  ReviewsError({required this.productId, required this.message});
}

final class SubmitReviewLoading extends ReviewsState {}

final class SubmitReviewSuccess extends ReviewsState {}

final class SubmitReviewError extends ReviewsState {
  final String message;
  SubmitReviewError({required this.message});
}
