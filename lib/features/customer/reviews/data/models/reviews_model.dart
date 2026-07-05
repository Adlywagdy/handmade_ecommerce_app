import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';

class ReviewsModel {
  final String id;
  final String productId;
  final String sellerId;
  final String userId;
  final String comment;
  final int rating;
  final DateTime createdAt;

  const ReviewsModel({
    required this.id,
    required this.productId,
    required this.sellerId,
    required this.userId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewsModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ReviewsModel(
      id: id,
      productId: map['productId']?.toString() ?? '',
      sellerId: map['sellerId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      comment: map['comment']?.toString() ?? '',
      rating: parseInt(map['rating']) ?? 0,
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'sellerId': sellerId,
      'userId': userId,
      'comment': comment,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
