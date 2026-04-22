import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';

class OrderModel {
  final CustomerModel customer;
  final String orderid;
  final List<ProductModel> products;
  final OrderStatus status;
  final DateTime orderDate;
  final PaymentDetailsModel payment;
  final AddressModel address;
  OrderModel({
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

  factory OrderModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final productsData = map['products'] ?? map['items'];
    final products = productsData is List
        ? productsData
              .whereType<Map<String, dynamic>>()
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

    return OrderModel(
      customer: CustomerModel.fromMap(
        map['customer'] is Map<String, dynamic>
            ? map['customer'] as Map<String, dynamic>
            : {
                'name': map['customerName'] ?? '',
                'email': map['customerEmail'] ?? '',
                'phone': map['customerPhone'] ?? '',
                'password': '',
              },
      ),
      products: products,
      status: orderStatus,
      orderid:
          (map['orderId'] ?? map['orderid'] ?? map['orderNumber'] ?? id ?? '')
              .toString(),
      orderDate: orderDate,
      payment: map['payment'] is Map<String, dynamic>
          ? PaymentDetailsModel.fromMap(map['payment'] as Map<String, dynamic>)
          : PaymentDetailsModel.fromMap(map),
      address:
          (map['address'] ?? map['shippingAddress']) is Map<String, dynamic>
          ? AddressModel.fromMap(
              (map['address'] ?? map['shippingAddress'])
                  as Map<String, dynamic>,
            )
          : AddressModel(
              addressdescription: (map['deliveryAddress'] ?? '').toString(),
              zipCode: 0,
              city: null,
              country: null,
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderid,
      'customerName': customer.name,
      'customerEmail': customer.email,
      'customerPhone': customer.phone,
      'customer': customer.toMap(),
      'status': status.name,
      'totalAmount': totalAmount,
      'totalPrice': totalAmount,
      'subtotal': payment.subtotalPrice,
      'deliveryAddress': deliveryAddress,
      'address': address.toMap(),
      'shippingAddress': address.toMap(),
      'paymentMethod': payment.paymentMethod,
      'payment': payment.toMap(),
      'products': products.map((product) => product.toMap()).toList(),
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
      'itemsCount': products.length,
      'orderNumber': orderid,
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
