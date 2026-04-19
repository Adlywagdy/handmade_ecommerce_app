import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final String currency;
  final List<String> images;
  final String categoryId;
  final String sellerId;
  final int stock;
  final bool isActive;
  final String status; // 'pending' | 'approved' | 'rejected'
  final double rating;
  final int reviewsCount;
  final int salesCount;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Legacy display field populated from denormalized joins.
  final String? vendorName;

  const ProductsModel({
    this.id = '',
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.discountedPrice,
    this.currency = 'EGP',
    this.images = const [],
    this.categoryId = '',
    this.sellerId = '',
    this.stock = 0,
    this.isActive = true,
    this.status = 'pending',
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.salesCount = 0,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
    this.vendorName,
  });

  /// Back-compat for screens that read a single image URL.
  String get productImage => images.isNotEmpty ? images.first : '';

  /// Back-compat for screens that used an int product id.
  @Deprecated('Use id (String). Kept for legacy inline mock data.')
  String get productId => id;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'discountedPrice': discountedPrice,
        'currency': currency,
        'images': images,
        'categoryId': categoryId,
        'sellerId': sellerId,
        'stock': stock,
        'isActive': isActive,
        'status': status,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'salesCount': salesCount,
        'tags': tags,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
        if (vendorName != null) 'vendorName': vendorName,
      };

  factory ProductsModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ProductsModel(
      id: id ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      currency: json['currency'] ?? 'EGP',
      images: (json['images'] as List?)?.whereType<String>().toList() ?? const [],
      categoryId: json['categoryId'] ?? '',
      sellerId: json['sellerId'] ?? '',
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'pending',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      salesCount: json['salesCount'] ?? 0,
      tags: (json['tags'] as List?)?.whereType<String>().toList() ?? const [],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      vendorName: json['vendorName'],
    );
  }
}
