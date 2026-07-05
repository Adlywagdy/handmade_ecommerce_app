import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notifications_model.dart';
import 'notifications_local_service.dart';

/// Repository / Service layer for notification operations
/// Synchronizes Firestore (sundry cloud data) with Hive (local cache)
class NotificationsService {
  NotificationsService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current authenticated user's ID
  static String? get _currentUserId => _auth.currentUser?.uid;

  /// Get reference to the user's notifications collection
  static CollectionReference<Map<String, dynamic>> _userNotificationsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('notifications');
  }

  /// Get real-time stream of notifications from Firestore
  /// Automatically caches the received notifications to Hive local storage
  static Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _userNotificationsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final List<NotificationModel> notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure id is set
        if (data['id'] == null) {
          data['id'] = doc.id;
        }
        return NotificationModel.fromJson(data);
      }).toList();

      // Caching to Hive locally in the background
      NotificationsLocalService.saveNotifications(notifications);

      return notifications;
    });
  }

  /// Fetch all notifications from local cache (Hive) - useful for instant load/offline fallback
  static List<NotificationModel> fetchLocalNotifications() {
    return NotificationsLocalService.loadNotifications();
  }

  /// Save a single notification to Firestore (which will sync to Hive via Stream)
  static Future<void> saveNotification(NotificationModel notification) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _userNotificationsRef(userId)
        .doc(notification.id)
        .set(notification.toJson(), SetOptions(merge: true));
  }

  /// Save multiple notifications to Firestore
  static Future<void> saveAllNotifications(List<NotificationModel> notifications) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final batch = _firestore.batch();
    for (final notification in notifications) {
      final ref = _userNotificationsRef(userId).doc(notification.id);
      batch.set(ref, notification.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// Mark a notification as read
  static Future<void> markAsRead(String notificationId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _userNotificationsRef(userId).doc(notificationId).update({'isRead': true});
  }

  /// Mark all notifications as read
  static Future<void> markAllAsRead(List<NotificationModel> current) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final batch = _firestore.batch();
    for (final notification in current) {
      if (!notification.isRead) {
        final ref = _userNotificationsRef(userId).doc(notification.id);
        batch.update(ref, {'isRead': true});
      }
    }
    await batch.commit();
  }

  /// Delete a single notification
  static Future<void> deleteNotification(String notificationId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _userNotificationsRef(userId).doc(notificationId).delete();
  }

  /// Clear all notifications
  static Future<void> clearAll(List<NotificationModel> current) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final batch = _firestore.batch();
    for (final notification in current) {
      final ref = _userNotificationsRef(userId).doc(notification.id);
      batch.delete(ref);
    }
    await batch.commit();
    await NotificationsLocalService.clearAll();
  }
}
