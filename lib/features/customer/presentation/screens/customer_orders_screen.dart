import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.56,
            letterSpacing: -0.45,
          ),
        ),
      ),
    );
  }
}
