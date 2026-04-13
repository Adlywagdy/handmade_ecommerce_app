import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backGroundColor,
      leading: Icon(Icons.arrow_back_ios, color: primaryColor),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
