import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/review_model.dart';

// Sample product data , in a real app this would come from an API or database

List<ProductModel> wishlistProductsdata = [
  ProductModel(
    id: "1",
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
          password: "456789",
          phone: "0651616161681",
          image: "assets/images/splash.jpeg",
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
];
