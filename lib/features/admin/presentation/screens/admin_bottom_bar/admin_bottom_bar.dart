import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

import '../../../../../core/theme/colors.dart';
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
      child: CustomBottomBar(
        selectedColor: commonColor,
        unselectedColor: subTitleColor,
        backgroundColor: Colors.white,
        highlightSelected: true,
        items: [
          BottomNavItem(
            iconPath: 'assets/images/dashboard.svg',
            label: AppLocalizations.of(context)!.admDashboard,
            page: const AdminDashboardScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/sellers.svg',
            label: AppLocalizations.of(context)!.admSellers,
            page: const AdminSellersScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/orders.svg',
            label: AppLocalizations.of(context)!.admOrders,
            page: const AdminOrdersScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/products.svg',
            label: AppLocalizations.of(context)!.admProducts,
            page: const AdminProductsScreen(),
          ),
          BottomNavItem(
            iconPath: 'assets/images/settings.svg',
            label: AppLocalizations.of(context)!.admSettingsNav,
            page: const AdminSettingsScreen(),
          ),
        ],
      ),
    );
  }
}
