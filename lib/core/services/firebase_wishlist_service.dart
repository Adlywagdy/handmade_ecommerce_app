import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseWishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _wishlistRootRef(String userId) {
    return _firestore.collection('wishlists').doc(userId);
  }

  CollectionReference<Map<String, dynamic>> _wishlistItemsRef(String userId) {
    // Exact path: /wishlists/{userId}/items/{productId}
    return _wishlistRootRef(userId).collection('items');
  }

  Future<void> _ensureWishlistRootDoc(String userId) async {
    await _wishlistRootRef(userId).set({
      'userId': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get user's wishlist products
  Future<List<ProductModel>> getWishlistProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final wishlistItemsSnapshot = await _wishlistItemsRef(
        user.uid,
      ).orderBy('addedAt', descending: true).get();
      if (wishlistItemsSnapshot.docs.isEmpty) return [];

      final productIds = wishlistItemsSnapshot.docs
          .map((doc) => (doc.data()['productId'] ?? doc.id).toString())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final products = <ProductModel>[];
      for (final productId in productIds) {
        final productDoc = await _firestore
            .collection('products')
            .doc(productId)
            .get();
        if (productDoc.exists && productDoc.data() != null) {
          products.add(
            ProductModel.fromMap(productDoc.data()!, id: productDoc.id),
          );
        }
      }

      return products;
    } catch (e) {
      rethrow;
    }
  }

  /// Add or remove product from wishlist
  Future<void> toggleWishlistProduct(ProductModel product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _ensureWishlistRootDoc(user.uid);

      final wishlistRef = _wishlistItemsRef(user.uid).doc(product.id);

      final doc = await wishlistRef.get();

      if (doc.exists) {
        // Remove from wishlist
        await wishlistRef.delete();
      } else {
        // Add to wishlist
        await wishlistRef.set({
          'productId': product.id,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      await _wishlistRootRef(user.uid).set({
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _wishlistItemsRef(user.uid).doc(productId).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  /// Clear entire wishlist
  Future<void> clearWishlist() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final docs = await _wishlistItemsRef(user.uid).get();

      for (var doc in docs.docs) {
        await doc.reference.delete();
      }

      await _wishlistRootRef(user.uid).set({
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }
}
