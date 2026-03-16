import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_bottom_bar.dart';
import '../dashboard/dashboard_screen.dart';

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
          page: Center(child: Text("Sellers", style: TextStyle(color: Colors.black))),
        ),
        BottomNavItem(
          iconPath: 'assets/images/orders.svg',
          label: 'Orders',
          page: Center(child: Text("Orders", style: TextStyle(color: Colors.black))),
        ),
        BottomNavItem(
          iconPath: 'assets/images/settings.svg',
          label: 'Settings',
          page: Center(child: Text("Settings", style: TextStyle(color: Colors.black))),
        ),
      ],
    );
  }
}