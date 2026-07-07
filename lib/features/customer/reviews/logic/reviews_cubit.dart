import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/data/models/reviews_model.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/data/services/reviews_service.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit({ReviewsService? reviewsService})
    : _reviewsService = reviewsService ?? ReviewsService(),
      super(ReviewsInitial());

  final ReviewsService _reviewsService;

  final Map<String, List<ReviewsModel>> _reviewsByProduct = {};
  List<ReviewsModel> currentProductReviews = [];
  String? currentProductId;

  List<ReviewsModel> cachedReviewsFor(String productId) {
    return _reviewsByProduct[productId] ?? const <ReviewsModel>[];
  }

  Future<void> loadProductReviews(
    String productId, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emit(ReviewsLoadingState(productId: productId));
    }

    try {
      currentProductId = productId;
      currentProductReviews = await _reviewsService.getProductReviews(
        productId,
      );
      _reviewsByProduct[productId] = currentProductReviews;
      emit(
        ReviewsLoadedState(
          productId: productId,
          reviews: currentProductReviews,
        ),
      );
    } catch (e) {
      emit(ReviewsErrorState(productId: productId, errorMessage: e.toString()));
    }
  }

  Future<void> submitReview({
    required ProductModel product,
    required String comment,
    required int rating,
  }) async {
    final normalizedComment = comment.trim();
    if (normalizedComment.isEmpty) {
      emit(
        SubmitReviewErrorState(
          errorMessage: AppLocalizations.of(Get.context!)!.pleaseWriteShortComment,
        ),
      );
      return;
    }

    if (rating < 1 || rating > 5) {
      emit(
        SubmitReviewErrorState(
          errorMessage: AppLocalizations.of(Get.context!)!.pleaseSelectRating,
        ),
      );
      return;
    }

    emit(SubmitReviewLoadingState());

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null || userId.trim().isEmpty) {
        throw Exception(AppLocalizations.of(Get.context!)!.youNeedToLoginBeforeReviewing);
      }

      await _reviewsService.addProductReview(
        productId: product.id,
        sellerId: product.sellerId,
        userId: userId,
        comment: normalizedComment,
        rating: rating,
      );

      emit(SubmitReviewSuccessState());
      await loadProductReviews(product.id, showLoading: false);
    } catch (e) {
      emit(SubmitReviewErrorState(errorMessage: _formatError(e)));
    }
  }

  String _formatError(Object error) {
    final message = error.toString().trim();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    if (message.startsWith('ArgumentError: ')) {
      return message.replaceFirst('ArgumentError: ', '');
    }
    return message;
  }
}
