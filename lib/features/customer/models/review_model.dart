import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

class ReviewModel {
  final CustomerModel reviewer;
  final String reviewText;
  final int rating;
  final DateTime reviewDate;

  ReviewModel({
    required this.reviewer,
    required this.reviewText,
    required this.rating,
    required this.reviewDate,
  });
}
