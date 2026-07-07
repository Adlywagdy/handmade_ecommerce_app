import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/logic/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/ui/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/screens/customer_home_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/widgets/customer_bloc_providers.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/screens/customer_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/ui/screens/customer_profile_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/ui/screens/customer_wishlist_screen.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

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

    return CustomerBlocProviders(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: customerbackGroundColor,
            body: IndexedStack(index: currentIndex, children: pages),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) async {
                setState(() {
                  currentIndex = value;
                });
                if (value == 2) {
                  await context.read<CartCubit>().getcartProducts();
                }
              },
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  label: context.l10n.home,
                  activeIcon: const Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_border),
                  label: context.l10n.wishlist,
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
                                context
                                    .read<CartCubit>()
                                    .cartProductsList
                                    .length
                                    .toString(),
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
                  label: context.l10n.cart,
                  activeIcon: const Icon(Icons.shopping_cart),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: context.l10n.ordersTab,
                  activeIcon: const Icon(Icons.shopping_bag),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  label: context.l10n.profile,
                  activeIcon: const Icon(Icons.person),
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: commonColor,
              unselectedItemColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
