import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';

class CustomerSellerProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SellerModel> getSellerProfile(String sellerId) async {
    final normalizedId = SellerModel.normalizeReferenceId(sellerId) ?? '';
    if (normalizedId.isEmpty) {
      throw ArgumentError('Seller id is empty');
    }

    // 1. Try direct document lookup
    final doc = await _firestore.collection('sellers').doc(normalizedId).get();
    if (doc.exists && doc.data() != null) {
      return _enrichSeller(doc.data()!, doc.id);
    }

    // 2. Fallback: search by common fields
    for (final field in const ['uid', 'email', 'sellerId']) {
      final match = await _findSellerByField(field: field, value: normalizedId);
      if (match != null) {
        return _enrichSeller(match.data(), match.id);
      }
    }

    throw StateError('Seller not found for id: $normalizedId');
  }

  /// Fetches stats (totalProducts, totalSales, rating) from the products
  /// collection and merges them into the seller data.
  Future<SellerModel> _enrichSeller(
    Map<String, dynamic> sellerData,
    String docId,
  ) async {
    final seller = SellerModel.fromMap(sellerData, fallbackId: docId);
    final sellerIdentifier = seller.primaryIdentifier;

    if (sellerIdentifier.isEmpty) {
      return seller;
    }

    try {
      // Query all active products for this seller
      final productsSnapshot = await _firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerIdentifier)
          .where('isActive', isEqualTo: true)
          .get();

      final products = productsSnapshot.docs;
      final totalProducts = products.length;

      if (totalProducts == 0) {
        return seller;
      }

      // Calculate total sales and average rating
      int totalSales = 0;
      double ratingSum = 0;
      int ratedCount = 0;

      for (final doc in products) {
        final data = doc.data();
        totalSales += (data['salesCount'] as num?)?.toInt() ?? 0;
        final rating = (data['rating'] as num?)?.toDouble() ?? 0;
        if (rating > 0) {
          ratingSum += rating;
          ratedCount++;
        }
      }

      final avgRating = ratedCount > 0 ? ratingSum / ratedCount : 0.0;

      // Return enriched seller with calculated stats
      return SellerModel(
        id: seller.id,
        name: seller.name,
        email: seller.email,
        specialty: seller.specialty,
        submittedDate: seller.submittedDate,
        ownerName: seller.ownerName,
        phone: seller.phone,
        badge: seller.badge,
        image: seller.image,
        city: seller.city,
        country: seller.country,
        location: seller.location,
        rating: seller.rating ?? avgRating,
        totalProducts: seller.totalProducts ?? totalProducts,
        totalSales: seller.totalSales ?? totalSales,
        walletBalance: seller.walletBalance,
        commissionRate: seller.commissionRate,
        isActive: seller.isActive,
        status: seller.status,
        submittedAt: seller.submittedAt,
        approvedAt: seller.approvedAt,
        createdAt: seller.createdAt,
      );
    } catch (_) {
      // If product query fails, return seller as-is
      return seller;
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _findSellerByField({
    required String field,
    required String value,
  }) async {
    final result = await _firestore
        .collection('sellers')
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    return result.docs.isNotEmpty ? result.docs.first : null;
  }
}
