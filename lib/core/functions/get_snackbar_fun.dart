import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

void showSnack({
  required String title,
  required String message,
  Color bgColor = Colors.black,
  IconData icon = Icons.info,
}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: bgColor,
    colorText: Colors.white,
    icon: Icon(icon, color: Colors.white),
    snackStyle: SnackStyle.FLOATING,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    margin: EdgeInsets.all(16),
    borderRadius: 12,
  );
}
