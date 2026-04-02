import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text1.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text2.dart';

class Password extends StatelessWidget {
  const Password({super.key});

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
            Text1(text1: 'Create new password'),
            // SizedBox()
            Text2(
              text2:
                  'Please create a secure password for your account to ensure security of the account.',
            ),
            SizedBox(height: 20),
            Customtextfield(
              label: 'Password',

              prefixIcon: Icon(Icons.lock, color: SecodaryColor),
              suffixIcon: Icon(Icons.remove_red_eye, color: SecodaryColor),
            ),

            SizedBox(height: 10),

            Customtextfield(
              label: 'Re-type Password',

              prefixIcon: Icon(Icons.lock, color: SecodaryColor),
              suffixIcon: Icon(Icons.remove_red_eye, color: SecodaryColor),
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
          // onTap: (){
          //   Get.
          // },
          text: 'Set Password',
          value: 'SetPassword',
        ),
      ),
    );
  }
}
