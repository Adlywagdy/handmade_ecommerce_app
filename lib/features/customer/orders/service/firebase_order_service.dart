import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class FirebaseOrderService {
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
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final docs = await _getOrdersSnapshot(user.uid);
      return _sortOrders(docs.docs);
    } catch (e) {
      rethrow;
    }
  }

  /// Get filtered orders by status
  Future<List<CustomerOrderModel>> getFilteredOrders(OrderStatus status) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final docs = await _getOrdersSnapshot(user.uid, status: status);

      return _sortOrders(docs.docs);
    } catch (e) {
      rethrow;
    }
  }

  /// Get order details
  Future<CustomerOrderModel?> getOrderDetails(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      // 1) Try direct doc lookup (doc id)
      final rootDoc = await _firestore.collection('orders').doc(orderId).get();
      if (rootDoc.exists && rootDoc.data()?['customerId'] == user.uid) {
        return _orderFromSnapshot(rootDoc);
      }

      // 2) Try numeric `orderNumber` match (if orderId contains digits)
      final parsedNum = _extractNumeric(orderId);
      if (parsedNum != null) {
        final snap = await _firestore
            .collection('orders')
            .where('customerId', isEqualTo: user.uid)
            .where('orderNumber', isEqualTo: parsedNum)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) return _orderFromSnapshot(snap.docs.first);
      }

      // 3) Try exact string match on `orderid` (the prefixed/display id)
      final byOrderId = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .where('orderid', isEqualTo: orderId)
          .limit(1)
          .get();
      if (byOrderId.docs.isNotEmpty)
        return _orderFromSnapshot(byOrderId.docs.first);

      // 4) Fallback: try legacy string-stored orderNumber
      final byOrderNumberString = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .where('orderNumber', isEqualTo: orderId)
          .limit(1)
          .get();
      if (byOrderNumberString.docs.isNotEmpty)
        return _orderFromSnapshot(byOrderNumberString.docs.first);

      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Place new order
  Future<String> placeOrder(CustomerOrderModel order) async {
    try {
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

      await rootOrderRef.set(orderPayload);

      return rootOrderRef.id;
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
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

      // Try numeric `orderNumber`, then string `orderid`, then legacy string `orderNumber`
      final parsedNum = _extractNumeric(orderId);
      if (parsedNum != null) {
        final snap = await _firestore
            .collection('orders')
            .where('customerId', isEqualTo: user.uid)
            .where('orderNumber', isEqualTo: parsedNum)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty)
          await snap.docs.first.reference.update(cancelPayload);
      }

      final byOrderId = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .where('orderid', isEqualTo: orderId)
          .limit(1)
          .get();
      if (byOrderId.docs.isNotEmpty)
        await byOrderId.docs.first.reference.update(cancelPayload);

      final byOrderNumberString = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .where('orderNumber', isEqualTo: orderId)
          .limit(1)
          .get();
      if (byOrderNumberString.docs.isNotEmpty)
        await byOrderNumberString.docs.first.reference.update(cancelPayload);
    } catch (e) {
      rethrow;
    }
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

  /// Get next order ID by fetching the last order and incrementing
  Future<int> getNextOrderID() async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .orderBy('orderNumber', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 10000;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final String orderNumber = data['orderNumber'];

      final int lastOrderNum = int.parse(orderNumber.split('-').last);

      return lastOrderNum;
    } catch (e) {
      throw Exception('Failed to get next order ID: $e');
    }
  }
}
