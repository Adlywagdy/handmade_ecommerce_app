import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/utils/focus_managements.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_dashboard_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_earnings_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_manage_products_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_edit_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_profile_screen.dart';

class SellerBottomNav extends StatefulWidget {
  const SellerBottomNav({super.key});

  @override
  State<SellerBottomNav> createState() => _SellerBottomNavState();
}

class _SellerBottomNavState extends State<SellerBottomNav> {
  int _activeScreenIndex = 0; // Default to Dashboard

  void _switchTab(int index) {
    FocusManagementTips.clearFocusBeforeNavigation(null);
    setState(() {
      _activeScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (_activeScreenIndex != 0) {
          setState(() => _activeScreenIndex = 0);
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(index: _activeScreenIndex, children: _screens),
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: SafeArea(top: false, child: _buildBottomNav()),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _screens => [
    SellerDashboardScreen(
      onAddProduct: () => Get.to(() => const SellerAddEditProductScreen()),
      onViewProducts: () => _switchTab(1),
      onViewOrders: () => _switchTab(2),
      onOpenProfile: () => _switchTab(3),
    ),
    SellerManageProductsScreen(onBackPressed: () => _switchTab(0)),
    SellerOrdersScreen(onBackPressed: () => _switchTab(0)),
    const SellerProfileScreen(),
    SellerEarningsScreen(onBackPressed: () => _switchTab(0)),
  ];

  Widget _buildBottomNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavIcon(
          Icons.dashboard_outlined,
          Icons.dashboard_rounded,
          'Home',
          _activeScreenIndex == 0,
          () => _switchTab(0),
          false,
          false,
        ),
        _buildNavIcon(
          Icons.inventory_2_outlined,
          Icons.inventory_2_rounded,
          'Products',
          _activeScreenIndex == 1,
          () => _switchTab(1),
          false,
          false,
        ),
        _buildNavIcon(
          Icons.shopping_bag_outlined,
          Icons.shopping_bag_rounded,
          'Orders',
          _activeScreenIndex == 2,
          () => _switchTab(2),
          true,
          false,
        ),
        _buildNavIcon(
          Icons.payments_outlined,
          Icons.payments_rounded,
          'Earnings',
          _activeScreenIndex == 4,
          () => _switchTab(4),
          false,
          false,
        ),
        _buildNavIcon(
          Icons.person_outline_rounded,
          Icons.person_rounded,
          'Profile',
          _activeScreenIndex == 3,
          () => _switchTab(3),
          false,
          false,
        ),
      ],
    );
  }

  Widget _buildNavIcon(
    IconData inactiveIcon,
    IconData activeIcon,
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool hasBadge,
    bool isSmallText,
  ) {
    Widget iconWidget = Icon(
      isSelected ? activeIcon : inactiveIcon,
      color: isSelected ? commonColor : const Color(0xFF94A3B8),
      size: 24.w,
    );

    if (hasBadge) {
      iconWidget = Badge(
        backgroundColor: const Color(0xFFEF4444),
        smallSize: 8.w,
        child: iconWidget,
      );
    }

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 24.w, height: 24.h, child: iconWidget),
          SizedBox(height: 4.h),
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? commonColor : const Color(0xFF94A3B8),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: isSmallText ? 10.sp : 12.sp,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
