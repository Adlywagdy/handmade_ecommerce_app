import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/order_cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_orderslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_home_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_profile_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_wishlist_screen.dart';

class CustomerLayout extends StatefulWidget {
  const CustomerLayout({super.key});
  @override
  State<CustomerLayout> createState() => _CustomerLayoutState();
}

class _CustomerLayoutState extends State<CustomerLayout> {
  int currentIndex = 0;
  void setTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late final List<Widget> pages;
  @override
  void initState() {
    pages = [
      CustomerHomeScreen(),

      CustomerWishlistScreen(),
      CustomerCartScreen(),
      CustomerOrdersScreen(customerorderslist: ordersListdata),
      CustomerProfilesScreen(
        customer: CustomerModel(
          name: "Adly Wagdy",
          email: "adly.wagdy@ayady.com",
          image: "assets/images/splash.jpeg",
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          switch (value) {
            case 0:
              break;
            case 1:
              BlocProvider.of<WishListCubit>(context).getWishlistProducts();
              break;
            case 2:
              BlocProvider.of<CartCubit>(context).getcartProducts();

              break;
            case 3:
              BlocProvider.of<OrderCubit>(context).getAllOrders();
              break;
          }

          setState(() {
            currentIndex = value;
          });
        },
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            label: 'Wishlist',
            activeIcon: const Icon(Icons.favorite, fontWeight: FontWeight.w700),
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 6.r,
                        backgroundColor: commonColor,
                        child: Text(
                          BlocProvider.of<CartCubit>(
                            context,
                          ).cartProductsList.length.toString(),
                          style: AppTextStyles.t_8w400.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            label: 'Cart',
            activeIcon: const Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
            activeIcon: const Icon(Icons.shopping_bag),
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: const Icon(Icons.person),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: commonColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
