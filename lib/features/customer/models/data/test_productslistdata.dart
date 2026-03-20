import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';

// Sample product data , in a real app this would come from an API or database
List<ProductModel> productsListData = [
  ProductModel(
    name: 'Handmade Ceramic Vase',
    description:
        'A beautifully crafted ceramic vase, perfect for adding a touch of elegance to your home decor.',
    price: 49.99,
    rate: 4.5,
    quantity: 50,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    rate: 4.0,
    quantity: 30,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Hand-Painted Wooden Sign',
    description:
        'A charming hand-painted wooden sign that adds a rustic touch to any space.',
    price: 19.99,
    rate: 4.8,
    quantity: 20,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Hand-Painted Wooden Sign',
    description:
        'A charming hand-painted wooden sign that adds a rustic touch to any space.',
    price: 19.99,
    rate: 4.8,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    rate: 4.0,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    rate: 4.0,
    images: ["assets/images/splash.jpeg"],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    rate: 4.0,
    images: ["assets/images/test2.png", "assets/images/splash.jpeg"],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    rate: 4.0,
    images: ["assets/images/test2.png", "assets/images/splash.jpeg"],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
  ProductModel(
    name: 'Hand-Painted Wooden Sign',
    description:
        'A charming hand-painted wooden sign that adds a rustic touch to any space.',
    price: 19.99,
    rate: 4.8,
    images: ["assets/images/splash.jpeg"],
    category: CategoryModel(categorytitle: "WOODWORK"),
  ),
];
