import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseWishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user's wishlist products
  Future<List<ProductModel>> getWishlistProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .get();

      return docs.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
          id: data['productId'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          image: data['image'],
          sellerId: data['sellerId'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          reviewsCount: data['reviewsCount'] ?? 0,
          quantity: data['quantity'] ?? 0,
          categoryId: data['categoryId'],
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Add or remove product from wishlist
  Future<void> toggleWishlistProduct(ProductModel product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final wishlistRef = _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .doc(product.id);

      final doc = await wishlistRef.get();

      if (doc.exists) {
        // Remove from wishlist
        await wishlistRef.delete();
      } else {
        // Add to wishlist
        await wishlistRef.set({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'image': product.image,
          'description': product.description,
          'sellerId': product.sellerId,
          'rating': product.rating,
          'reviewsCount': product.reviewsCount,
          'categoryId': product.categoryId,
          'quantity': product.quantity,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .doc(productId)
          .get();

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

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .get();

      for (var doc in docs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
