import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/notifications_model.dart';

/// Generates notifications from app events and writes them directly to the recipient's Firestore collection.
/// From there, the recipient's app (via NotificationsCubit stream) will receive them reactively.
///
/// Usage example:
/// ```dart
/// NotificationGenerator.onOrderCreated(
///   sellerId: 'seller_123',
///   orderId: '#ORD-2841',
///   customerName: 'Ahmed',
///   productName: 'Leather Handbag',
/// );
/// ```
class NotificationGenerator {
  NotificationGenerator._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a unique notification ID
  static String _generateId() {
    return 'n-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Get user UID from users collection matching the email
  static Future<String?> _getUserIdByEmail(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        return query.docs.first.id;
      }
    } catch (e) {
      debugPrint('Error getting UID by email: $e');
    }
    return null;
  }

  /// Resolve email to UID if needed
  static Future<String?> _resolveUserId(String idOrEmail) async {
    if (idOrEmail.contains('@')) {
      return await _getUserIdByEmail(idOrEmail);
    }
    return idOrEmail;
  }

  /// Write notification to Firestore under the recipient's collection
  static Future<void> _sendToUser(String idOrEmail, NotificationModel notification) async {
    try {
      final userId = await _resolveUserId(idOrEmail);
      if (userId == null) {
        debugPrint('❌ Could not resolve user ID for: $idOrEmail');
        return;
      }
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toJson());
      debugPrint('🔔 Notification successfully written to Firestore for user: $userId');
    } catch (e) {
      debugPrint('❌ Failed to write notification to Firestore: $e');
    }
  }

  // ─── Seller Notifications ───

  /// When a new order is placed → notify the seller
  static Future<void> onOrderCreated({
    required String sellerId,
    required String orderId,
    required String customerName,
    required String productName,
  }) async {
    await _sendToUser(
      sellerId,
      NotificationModel(
        id: _generateId(),
        title: 'New Order Received! 🛒',
        body: 'Order $orderId from $customerName — "$productName"',
        type: NotificationType.newOrder,
        createdAt: DateTime.now(),
        targetId: orderId,
      ),
    );
  }

  /// When an order is cancelled by the customer → notify the seller
  static Future<void> onOrderCancelledByCustomer({
    required String sellerId,
    required String orderId,
    required String customerName,
    required String productName,
  }) async {
    await _sendToUser(
      sellerId,
      NotificationModel(
        id: _generateId(),
        title: 'Order Cancelled ❌',
        body: 'Order $orderId containing "$productName" was cancelled by $customerName.',
        type: NotificationType.orderStatusUpdate, // Seller will get an order status update notification
        createdAt: DateTime.now(),
        targetId: orderId,
      ),
    );
  }

  /// When a product review is posted → notify the seller
  static Future<void> onProductReview({
    required String sellerId,
    required String productName,
    required int rating,
    required String reviewerName,
  }) async {
    final stars = '★' * rating + '☆' * (5 - rating);
    await _sendToUser(
      sellerId,
      NotificationModel(
        id: _generateId(),
        title: 'New Review on $productName ⭐',
        body: '"Great product!" — $stars by $reviewerName',
        type: NotificationType.productReview,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// When a payment is received → notify the seller
  static Future<void> onPaymentReceived({
    required String sellerId,
    required String amount,
    required String orderId,
    required String productName,
  }) async {
    await _sendToUser(
      sellerId,
      NotificationModel(
        id: _generateId(),
        title: 'Payment Received 💵',
        body: 'EGP $amount received for Order $orderId — "$productName"',
        type: NotificationType.paymentReceived,
        createdAt: DateTime.now(),
        targetId: orderId,
      ),
    );
  }

  /// When stock is low → notify the seller
  static Future<void> onLowStock({
    required String sellerId,
    required String productName,
    required int remaining,
  }) async {
    await _sendToUser(
      sellerId,
      NotificationModel(
        id: _generateId(),
        title: 'Low Stock Alert ⚠️',
        body: '"$productName" has only $remaining units left. Consider restocking.',
        type: NotificationType.lowStock,
        createdAt: DateTime.now(),
      ),
    );
  }

  // ─── Customer Notifications ───

  /// When an order status changes → notify the customer
  static Future<void> onOrderStatusChanged({
    required String customerId,
    required String orderId,
    required String newStatus,
  }) async {
    final NotificationType type;
    final String title;
    final String body;

    switch (newStatus.toLowerCase()) {
      case 'confirmed':
        type = NotificationType.orderConfirmed;
        title = 'Order Confirmed! 🎉';
        body = 'Your order $orderId has been confirmed and is being prepared.';
        break;
      case 'shipped':
        type = NotificationType.orderShipped;
        title = 'Your Order is on the Way! 📦';
        body = 'Order $orderId has been shipped. Expected delivery in 3-5 days.';
        break;
      case 'delivered':
        type = NotificationType.orderDelivered;
        title = 'Order Delivered ✅';
        body = 'Your order $orderId has been delivered successfully. Enjoy!';
        break;
      case 'cancelled':
        type = NotificationType.orderCancelled;
        title = 'Order Cancelled ❌';
        body =
            'Your order $orderId has been cancelled. Refund will be processed in 3-5 days.';
        break;
      default:
        type = NotificationType.orderStatusUpdate;
        title = 'Order Status Updated 📋';
        body = 'Order $orderId status changed to "$newStatus".';
    }

    await _sendToUser(
      customerId,
      NotificationModel(
        id: _generateId(),
        title: title,
        body: body,
        type: type,
        createdAt: DateTime.now(),
        targetId: orderId,
      ),
    );
  }

  /// When a new message is received → notify the other party
  static Future<void> onNewMessage({
    required String recipientId,
    required String senderName,
    required String messagePreview,
    String? chatId,
    bool isSeller = false,
  }) async {
    await _sendToUser(
      recipientId,
      NotificationModel(
        id: _generateId(),
        title: isSeller
            ? 'New Message from Customer 💬'
            : 'New Message from $senderName 💬',
        body: '$senderName: "$messagePreview"',
        type: isSeller
            ? NotificationType.newCustomerMessage
            : NotificationType.newMessage,
        createdAt: DateTime.now(),
        targetId: chatId,
      ),
    );
  }

  /// When a new coupon is available → notify customer
  static Future<void> onNewCoupon({
    required String customerId,
    required String code,
    required String discount,
  }) async {
    await _sendToUser(
      customerId,
      NotificationModel(
        id: _generateId(),
        title: 'New Coupon Just for You! 🎟️',
        body: 'Use code $code to get $discount off your next purchase.',
        type: NotificationType.newCoupon,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Request customer to review a product
  static Future<void> onReviewRequest({
    required String customerId,
    required String productName,
    required String productId,
  }) async {
    await _sendToUser(
      customerId,
      NotificationModel(
        id: _generateId(),
        title: 'Review your purchase ⭐',
        body: 'How was your experience with "$productName"? Tap to leave a review.',
        type: NotificationType.productReview,
        createdAt: DateTime.now(),
        targetId: productId,
      ),
    );
  }

  /// When a product price drops → notify interested customer
  static Future<void> onPriceDrop({
    required String customerId,
    required String productName,
    required String oldPrice,
    required String newPrice,
  }) async {
    await _sendToUser(
      customerId,
      NotificationModel(
        id: _generateId(),
        title: 'Price Drop Alert! 💰',
        body: '"$productName" dropped from EGP $oldPrice to EGP $newPrice!',
        type: NotificationType.priceDropAlert,
        createdAt: DateTime.now(),
      ),
    );
  }

  // ─── Admin Notifications ───

  /// When a new seller registers → notify admin
  static Future<void> onNewSellerRegistered({
    required String adminId,
    required String sellerName,
    String? sellerId,
  }) async {
    await _sendToUser(
      adminId,
      NotificationModel(
        id: _generateId(),
        title: 'New Seller Registration 👤',
        body: '$sellerName has submitted a seller registration request. Review required.',
        type: NotificationType.newSellerRegistration,
        createdAt: DateTime.now(),
        targetId: sellerId,
      ),
    );
  }
}
