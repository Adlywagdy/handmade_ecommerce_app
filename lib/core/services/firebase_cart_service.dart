import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseCartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user's cart products
  Future<List<ProductModel>> getCartProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('cart')
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
          quantity: data['quantity'] ?? 1,
          categoryId: data['categoryId'],
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Add product to cart or increase quantity
  Future<void> addToCart(ProductModel product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final cartRef = _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('cart')
          .doc(product.id);

      final doc = await cartRef.get();

      if (doc.exists) {
        // Increase quantity
        await cartRef.update({'quantity': FieldValue.increment(1)});
      } else {
        // Add new item
        await cartRef.set({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'image': product.image,
          'description': product.description,
          'sellerId': product.sellerId,
          'rating': product.rating,
          'reviewsCount': product.reviewsCount,
          'categoryId': product.categoryId,
          'quantity': 1,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove product from cart or decrease quantity
  Future<void> removeFromCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final cartRef = _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('cart')
          .doc(productId);

      final doc = await cartRef.get();

      if (doc.exists && doc['quantity'] > 1) {
        // Decrease quantity
        await cartRef.update({'quantity': FieldValue.increment(-1)});
      } else {
        // Remove item completely
        await cartRef.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('cart')
          .get();

      for (var doc in docs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update product quantity in cart
  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      if (quantity <= 0) {
        await removeFromCart(productId);
      } else {
        await _firestore
            .collection('customers')
            .doc(user.uid)
            .collection('cart')
            .doc(productId)
            .update({'quantity': quantity});
      }
    } catch (e) {
      rethrow;
    }
  }
}
