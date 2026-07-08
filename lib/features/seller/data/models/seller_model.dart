import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a product from the seller's perspective with stock management
class SellerProductModel {
  final String id;
  final String name;
  final String? nameAR;
  final String description;
  final String? descriptionAR;
  final double price;
  final int stock;
  final String categoryId;
  final List<String> images;
  final bool isActive;
  final String status;
  final String currency;
  final double? discountedPrice;
  final double rating;
  final int reviewsCount;
  final int salesCount;
  final List<String> tags;

  const SellerProductModel({
    required this.id,
    required this.name,
    this.nameAR,
    required this.description,
    this.descriptionAR,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.images,
    this.isActive = true,
    required this.status,
    this.currency = 'EGP',
    this.discountedPrice,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.salesCount = 0,
    this.tags = const [],
  });

  SellerProductModel copyWith({
    String? id,
    String? name,
    String? nameAR,
    String? description,
    String? descriptionAR,
    double? price,
    int? stock,
    String? categoryId,
    List<String>? images,
    bool? isActive,
    String? status,
    String? currency,
    double? discountedPrice,
    double? rating,
    int? reviewsCount,
    int? salesCount,
    List<String>? tags,
  }) {
    return SellerProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAR: nameAR ?? this.nameAR,
      description: description ?? this.description,
      descriptionAR: descriptionAR ?? this.descriptionAR,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      salesCount: salesCount ?? this.salesCount,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameAR': nameAR,
      'description': description,
      'descriptionAR': descriptionAR,
      'price': price,
      'stock': stock,
      'categoryId': categoryId,
      'images': images,
      'isActive': isActive,
      'status': status,
      'currency': currency,
      'discountedPrice': discountedPrice,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'salesCount': salesCount,
      'tags': tags,
    };
  }

  factory SellerProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SellerProductModel(
      id: documentId,
      name: map['name'] ?? '',
      nameAR: map['nameAR'],
      description: map['description'] ?? '',
      descriptionAR: map['descriptionAR'],
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock']?.toInt() ?? 0,
      categoryId: map['categoryId'] ?? map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      isActive: map['isActive'] ?? true,
      status: map['status'] ?? 'In Stock',
      currency: map['currency'] ?? 'EGP',
      discountedPrice: map['discountedPrice'] != null ? (map['discountedPrice'] as num).toDouble() : null,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewsCount: map['reviewsCount']?.toInt() ?? 0,
      salesCount: map['salesCount']?.toInt() ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}

/// Represents an order item inside a seller order
class SellerOrderItemModel {
  final String productName;
  final int quantity;
  final double price;
  final String? image;

  const SellerOrderItemModel({
    required this.productName,
    required this.quantity,
    required this.price,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory SellerOrderItemModel.fromMap(Map<String, dynamic> map) {
    String? parsedImage = map['productImage']?.toString() ?? map['image']?.toString();
    if ((parsedImage == null || parsedImage.isEmpty) && map['images'] is List && (map['images'] as List).isNotEmpty) {
      parsedImage = (map['images'] as List)[0]?.toString();
    }

    return SellerOrderItemModel(
      productName: map['productName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      image: parsedImage,
    );
  }
}

/// Represents an order from the seller's perspective
class SellerOrderModel {
  final String orderId;
  final String customerName;
  final String orderDate;
  final double totalAmount;
  final String status; // 'Pending', 'Delivered', 'Cancelled'
  final List<SellerOrderItemModel> items;

  const SellerOrderModel({
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  SellerOrderModel copyWith({
    String? orderId,
    String? customerName,
    String? orderDate,
    double? totalAmount,
    String? status,
    List<SellerOrderItemModel>? items,
  }) {
    return SellerOrderModel(
      orderId: orderId ?? this.orderId,
      customerName: customerName ?? this.customerName,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'orderDate': orderDate,
      'totalAmount': totalAmount,
      'status': status,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

      factory SellerOrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    String parsedCustomerName = map['customerName']?.toString() ?? '';
    if (parsedCustomerName.isEmpty) {
      if (map['customer'] is Map) {
        parsedCustomerName = map['customer']['name']?.toString() ?? '';
      }
    }
    if (parsedCustomerName.isEmpty) {
      parsedCustomerName = map['customerId']?.toString() ?? 'Customer';
    }

    final rawTotal = map['totalAmount'] ?? map['totalPrice'] ?? 0;
    double parsedTotalAmount = 0.0;
    if (rawTotal is num) {
      parsedTotalAmount = rawTotal.toDouble();
    } else if (rawTotal is String) {
      parsedTotalAmount = double.tryParse(rawTotal) ?? 0.0;
    }

    final rawDate = map['orderDate'] ?? map['createdAt'];
    String parsedDate = '';
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate().toIso8601String();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate.toIso8601String();
    } else {
      parsedDate = rawDate?.toString() ?? '';
    }

    return SellerOrderModel(
      orderId: documentId,
      customerName: parsedCustomerName,
      orderDate: parsedDate,
      totalAmount: parsedTotalAmount,
      status: (map['status']?.toString() ?? 'pending').toLowerCase(),
      items: List<SellerOrderItemModel>.from(
        (map['items'] as List? ?? []).map((x) {
          final itemMap = x is Map ? Map<String, dynamic>.from(x) : <String, dynamic>{};
          return SellerOrderItemModel.fromMap(itemMap);
        }),
      ),
    );
  }
}

/// Dashboard stats model
class SellerDashboardStats {
  final String totalSales;
  final String totalOrders;
  final String totalRevenue;
  final String totalProducts;
  final List<double> weeklySales; // 7 values for bar chart
  final List<double> monthlySales; // 6 values for monthly chart
  final String revenueGrowth; // e.g. "+12.5%"
  final String ordersGrowth; // e.g. "+5.4%"

  const SellerDashboardStats({
    required this.totalSales,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.weeklySales,
    required this.monthlySales,
    required this.revenueGrowth,
    required this.ordersGrowth,
  });
}
