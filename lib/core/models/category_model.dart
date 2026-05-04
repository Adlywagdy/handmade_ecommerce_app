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

  factory CategoryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final orderValue = map['order'];
    final productsCountValue = map['productsCount'];

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
      order: orderValue is int ? orderValue : int.tryParse('$orderValue'),
      productsCount: productsCountValue is int
          ? productsCountValue
          : int.tryParse('$productsCountValue'),
    );
  }

  static String? normalizeReferenceId(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    final categoriesPath = RegExp(r'^/?categories/([^/]+)$');
    final pathMatch = categoriesPath.firstMatch(text);
    if (pathMatch != null) return pathMatch.group(1);

    final embeddedPath = RegExp(r'categories/([^/\s)]+)');
    final embeddedMatch = embeddedPath.firstMatch(text);
    if (embeddedMatch != null) return embeddedMatch.group(1);

    return text;
  }
}
