import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class FirebaseOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _docLogicalId(Map<String, dynamic> data, String docId) {
    return (data['orderId'] ?? data['orderNumber'] ?? docId).toString();
  }

  List<OrderModel> _mergeAndSortOrders({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> customerDocs,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> rootDocs,
  }) {
    final merged = <String, OrderModel>{};

    for (final doc in rootDocs) {
      final data = doc.data();
      final key = _docLogicalId(data, doc.id);
      merged[key] = _orderFromSnapshot(doc);
    }

    for (final doc in customerDocs) {
      final data = doc.data();
      final key = _docLogicalId(data, doc.id);
      merged[key] = _orderFromSnapshot(doc);
    }

    final orders = merged.values.toList();
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return orders;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getCustomerOrdersSnapshot(
    String userId, {
    OrderStatus? status,
    String? orderNumber,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection('customers')
        .doc(userId)
        .collection('orders');

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

  Future<QuerySnapshot<Map<String, dynamic>>> _getRootOrdersSnapshot(
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
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final customerOrdersDocs = await _getCustomerOrdersSnapshot(user.uid);
      final docs = await _getRootOrdersSnapshot(user.uid);

      return _mergeAndSortOrders(
        customerDocs: customerOrdersDocs.docs,
        rootDocs: docs.docs,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get filtered orders by status
  Future<List<OrderModel>> getFilteredOrders(OrderStatus status) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final customerOrdersDocs = await _getCustomerOrdersSnapshot(
        user.uid,
        status: status,
      );
      final docs = await _getRootOrdersSnapshot(user.uid, status: status);

      return _mergeAndSortOrders(
        customerDocs: customerOrdersDocs.docs,
        rootDocs: docs.docs,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Search orders by ID, name, email, or phone
  Future<List<OrderModel>> searchOrders(String query) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final normalizedQuery = query.toLowerCase();

      final customerOrdersDocs = await _getCustomerOrdersSnapshot(user.uid);
      final rootOrdersDocs = await _getRootOrdersSnapshot(user.uid);
      final mergedOrders = _mergeAndSortOrders(
        customerDocs: customerOrdersDocs.docs,
        rootDocs: rootOrdersDocs.docs,
      );

      return mergedOrders.where((order) {
        final orderId = order.orderid.toLowerCase();
        final customerName = order.customer.name.toLowerCase();
        final customerEmail = order.customer.email.toLowerCase();
        final customerPhone = order.customer.phone.toLowerCase();

        return orderId.contains(normalizedQuery) ||
            customerName.contains(normalizedQuery) ||
            customerEmail.contains(normalizedQuery) ||
            customerPhone.contains(normalizedQuery);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get order details
  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final customerDoc = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .get();

      if (customerDoc.exists) {
        return _orderFromSnapshot(customerDoc);
      }

      final rootDoc = await _firestore.collection('orders').doc(orderId).get();
      if (rootDoc.exists && rootDoc.data()?['customerId'] == user.uid) {
        return _orderFromSnapshot(rootDoc);
      }

      final customerQuery = await _getCustomerOrdersSnapshot(
        user.uid,
        orderNumber: orderId,
        limit: 1,
      );
      if (customerQuery.docs.isNotEmpty) {
        return _orderFromSnapshot(customerQuery.docs.first);
      }

      final docs = await _getRootOrdersSnapshot(
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
  Future<String> placeOrder(OrderModel order) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final rootOrderRef = _firestore.collection('orders').doc();
      final orderPayload = {
        ...order.toMap(),
        'customerId': user.uid,
        'orderId': order.orderid,
        'orderNumber': order.orderid,
        'status': _statusToString(order.status),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await rootOrderRef.set(orderPayload);

      await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .doc(rootOrderRef.id)
          .set(orderPayload, SetOptions(merge: true));

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

      final customerDocRef = _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId);
      final customerDoc = await customerDocRef.get();
      if (customerDoc.exists) {
        await customerDocRef.update({
          'status': _statusToString(OrderStatus.cancelled),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      final rootDocRef = _firestore.collection('orders').doc(orderId);
      final rootDoc = await rootDocRef.get();
      if (rootDoc.exists && rootDoc.data()?['customerId'] == user.uid) {
        await rootDocRef.update({
          'status': _statusToString(OrderStatus.cancelled),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      final rootByOrderNumber = await _getRootOrdersSnapshot(
        user.uid,
        orderNumber: orderId,
        limit: 1,
      );
      if (rootByOrderNumber.docs.isNotEmpty) {
        await rootByOrderNumber.docs.first.reference.update({
          'status': _statusToString(OrderStatus.cancelled),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Helper to convert Firestore document to OrderModel
  OrderModel _orderFromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];

    final normalizedCreatedAt = createdAt is Timestamp
        ? createdAt.toDate().toIso8601String()
        : createdAt?.toString();
    final normalizedUpdatedAt = updatedAt is Timestamp
        ? updatedAt.toDate().toIso8601String()
        : updatedAt?.toString();

    return OrderModel.fromMap({
      ...data,
      'orderId': data['orderId'] ?? data['orderNumber'] ?? doc.id,
      'status': data['status'] ?? 'pending',
      'orderDate': data['orderDate']?.toString() ?? normalizedCreatedAt,
      'createdAt': normalizedCreatedAt,
      'updatedAt': normalizedUpdatedAt,
    }, id: doc.id);
  }

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}
