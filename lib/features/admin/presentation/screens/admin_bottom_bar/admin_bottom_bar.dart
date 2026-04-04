import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_bottom_bar.dart';
import '../dashboard/dashboard_screen.dart';
import '../orders_screen/orders_screen.dart';
import '../products/approve_products.dart';
import '../sellers/sellers_screen.dart';

class AdminBottomBarScreen extends StatelessWidget {
  const AdminBottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomBar(
      items: [
        BottomNavItem(
          iconPath: 'assets/images/dashboard.svg',
          label: 'Dashboard',
          page: DashboardScreen(),
        ),
        BottomNavItem(
          iconPath: 'assets/images/sellers.svg',
          label: 'Sellers',
          page: SellersScreen(),
        ),
        BottomNavItem(
          iconPath: 'assets/images/orders.svg',
          label: 'Orders',
          page: OrdersScreen(),
        ),
        BottomNavItem(
          iconPath: 'assets/images/products.svg',
          label: 'Products',
          page: ApproveProductsScreen(),
        ),
        BottomNavItem(
          iconPath: 'assets/images/settings.svg',
          label: 'Settings',
          page: Center(child: Text('Settings'),),
        ),
      ],
    );
  }
}
