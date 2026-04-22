import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class FirebaseOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all orders for current user
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final customerOrdersDocs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      if (customerOrdersDocs.docs.isNotEmpty) {
        return customerOrdersDocs.docs
            .map((doc) => _orderFromSnapshot(doc))
            .toList();
      }

      final docs = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return docs.docs.map((doc) => _orderFromSnapshot(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get filtered orders by status
  Future<List<OrderModel>> getFilteredOrders(OrderStatus status) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final customerOrdersDocs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .where('status', isEqualTo: _statusToString(status))
          .orderBy('createdAt', descending: true)
          .get();

      if (customerOrdersDocs.docs.isNotEmpty) {
        return customerOrdersDocs.docs
            .map((doc) => _orderFromSnapshot(doc))
            .toList();
      }

      final docs = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .where('status', isEqualTo: _statusToString(status))
          .orderBy('createdAt', descending: true)
          .get();

      return docs.docs.map((doc) => _orderFromSnapshot(doc)).toList();
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

      final customerOrdersDocs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final docs = customerOrdersDocs.docs.isNotEmpty
          ? customerOrdersDocs
          : await _firestore
                .collection('orders')
                .where('customerId', isEqualTo: user.uid)
                .orderBy('createdAt', descending: true)
                .get();

      return docs.docs
          .where((doc) {
            final data = doc.data();
            final orderId = (data['orderId'] ?? data['orderNumber'] ?? '')
                .toString()
                .toLowerCase();
            final customerName = (data['customerName'] ?? '')
                .toString()
                .toLowerCase();
            final customerEmail = (data['customerEmail'] ?? '')
                .toString()
                .toLowerCase();
            final customerPhone = (data['customerPhone'] ?? '')
                .toString()
                .toLowerCase();

            return orderId.contains(normalizedQuery) ||
                customerName.contains(normalizedQuery) ||
                customerEmail.contains(normalizedQuery) ||
                customerPhone.contains(normalizedQuery);
          })
          .map((doc) => _orderFromSnapshot(doc))
          .toList();
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

      final docs = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: user.uid)
          .where('orderNumber', isEqualTo: orderId)
          .limit(1)
          .get();

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

      final docRef = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .add({
            ...order.toMap(),
            'customerId': user.uid,
            'status': _statusToString(order.status),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({
            'status': _statusToString(OrderStatus.cancelled),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }

  /// Helper to convert Firestore document to OrderModel
  OrderModel _orderFromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAt = data['createdAt'];

    return OrderModel.fromMap({
      ...data,
      'orderId': data['orderId'] ?? data['orderNumber'] ?? doc.id,
      'status': data['status'] ?? 'pending',
      'orderDate': createdAt is Timestamp
          ? createdAt.toDate().toIso8601String()
          : data['orderDate']?.toString() ?? data['createdAt']?.toString(),
      'updatedAt': DateTime.now().toIso8601String(),
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
