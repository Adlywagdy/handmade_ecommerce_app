import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/review_model.dart';

// Sample product data , in a real app this would come from an API or database

List<ProductModel> wishlistProductsdata = [
  ProductModel(
    name: 'Handmade Ceramic Vase',
    description:
        'This exquisite Terra Vase is hand-thrown by master artisans using traditional Mediterranean techniques.\nEach piece is unique, featuring a natural matte finish and subtle variations in texture that celebrate the organic beauty of locally sourced clay. \nPerfect for dried botanicals or as a standalone sculptural piece.',
    price: 49.99,
    totalrate: 4.5,
    quantity: 50,
    reviews: [
      ReviewModel(
        reviewer: CustomerModel(
          name: "Alice Smith",
          email: "alice.smith@example.com",
        ),
        rating: 3,
        reviewText:
            "Absolutely stunning quality. You can feel the craftsmanship in the texture of the clay.",
        reviewDate: DateTime.now(),
      ),
    ],
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Artisan ",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Verified",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Ceramic", "Decorative"],
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    totalrate: 4.0,
    quantity: 30,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Ceramics",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Top Seller",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Wooden", "Decorative"],
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    totalrate: 4.0,
    quantity: 30,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Ceramics",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Top Seller",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Wooden", "Decorative"],
  ),

  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    totalrate: 4.0,
    quantity: 30,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Ceramics",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Top Seller",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Wooden", "Decorative"],
  ),
  ProductModel(
    name: 'Hand-Painted Wooden Sign',
    description:
        'A charming hand-painted wooden sign that adds a rustic touch to any space.',
    price: 19.99,
    totalrate: 4.8,
    quantity: 20,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Ceramics",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Top Seller",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Wooden", "Decorative"],
  ),
];
