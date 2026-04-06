import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

late GlobalKey<FormState> _formkey;
late TextEditingController _passwordController;
late TextEditingController _confirmPasswordController;

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Create new password',
                  style: AppTextStyles.t_30w700.copyWith(color: primaryColor),
                ),
                Text(
                  'Please create a secure password for your account to ensure security of the account.',
                  style: AppTextStyles.t_12w500.copyWith(
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 20),
                Customtextfield(
                  controller: _passwordController,
                  label: 'Password',
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Password is required";
                    }
                    if (password.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  prefixIcon: Icon(
                    Icons.lock,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 10),

                Customtextfield(
                  controller: _confirmPasswordController,
                  label: 'Re-type Password',
                  validator: (confirmPassword) {
                    if (confirmPassword == null || confirmPassword.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (confirmPassword != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  prefixIcon: Icon(
                    Icons.lock,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16.h),
        child: CustomElevatedButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              // logic to reset password
            }
          },
          buttoncolor: primaryColor,
          child: Text(
            'Set Password',
            style: AppTextStyles.t_16w500.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
