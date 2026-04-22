import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseCartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _normalizeItems(dynamic rawItems) {
    if (rawItems is! List) return <Map<String, dynamic>>[];
    return rawItems
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  double _calculateSubtotal(List<Map<String, dynamic>> items) {
    double subtotal = 0;
    for (final item in items) {
      final rawPrice = item['price'];
      final rawQuantity = item['quantity'];
      final price = rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice?.toString() ?? '') ?? 0;
      final quantity = rawQuantity is int
          ? rawQuantity
          : int.tryParse(rawQuantity?.toString() ?? '') ?? 0;
      subtotal += price * quantity;
    }
    return subtotal;
  }

  Map<String, dynamic> _toCartItem(
    ProductModel product, {
    required int quantity,
  }) {
    return {
      'productId': product.id,
      'title': product.name,
      'imageUrl': product.image ?? '',
      'price': product.price,
      'quantity': quantity.toString(),
      'sellerId': product.sellerId,
    };
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _getCartDocument(
    User user,
  ) async {
    final byUid = await _firestore
        .collection('carts')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (byUid.docs.isNotEmpty) return byUid.docs.first;

    final uidAsInt = int.tryParse(user.uid);
    if (uidAsInt != null) {
      final byIntId = await _firestore
          .collection('carts')
          .where('userId', isEqualTo: uidAsInt)
          .limit(1)
          .get();

      if (byIntId.docs.isNotEmpty) return byIntId.docs.first;
    }

    return null;
  }

  Future<DocumentReference<Map<String, dynamic>>> _getOrCreateCartDocRef(
    User user,
  ) async {
    final existing = await _getCartDocument(user);
    if (existing != null) {
      return existing.reference;
    }

    return _firestore.collection('carts').doc();
  }

  List<ProductModel> _extractProductsFromCartDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final products = <ProductModel>[];

    for (final doc in docs) {
      final data = doc.data();
      final items = data['items'];

      if (items is List) {
        for (final item in items.whereType<Map<String, dynamic>>()) {
          products.add(ProductModel.fromMap(item));
        }
      } else {
        products.add(ProductModel.fromMap(data, id: doc.id));
      }
    }

    return products;
  }

  /// Get user's cart products
  Future<List<ProductModel>> getCartProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final cartsDoc = await _getCartDocument(user);
      if (cartsDoc != null) {
        final data = cartsDoc.data();
        final items = _normalizeItems(data['items']);
        return items.map((item) => ProductModel.fromMap(item)).toList();
      }

      final customerCartDocs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('cart')
          .get();

      if (customerCartDocs.docs.isNotEmpty) {
        return _extractProductsFromCartDocs(customerCartDocs.docs);
      }

      final globalCartDocs = await _firestore
          .collection('cart')
          .where('userId', isEqualTo: user.uid)
          .get();

      return _extractProductsFromCartDocs(globalCartDocs.docs);
    } catch (e) {
      rethrow;
    }
  }

  /// Add product to cart or increase quantity
  Future<void> addToCart(ProductModel product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final cartRef = await _getOrCreateCartDocRef(user);
      final snapshot = await cartRef.get();
      final currentData = snapshot.data() ?? <String, dynamic>{};
      final items = _normalizeItems(currentData['items']);

      final index = items.indexWhere(
        (item) => item['productId']?.toString() == product.id,
      );

      if (index != -1) {
        final currentQuantity =
            int.tryParse(items[index]['quantity']?.toString() ?? '0') ?? 0;
        items[index]['quantity'] = (currentQuantity + 1).toString();
      } else {
        items.add(_toCartItem(product, quantity: 1));
      }

      await cartRef.set({
        'userId': currentData['userId'] ?? user.uid,
        'items': items,
        'itemsCount': items.length,
        'subtotal': _calculateSubtotal(items),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Remove product from cart or decrease quantity
  Future<void> removeFromCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final cartDoc = await _getCartDocument(user);
      if (cartDoc == null) return;

      final items = _normalizeItems(cartDoc.data()['items']);
      final index = items.indexWhere(
        (item) => item['productId']?.toString() == productId,
      );

      if (index == -1) return;

      final currentQuantity =
          int.tryParse(items[index]['quantity']?.toString() ?? '0') ?? 0;

      if (currentQuantity > 1) {
        items[index]['quantity'] = (currentQuantity - 1).toString();
      } else {
        items.removeAt(index);
      }

      await cartDoc.reference.update({
        'items': items,
        'itemsCount': items.length,
        'subtotal': _calculateSubtotal(items),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final cartDoc = await _getCartDocument(user);
      if (cartDoc != null) {
        await cartDoc.reference.update({
          'items': <Map<String, dynamic>>[],
          'itemsCount': 0,
          'subtotal': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

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

      final cartDoc = await _getCartDocument(user);
      if (cartDoc != null) {
        final items = _normalizeItems(cartDoc.data()['items']);
        final index = items.indexWhere(
          (item) => item['productId']?.toString() == productId,
        );

        if (index == -1) return;

        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index]['quantity'] = quantity.toString();
        }

        await cartDoc.reference.update({
          'items': items,
          'itemsCount': items.length,
          'subtotal': _calculateSubtotal(items),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

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
