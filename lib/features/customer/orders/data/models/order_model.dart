import 'package:flutter/widgets.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/home/data/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/data/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

class CustomerOrderModel {
  final CustomerModel customer;
  final String orderid;
  final List<ProductModel> products;
  final OrderStatus status;
  final DateTime orderDate;
  final PaymentDetailsModel payment;
  final AddressModel address;
  final String phone;
  CustomerOrderModel({
    required this.customer,
    required this.products,
    required this.status,
    required this.orderid,
    required this.orderDate,
    required this.payment,
    required this.address,
    required this.phone,
  });

  double get totalAmount => payment.totalPrice ?? 0;
  double get subtotalAmount => payment.subtotalPrice ?? totalAmount;
  double get deliveryFeeAmount => payment.deliveryFee ?? 0;
  double get commissionRate => 0.1;
  double get commissionAmount => subtotalAmount * commissionRate;
  double get sellerEarningAmount => subtotalAmount - commissionAmount;
  String get deliveryAddress => address.addressdescription;
  List<ProductModel> get items => products;

  String get paymentStatus {
    if (payment.paymentMethod?.toLowerCase() == 'cash_on_delivery')
      return 'pending';
    return 'paid';
  }

  static Map<String, dynamic> _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return <String, dynamic>{};
  }

  static List<ProductModel> _parseProducts(dynamic data) {
    if (data is! List) return [];
    return data
        .map((item) => _asStringKeyedMap(item))
        .where((item) => item.isNotEmpty)
        .map(ProductModel.fromMap)
        .toList();
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }

  static Map<String, dynamic> _buildCustomerMap(
    Map<String, dynamic> map,
    Map<String, dynamic> customerMap,
  ) {
    if (customerMap.isNotEmpty) return customerMap;
    return {
      'fullName': map['customerName'] ?? map['fullName'] ?? map['name'] ?? '',
      'name': map['customerName'] ?? map['name'] ?? '',
      'email': map['customerEmail'] ?? map['email'] ?? '',
      'phone': map['customerPhone'] ?? map['phone'] ?? '',
      'uid': map['customerId'] ?? map['uid'] ?? map['id'] ?? '',
    };
  }

  static Map<String, dynamic> _buildPaymentMap(
    Map<String, dynamic> map,
    Map<String, dynamic> paymentMap,
  ) {
    return {
      ...map,
      ...paymentMap,
      'subtotalPrice':
          paymentMap['subtotalPrice'] ??
          map['subtotalPrice'] ??
          map['subtotal'],
    };
  }

  factory CustomerOrderModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final products = _parseProducts(map['products'] ?? map['items']);
    final orderStatus = OrderStatus.values.firstWhere(
      (v) => v.name == (map['status'] ?? 'pending').toString(),
      orElse: () => OrderStatus.pending,
    );
    final addressMap = _asStringKeyedMap(
      map['address'] ?? map['shippingAddress'],
    );
    final paymentMap = _asStringKeyedMap(map['payment']);
    final customerMap = _asStringKeyedMap(map['customer']);

    return CustomerOrderModel(
      customer: CustomerModel.fromMap(_buildCustomerMap(map, customerMap)),
      products: products,
      status: orderStatus,
      orderid:
          (map['orderId'] ?? map['orderid'] ?? map['orderNumber'] ?? id ?? '')
              .toString(),
      orderDate: _parseDate(map['orderDate'] ?? map['createdAt']),
      payment: PaymentDetailsModel.fromMap(_buildPaymentMap(map, paymentMap)),
      address: addressMap.isNotEmpty
          ? AddressModel.fromMap(addressMap)
          : AddressModel(
              addressdescription: (map['deliveryAddress'] ?? '').toString(),
              zipCode: 0,
            ),
      phone: (map['phone'] ?? map['customerPhone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final numMatch = RegExp(r"(\d+)").firstMatch(orderid);
    final orderNum = numMatch != null ? int.tryParse(numMatch.group(1)!) : null;
    final items = products
        .map(
          (p) => {
            'productId': p.id,
            'productName': p.name,
            'price': p.price,
            'quantity': p.quantity,
            'sellerId': p.sellerId,
            'images': p.images,
            'productImage': p.image,
            'subtotal': p.price * p.quantity,
          },
        )
        .toList();

    return {
      'orderid': orderid,
      'orderNumber': orderNum,
      'items': items,
      'shippingAddress': {
        'street': address.street,
        'city': address.city,
        'zipCode': address.zipCode,
        'country': address.country,
      },
      'phone': phone,
      'customerId': customer.id,
      'status': status.name,
      'subtotal': subtotalAmount,
      'deliveryFee': deliveryFeeAmount,
      'commissionRate': commissionRate,
      'commission': commissionAmount,
      'sellerEarning': sellerEarningAmount,
      'totalPrice': payment.totalPrice ?? totalAmount,
      'currency': payment.currency ?? 'EGP',
      'paymentMethod': payment.paymentMethod,
      'paymentStatus': paymentStatus,
      'orderDate': orderDate.toIso8601String(),
      'createdAt': orderDate.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusLocalization on OrderStatus {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case OrderStatus.pending:
        return l10n.pending;
      case OrderStatus.confirmed:
        return l10n.confirmed;
      case OrderStatus.preparing:
        return l10n.preparing;
      case OrderStatus.shipped:
        return l10n.shipped;
      case OrderStatus.delivered:
        return l10n.delivered;
      case OrderStatus.cancelled:
        return l10n.cancelled;
    }
  }
}
