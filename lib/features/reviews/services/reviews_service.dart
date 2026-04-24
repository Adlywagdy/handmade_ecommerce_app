import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/features/reviews/models/reviews_model.dart';

class ReviewsService {
  ReviewsService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _reviewsCollection = 'reviews';

  Future<List<ReviewsModel>> getProductReviews(String productId) async {
    final normalizedProductId = productId.trim();
    if (normalizedProductId.isEmpty) {
      throw ArgumentError('Product id cannot be empty');
    }

    final snapshot = await _firestore
        .collection(_reviewsCollection)
        .where('productId', isEqualTo: normalizedProductId)
        .get();

    final reviews = snapshot.docs
        .map((doc) => ReviewsModel.fromMap(doc.data(), id: doc.id))
        .toList();

    reviews.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return reviews;
  }

  Future<void> addProductReview({
    required String productId,
    required String sellerId,
    required String userId,
    required String comment,
    required int rating,
  }) async {
    final normalizedProductId = productId.trim();
    final normalizedSellerId = sellerId.trim();
    final normalizedUserId = userId.trim();
    final normalizedComment = comment.trim();

    if (normalizedProductId.isEmpty) {
      throw ArgumentError('Product id cannot be empty');
    }
    if (normalizedSellerId.isEmpty) {
      throw ArgumentError('Seller id cannot be empty');
    }
    if (normalizedUserId.isEmpty) {
      throw ArgumentError('User id cannot be empty');
    }
    if (normalizedComment.isEmpty) {
      throw ArgumentError('Review comment cannot be empty');
    }
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    final review = ReviewsModel(
      id: '',
      productId: normalizedProductId,
      sellerId: normalizedSellerId,
      userId: normalizedUserId,
      comment: normalizedComment,
      rating: rating,
      createdAt: DateTime.now(),
    );

    await _firestore.collection(_reviewsCollection).add(review.toMap());
  }
}
