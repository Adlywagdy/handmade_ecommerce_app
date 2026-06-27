import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_bottom_bar.dart';
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
      child: CustomBottomBar(
        items: [
          BottomNavItem(
            iconPath: 'assets/images/dashboard.svg',
            label: context.l10n.dashboard,
            page: AdminDashboardScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/sellers.svg',
            label: context.l10n.sellers,
            page: AdminSellersScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/orders.svg',
            label: context.l10n.orders,
            page: AdminOrdersScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/products.svg',
            label: context.l10n.products,
            page: AdminProductsScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/settings.svg',
            label: context.l10n.settings,
            page: AdminSettingsScreen(),
          ),
        ],
      ),
    );
  }
}
