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

  /// Search orders by ID, name, email, or phone
  Future<List<CustomerOrderModel>> searchOrders(String query) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final normalizedQuery = query.toLowerCase();

      final ordersDocs = await _getOrdersSnapshot(user.uid);
      final mergedOrders = _sortOrders(ordersDocs.docs);

      return mergedOrders.where((order) {
        final orderId = order.orderid.toLowerCase();
        final customerName = order.customer.name.toLowerCase();
        final customerEmail = order.customer.email.toLowerCase();
        final customerPhone = order.customer.phone.toLowerCase();
        final productNames = order.products
            .map((product) => product.name.toLowerCase())
            .join(' ');

        return orderId.contains(normalizedQuery) ||
            customerName.contains(normalizedQuery) ||
            customerEmail.contains(normalizedQuery) ||
            customerPhone.contains(normalizedQuery) ||
            productNames.contains(normalizedQuery);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get order details
  Future<CustomerOrderModel?> getOrderDetails(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final rootDoc = await _firestore.collection('orders').doc(orderId).get();
      if (rootDoc.exists && rootDoc.data()?['customerId'] == user.uid) {
        return _orderFromSnapshot(rootDoc);
      }

      final userQuery = await _getOrdersSnapshot(
        user.uid,
        orderNumber: orderId,
        limit: 1,
      );
      if (userQuery.docs.isNotEmpty) {
        return _orderFromSnapshot(userQuery.docs.first);
      }

      final docs = await _getOrdersSnapshot(
        user.uid,
        orderNumber: orderId,
        limit: 1,
      );

      if (docs.docs.isEmpty) return null;

      return _orderFromSnapshot(docs.docs.first);
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

      final userByOrderNumber = await _getOrdersSnapshot(
        user.uid,
        orderNumber: orderId,
        limit: 1,
      );
      if (userByOrderNumber.docs.isNotEmpty) {
        await userByOrderNumber.docs.first.reference.update(cancelPayload);
      }
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
}
