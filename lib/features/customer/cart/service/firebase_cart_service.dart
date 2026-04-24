import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseCartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _cartsRef =>
      _firestore.collection('carts');

  List<Map<String, dynamic>> _normalizeItems(dynamic rawItems) {
    if (rawItems is! List) return <Map<String, dynamic>>[];
    return rawItems
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  double _calculateSubtotal(List<Map<String, dynamic>> items) {
    return items.fold(0, (subtotal, item) {
      final rawPrice = item['price'];
      final rawQuantity = item['quantity'];
      final price = rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice?.toString() ?? '') ?? 0;
      final quantity = rawQuantity is int
          ? rawQuantity
          : int.tryParse(rawQuantity?.toString() ?? '') ?? 0;
      return subtotal + (price * quantity);
    });
  }

  Map<String, dynamic> _toCartItem(
    ProductModel product, {
    required int quantity,
  }) {
    return {
      'productId': product.id,
      'name': product.name,
      'title': product.name,
      'images': product.images,
      'productImage': product.image ?? '',
      'imageUrl': product.image ?? '',
      'price': product.price,
      'quantity': quantity.toString(),
      'sellerId': product.sellerId,
    };
  }

  Map<String, dynamic> _buildCartPayload({
    required String userId,
    required List<Map<String, dynamic>> items,
  }) {
    return {
      'userId': userId,
      'items': items,
      'itemsCount': items.length,
      'subtotal': _calculateSubtotal(items),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getCartDocument(
    User user,
  ) async {
    final byId = await _cartsRef.doc(user.uid).get();
    if (byId.exists) return byId;

    final byUid = await _cartsRef
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (byUid.docs.isNotEmpty) return byUid.docs.first;

    return null;
  }

  Future<DocumentReference<Map<String, dynamic>>> _getOrCreateCartDocRef(
    User user,
  ) async {
    final userCartRef = _cartsRef.doc(user.uid);
    final userCartSnapshot = await userCartRef.get();
    if (userCartSnapshot.exists) {
      return userCartRef;
    }

    final existing = await _getCartDocument(user);
    if (existing != null && existing.id != user.uid) {
      await userCartRef.set(existing.data() ?? <String, dynamic>{});
      await existing.reference.delete();
    }

    return userCartRef;
  }

  /// Get user's cart products
  Future<List<ProductModel>> getCartProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final cartsDoc = await _getCartDocument(user);
      if (cartsDoc == null) return [];

      final data = cartsDoc.data() ?? <String, dynamic>{};
      final items = _normalizeItems(data['items']);
      return items.map((item) => ProductModel.fromMap(item)).toList();
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

      await cartRef.set(
        _buildCartPayload(
          userId: currentData['userId']?.toString() ?? user.uid,
          items: items,
        ),
        SetOptions(merge: true),
      );
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

      final data = cartDoc.data() ?? <String, dynamic>{};
      final items = _normalizeItems(data['items']);
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

      await cartDoc.reference.update(
        _buildCartPayload(userId: user.uid, items: items),
      );
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
        await cartDoc.reference.update(
          _buildCartPayload(userId: user.uid, items: <Map<String, dynamic>>[]),
        );
        return;
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
        final data = cartDoc.data() ?? <String, dynamic>{};
        final items = _normalizeItems(data['items']);
        final index = items.indexWhere(
          (item) => item['productId']?.toString() == productId,
        );

        if (index == -1) return;

        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index]['quantity'] = quantity.toString();
        }

        await cartDoc.reference.update(
          _buildCartPayload(userId: user.uid, items: items),
        );
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
