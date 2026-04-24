class CategoryModel {
  final String? id;
  final String categorytitle;
  final String? categoryiconpath;
  final bool? isActive;
  final int? order;
  final List<CategoryModel>? subcategories;
  const CategoryModel({
    this.id,
    required this.categorytitle,
    this.categoryiconpath,
    this.isActive,
    this.order,
    this.subcategories,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final orderValue = map['order'];

    return CategoryModel(
      id: id ?? map['id']?.toString() ?? map['categoryId']?.toString(),
      categorytitle: (map['name'] ?? map['categorytitle'] ?? '').toString(),
      categoryiconpath: map['icon']?.toString(),
      isActive: map['isActive'] as bool?,
      order: orderValue is int ? orderValue : int.tryParse('$orderValue'),
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
