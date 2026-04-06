import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text1.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text2.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text1(text1: 'Password recovery'),
            // SizedBox()
            Text2(
              text2:
                  'Please enter your email address to send to a password recovery email.',
            ),
            SizedBox(height: 20),
            Customtextfield(
              label: 'EMAIL ADDRESS',
              hintText: 'example@mail.com',
              prefixIcon: Icon(
                Icons.email,
                color: primaryColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: CustomButton(
          onTap: () {
            Get.toNamed('/verify');
          },
          text: 'SendCode',
          value: 'Sendcode',
        ),
      ),
    );
  }
}
