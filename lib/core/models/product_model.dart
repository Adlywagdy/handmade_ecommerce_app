import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/review_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? totalrate;
  int quantity;
  final List<ReviewModel>? reviews;
  final List<String> images;
  final List<String>? tags;
  final SellerModel seller;

  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.totalrate,
    required this.images,
    this.category,
    required this.quantity,
    required this.seller,
    this.tags,
    this.reviews,
  });
  // to make a copy of the product coming from firebase with a new quantity value to add to cart
  factory ProductModel.copywith(ProductModel product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      totalrate: product.totalrate,
      quantity: 1,
      images: product.images,
      category: product.category,
      seller: product.seller,
      tags: product.tags,
      reviews: product.reviews,
    );
  }
}
