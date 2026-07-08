import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/notifications_model.dart';
import '../data/services/notifications_service.dart';
import '../data/services/fcm_service.dart';
import 'notifications_state.dart';

/// Cubit managing notifications state across all user roles
/// Reactively driven by Firestore Stream with local Hive caching
class NotificationsCubit extends Cubit<NotificationsState> {
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;
  final Set<String> _shownNotificationIds = {};

  NotificationsCubit() : super(const NotificationsInitial());

  // ─── Load Notifications ───

  /// Load notifications — from Hive cache instantly, then subscribe to Firestore
  void loadNotifications({String role = 'seller'}) async {
    try {
      // 1. Immediately emit local cached notifications for zero-latency startup
      final localNotifications = NotificationsService.fetchLocalNotifications();
      localNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final localUnreadCount = localNotifications
          .where((n) => !n.isRead)
          .length;

      emit(
        NotificationsLoaded(
          notifications: localNotifications,
          unreadCount: localUnreadCount,
        ),
      );

      // 2. Subscribe to Firestore real-time stream if user is logged in
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await _notificationsSubscription?.cancel();
        // Listen to Firestore updates
        _notificationsSubscription =
            NotificationsService.getNotificationsStream(currentUser.uid).listen(
              (notifications) {
                notifications.sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt),
                );
                final unreadCount = notifications
                    .where((n) => !n.isRead)
                    .length;

                // Show local popup banner for new recent unread notifications
                final now = DateTime.now();
                for (final n in notifications) {
                  final isRecent = now.difference(n.createdAt).inSeconds < 15;
                  if (!n.isRead &&
                      isRecent &&
                      !_shownNotificationIds.contains(n.id)) {
                    _shownNotificationIds.add(n.id);
                    FCMService.showTestNotification(
                      title: n.title,
                      body: n.body,
                      type: n.type.name,
                      targetId: n.targetId ?? '',
                    );
                  }
                }

                emit(
                  NotificationsLoaded(
                    notifications: notifications,
                    unreadCount: unreadCount,
                  ),
                );
              },
              onError: (e) {
                emit(NotificationsError('Failed to sync notifications: $e'));
              },
            );
      }
    } catch (e) {
      emit(NotificationsError('Failed to load notifications: $e'));
    }
  }

  // ─── Add Notification ───

  /// Add a new notification siphoned to Firestore
  void addNotification(NotificationModel notification) {
    NotificationsService.saveNotification(notification);
  }

  // ─── Mark as Read ───

  /// Mark a single notification as read in Firestore
  void markAsRead(String notificationId) {
    NotificationsService.markAsRead(notificationId);
  }

  /// Mark all notifications as read in Firestore
  void markAllAsRead() {
    final current = state;
    if (current is NotificationsLoaded) {
      NotificationsService.markAllAsRead(current.notifications);
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

  /// Delete a single notification from Firestore
  void deleteNotification(String notificationId) {
    NotificationsService.deleteNotification(notificationId);
  }

  /// Clear all notifications in Firestore
  void clearAll() {
    final current = state;
    if (current is NotificationsLoaded) {
      NotificationsService.clearAll(current.notifications);
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
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
