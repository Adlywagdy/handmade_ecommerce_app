import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/admin/data/models/coupon_model.dart';

class FirebaseCartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _carts =>
      _firestore.collection('carts');

  // ─── Helpers ──────────────────────────────────────────

  String? get _userId => _auth.currentUser?.uid;

  List<Map<String, dynamic>> _parseItems(dynamic raw) {
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  double _subtotal(List<Map<String, dynamic>> items) {
    return items.fold(0, (runningTotal, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0;
      final qty = int.tryParse('${item['quantity']}') ?? 0;
      return runningTotal + price * qty;
    });
  }

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

  Map<String, dynamic> _toCartItem(ProductModel product, {int quantity = 1}) {
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getCartDoc() async {
    final uid = _userId;
    if (uid == null) return null;
    final doc = await _carts.doc(uid).get();
    return doc.exists ? doc : null;
  }

  // ─── Public API ───────────────────────────────────────

  Future<List<ProductModel>> getCartProducts() async {
    final doc = await _getCartDoc();
    if (doc == null) return [];
    final items = _parseItems(doc.data()?['items']);
    return items.map((item) => ProductModel.fromMap(item)).toList();
  }

  Future<void> addToCart(ProductModel product) async {
    final uid = _userId;
    if (uid == null) throw Exception('User not authenticated');

    final ref = _carts.doc(uid);
    final snapshot = await ref.get();
    final items = _parseItems(snapshot.data()?['items']);

    final idx = items.indexWhere((i) => i['productId']?.toString() == product.id);
    if (idx != -1) {
      final currentQty = int.tryParse('${items[idx]['quantity']}') ?? 0;
      items[idx]['quantity'] = (currentQty + 1).toString();
    } else {
      items.add(_toCartItem(product, quantity: 1));
    }

    await ref.set(_cartPayload(userId: uid, items: items), SetOptions(merge: true));
  }

  Future<void> removeFromCart(String productId) async {
    final uid = _userId;
    if (uid == null) throw Exception('User not authenticated');

    final doc = await _getCartDoc();
    if (doc == null) return;

    final items = _parseItems(doc.data()?['items']);
    final idx = items.indexWhere((i) => i['productId']?.toString() == productId);
    if (idx == -1) return;

    final currentQty = int.tryParse('${items[idx]['quantity']}') ?? 0;
    if (currentQty > 1) {
      items[idx]['quantity'] = (currentQty - 1).toString();
    } else {
      items.removeAt(idx);
    }

    await doc.reference.update(_cartPayload(userId: uid, items: items));
  }

  Future<void> clearCart() async {
    final uid = _userId;
    if (uid == null) throw Exception('User not authenticated');

    final doc = await _getCartDoc();
    if (doc != null) {
      await doc.reference.update(_cartPayload(userId: uid, items: []));
    }
  }

  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    final uid = _userId;
    if (uid == null) throw Exception('User not authenticated');

    final doc = await _getCartDoc();
    if (doc == null) return;

    final items = _parseItems(doc.data()?['items']);
    final idx = items.indexWhere((i) => i['productId']?.toString() == productId);
    if (idx == -1) return;

    if (quantity <= 0) {
      items.removeAt(idx);
    } else {
      items[idx]['quantity'] = quantity.toString();
    }

    await doc.reference.update(_cartPayload(userId: uid, items: items));
  }

  Future<List<CouponModel>> fetchCoupons() async {
    final snapshot = await _firestore.collection('coupons').get();
    return snapshot.docs
        .map((doc) => CouponModel.fromJson(doc.data(), id: doc.id))
        .toList();
  }
}
