import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class CategoryModel {
  final String categorytitle;
  final String? categoryiconpath;
  final String? categoryexample;
  final List<ProductModel>? categoryproducts;
  final List<CategoryModel>? subcategories;
  const CategoryModel({
    required this.categorytitle,
    this.categoryiconpath,
    this.categoryexample,
    this.categoryproducts,
    this.subcategories,
  });
}
