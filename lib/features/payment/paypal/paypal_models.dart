class AmountPaymentModel {
  final String? total;
  final String? currency;
  final Details? details;

  AmountPaymentModel({
    required this.total,
    required this.currency,
    required this.details,
  });

  factory AmountPaymentModel.fromJson(Map<String, dynamic> json) {
    return AmountPaymentModel(
      total: json['total'] as String?,
      currency: json['currency'] as String?,
      details: json['details'] == null
          ? null
          : Details.fromJson(json['details'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'currency': currency,
    'details': details?.toJson(),
  };
}

class Details {
  String? subtotal;
  String? shipping;
  int? shippingDiscount;

  Details({this.subtotal, this.shipping, this.shippingDiscount});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    subtotal: json['subtotal'] as String?,
    shipping: json['shipping'] as String?,
    shippingDiscount: json['shipping_discount'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'subtotal': subtotal,
    'shipping': shipping,
    'shipping_discount': shippingDiscount,
  };
}

class ItemListModel {
  List<OrderItemModel>? orderslist;
  ShippingAddress? shippingAddress;

  ItemListModel({this.orderslist, this.shippingAddress});

  factory ItemListModel.fromJson(Map<String, dynamic> json) => ItemListModel(
    orderslist: (json['items'] as List<dynamic>?)
        ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    shippingAddress: json['shipping_address'] == null
        ? null
        : ShippingAddress.fromJson(
            json['shipping_address'] as Map<String, dynamic>,
          ),
  );

  Map<String, dynamic> toJson() => {
    'items': orderslist?.map((e) => e.toJson()).toList(),
    'shipping_address': shippingAddress?.toJson(),
  };
}

class OrderItemModel {
  String? name;
  int? quantity;
  String? price;
  String? currency;

  OrderItemModel({this.name, this.quantity, this.price, this.currency});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    name: json['name'] as String?,
    quantity: json['quantity'] as int?,
    price: json['price'] as String?,
    currency: json['currency'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
    'currency': currency,
  };
}

class ShippingAddress {
  String? recipientName;
  String? line1;
  String? line2;
  String? city;
  String? countryCode;
  String? postalCode;
  String? phone;
  String? state;

  ShippingAddress({
    this.recipientName,
    this.line1,
    this.line2,
    this.city,
    this.countryCode,
    this.postalCode,
    this.phone,
    this.state,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      recipientName: json['recipient_name'] as String?,
      line1: json['line1'] as String?,
      line2: json['line2'] as String?,
      city: json['city'] as String?,
      countryCode: json['country_code'] as String?,
      postalCode: json['postal_code'] as String?,
      phone: json['phone'] as String?,
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'recipient_name': recipientName,
    'line1': line1,
    'line2': line2,
    'city': city,
    'country_code': countryCode,
    'postal_code': postalCode,
    'phone': phone,
    'state': state,
  };
}
