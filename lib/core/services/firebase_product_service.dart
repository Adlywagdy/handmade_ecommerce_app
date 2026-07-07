import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firestore.collection('categories');

  Query<Map<String, dynamic>> get _activeProducts =>
      _products.where('isActive', isEqualTo: true);

  // ─── Helpers ──────────────────────────────────────────

  ProductModel _docToProduct(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ProductModel.fromMap(doc.data() ?? {}, id: doc.id);
  }

  bool _isApproved(ProductModel p) => p.status == 'approved';

  Future<List<ProductModel>> _withCategories(List<ProductModel> products) async {
    if (products.isEmpty) return products;

    final snapshot = await _categories.where('isActive', isEqualTo: true).get();
    final catMap = <String, CategoryModel>{
      for (final doc in snapshot.docs)
        if (doc.id.isNotEmpty) doc.id: CategoryModel.fromMap(doc.data(), id: doc.id),
    };

    return products.map((p) {
      final catId = p.category?.id?.trim();
      if (catId == null || catId.isEmpty) return p;
      final cat = catMap[catId];
      return cat != null ? p.copyWith(category: cat) : p;
    }).toList();
  }

  Future<List<ProductModel>> _loadActive({int limit = 200}) async {
    final docs = await _activeProducts.limit(limit).get();
    return docs.docs.map(_docToProduct).where(_isApproved).toList();
  }

  // ─── Featured / Top-Rated ─────────────────────────────

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final docs = await _activeProducts
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();
      final products = docs.docs.map(_docToProduct).where(_isApproved).toList();
      if (products.isNotEmpty) return _withCategories(products);
    } catch (_) {
      // isFeatured field may not exist on all datasets
    }

    final all = await _loadActive();
    if (all.isEmpty) return [];
    all.sort((a, b) => (b.salesCount ?? 0).compareTo(a.salesCount ?? 0));
    return _withCategories(all.take(10).toList());
  }

  Future<List<ProductModel>> getTopRatedProducts() async {
    final all = await _loadActive();
    if (all.isEmpty) return [];
    all.sort((a, b) => b.rating.compareTo(a.rating));
    return _withCategories(all.take(10).toList());
  }

  // ─── Categories ───────────────────────────────────────

  Future<List<CategoryModel>> getCategories() async {
    final docs = await _categories.where('isActive', isEqualTo: true).get();
    final list = docs.docs
        .map((doc) => CategoryModel.fromMap(doc.data(), id: doc.id))
        .toList();
    list.sort((a, b) {
      final cmp = (a.order ?? 0).compareTo(b.order ?? 0);
      return cmp != 0
          ? cmp
          : a.categorytitle.toLowerCase().compareTo(b.categorytitle.toLowerCase());
    });
    return list;
  }

  // ─── Search ───────────────────────────────────────────

  Future<List<ProductModel>> searchProducts(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    // Try Firestore range query first
    try {
      final docs = await _activeProducts
          .where('name', isGreaterThanOrEqualTo: q)
          .where('name', isLessThanOrEqualTo: '$q\uf8ff')
          .limit(20)
          .get();
      final results = docs.docs.map(_docToProduct).where(_isApproved).toList();
      if (results.isNotEmpty) return _withCategories(results);
    } catch (_) {
      // fall through to client-side
    }

    // Client-side fallback
    final lower = q.toLowerCase();
    final all = await _loadActive(limit: 400);
    final matches = all
        .where((p) => p.name.toLowerCase().contains(lower))
        .take(20)
        .toList();
    return _withCategories(matches);
  }

  // ─── Filter ───────────────────────────────────────────

  Future<List<ProductModel>> filterProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    final catId = categoryId?.trim();

    try {
      var q = _activeProducts;
      if (catId != null && catId.isNotEmpty) {
        q = q.where('categoryId', isEqualTo: catId);
      }
      if (minPrice != null) q = q.where('price', isGreaterThanOrEqualTo: minPrice);
      if (maxPrice != null) q = q.where('price', isLessThanOrEqualTo: maxPrice);
      if (minRating != null) q = q.where('rating', isGreaterThanOrEqualTo: minRating);

      final docs = await q.limit(50).get();
      final products = docs.docs.map(_docToProduct).where(_isApproved).toList();
      return _withCategories(products);
    } catch (_) {
      // Fallback: client-side filtering
      final all = await _loadActive(limit: 200);
      final filtered = all.where((p) {
        if (catId != null && catId.isNotEmpty && p.categoryId != catId) return false;
        if (minPrice != null && p.price < minPrice) return false;
        if (maxPrice != null && p.price > maxPrice) return false;
        if (minRating != null && p.rating < minRating) return false;
        return true;
      }).toList();
      return _withCategories(filtered);
    }
  }

  // ─── Single Product ───────────────────────────────────

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _products.doc(productId).get();
    if (!doc.exists) return null;

    final product = _docToProduct(doc);
    if (!product.isActive || product.status != 'approved') return null;

    final resolved = await _withCategories([product]);
    return resolved.isNotEmpty ? resolved.first : null;
  }
}
