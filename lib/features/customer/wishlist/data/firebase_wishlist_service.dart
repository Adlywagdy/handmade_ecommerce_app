import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

class FirebaseWishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _rootRef(String uid) =>
      _firestore.collection('wishlists').doc(uid);

  CollectionReference<Map<String, dynamic>> _itemsRef(String uid) =>
      _rootRef(uid).collection('items');

  Future<void> _ensureRoot(String uid) async {
    await _rootRef(uid).set({
      'userId': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<ProductModel>> getWishlistProducts() async {
    final uid = _userId;
    if (uid == null) return [];

    final snapshot = await _itemsRef(uid).orderBy('addedAt', descending: true).get();
    if (snapshot.docs.isEmpty) return [];

    final productIds = snapshot.docs
        .map((doc) => (doc.data()['productId'] ?? doc.id).toString())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final products = <ProductModel>[];
    for (var i = 0; i < productIds.length; i += 30) {
      final chunk = productIds.sublist(i, (i + 30).clamp(0, productIds.length));
      final docs = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in docs.docs) {
        if (doc.data().isNotEmpty) {
          products.add(ProductModel.fromMap(doc.data(), id: doc.id));
        }
      }
    }
    return products;
  }

  Future<void> toggleWishlistProduct(ProductModel product) async {
    final uid = _userId;
    if (uid == null) throw Exception('User not authenticated');

    await _ensureRoot(uid);

    final ref = _itemsRef(uid).doc(product.id);
    final doc = await ref.get();

    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({
        'productId': product.id,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }

    await _rootRef(uid).set({'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> clearWishlist() async {
    final uid = _userId;
    if (uid == null) throw Exception('User not authenticated');

    final docs = await _itemsRef(uid).get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }

    await _rootRef(uid).set({'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }
}
