import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/coupon_model.dart';

/// Handles all cart-related Firebase operations for the current user.
class FirebaseCartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _carts =>
      _firestore.collection('carts');

  String? get _userId => _auth.currentUser?.uid;

  /// Safely converts raw Firestore data into a list of item maps.
  List<Map<String, dynamic>> _parseItems(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Calculates the total price of all items (price × quantity).
  double _subtotal(List<Map<String, dynamic>> items) {
    return items.fold(0, (acc, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0;
      final qty = int.tryParse('${item['quantity']}') ?? 0;
      return acc + price * qty;
    });
  }

  /// Builds the cart document payload with metadata.
  Map<String, dynamic> _cartPayload({
    required String userId,
    required List<Map<String, dynamic>> items,
  }) {
    return {
      'userId': userId,
      'items': items,
      'itemsCount': items.length,
      'subtotal': _subtotal(items),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converts a ProductModel into a cart-item map for Firestore.

  Map<String, dynamic> _toCartItem(ProductModel product, {int quantity = 1}) {
    return {
      'productId': product.id,
      'name': product.name,
      'images': product.images,
      'productImage': product.image ?? '',
      'price': product.price,
      'quantity': quantity.toString(),
      'sellerId': product.sellerId,
    };
  }

  /// Fetches the current user's cart document, or null if none exists.
  Future<DocumentSnapshot<Map<String, dynamic>>?> _getCartDoc() async {
    if (_userId == null) return null;
    final doc = await _carts.doc(_userId).get();
    return doc.exists ? doc : null;
  }

  /// Returns all products currently in the user's cart.
  Future<List<ProductModel>> getCartProducts() async {
    final doc = await _getCartDoc();
    if (doc == null) return [];
    final items = _parseItems(doc.data()?['items']);
    return items.map((item) => ProductModel.fromMap(item)).toList();
  }

  /// Adds a product to the cart, or increments its quantity if already present.
  /// Uses a transaction to atomically validate stock and update the cart.
  /// Throws if the product is out of stock or exceeds available stock.
  Future<void> addToCart(ProductModel product) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _firestore.runTransaction((transaction) async {
      // 1. Read product stock atomically
      final productDoc = await transaction.get(
        _firestore.collection('products').doc(product.id),
      );
      if (!productDoc.exists) throw Exception('Product not found');
      final stock = int.tryParse('${productDoc.data()?['stock']}') ?? 0;

      // 2. Read current cart
      final cartDoc = await transaction.get(_carts.doc(_userId));
      final items = _parseItems(cartDoc.data()?['items']);

      // 3. Find or add the product in the cart
      final idx = items.indexWhere(
        (i) => i['productId']?.toString() == product.id,
      );

      if (idx != -1) {
        final currentQty = int.tryParse('${items[idx]['quantity']}') ?? 0;
        if (currentQty + 1 > stock) {
          throw Exception('Cannot exceed available stock ($stock)');
        }
        items[idx]['quantity'] = (currentQty + 1).toString();
      } else {
        if (1 > stock) throw Exception('Product is out of stock');
        items.add(_toCartItem(product, quantity: 1));
      }

      // 4. Write the updated cart
      transaction.set(
        _carts.doc(_userId),
        _cartPayload(userId: _userId!, items: items),
        SetOptions(merge: true),
      );
    });
  }

  /// Decreases product quantity by 1, or removes it entirely if quantity is 1.
  Future<void> removeFromCart(String productId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final doc = await _getCartDoc();
    if (doc == null) return;

    final items = _parseItems(doc.data()?['items']);
    final idx = items.indexWhere(
      (i) => i['productId']?.toString() == productId,
    );
    if (idx == -1) return;

    final currentQty = int.tryParse('${items[idx]['quantity']}') ?? 0;
    if (currentQty > 1) {
      items[idx]['quantity'] = (currentQty - 1).toString();
    } else {
      items.removeAt(idx);
    }

    await _carts
        .doc(_userId)
        .update(_cartPayload(userId: _userId!, items: items));
  }

  /// Empties the entire cart for the current user.
  Future<void> clearCart() async {
    if (_userId == null) throw Exception('User not authenticated');

    final doc = await _getCartDoc();
    if (doc != null) {
      await _carts
          .doc(_userId)
          .update(_cartPayload(userId: _userId!, items: []));
    }
  }

  /// Fetches all available coupons from Firestore.
  Future<List<CouponModel>> fetchCoupons() async {
    final snapshot = await _firestore.collection('coupons').get();
    return snapshot.docs
        .map((doc) => CouponModel.fromJson(doc.data(), id: doc.id))
        .toList();
  }
}
