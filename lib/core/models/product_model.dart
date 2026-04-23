import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/review_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? totalrate;
  int quantity;
  final List<ReviewModel>? reviews;
  final List<String> images;
  final List<String>? tags;
  final SellerModel seller;

  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.totalrate,
    required this.images,
    this.category,
    required this.quantity,
    required this.seller,
    this.tags,
    this.reviews,
  });

  String? get image => images.isNotEmpty ? images.first : null;
  double get rating => totalrate ?? 0;
  int get reviewsCount => reviews?.length ?? 0;
  String get sellerId => seller.email;
  String? get categoryId => category?.id ?? category?.categorytitle;

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final imagesField = map['images'];
    final String? singleImage =
        map['image']?.toString() ??
        map['imageUrl']?.toString() ??
        map['productImage']?.toString();
    final List<String> normalizedImages = imagesField is List
        ? imagesField.map((e) => e.toString()).toList()
        : (singleImage != null && singleImage.isNotEmpty)
        ? [singleImage]
        : <String>[];

    final dynamic rawPrice = map['price'] ?? 0;
    final double parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice.toString()) ?? 0;

    final dynamic rawQuantity = map['quantity'] ?? map['stock'] ?? 0;
    final int parsedQuantity = rawQuantity is int
        ? rawQuantity
        : int.tryParse(rawQuantity.toString()) ?? 0;

    final dynamic rawRating = map['rating'] ?? map['totalrate'];
    final double? parsedRating = rawRating == null
        ? null
        : (rawRating is num
              ? rawRating.toDouble()
              : double.tryParse(rawRating.toString()));

    final sellerMap = map['seller'];
    final seller = sellerMap is Map<String, dynamic>
        ? SellerModel(
            name: sellerMap['name']?.toString() ?? 'Unknown Seller',
            email: sellerMap['email']?.toString() ?? '',
            specialty: sellerMap['specialty']?.toString() ?? '',
            submittedDate: sellerMap['submittedDate']?.toString() ?? '',
            badge: sellerMap['badge']?.toString(),
            image: sellerMap['image']?.toString(),
            location: sellerMap['location']?.toString(),
          )
        : SellerModel(
            name: map['sellerName']?.toString() ?? 'Unknown Seller',
            email: map['sellerId']?.toString() ?? '',
            specialty: map['sellerSpecialty']?.toString() ?? '',
            submittedDate: '',
            image: map['sellerImage']?.toString(),
            badge: map['sellerBadge']?.toString(),
            location: map['sellerLocation']?.toString(),
          );

    final categoryField = map['category'];
    final category = categoryField is Map<String, dynamic>
        ? CategoryModel.fromMap(
            categoryField,
            id: map['categoryId']?.toString(),
          )
        : (map['categorytitle'] != null ||
              map['categoryName'] != null ||
              map['categoryId'] != null)
        ? CategoryModel(
            id: map['categoryId']?.toString(),
            categorytitle:
                (map['categorytitle'] ??
                        map['categoryName'] ??
                        map['categoryId'] ??
                        'General')
                    .toString(),
          )
        : null;

    return ProductModel(
      id: id ?? map['id']?.toString() ?? map['productId']?.toString() ?? '',
      name:
          map['name']?.toString() ??
          map['title']?.toString() ??
          map['productName']?.toString() ??
          '',
      description: map['description']?.toString() ?? '',
      price: parsedPrice,
      totalrate: parsedRating,
      quantity: parsedQuantity,
      images: normalizedImages,
      category: category,
      seller: seller,
      tags: map['tags'] is List
          ? (map['tags'] as List).map((e) => e.toString()).toList()
          : null,
      reviews: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': 'EGP',
      'rating': totalrate,
      'quantity': quantity,
      'stock': quantity,
      'images': images,
      'image': image,
      'imageUrl': image,
      'productImage': image,
      'title': name,
      'sellerId': seller.email,
      'seller': {
        'name': seller.name,
        'email': seller.email,
        'specialty': seller.specialty,
        'submittedDate': seller.submittedDate,
        'badge': seller.badge,
        'image': seller.image,
        'location': seller.location,
      },
      'categoryId': category?.id,
      'category': category?.toMap(),
      'tags': tags,
      'isActive': true,
      'addedAt': DateTime.now().toIso8601String(),
    };
  }

  // to make a copy of the product coming from firebase with a new quantity value to add to cart
  factory ProductModel.copywith(ProductModel product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      totalrate: product.totalrate,
      quantity: 1,
      images: product.images,
      category: product.category,
      seller: product.seller,
      tags: product.tags,
      reviews: product.reviews,
    );
  }
}
