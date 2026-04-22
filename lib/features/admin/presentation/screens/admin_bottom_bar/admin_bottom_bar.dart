import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_bottom_bar.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../services/admin_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../orders_screen/orders_screen.dart';
import '../products/products_screen.dart';
import '../sellers/sellers_screen.dart';
import '../settings/settings_screen.dart';

class AdminBottomBarScreen extends StatelessWidget {
  const AdminBottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(AdminFirestoreService())..init(),
      child: const CustomBottomBar(
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
            page: ProductsScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/settings.svg',
            label: 'Settings',
            page: SettingsScreen(),
          ),
        ],
      ),
    );
  }
}
