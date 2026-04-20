import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/extension/validation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

late GlobalKey<FormState> _formkey;
late TextEditingController _emailController;

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Password recovery',
                  style: AppTextStyles.t_30w700.copyWith(color: primaryColor),
                ),
                Text(
                  'Please enter your email address to send to a password recovery email.',
                  style: AppTextStyles.t_12w500.copyWith(
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 20),
                Customtextfield(
                  controller: _emailController,
                  label: 'EMAIL ADDRESS',
                  hintText: 'example@mail.com',
                  prefixIcon: Icon(
                    Icons.email,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  validator: (value) {
                    if (!value!.emailValid()) {
                      return "email isn't valid";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: CustomElevatedButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              // logic to send otp
              Get.toNamed(AppRoutes.verifyPassword);
            }
          },

          buttoncolor: primaryColor,
          child: Text(
            'Send Code',
            style: AppTextStyles.t_16w500.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
