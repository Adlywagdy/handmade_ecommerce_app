import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';

Future<SellerModel> getsellerdata(String sellerId) async {
  final normalizedId = SellerModel.normalizeReferenceId(sellerId) ?? '';
  if (normalizedId.isEmpty) {
    throw ArgumentError('Seller id is empty');
  }

  final db = FirebaseFirestore.instance;

  final doc = await db.collection('sellers').doc(normalizedId).get();
  if (doc.exists && doc.data() != null) {
    return SellerModel.fromMap(doc.data()!, fallbackId: doc.id);
  }

  for (final field in const ['uid', 'email', 'sellerId']) {
    final match = await _findSellerByField(
      db: db,
      field: field,
      value: normalizedId,
    );
    if (match != null) {
      return SellerModel.fromMap(match.data(), fallbackId: match.id);
    }
  }

  throw StateError('Seller not found for id: $normalizedId');
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _findSellerByField({
  required FirebaseFirestore db,
  required String field,
  required String value,
}) async {
  final result = await db
      .collection('sellers')
      .where(field, isEqualTo: value)
      .limit(1)
      .get();

  if (result.docs.isEmpty) {
    return null;
  }

  return result.docs.first;
}
