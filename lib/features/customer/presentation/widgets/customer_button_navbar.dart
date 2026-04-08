import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomerButtonNavBar extends StatefulWidget {
  const CustomerButtonNavBar({super.key});

  @override
  State<CustomerButtonNavBar> createState() => _CustomerButtonNavBarState();
}

int currentIndex = 0;

class _CustomerButtonNavBarState extends State<CustomerButtonNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        setState(() {
          currentIndex = value;
          switch (value) {
            case 0:
              Get.toNamed(AppRoutes.customerHome);
              break;
            case 1:
              Get.toNamed(AppRoutes.customerSearch);
              break;
            case 2:
              Get.toNamed(AppRoutes.customerCart);
              break;
            case 3:
              Get.toNamed(AppRoutes.customerOrders);
              break;
            case 4:
              Get.toNamed(AppRoutes.customerProfile);
              break;
          }
        });
      },
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
          activeIcon: Icon(Icons.search, fontWeight: FontWeight.w700),
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart_outlined),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 6.r,
                  backgroundColor: commonColor,
                  child: Text(
                    '3', // This should be dynamic based on the cart items count
                    style: AppTextStyles.t_8w400.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          label: 'Cart',
          activeIcon: Icon(Icons.shopping_cart),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Orders',
          activeIcon: Icon(Icons.shopping_bag),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
          activeIcon: Icon(Icons.person),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: commonColor,
    );
  }
}
