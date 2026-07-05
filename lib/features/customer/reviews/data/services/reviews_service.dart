import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/data/models/reviews_model.dart';

class ReviewsService {
  ReviewsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ReviewsModel>> getProductReviews(String productId) async {
    final pid = productId.trim();
    if (pid.isEmpty) throw ArgumentError('Product id cannot be empty');

    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: pid)
        .limit(50)
        .get();

    final reviews = snapshot.docs
        .map((doc) => ReviewsModel.fromMap(doc.data(), id: doc.id))
        .toList();
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }

  Future<void> addProductReview({
    required String productId,
    required String sellerId,
    required String userId,
    required String comment,
    required int rating,
  }) async {
    final pid = productId.trim();
    final sid = sellerId.trim();
    final uid = userId.trim();
    final msg = comment.trim();

    if (pid.isEmpty) throw ArgumentError('Product id cannot be empty');
    if (sid.isEmpty) throw ArgumentError('Seller id cannot be empty');
    if (uid.isEmpty) throw ArgumentError('User id cannot be empty');
    if (msg.isEmpty) throw ArgumentError('Review comment cannot be empty');
    if (rating < 1 || rating > 5) throw ArgumentError('Rating must be between 1 and 5');

    await _firestore.collection('reviews').add(ReviewsModel(
      id: '', productId: pid, sellerId: sid, userId: uid,
      comment: msg, rating: rating, createdAt: DateTime.now(),
    ).toMap());
  }
}
