import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final docs = await _firestore
          .collection('products')
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();

      return docs.docs.map((doc) => _productFromSnapshot(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get top-rated products
  Future<List<ProductModel>> getTopRatedProducts() async {
    try {
      final docs = await _firestore
          .collection('products')
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return docs.docs.map((doc) => _productFromSnapshot(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> docs; // Initialize the docs variable

      try {
        docs = await _firestore
            .collection('categories')
            .where('isActive', isEqualTo: true)
            .orderBy('sortOrder') // Change 'order' to 'sortOrder'
            .get();
      } catch (_) {
        docs = await _firestore.collection('categories').orderBy('name').get();
      }

      return docs.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Search products by name
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      if (query.isEmpty) return [];

      final docs = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .limit(20)
          .get();

      return docs.docs.map((doc) => _productFromSnapshot(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Filter products
  Future<List<ProductModel>> filterProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      Query query = _firestore.collection('products');

      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
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

      return docs.docs.map((doc) => _productFromSnapshot(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();

      if (!doc.exists) return null;

      return _productFromSnapshot(doc);
    } catch (e) {
      rethrow;
    }
  }

  /// Helper to convert Firestore document to ProductModel
  ProductModel _productFromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data, id: doc.id);
  }
}
