import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../theme/colors.dart';
import '../utils/focus_managements.dart';

class CustomBottomBar extends StatefulWidget {
  /// List of nav items (icon + label + page)
  final List<BottomNavItem> items;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final bool highlightSelected;

  const CustomBottomBar({
    super.key,
    required this.items,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.highlightSelected = false,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

/// using the AutomaticKeepAliveClientMixin to avoid rebuild
/// any time for page or part disposing
class _CustomBottomBarState extends State<CustomBottomBar> with AutomaticKeepAliveClientMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final selectedColor = widget.selectedColor ?? commonColor;
    final unselectedColor = widget.unselectedColor ?? greyTextColor;
    final barColor = widget.backgroundColor ?? Colors.white.withValues(alpha: 0.03);
    return PopScope(
      canPop: false,
      /// if in tap of index 3 for example and press back
      /// first will make check if (drawer open ) will clos it then
      /// if not in home screen will navigate to home
      /// if press tap in home will close app
      onPopInvokedWithResult: (didPop, result) async {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
          return;
        }
        if (currentIndex != 0) {
          setState(() => currentIndex = 0);
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: currentIndex,
          children: widget.items.map((item) => item.page).toList(),
        ),
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.01),
                    width: 0.8,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    widget.items.length, (index) => _buildNavItem(
                      widget.items[index].iconPath,
                      widget.items[index].label,
                      index,
                      selectedColor,
                      unselectedColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String iconPath,
    String label,
    int index,
    Color selectedColor,
    Color unselectedColor,
  ) {
    final isSelected = currentIndex == index;
    final itemColor = isSelected ? selectedColor : unselectedColor;
    final highlight = widget.highlightSelected && isSelected;
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        /// To Lock any available Focus before any navigation
        /// or screen change(like keyboard or search).
        FocusManagementTips.clearFocusBeforeNavigation(null);
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: highlight ? 14.w : 8.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: highlight
              ? selectedColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  itemColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// when make scroll in page and go to
  /// another screen when return no start again from top of screen
  /// keep on last index (scroll)
  @override
  bool get wantKeepAlive => true;
}

/// As Model to define each bottom navigation item
/// contains the icon path , label and the page widget
class BottomNavItem {
  final String iconPath;
  final String label;
  final Widget page;

  const BottomNavItem({
    required this.iconPath,
    required this.label,
    required this.page,
  });
}
