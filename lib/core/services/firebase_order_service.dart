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

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
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

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
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

      final docs = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return docs.docs
          .where((doc) {
            final data = doc.data();
            final orderId = (data['orderId'] ?? '').toString().toLowerCase();
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

      final doc = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .get();

      if (!doc.exists) return null;

      return _orderFromSnapshot(doc);
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
            'orderId': order.orderid,
            'customerName': order.customer.name,
            'customerEmail': order.customer.email,
            'customerPhone': order.customer.phone,
            'status': _statusToString(order.status),
            'totalAmount': order.totalAmount,
            'deliveryAddress': order.deliveryAddress,
            'paymentMethod': order.payment.paymentMethod,
            'paymentStatus': 'completed',
            'items': order.items.length,
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
    final statusString = data['status'] as String?;

    OrderStatus status;
    switch (statusString) {
      case 'pending':
        status = OrderStatus.pending;
        break;
      case 'confirmed':
        status = OrderStatus.confirmed;
        break;
      case 'shipped':
        status = OrderStatus.shipped;
        break;
      case 'delivered':
        status = OrderStatus.delivered;
        break;
      case 'cancelled':
        status = OrderStatus.cancelled;
        break;
      default:
        status = OrderStatus.pending;
    }

    return OrderModel(
      orderid: data['orderId'] ?? doc.id,
      status: status,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryAddress: data['deliveryAddress'] ?? '',
      items: [],
      customer: CustomerData(
        name: data['customerName'] ?? '',
        email: data['customerEmail'] ?? '',
        phone: data['customerPhone'] ?? '',
      ),
      payment: PaymentData(
        paymentMethod: data['paymentMethod'] ?? 'Visa',
        totalPrice: (data['totalAmount'] ?? 0).toDouble(),
      ),
    );
  }

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

// Helper classes for OrderModel compatibility
class CustomerData {
  final String name;
  final String email;
  final String phone;

  CustomerData({required this.name, required this.email, required this.phone});
}

class PaymentData {
  final String paymentMethod;
  final double totalPrice;

  PaymentData({required this.paymentMethod, required this.totalPrice});
}
