import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

class CustomerOrderModel {
  final CustomerModel customer;
  final String orderid;
  final List<ProductModel> products;
  final OrderStatus status;
  final DateTime orderDate;
  final PaymentDetailsModel payment;
  final AddressModel address;
  CustomerOrderModel({
    required this.customer,
    required this.products,
    required this.status,
    required this.orderid,
    required this.orderDate,
    required this.payment,
    required this.address,
  });

  double get totalAmount => payment.totalPrice ?? 0;
  String get deliveryAddress => address.addressdescription;
  List<ProductModel> get items => products;

  double get subtotalAmount => payment.subtotalPrice ?? totalAmount;

  double get deliveryFeeAmount => payment.deliveryFee ?? 0;

  double get commissionRate => 0.1;

  double get commissionAmount => subtotalAmount * commissionRate;

  double get sellerEarningAmount => subtotalAmount - commissionAmount;

  String get paymentStatus {
    final method = payment.paymentMethod?.toLowerCase();
    if (method == 'cash_on_delivery') {
      return 'pending';
    }
    return 'paid';
  }

  static Map<String, dynamic> _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return <String, dynamic>{};
  }

  factory CustomerOrderModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final productsData = map['products'] ?? map['items'];
    final products = productsData is List
        ? productsData
              .map((item) => _asStringKeyedMap(item))
              .where((item) => item.isNotEmpty)
              .map(ProductModel.fromMap)
              .toList()
        : <ProductModel>[];

    final statusString = (map['status'] ?? 'pending').toString();
    final orderStatus = OrderStatus.values.firstWhere(
      (value) => value.name == statusString,
      orElse: () => OrderStatus.pending,
    );

    final createdAt = map['orderDate'] ?? map['createdAt'];
    DateTime orderDate;
    if (createdAt is DateTime) {
      orderDate = createdAt;
    } else {
      orderDate =
          DateTime.tryParse(createdAt?.toString() ?? '') ?? DateTime.now();
    }

    final addressMap = _asStringKeyedMap(
      map['address'] ?? map['shippingAddress'],
    );
    final paymentMap = _asStringKeyedMap(map['payment']);
    final customerMap = _asStringKeyedMap(map['customer']);

    return CustomerOrderModel(
      customer: CustomerModel.fromMap(
        customerMap.isNotEmpty
            ? customerMap
            : {
                'fullName':
                    map['customerName'] ?? map['fullName'] ?? map['name'] ?? '',
                'name': map['customerName'] ?? map['name'] ?? '',
                'email': map['customerEmail'] ?? map['email'] ?? '',
                'phone': map['customerPhone'] ?? map['phone'] ?? '',
                'uid': map['customerId'] ?? map['uid'] ?? map['id'] ?? '',
              },
      ),
      products: products,
      status: orderStatus,
      orderid:
          (map['orderId'] ?? map['orderid'] ?? map['orderNumber'] ?? id ?? '')
              .toString(),
      orderDate: orderDate,
      payment: PaymentDetailsModel.fromMap({
        ...map,
        ...paymentMap,
        'subtotalPrice':
            paymentMap['subtotalPrice'] ??
            map['subtotalPrice'] ??
            map['subtotal'],
      }),
      address: addressMap.isNotEmpty
          ? AddressModel.fromMap(addressMap)
          : AddressModel(
              addressdescription: (map['deliveryAddress'] ?? '').toString(),
              zipCode: 0,
              city: null,
              country: null,
            ),
    );
  }

  Map<String, dynamic> toMap() {
    // try to extract numeric part from prefixed id (e.g. '#AY-10004')
    final match = RegExp(r"(\d+)").firstMatch(orderid);
    final numeric = match != null ? int.tryParse(match.group(1)!) : null;

    return {
      'orderid': orderid,
      // store numeric `orderNumber` when available to enable numeric ordering
      'orderNumber': numeric,
      'items': products
          .map(
            (product) => {
              'productId': product.id,
              'productName': product.name,
              'price': product.price,
              'quantity': product.quantity,
              'sellerId': product.sellerId,
              'subtotal': product.price * product.quantity,
            },
          )
          .toList(),
      'shippingAddress': {
        'street': address.street,
        'city': address.city,
        'governorate': address.city,
        'country': address.country,
        'zipCode': address.zipCode,
      },
      'customer': customer.toMap(),
      'customerId': customer.id,
      'customerName': customer.name,
      'customerEmail': customer.email,
      'customerPhone': customer.phone,
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
