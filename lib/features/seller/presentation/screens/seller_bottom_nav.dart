import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/seller_cubit.dart';
import 'seller_dashboard_screen.dart';
import 'seller_manage_products_screen.dart';
import 'seller_orders_screen.dart';

class SellerBottomNav extends StatefulWidget {
  const SellerBottomNav({super.key});

  @override
  State<SellerBottomNav> createState() => _SellerBottomNavState();
}

class _SellerBottomNavState extends State<SellerBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    SellerDashboardScreen(),
    SellerManageProductsScreen(),
    SellerOrdersScreen(),
    _SellerProfilePlaceholder(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<SellerCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 0),
                  _buildNavItem(Icons.inventory_2_outlined, 'Products', 1),
                  _buildNavItem(Icons.receipt_long_outlined, 'Orders', 2),
                  _buildNavItem(Icons.person_outline, 'Profile', 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => _currentIndex = index);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xff8B4513).withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xff8B4513)
                    : Colors.white.withValues(alpha: 0.4),
                size: 22.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xff8B4513)
                    : Colors.white.withValues(alpha: 0.4),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile tab placeholder — other team members can implement this
class _SellerProfilePlaceholder extends StatelessWidget {
  const _SellerProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 56.sp,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'Seller Profile',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.3),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
