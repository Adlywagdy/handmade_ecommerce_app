import 'package:handmade_ecommerce_app/core/models/category_model.dart';

class ProductModel {
  String? id;
  String name;
  String description;
  double price;
  double? rate;
  int? quantity;
  List<String> images;

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
  });
}
