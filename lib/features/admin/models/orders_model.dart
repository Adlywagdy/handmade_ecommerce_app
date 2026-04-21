import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, confirmed, preparing, shipped, delivered, cancelled }

class OrderItemModel {
  final String productId;
  final String productName;
  final String? sellerId;
  final double price;
  final int quantity;
  final double subtotal;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    this.sellerId,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'sellerId': sellerId,
        'price': price,
        'quantity': quantity,
        'subtotal': subtotal,
      };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      sellerId: json['sellerId']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ShippingAddressModel {
  final String street;
  final String city;
  final String governorate;
  final String country;
  final String zipCode;

  const ShippingAddressModel({
    required this.street,
    required this.city,
    required this.governorate,
    required this.country,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'governorate': governorate,
        'country': country,
        'zipCode': zipCode,
      };

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      zipCode: json['zipCode']?.toString() ?? '',
    );
  }

  static const empty = ShippingAddressModel(
    street: '',
    city: '',
    governorate: '',
    country: '',
    zipCode: '',
  );
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerId;
  final String sellerId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double totalPrice;
  final double commissionRate;
  final double commission;
  final double sellerEarning;
  final String currency;
  final OrderStatus status;
  final String paymentMethod;
  final String paymentStatus;
  final ShippingAddressModel shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Legacy display fields (optional, populated from denormalized reads).
  final String? customerName;
  final String? sellerName;

  const OrderModel({
    this.id = '',
    this.orderNumber = '',
    this.customerId = '',
    this.sellerId = '',
    this.items = const [],
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.totalPrice = 0.0,
    this.commissionRate = 0.10,
    this.commission = 0.0,
    this.sellerEarning = 0.0,
    this.currency = 'EGP',
    this.status = OrderStatus.pending,
    this.paymentMethod = 'cash_on_delivery',
    this.paymentStatus = 'pending',
    this.shippingAddress = ShippingAddressModel.empty,
    this.createdAt,
    this.updatedAt,
    this.customerName,
    this.sellerName,
  });

  String get displayId => orderNumber.isNotEmpty ? orderNumber : id;
  double get price => totalPrice;
  String get date => createdAt != null
      ? '${_monthShort(createdAt!.month)} ${createdAt!.day}, ${createdAt!.year}'
      : '';

  Map<String, dynamic> toJson() => {
        'orderNumber': orderNumber,
        'customerId': customerId,
        'sellerId': sellerId,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'totalPrice': totalPrice,
        'commissionRate': commissionRate,
        'commission': commission,
        'sellerEarning': sellerEarning,
        'currency': currency,
        'status': status.name,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'shippingAddress': shippingAddress.toJson(),
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
        if (customerName != null) 'customerName': customerName,
        if (sellerName != null) 'sellerName': sellerName,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: id ?? json['id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(OrderItemModel.fromJson)
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.10,
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      sellerEarning: (json['sellerEarning'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'EGP',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: json['paymentMethod']?.toString() ?? 'cash_on_delivery',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      shippingAddress: json['shippingAddress'] is Map<String, dynamic>
          ? ShippingAddressModel.fromJson(json['shippingAddress'])
          : ShippingAddressModel.empty,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      customerName: json['customerName']?.toString(),
      sellerName: json['sellerName']?.toString(),
    );
  }

  static String _monthShort(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][m];
}
