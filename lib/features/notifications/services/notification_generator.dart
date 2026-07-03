import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notifications_cubit.dart';
import '../models/notifications_model.dart';

/// Generates notifications from app events and adds them to the Cubit
///
/// Usage example:
/// ```dart
/// NotificationGenerator.onOrderCreated(
///   context: context,
///   orderId: '#ORD-2841',
///   customerName: 'Ahmed',
///   productName: 'Leather Handbag',
/// );
/// ```
class NotificationGenerator {
  NotificationGenerator._();

  /// Generate a unique notification ID
  static String _generateId() {
    return 'n-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Add notification to the cubit
  static void _emit(BuildContext context, NotificationModel notification) {
    context.read<NotificationsCubit>().addNotification(notification);
  }

  // ─── Seller Notifications ───

  /// When a new order is placed → notify the seller
  static void onOrderCreated({
    required BuildContext context,
    required String orderId,
    required String customerName,
    required String productName,
  }) {
    _emit(
      context,
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

  /// When a product review is posted → notify the seller
  static void onProductReview({
    required BuildContext context,
    required String productName,
    required int rating,
    required String reviewerName,
  }) {
    final stars = '★' * rating + '☆' * (5 - rating);
    _emit(
      context,
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
  static void onPaymentReceived({
    required BuildContext context,
    required String amount,
    required String orderId,
    required String productName,
  }) {
    _emit(
      context,
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
  static void onLowStock({
    required BuildContext context,
    required String productName,
    required int remaining,
  }) {
    _emit(
      context,
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
  static void onOrderStatusChanged({
    required BuildContext context,
    required String orderId,
    required String newStatus,
  }) {
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

    _emit(
      context,
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
  static void onNewMessage({
    required BuildContext context,
    required String senderName,
    required String messagePreview,
    String? chatId,
    bool isSeller = false,
  }) {
    _emit(
      context,
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

  /// When a new coupon is available → notify customers
  static void onNewCoupon({
    required BuildContext context,
    required String code,
    required String discount,
  }) {
    _emit(
      context,
      NotificationModel(
        id: _generateId(),
        title: 'New Coupon Just for You! 🎟️',
        body: 'Use code $code to get $discount off your next purchase.',
        type: NotificationType.newCoupon,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// When a product price drops → notify interested customers
  static void onPriceDrop({
    required BuildContext context,
    required String productName,
    required String oldPrice,
    required String newPrice,
  }) {
    _emit(
      context,
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
  static void onNewSellerRegistered({
    required BuildContext context,
    required String sellerName,
    String? sellerId,
  }) {
    _emit(
      context,
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
