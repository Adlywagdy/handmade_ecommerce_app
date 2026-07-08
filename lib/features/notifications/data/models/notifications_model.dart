/// Enum representing all notification types across the app
enum NotificationType {
  // ─── Customer Notifications ───
  orderConfirmed,
  orderShipped,
  orderDelivered,
  orderCancelled,
  priceDropAlert,
  newCoupon,
  newMessage,

  // ─── Seller Notifications ───
  newOrder,
  orderStatusUpdate,
  productReview,
  lowStock,
  paymentReceived,
  newCustomerMessage,

  // ─── Admin Notifications ───
  newSellerRegistration,
  reportedProduct,
  systemAlert,
}

/// Model representing a single notification
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? targetId;
  final String? imageUrl;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.targetId,
    this.imageUrl,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? targetId,
    String? imageUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      targetId: targetId ?? this.targetId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Convert to JSON-compatible Map for Hive storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isRead': isRead,
      'targetId': targetId,
      'imageUrl': imageUrl,
    };
  }

  /// Create from JSON-compatible Map (from Hive storage)
  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values[json['type'] as int],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      isRead: json['isRead'] as bool? ?? false,
      targetId: json['targetId'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
