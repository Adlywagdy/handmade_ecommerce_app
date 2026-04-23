import '../models/notifications_model.dart';
import 'notifications_local_service.dart';

/// Repository / Service layer for notification operations
/// Reads from Hive (local) now — ready for API integration later
///
/// When backend is ready, replace the local calls with API calls:
/// Example: ApiHelperService.get(url: '/notifications/$userId')
class NotificationsService {
  NotificationsService._();

  /// Fetch all notifications
  /// Currently: reads from Hive
  /// Future: will call API first, then cache in Hive
  static List<NotificationModel> fetchNotifications() {
    return NotificationsLocalService.loadNotifications();
  }

  /// Save a single notification
  static Future<void> saveNotification(
      NotificationModel notification, List<NotificationModel> current) async {
    await NotificationsLocalService.addNotification(notification, current);
  }

  /// Save the full notifications list
  static Future<void> saveAllNotifications(
      List<NotificationModel> notifications) async {
    await NotificationsLocalService.saveNotifications(notifications);
  }

  /// Mark a notification as read
  static Future<void> markAsRead(
      String notificationId, List<NotificationModel> current) async {
    final updated = current.map((n) {
      if (n.id == notificationId && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    await NotificationsLocalService.saveNotifications(updated);
  }

  /// Mark all notifications as read
  static Future<void> markAllAsRead(List<NotificationModel> current) async {
    final updated = current.map((n) {
      return n.isRead ? n : n.copyWith(isRead: true);
    }).toList();
    await NotificationsLocalService.saveNotifications(updated);
  }

  /// Delete a single notification
  static Future<void> deleteNotification(
      String notificationId, List<NotificationModel> current) async {
    final updated = current.where((n) => n.id != notificationId).toList();
    await NotificationsLocalService.saveNotifications(updated);
  }

  /// Clear all notifications
  static Future<void> clearAll() async {
    await NotificationsLocalService.clearAll();
  }

  /// Check if this is the first launch (needs mock data seeding)
  static bool needsSeeding() {
    return !NotificationsLocalService.isSeeded();
  }

  /// Mark seeding as complete
  static Future<void> completeSeed(
      List<NotificationModel> seedData) async {
    await NotificationsLocalService.saveNotifications(seedData);
    await NotificationsLocalService.markAsSeeded();
  }
}
