import '../models/notifications_model.dart';

/// Filter types for the notifications screen
enum NotificationFilter {
  all,
  unread,
  orders,
  messages,
  offers,
}

/// Base state for the notifications feature
abstract class NotificationsState {
  const NotificationsState();
}

/// Initial state before notifications are loaded
class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

/// State when notifications are successfully loaded
class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final NotificationFilter activeFilter;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
    this.activeFilter = NotificationFilter.all,
  });

  /// Get filtered notifications based on active filter
  List<NotificationModel> get filteredNotifications {
    switch (activeFilter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.unread:
        return notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.orders:
        return notifications
            .where((n) =>
                n.type == NotificationType.orderConfirmed ||
                n.type == NotificationType.orderShipped ||
                n.type == NotificationType.orderDelivered ||
                n.type == NotificationType.orderCancelled ||
                n.type == NotificationType.newOrder ||
                n.type == NotificationType.orderStatusUpdate ||
                n.type == NotificationType.paymentReceived)
            .toList();
      case NotificationFilter.messages:
        return notifications
            .where((n) =>
                n.type == NotificationType.newMessage ||
                n.type == NotificationType.newCustomerMessage)
            .toList();
      case NotificationFilter.offers:
        return notifications
            .where((n) =>
                n.type == NotificationType.priceDropAlert ||
                n.type == NotificationType.newCoupon)
            .toList();
    }
  }

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    NotificationFilter? activeFilter,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

/// State when an error occurs
class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}
