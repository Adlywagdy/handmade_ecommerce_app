import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';

Future<SellerModel> getsellerdata(String sellerId) async {
  final normalizedId = _normalizeSellerIdentifier(sellerId);
  if (normalizedId.isEmpty) {
    throw ArgumentError('Seller id is empty');
  }

  final db = FirebaseFirestore.instance;

  final doc = await db.collection('sellers').doc(normalizedId).get();
  if (doc.exists && doc.data() != null) {
    return SellerModel.fromMap(doc.data()!, fallbackId: doc.id);
  }

  final byUid = await db
      .collection('sellers')
      .where('uid', isEqualTo: normalizedId)
      .limit(1)
      .get();
  if (byUid.docs.isNotEmpty) {
    final first = byUid.docs.first;
    return SellerModel.fromMap(first.data(), fallbackId: first.id);
  }

  final byEmail = await db
      .collection('sellers')
      .where('email', isEqualTo: normalizedId)
      .limit(1)
      .get();
  if (byEmail.docs.isNotEmpty) {
    final first = byEmail.docs.first;
    return SellerModel.fromMap(first.data(), fallbackId: first.id);
  }

  final bySellerId = await db
      .collection('sellers')
      .where('sellerId', isEqualTo: normalizedId)
      .limit(1)
      .get();
  if (bySellerId.docs.isNotEmpty) {
    final first = bySellerId.docs.first;
    return SellerModel.fromMap(first.data(), fallbackId: first.id);
  }

  throw StateError('Seller not found for id: $normalizedId');
}

String _normalizeSellerIdentifier(String raw) {
  final trimmed = raw.trim().replaceAll('\\', '/');

  final sellersPath = RegExp(r'^/?sellers/([^/]+)$');
  final pathMatch = sellersPath.firstMatch(trimmed);
  if (pathMatch != null && pathMatch.groupCount >= 1) {
    return pathMatch.group(1)!.trim();
  }

  final embeddedPath = RegExp(r'sellers/([^/\s)]+)');
  final embeddedMatch = embeddedPath.firstMatch(trimmed);
  if (embeddedMatch != null && embeddedMatch.groupCount >= 1) {
    return embeddedMatch.group(1)!.trim();
  }

  final segments = trimmed
      .split('/')
      .where((e) => e.trim().isNotEmpty)
      .toList();
  if (segments.isNotEmpty) {
    return segments.last.trim();
  }

  return trimmed;
}
