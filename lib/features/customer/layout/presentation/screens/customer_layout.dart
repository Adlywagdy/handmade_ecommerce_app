import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/home/cubit/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/cubit/reviews_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/home/presentation/screens/customer_home_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/presentation/screens/customer_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/presentation/screens/customer_profile_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/presentation/screens/customer_wishlist_screen.dart';

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

  @override
  void initState() {
    super.initState();

    final dynamic arg = Get.arguments;
    if (arg is int) {
      currentIndex = arg.clamp(0, 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CustomerHomeScreen(),
      CustomerWishlistScreen(),
      CustomerCartScreen(),
      CustomerOrdersScreen(),
      CustomerProfilesScreen(onNavigateToTab: setTab),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CustomerCubit()..getCustomerdata()),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getFeaturedProducts()
            ..getTopRatedProducts(),
        ),
        BlocProvider(create: (context) => SearchCubit()..getCategories()),
        BlocProvider(
          create: (context) => WishListCubit()..getWishlistProducts(),
        ),
        BlocProvider(create: (context) => CartCubit()..getcartProducts()),
        BlocProvider(create: (context) => OrderCubit()..getAllOrders()),
        BlocProvider(create: (context) => ReviewsCubit()),
      ],
      child: Scaffold(
        backgroundColor: customerbackGroundColor,
        body: IndexedStack(index: currentIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
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
              activeIcon: const Icon(
                Icons.favorite,
                fontWeight: FontWeight.w700,
              ),
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
      ),
    );
  }
}
