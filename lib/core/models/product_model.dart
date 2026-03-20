import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';

class ProductModel {
  final String? id;
  final String name;
  final String description;
  final double price;
  final double? rate;
  final int? quantity;
  final List<String> images;
  final List<String>? tags;
  final SellerModel seller;

  CategoryModel? category;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.rate,

    required this.images,
    this.category,
    this.quantity,
    required this.seller,
    this.tags,
  });
}
