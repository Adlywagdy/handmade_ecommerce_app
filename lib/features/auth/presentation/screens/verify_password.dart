import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text1.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text2.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifytPassword extends StatelessWidget {
  VerifytPassword({super.key});

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
            Text1(text1: 'Verify it’s you'),
            Text2(
              text2:
                  'We have send a verifiction code to your email please enter the code below.',
            ),

            
            PinInput(
              keyboardType: TextInputType.number,

              length: 4,
              builder: (context, cells) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cells.map((cell) {
                    return Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 8),

                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        color: cell.isFocused
                            ? SecodaryColor
                            : Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          cell.character ?? '',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              onCompleted: (pin) => print('PIN: $pin'),
            ),

            Text2(text2: "You can resend the code after 1 minute ( 00:56 )"),
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
            Get.toNamed('/password');
          },
          text: 'Confirm',
          value: 'Confirm',
        ),
      ),
    );
  }
}
