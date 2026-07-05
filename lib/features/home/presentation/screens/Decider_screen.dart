import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';

class DeciderScreen extends StatefulWidget {
  const DeciderScreen({super.key});

  @override
  State<DeciderScreen> createState() => _DeciderScreenState();
}

class _DeciderScreenState extends State<DeciderScreen> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      final email = user.email?.trim().toLowerCase();

      if (email == null) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      final data = query.docs.first.data();
      final role = data['role'];

      if (role == 'seller') {
        Get.offAllNamed(AppRoutes.sellerdashboard);
      } else if (role == 'admin') {
        Get.offAllNamed(AppRoutes.adminBottomBar);
      } else {
        Get.offAllNamed(AppRoutes.customerlayout);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffEEDFC8),
      body: Center(child: CircularProgressIndicator(color: Color(0xff492914))),
    );
  }
}
