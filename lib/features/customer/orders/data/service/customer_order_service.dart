import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';

class CustomerOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const double _commissionRate = 0.1;

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int? _extractNumeric(dynamic raw) {
    final s = raw?.toString() ?? '';
    final direct = int.tryParse(s);
    if (direct != null) return direct;
    final m = RegExp(r"(\d+)").firstMatch(s);
    return m != null ? int.tryParse(m.group(1)!) : null;
  }

  List<CustomerOrderModel> _sortOrders(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final orders = docs.map(_orderFromSnapshot).toList();
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return orders;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getOrdersSnapshot(
    String userId, {
    OrderStatus? status,
    String? orderNumber,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId);

    if (status != null) {
      query = query.where('status', isEqualTo: _statusToString(status));
    }

    if (orderNumber != null) {
      query = query.where('orderNumber', isEqualTo: orderNumber);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    try {
      return await query.orderBy('createdAt', descending: true).get();
    } catch (_) {
      return await query.get();
    }
  }

  /// Get all orders for current user
  Future<List<CustomerOrderModel>> getAllOrders() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final docs = await _getOrdersSnapshot(user.uid);
    return _sortOrders(docs.docs);
  }

  /// Get filtered orders by status
  Future<List<CustomerOrderModel>> getFilteredOrders(OrderStatus status) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final docs = await _getOrdersSnapshot(user.uid, status: status);
    return _sortOrders(docs.docs);
  }

  Future<CustomerOrderModel?> _findOrder(
    String userId,
    String field,
    dynamic value,
  ) async {
    final snap = await _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? _orderFromSnapshot(snap.docs.first) : null;
  }

  /// Get order details
  Future<CustomerOrderModel?> getOrderDetails(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final rootDoc = await _firestore.collection('orders').doc(orderId).get();
    if (rootDoc.exists && rootDoc.data()?['customerId'] == user.uid) {
      return _orderFromSnapshot(rootDoc);
    }

    final parsedNum = _extractNumeric(orderId);
    if (parsedNum != null) {
      final found = await _findOrder(user.uid, 'orderNumber', parsedNum);
      if (found != null) return found;
    }

    return await _findOrder(user.uid, 'orderid', orderId) ??
        await _findOrder(user.uid, 'orderNumber', orderId);
  }

  /// Place new order
  Future<String> placeOrder(CustomerOrderModel order) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final rootOrderRef = _firestore.collection('orders').doc();
    final subtotal = _toDouble(order.payment.subtotalPrice);
    final deliveryFee = _toDouble(order.payment.deliveryFee);
    final totalPrice = _toDouble(order.payment.totalPrice);
    final commission = subtotal * _commissionRate;
    final orderPayload = {
      ...order.toMap(),
      'customerId': user.uid,
      'commissionRate': _commissionRate,
      'commission': commission,
      'sellerEarning': subtotal - commission,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalPrice': totalPrice > 0 ? totalPrice : subtotal + deliveryFee,
      'status': _statusToString(order.status),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final batch = _firestore.batch();
    batch.set(rootOrderRef, orderPayload);

    for (final product in order.products) {
      if (product.id.isNotEmpty) {
        final productRef = _firestore.collection('products').doc(product.id);
        batch.update(productRef, {
          'stock': FieldValue.increment(-product.quantity),
          'salesCount': FieldValue.increment(product.quantity),
        });
      }
    }

    await batch.commit();
    return rootOrderRef.id;
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final cancelPayload = {
      'status': _statusToString(OrderStatus.cancelled),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final rootDocRef = _firestore.collection('orders').doc(orderId);
    final rootDoc = await rootDocRef.get();
    if (rootDoc.exists && rootDoc.data()?['customerId'] == user.uid) {
      await rootDocRef.update(cancelPayload);
    }

    final parsedNum = _extractNumeric(orderId);
    if (parsedNum != null) {
      final snap = await _findDoc(user.uid, 'orderNumber', parsedNum);
      if (snap != null) await snap.reference.update(cancelPayload);
    }

    final byId = await _findDoc(user.uid, 'orderid', orderId);
    if (byId != null) await byId.reference.update(cancelPayload);

    final byNum = await _findDoc(user.uid, 'orderNumber', orderId);
    if (byNum != null) await byNum.reference.update(cancelPayload);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findDoc(
    String userId,
    String field,
    dynamic value,
  ) async {
    final snap = await _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty ? snap.docs.first : null;
  }

  /// Helper to convert Firestore document to OrderModel
  CustomerOrderModel _orderFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];

    final normalizedCreatedAt = createdAt is Timestamp
        ? createdAt.toDate().toIso8601String()
        : createdAt?.toString();
    final normalizedUpdatedAt = updatedAt is Timestamp
        ? updatedAt.toDate().toIso8601String()
        : updatedAt?.toString();

    return CustomerOrderModel.fromMap({
      ...data,
      'orderId': data['orderId'] ?? data['orderNumber'] ?? doc.id,
      'status': data['status'] ?? 'pending',
      'orderDate': data['orderDate']?.toString() ?? normalizedCreatedAt,
      'createdAt': normalizedCreatedAt,
      'updatedAt': normalizedUpdatedAt,
    }, id: doc.id);
  }

  String _statusToString(OrderStatus status) {
    return status.name;
  }

  /// Get next order ID atomically using a Firestore counter document.
  Future<int> getNextOrderID() async {
    final counterRef = _firestore.collection('counters').doc('orderCounter');

    return await _firestore.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);
      final current = snapshot.exists
          ? (snapshot.data()?['current'] as int? ?? 9999)
          : 9999;
      final next = current + 1;
      transaction.set(counterRef, {'current': next});
      return next;
    });
  }
}
