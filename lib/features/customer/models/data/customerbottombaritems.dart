// import 'package:flutter/material.dart';
// import 'package:handmade_ecommerce_app/core/widgets/custom_bottom_bar.dart';
// import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
// import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
// import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
// import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
// import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_cart_screen.dart';
// import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_home_screen.dart';
// import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orders_screen.dart';
// import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_profile_screen.dart';
// import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_search_screen.dart';

// List<BottomNavItem> customerBottomBarItems = [
//   BottomNavItem(
//     iconPath: 'assets/images/home.svg',
//     label: 'Home',
//     page: CustomerHomeScreen(),
//   ),
//   BottomNavItem(
//     iconPath: 'assets/images/search.svg',
//     label: 'Search',
//     page: CustomerSearchScreen(),
//   ),
//   BottomNavItem(
//     iconPath: 'assets/images/orders.svg',
//     label: 'Cart',
//     page: CustomerCartScreen(
//       order: OrderModel(
//         customer: CustomerModel(name: "Adly"),
//         products: productsListData,
//         orderid: "123",
//       ),
//     ),
//   ),
//   BottomNavItem(
//     iconPath: 'assets/images/total_orders_icon.svg',
//     label: 'Orders',
//     page: CustomerOrdersScreen(
//       customerorderslist: [
//         OrderModel(
//           customer: CustomerModel(name: "adly"),
//           orderid: '#AY-84920',
//           products: productsListData,

//           payment: PaymentDetailsModel(
//             paymentMethod: 'Credit Card',
//             totalPrice: 500.00,
//             discount: 50.00,
//           ),
//           orderDate: DateTime.now().subtract(const Duration(days: 2)),
//           status: .delivered,
//         ),
//         OrderModel(
//           customer: CustomerModel(name: "adly"),
//           orderid: '#AY-84920',
//           products: productsListData,

//           payment: PaymentDetailsModel(
//             paymentMethod: 'Credit Card',
//             totalPrice: 500.00,
//             discount: 50.00,
//           ),
//           orderDate: DateTime.now().subtract(const Duration(days: 2)),
//           status: .confirmed,
//         ),
//       ],
//     ),
//   ),
//   BottomNavItem(
//     iconPath: 'assets/images/profile.svg',
//     label: 'Profile',
//     page: CustomerProfilesScreen(
//       customer: CustomerModel(
//         name: "Adly Wagdy",
//         email: "adly.wagdy@ayady.com",
//         image: "assets/images/splash.jpeg",
//       ),
//     ),
//   ),
// ];
