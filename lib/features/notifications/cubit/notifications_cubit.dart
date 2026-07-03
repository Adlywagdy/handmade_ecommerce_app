import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/notifications_model.dart';
import '../models/data/mock_notifications.dart';
import '../services/notifications_service.dart';
import 'notifications_state.dart';

/// Cubit managing notifications state across all user roles
/// Persists data to Hive via NotificationsService
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  // ─── Load Notifications ───

  /// Load notifications — from Hive if available, otherwise seed with mock data
  /// Defaults to seller notifications (matches current initialRoute)
  void loadNotifications({String role = 'seller'}) {
    try {
      List<NotificationModel> notifications;

      if (NotificationsService.needsSeeding()) {
        // First launch — load mock data and save to Hive
        switch (role) {
          case 'customer':
            notifications = List.from(mockCustomerNotifications);
            break;
          case 'admin':
            notifications = List.from(mockAdminNotifications);
            break;
          case 'seller':
          default:
            notifications = List.from(mockSellerNotifications);
            break;
        }
        // Save seed data to Hive
        NotificationsService.completeSeed(notifications);
      } else {
        // Load from Hive
        notifications = NotificationsService.fetchNotifications();
      }

      // Sort by createdAt descending (newest first)
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError('Failed to load notifications: $e'));
    }
  }

  // ─── Add Notification ───

  /// Add a new notification (used by NotificationGenerator)
  void addNotification(NotificationModel notification) {
    final current = state;
    if (current is NotificationsLoaded) {
      final updatedNotifications = [notification, ...current.notifications];
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      // Persist to Hive
      NotificationsService.saveAllNotifications(updatedNotifications);

      emit(current.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      ));
    }
  }

  // ─── Mark as Read ───

  /// Mark a single notification as read
  void markAsRead(String notificationId) {
    final current = state;
    if (current is NotificationsLoaded) {
      final updatedNotifications = current.notifications.map((n) {
        if (n.id == notificationId && !n.isRead) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      // Persist to Hive
      NotificationsService.saveAllNotifications(updatedNotifications);

      emit(current.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      ));
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    final current = state;
    if (current is NotificationsLoaded) {
      final updatedNotifications = current.notifications.map((n) {
        return n.isRead ? n : n.copyWith(isRead: true);
      }).toList();

      // Persist to Hive
      NotificationsService.saveAllNotifications(updatedNotifications);

      emit(current.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      ));
    }
  }

  // ─── Filter ───

  /// Set the active filter tab
  void setFilter(NotificationFilter filter) {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(activeFilter: filter));
    }
  }

  // ─── Delete Notifications ───

  /// Delete a single notification
  void deleteNotification(String notificationId) {
    final current = state;
    if (current is NotificationsLoaded) {
      final updatedNotifications =
          current.notifications.where((n) => n.id != notificationId).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      // Persist to Hive
      NotificationsService.saveAllNotifications(updatedNotifications);

      emit(current.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      ));
    }
  }

  /// Clear all notifications
  void clearAll() {
    final current = state;
    if (current is NotificationsLoaded) {
      // Persist to Hive
      NotificationsService.clearAll();

      emit(current.copyWith(
        notifications: [],
        unreadCount: 0,
      ));
    }
  }

  // ─── Getters ───

  /// Get unread count from current state
  int get unreadCount {
    final current = state;
    if (current is NotificationsLoaded) {
      return current.unreadCount;
    }
    return 0;
  }
}
