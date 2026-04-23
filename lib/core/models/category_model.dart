import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class CategoryModel {
  final String? id;
  final String categorytitle;
  final String? categoryiconpath;
  final String? categoryexample;
  final bool? isActive;
  final int? order;
  final int? productsCount;
  final List<ProductModel>? categoryproducts;
  final List<CategoryModel>? subcategories;
  const CategoryModel({
    this.id,
    required this.categorytitle,
    this.categoryiconpath,
    this.categoryexample,
    this.isActive,
    this.order,
    this.productsCount,
    this.categoryproducts,
    this.subcategories,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final orderValue = map['order'] ?? map['sortOrder'];
    final productsCountValue = map['productsCount'];

    return CategoryModel(
      id: id ?? map['id']?.toString() ?? map['categoryId']?.toString(),
      categorytitle: (map['categorytitle'] ?? map['name'] ?? '').toString(),
      categoryiconpath:
          map['categoryiconpath']?.toString() ??
          map['icon']?.toString() ??
          map['imageUrl']?.toString() ??
          map['image']?.toString(),
      categoryexample: map['categoryexample']?.toString(),
      isActive: map['isActive'] as bool?,
      order: orderValue is int ? orderValue : int.tryParse('$orderValue'),
      productsCount: productsCountValue is int
          ? productsCountValue
          : int.tryParse('$productsCountValue'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categorytitle': categorytitle,
      'name': categorytitle,
      'categoryiconpath': categoryiconpath,
      'icon': categoryiconpath,
      'imageUrl': categoryiconpath,
      'image': categoryiconpath,
      'categoryexample': categoryexample,
      'isActive': isActive,
      'order': order,
      'sortOrder': order,
      'productsCount': productsCount,
    };
  }
}
