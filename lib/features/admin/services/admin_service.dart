import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../models/sellers_model.dart';
import '../models/settings_model.dart';

class AdminStats {
  final int users;
  final int sellers;
  final int orders;
  final double revenue;

  const AdminStats({
    required this.users,
    required this.sellers,
    required this.orders,
    required this.revenue,
  });
}

class AdminFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Reads (streams) ────────────────────────────────────────────────────────
  Stream<List<OrderModel>> streamOrders() => _db.collection('orders').orderBy('createdAt', descending: true).snapshots().map((s) => s.docs.map((d) => OrderModel.fromJson(d.data(), id: d.id)).toList());

  Stream<List<ProductsModel>> streamProducts() => _db.collection('products').orderBy('createdAt', descending: true).snapshots().map((s) => s.docs.map((d) => ProductsModel.fromJson(d.data(), id: d.id)).toList());

  Stream<List<SellerData>> streamSellers() => _db.collection('sellers').snapshots().map((s) => s.docs.map((d) => SellerData.fromJson(d.data(), id: d.id)).toList());

  Stream<SettingsModel> streamSettings() => _db.doc('settings/platform').snapshots().map((d) => SettingsModel.fromJson(d.data() ?? {}));

  // ── Writes ─────────────────────────────────────────────────────────────────
  Future<void> approveSeller(String id) =>_db.collection('sellers').doc(id).update({
        'status': 'approved',
        'isActive': true,
        'approvedAt': FieldValue.serverTimestamp(),
      });

  Future<void> rejectSeller(String id) => _db.collection('sellers').doc(id).update({'status': 'rejected'});

  Future<void> approveProduct(String id) =>
      _db.collection('products').doc(id).update({
        'status': 'approved',
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> rejectProduct(String id) =>
      _db.collection('products').doc(id).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> updateOrderStatus(String id, OrderStatus status) =>
      _db.collection('orders').doc(id).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> setCommissionRate(double rate) =>
      _db.doc('settings/platform').set({
        'commissionRate': rate,
        'updatedAt': FieldValue.serverTimestamp(),
      },
       SetOptions(merge: true));

  // ── Aggregations (dashboard stats) ─────────────────────────────────────────
  Future<AdminStats> fetchStats() async {
    final usersCount = await _db.collection('users').count().get();
    final sellersCount = await _db  .collection('sellers').where('status', isEqualTo: 'approved').count().get();
    final ordersCount = await _db.collection('orders').count().get();
    final txSnap = await _db.collection('transactions').get();
    final revenue = txSnap.docs.fold<double>(0,(acc, d) => acc + ((d.data()['amount'] as num?)?.toDouble() ?? 0));
    return AdminStats(
      users: usersCount.count ?? 0,
      sellers: sellersCount.count ?? 0,
      orders: ordersCount.count ?? 0,
      revenue: revenue,
    );
  }

  Future<int> fetchPendingSellersCount() async {
    final snap = await _db.collection('sellers').where('status', isEqualTo: 'pending').count().get();
    return snap.count ?? 0;
  }

  Future<int> fetchPendingProductsCount() async {
    final snap = await _db.collection('products').where('status', isEqualTo: 'pending').count().get();
    return snap.count ?? 0;
  }
}
