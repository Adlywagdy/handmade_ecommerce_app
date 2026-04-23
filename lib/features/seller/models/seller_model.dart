/// Represents a product from the seller's perspective with stock management
class SellerProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final List<String> images;
  final bool isActive;
  final String status; // 'In Stock', 'Out of Stock', 'Low Stock'

  const SellerProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.images,
    this.isActive = true,
    required this.status,
  });

  SellerProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    List<String>? images,
    bool? isActive,
    String? status,
  }) {
    return SellerProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'images': images,
      'isActive': isActive,
      'status': status,
    };
  }

  factory SellerProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SellerProductModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock']?.toInt() ?? 0,
      category: map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      isActive: map['isActive'] ?? true,
      status: map['status'] ?? 'In Stock',
    );
  }
}

/// Represents an order item inside a seller order
class SellerOrderItemModel {
  final String productName;
  final int quantity;
  final double price;

  const SellerOrderItemModel({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory SellerOrderItemModel.fromMap(Map<String, dynamic> map) {
    return SellerOrderItemModel(
      productName: map['productName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: (map['price'] ?? 0).toDouble(),
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
    return SellerOrderModel(
      orderId: documentId,
      customerName: map['customerName'] ?? '',
      orderDate: map['orderDate'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'Pending',
      items: List<SellerOrderItemModel>.from(
        (map['items'] ?? []).map((x) => SellerOrderItemModel.fromMap(x)),
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

  const SellerDashboardStats({
    required this.totalSales,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.weeklySales,
  });
}
