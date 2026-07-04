import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');

  CollectionReference<Map<String, dynamic>> get _categoriesRef =>
      _firestore.collection('categories');

  Query<Map<String, dynamic>> get _activeProductsQuery =>
      _productsRef.where('isActive', isEqualTo: true);

  Future<Map<String, CategoryModel>> _getCategoriesById() async {
    final categories = await getCategories();
    return {
      for (final category in categories)
        if (category.id != null && category.id!.trim().isNotEmpty)
          category.id!: category,
    };
  }

  ProductModel _withResolvedCategory(
    ProductModel product,
    Map<String, CategoryModel> categoriesById,
  ) {
    final productCategory = product.category;
    final categoryId = productCategory?.id?.trim();

    if (categoryId == null || categoryId.isEmpty) {
      return product;
    }

    final resolvedCategory = categoriesById[categoryId];
    if (resolvedCategory == null) {
      return product;
    }

    return product.copyWith(category: resolvedCategory);
  }

  Future<List<ProductModel>> _resolveProductsCategories(
    List<ProductModel> products,
  ) async {
    if (products.isEmpty) return products;

    final categoriesById = await _getCategoriesById();
    if (categoriesById.isEmpty) return products;

    return products
        .map((product) => _withResolvedCategory(product, categoriesById))
        .toList();
  }

  List<ProductModel> _sortProductsByRating(List<ProductModel> products) {
    final sortedProducts = [...products];
    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedProducts;
  }

  List<ProductModel> _sortProductsBySales(List<ProductModel> products) {
    final sortedProducts = [...products];
    sortedProducts.sort(
      (a, b) => (b.salesCount ?? 0).compareTo(a.salesCount ?? 0),
    );
    return sortedProducts;
  }

  bool _isApproved(ProductModel product) => product.status == 'approved';

  Future<List<ProductModel>> _loadActiveProducts({int limit = 200}) async {
    final docs = await _activeProductsQuery.limit(limit).get();
    return docs.docs.map(_productFromSnapshot).where(_isApproved).toList();
  }

  /// Get featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final featuredDocs = await _activeProductsQuery
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();

      final featuredProducts = featuredDocs.docs
          .map(_productFromSnapshot)
          .where(_isApproved)
          .toList();

      if (featuredProducts.isNotEmpty) {
        return _resolveProductsCategories(featuredProducts);
      }
    } catch (_) {
      // Some datasets do not include isFeatured.
    }

    final products = await _loadActiveProducts();
    if (products.isEmpty) {
      return [];
    }

    final featuredProducts = _sortProductsBySales(products).take(10).toList();
    return _resolveProductsCategories(featuredProducts);
  }

  /// Get top-rated products
  Future<List<ProductModel>> getTopRatedProducts() async {
    final products = await _loadActiveProducts();
    if (products.isEmpty) return [];

    final topRatedProducts = _sortProductsByRating(products).take(10).toList();
    return _resolveProductsCategories(topRatedProducts);
  }

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final docs = await _categoriesRef
          .where('isActive', isEqualTo: true)
          .get();
      final categories = docs.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), id: doc.id))
          .toList();

      categories.sort((a, b) {
        final orderComparison = (a.order ?? 0).compareTo(b.order ?? 0);
        if (orderComparison != 0) return orderComparison;
        return a.categorytitle.toLowerCase().compareTo(
          b.categorytitle.toLowerCase(),
        );
      });

      return categories;
    } catch (e) {
      rethrow;
    }
  }

  /// Search products by name
  Future<List<ProductModel>> searchProducts(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return [];
    final normalizedQueryLower = normalizedQuery.toLowerCase();

    Future<List<ProductModel>> loadClientSideMatches() async {
      final products = await _loadActiveProducts(limit: 400);
      return products
          .where(
            (product) =>
                product.name.toLowerCase().contains(normalizedQueryLower),
          )
          .take(20)
          .toList();
    }

    try {
      final docs = await _activeProductsQuery
          .where('name', isGreaterThanOrEqualTo: normalizedQuery)
          .where('name', isLessThanOrEqualTo: '$normalizedQuery\uf8ff')
          .limit(20)
          .get();

      final firestoreMatches = docs.docs
          .map(_productFromSnapshot)
          .where(_isApproved)
          .toList();

      if (firestoreMatches.isNotEmpty) {
        return _resolveProductsCategories(firestoreMatches);
      }

      final matches = await loadClientSideMatches();
      return _resolveProductsCategories(matches);
    } catch (_) {
      final matches = await loadClientSideMatches();
      return _resolveProductsCategories(matches);
    }
  }

  /// Filter products
  Future<List<ProductModel>> filterProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    final normalizedCategoryId = categoryId?.trim();

    try {
      Query<Map<String, dynamic>> query = _activeProductsQuery;

      if (normalizedCategoryId != null && normalizedCategoryId.isNotEmpty) {
        query = query.where('categoryId', isEqualTo: normalizedCategoryId);
      }

      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      if (minRating != null) {
        query = query.where('rating', isGreaterThanOrEqualTo: minRating);
      }

      final docs = await query.limit(50).get();

      final products = docs.docs
          .map(_productFromSnapshot)
          .where(_isApproved)
          .toList();
      return _resolveProductsCategories(products);
    } catch (_) {
      final docs = await _productsRef.limit(200).get();

      final products = docs.docs.map(_productFromSnapshot).where((product) {
        if (!product.isActive || !_isApproved(product)) return false;
        if (normalizedCategoryId != null &&
            normalizedCategoryId.isNotEmpty &&
            product.categoryId != normalizedCategoryId) {
          return false;
        }
        if (minPrice != null && product.price < minPrice) return false;
        if (maxPrice != null && product.price > maxPrice) return false;
        if (minRating != null && product.rating < minRating) return false;
        return true;
      }).toList();
      return _resolveProductsCategories(products);
    }
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _productsRef.doc(productId).get();
    if (!doc.exists) return null;

    final product = _productFromSnapshot(doc);
    if (!product.isActive || product.status != 'approved') {
      return null;
    }

    final resolvedProducts = await _resolveProductsCategories([product]);
    if (resolvedProducts.isEmpty) {
      return null;
    }
    return resolvedProducts.first;
  }

  /// Helper to convert Firestore document to ProductModel
  ProductModel _productFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ProductModel.fromMap(data, id: doc.id);
  }
}
