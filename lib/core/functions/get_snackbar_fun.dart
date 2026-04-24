import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnack({
  required String title,
  required String message,
  Color bgColor = Colors.black,
  IconData icon = Icons.info,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      snackStyle: SnackStyle.FLOATING,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  });
}
