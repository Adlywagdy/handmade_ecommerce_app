import 'package:handmade_ecommerce_app/core/widgets/custom_bottom_bar.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_home_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_profiles_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_search_screen.dart';

List<BottomNavItem> customerBottomBarItems = [
  BottomNavItem(
    iconPath: 'assets/images/home.svg',
    label: 'Home',
    page: CustomerHomeScreen(),
  ),
  BottomNavItem(
    iconPath: 'assets/images/search.svg',
    label: 'Search',
    page: CustomerSearchScreen(),
  ),
  BottomNavItem(
    iconPath: 'assets/images/orders.svg',
    label: 'Cart',
    page: CustomerCartScreen(
      order: OrderModel(
        customer: CustomerModel(name: "Adly"),
        products: productsListData,
        orderid: "123",
      ),
    ),
  ),
  BottomNavItem(
    iconPath: 'assets/images/total_orders_icon.svg',
    label: 'Orders',
    page: CustomerOrdersScreen(),
  ),
  BottomNavItem(
    iconPath: 'assets/images/profile.svg',
    label: 'Profile',
    page: CustomerProfilesScreen(),
  ),
];
