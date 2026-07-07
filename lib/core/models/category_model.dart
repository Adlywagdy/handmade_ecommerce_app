import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';

class CategoryModel {
  final String? id;
  final String categorytitle;
  final String? categoryTitleAR;
  final String? categoryiconpath;
  final bool? isActive;
  final int? order;
  final int? productsCount;
  final List<CategoryModel>? subcategories;

  const CategoryModel({
    this.id,
    required this.categorytitle,
    this.categoryTitleAR,
    this.categoryiconpath,
    this.isActive,
    this.order,
    this.productsCount,
    this.subcategories,
  });

  String localizedTitle(bool isArabic) {
    if (isArabic && categoryTitleAR != null && categoryTitleAR!.isNotEmpty) {
      return categoryTitleAR!;
    }
    return categorytitle;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CategoryModel(
      id: id ?? map['categoryId']?.toString() ?? map['id']?.toString(),
      categorytitle:
          (map['nameEN'] ?? map['name'] ?? map['categorytitle'] ?? '')
              .toString(),
      categoryTitleAR:
          (map['nameAR'] ?? map['categoryTitleAR'] ?? map['name_ar'])
              ?.toString(),
      categoryiconpath: map['icon']?.toString(),
      isActive: map['isActive'] as bool?,
      order: parseInt(map['order']),
      productsCount: parseInt(map['productsCount']),
    );
  }

  static String? normalizeReferenceId(dynamic value) {
    final text = cleanString(value);
    if (text == null) return null;

    final path = RegExp(r'^/?categories/([^/]+)$').firstMatch(text);
    if (path != null) return path.group(1);

    final embedded = RegExp(r'categories/([^/\s)]+)').firstMatch(text);
    if (embedded != null) return embedded.group(1);

    return text;
  }
}
