import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';

/// Handles all order-related Firebase operations for the current user.
class CustomerOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const double _commissionRate = 0.1;

  /// Returns current user ID, or null if not authenticated.
  String? get _userId => _auth.currentUser?.uid;

  /// Sorts orders by date (newest first).
  List<CustomerOrderModel> _sortOrders(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final orders = docs.map(_orderFromSnapshot).toList();
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return orders;
  }

  /// Builds a Firestore query with optional filters (status, orderNumber, limit).
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
      query = query.where('status', isEqualTo: status.name);
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

  /// Fetches all orders for the current user.
  Future<List<CustomerOrderModel>> getAllOrders() async {
    if (_userId == null) return [];
    final docs = await _getOrdersSnapshot(_userId!);
    return _sortOrders(docs.docs);
  }

  /// Fetches orders filtered by status (e.g. pending, delivered).
  Future<List<CustomerOrderModel>> getFilteredOrders(OrderStatus status) async {
    if (_userId == null) return [];
    final docs = await _getOrdersSnapshot(_userId!, status: status);
    return _sortOrders(docs.docs);
  }

  /// Finds a single order by any field (e.g. orderNumber, orderid).
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

  /// Extracts a numeric value from a string (e.g. "#AY-10042" → 10042).
  int? _extractNumeric(dynamic raw) {
    final s = raw?.toString() ?? '';
    final direct = int.tryParse(s);
    if (direct != null) return direct;
    final m = RegExp(r"(\d+)").firstMatch(s);
    return m != null ? int.tryParse(m.group(1)!) : null;
  }

  /// Fetches order details by document ID, orderNumber, or orderid.
  Future<CustomerOrderModel?> getOrderDetails(String orderId) async {
    if (_userId == null) return null;

    // Try direct document ID lookup first.
    final rootDoc = await _firestore.collection('orders').doc(orderId).get();
    if (rootDoc.exists && rootDoc.data()?['customerId'] == _userId) {
      return _orderFromSnapshot(rootDoc);
    }

    // Try numeric orderNumber lookup.
    final parsedNum = _extractNumeric(orderId);
    if (parsedNum != null) {
      final found = await _findOrder(_userId!, 'orderNumber', parsedNum);
      if (found != null) return found;
    }

    // Try orderid field lookup.
    return await _findOrder(_userId!, 'orderid', orderId) ??
        await _findOrder(_userId!, 'orderNumber', orderId);
  }

  /// Places a new order: saves it to Firestore and decrements product stock.
  /// Returns the new document ID.
  Future<String> placeOrder(CustomerOrderModel order) async {
    if (_userId == null) throw Exception('User not authenticated');

    final orderRef = _firestore.collection('orders').doc();
    final subtotal = parseDouble(order.payment.subtotalPrice) ?? 0;
    final deliveryFee = parseDouble(order.payment.deliveryFee) ?? 0;
    final totalPrice = parseDouble(order.payment.totalPrice) ?? 0;
    final commission = subtotal * _commissionRate;

    final payload = {
      ...order.toMap(),
      'customerId': _userId,
      'commissionRate': _commissionRate,
      'commission': commission,
      'sellerEarning': subtotal - commission,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalPrice': totalPrice > 0 ? totalPrice : subtotal + deliveryFee,
      'status': order.status.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Use a batch to atomically create order + update stock.
    final batch = _firestore.batch();
    batch.set(orderRef, payload);

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
    return orderRef.id;
  }

  /// Cancels an order by setting its status to 'cancelled'.
  Future<void> cancelOrder(String orderId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final cancelPayload = {
      'status': OrderStatus.cancelled.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Try direct document ID.
    final rootRef = _firestore.collection('orders').doc(orderId);
    final rootDoc = await rootRef.get();
    if (rootDoc.exists && rootDoc.data()?['customerId'] == _userId) {
      await rootRef.update(cancelPayload);
    }

    // Try numeric orderNumber.
    final parsedNum = _extractNumeric(orderId);
    if (parsedNum != null) {
      final snap = await _findDoc(_userId!, 'orderNumber', parsedNum);
      if (snap != null) await snap.reference.update(cancelPayload);
    }

    // Try orderid field.
    final byId = await _findDoc(_userId!, 'orderid', orderId);
    if (byId != null) await byId.reference.update(cancelPayload);

    // Try orderNumber as string.
    final byNum = await _findDoc(_userId!, 'orderNumber', orderId);
    if (byNum != null) await byNum.reference.update(cancelPayload);
  }

  /// Finds a raw document snapshot by any field.
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

  /// Converts a Firestore document into a CustomerOrderModel,
  /// normalizing timestamps and field names.
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

  /// Generates the next sequential order ID from a Firestore counter.
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
