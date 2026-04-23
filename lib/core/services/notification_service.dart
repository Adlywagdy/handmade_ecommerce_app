import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/notifications/models/notifications_model.dart';

/// Core notification service — handles notification tap navigation
/// and is prepared for future FCM integration
class NotificationService {
  NotificationService._();

  /// Initialize notification service
  /// TODO: Add FCM initialization when backend is ready
  /// - Request notification permission
  /// - Get FCM token
  /// - Save token to backend
  /// - Setup foreground/background handlers
  static Future<void> init() async {
    // Placeholder for future FCM setup:
    // await FirebaseMessaging.instance.requestPermission();
    // final token = await FirebaseMessaging.instance.getToken();
    // await _saveTokenToBackend(token);
    // FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  /// Navigate to appropriate screen based on notification type
  /// Each type routes to a specific screen — fallback to /notifications
  static void handleNotificationTap(NotificationModel notification) {
    switch (notification.type) {
      // ─── Order (Customer) → Order Details ───
      case NotificationType.orderConfirmed:
      case NotificationType.orderShipped:
      case NotificationType.orderDelivered:
      case NotificationType.orderCancelled:
      case NotificationType.orderStatusUpdate:
        _navigateTo(AppRoutes.customerOrderDetails);
        break;

      // ─── Order (Seller) → Seller Orders ───
      case NotificationType.newOrder:
        _navigateTo(AppRoutes.sellerorders);
        break;

      // ─── Payment → Seller Dashboard ───
      case NotificationType.paymentReceived:
        _navigateTo(AppRoutes.sellerdashboard);
        break;

      // ─── Product (Customer) → Product Details ───
      case NotificationType.priceDropAlert:
      case NotificationType.productReview:
        _navigateTo(AppRoutes.customerProductDetails);
        break;

      // ─── Low Stock → Seller Manage Products ───
      case NotificationType.lowStock:
        _navigateTo(AppRoutes.sellermanageproducts);
        break;

      // ─── Messages → Notifications (Chat not built yet) ───
      case NotificationType.newMessage:
      case NotificationType.newCustomerMessage:
        // TODO: Navigate to chat screen when implemented
        // _navigateTo(AppRoutes.chat);
        _navigateTo(AppRoutes.notifications);
        break;

      // ─── Coupon / Offers → Customer Layout ───
      case NotificationType.newCoupon:
        _navigateTo(AppRoutes.customerlayout);
        break;

      // ─── Admin: New Seller → Admin Sellers ───
      case NotificationType.newSellerRegistration:
        _navigateTo(AppRoutes.adminSellers);
        break;

      // ─── Admin: Reported Product → Admin Dashboard ───
      case NotificationType.reportedProduct:
        _navigateTo(AppRoutes.adminDashboard);
        break;

      // ─── System Alert → Notifications (fallback) ───
      case NotificationType.systemAlert:
        _navigateTo(AppRoutes.notifications);
        break;
    }
  }

  /// Safe navigation helper — checks if route exists before navigating
  static void _navigateTo(String route) {
    try {
      Get.toNamed(route);
    } catch (_) {
      // Fallback to notifications screen if route fails
      Get.toNamed(AppRoutes.notifications);
    }
  }
}
