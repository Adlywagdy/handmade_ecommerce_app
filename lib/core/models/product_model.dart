import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/data/models/reviews_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String? nameAR;
  final String description;
  final String? descriptionAR;
  final double price;
  final double? discountedPrice;
  final String currency;
  final double? totalrate;
  final int? salesCount;
  final int? reviewsCount;
  final String? status;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  int quantity;
  final List<ReviewsModel>? reviews;
  final List<String> images;
  final List<String>? tags;
  final SellerModel seller;

  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    this.nameAR,
    required this.description,
    this.descriptionAR,
    required this.price,
    this.discountedPrice,
    this.currency = 'EGP',
    this.totalrate,
    this.salesCount,
    this.reviewsCount,
    this.status,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    required this.images,
    this.category,
    required this.quantity,
    required this.seller,
    this.tags,
    this.reviews,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? nameAR,
    String? description,
    String? descriptionAR,
    double? price,
    double? discountedPrice,
    String? currency,
    double? totalrate,
    int? salesCount,
    int? reviewsCount,
    String? status,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? quantity,
    List<ReviewsModel>? reviews,
    List<String>? images,
    List<String>? tags,
    SellerModel? seller,
    CategoryModel? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAR: nameAR ?? this.nameAR,
      description: description ?? this.description,
      descriptionAR: descriptionAR ?? this.descriptionAR,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      currency: currency ?? this.currency,
      totalrate: totalrate ?? this.totalrate,
      salesCount: salesCount ?? this.salesCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quantity: quantity ?? this.quantity,
      reviews: reviews ?? this.reviews,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      seller: seller ?? this.seller,
      category: category ?? this.category,
    );
  }

  String? get image => images.isNotEmpty ? images.first : null;
  double get rating => totalrate ?? 0;
  String get sellerId => seller.primaryIdentifier;
  String? get categoryId => category?.id ?? category?.categorytitle;

  String localizedName(bool isArabic) {
    if (isArabic && nameAR != null && nameAR!.isNotEmpty) return nameAR!;
    return name;
  }

  String localizedDescription(bool isArabic) {
    if (isArabic && descriptionAR != null && descriptionAR!.isNotEmpty) {
      return descriptionAR!;
    }
    return description;
  }

  static List<String> _parseImages(Map<String, dynamic> map) {
    if (map['images'] is List) {
      return (map['images'] as List).map((e) => e.toString()).toList();
    }
    final single =
        map['productImage']?.toString() ?? map['imageUrl']?.toString();
    return (single != null && single.isNotEmpty) ? [single] : [];
  }

  static SellerModel _parseSeller(Map<String, dynamic> map) {
    final sellerMap = map['seller'];
    final refId =
        SellerModel.normalizeReferenceId(sellerMap) ??
        SellerModel.normalizeReferenceId(map['sellerId']);
    if (sellerMap is Map<String, dynamic>) {
      return SellerModel.fromMap(sellerMap, fallbackId: refId?.toString());
    }
    return SellerModel.fromMap({
      'id': refId ?? map['sellerId'],
      'sellerId': refId ?? map['sellerId'],
      'name': map['sellerName'],
      'email': map['sellerEmail'] ?? refId ?? map['sellerId'],
      'specialty': map['sellerSpecialty'],
      'image': map['sellerImage'],
      'badge': map['sellerBadge'],
      'location': map['sellerLocation'],
    }, fallbackId: (refId ?? map['sellerId'])?.toString());
  }

  static CategoryModel? _parseCategory(Map<String, dynamic> map) {
    final categoryMap = map['category'];
    final refId =
        CategoryModel.normalizeReferenceId(categoryMap) ??
        CategoryModel.normalizeReferenceId(map['categoryId']);
    if (categoryMap is Map<String, dynamic>) {
      return CategoryModel.fromMap(categoryMap, id: refId);
    }
    if (refId != null || map['categoryName'] != null) {
      return CategoryModel(
        id: refId,
        categorytitle: (map['categoryName'] ?? refId ?? 'General').toString(),
      );
    }
    return null;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ProductModel(
      id: id ?? map['id']?.toString() ?? map['productId']?.toString() ?? '',
      name:
          map['name']?.toString() ??
          map['productName']?.toString() ??
          map['title']?.toString() ??
          '',
      nameAR: map['nameAR']?.toString() ?? map['name_ar']?.toString(),
      description: map['description']?.toString() ?? '',
      descriptionAR:
          map['descriptionAR']?.toString() ?? map['description_ar']?.toString(),
      price: parseDouble(map['price']) ?? 0,
      discountedPrice: parseDouble(map['discountedPrice']),
      currency: map['currency']?.toString() ?? 'EGP',
      totalrate: parseDouble(map['rating'] ?? map['totalrate']),
      salesCount: parseInt(map['salesCount']),
      reviewsCount: parseInt(map['reviewsCount']),
      status: map['status']?.toString(),
      isActive: map['isActive'] as bool? ?? true,
      createdAt: parseDateTime(map['createdAt']),
      updatedAt: parseDateTime(map['updatedAt']),
      quantity: parseInt(map['stock'] ?? map['quantity']) ?? 0,
      images: _parseImages(map),
      category: _parseCategory(map),
      seller: _parseSeller(map),
      tags: map['tags'] is List
          ? (map['tags'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'productId': id,
      'name': name,
      'nameAR': nameAR,
      'description': description,
      'descriptionAR': descriptionAR,
      'price': price,
      'currency': currency,
      'rating': totalrate ?? 0,
      'reviewsCount': reviewsCount ?? 0,
      'stock': quantity,
      'images': images,
      'productImage': image,
      'sellerId': sellerId,
      'categoryId': category?.id,
      'tags': tags ?? <String>[],
      'isActive': isActive,
      'status': status ?? 'pending',
      'salesCount': salesCount ?? 0,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
    };

    data['discountedPrice'] = discountedPrice;

    return data;
  }
}
