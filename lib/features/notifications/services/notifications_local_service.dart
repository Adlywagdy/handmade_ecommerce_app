import 'package:hive_flutter/hive_flutter.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import '../models/notifications_model.dart';

/// Local data source for notifications using Hive
/// Handles all persistence operations
class NotificationsLocalService {
  NotificationsLocalService._();

  static const String _boxName = HiveHelperService.notificationsBox;

  /// Get the notifications box
  static Box<dynamic> get _box => Hive.box(_boxName);

  /// Load all notifications from Hive
  static List<NotificationModel> loadNotifications() {
    try {
      final raw = _box.get('notifications_list');
      if (raw == null) return [];

      final List<dynamic> jsonList = List.from(raw);
      return jsonList
          .map((item) =>
              NotificationModel.fromJson(Map<dynamic, dynamic>.from(item)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save all notifications to Hive
  static Future<void> saveNotifications(
      List<NotificationModel> notifications) async {
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await _box.put('notifications_list', jsonList);
  }

  /// Add a single notification and save
  static Future<void> addNotification(NotificationModel notification,
      List<NotificationModel> currentList) async {
    final updatedList = [notification, ...currentList];
    await saveNotifications(updatedList);
  }

  /// Check if notifications have been seeded (first app launch)
  static bool isSeeded() {
    return _box.get('is_seeded', defaultValue: false) as bool;
  }

  /// Mark as seeded after first-time mock data load
  static Future<void> markAsSeeded() async {
    await _box.put('is_seeded', true);
  }

  /// Clear all data from the box
  static Future<void> clearAll() async {
    await _box.put('notifications_list', []);
  }
}
