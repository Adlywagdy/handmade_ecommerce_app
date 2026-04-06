import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifytPassword extends StatelessWidget {
  const VerifytPassword({super.key});

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
            Text(
              'Verify it’s you',
              style: AppTextStyles.t_30w700.copyWith(color: primaryColor),
            ),
            Text(
              'We have send a verifiction code to your email please enter the code below.',
              style: AppTextStyles.t_12w500.copyWith(
                color: primaryColor.withValues(alpha: 0.6),
              ),
            ),

            // PinCodeTextField(
            //    appContext: context,
            //     length: 6, // عدد أرقام aOTP
            //      onChanged: (value) {
            //     print("OTP current: $value");
            //     },
            //  onCompleted: (value) {
            //   print("OTP completed: $value");
            //   // هنا تبعتيه للسيرفر للتحقق
            //   },
            // keyboardType: TextInputType.number,
            //    pinTheme: PinTheme(
            //     shape: PinCodeFieldShape.box,
            //     borderRadius: BorderRadius.circular(5),
            //     fieldHeight: 50,
            //      fieldWidth: 40,
            //       activeColor: Colors.orange,
            //      selectedColor: Colors.blue,
            //   inactiveColor: Colors.grey,
            //    ),
            //      ),
            PinInput(
              keyboardType: TextInputType.number,

              length: 4,
              builder: (context, cells) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cells.map((cell) {
                    return Container(
                      width: 45.r,
                      height: 45.r,
                      margin: const EdgeInsets.symmetric(horizontal: 8).w,

                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.r),
                        color: cell.isFocused
                            ? primaryColor.withValues(alpha: 0.6)
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
            SizedBox(height: 20.h),
            Text(
              "You can resend the code after 1 minute ( 00:56 )", // counter logic
              style: AppTextStyles.t_12w500.copyWith(
                color: primaryColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: CustomElevatedButton(
          onPressed: () {
            Get.toNamed(AppRoutes.resetPassword);
          },
          buttoncolor: primaryColor,
          child: Text(
            'Confirm',
            style: AppTextStyles.t_16w500.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
