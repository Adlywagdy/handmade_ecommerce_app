import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/extension/email_validation.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/buttom_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/divider.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/q_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 80, bottom: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: backGroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset('assets/icons/Icon1.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Ayady',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  'Please enter your details to continue',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),

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
                  },
                ),

                SizedBox(height: 10),

                Customtextfield(
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Password should be more than 5 letters";
                    }
                  },

                  label: 'Password',
                ),

                SizedBox(height: 10),
                ButtomText(
                  onTap: () {
                    Get.toNamed('/forgot');
                  },
                  value: 'password',
                  text: 'Forgot Password?',
                ),

                SizedBox(height: 20),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      isLoading: state is AuthInitial,
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      value: 'sign in',
                      text: 'Sign In',
                    );
                  },
                ),
                SizedBox(height: 30),

                Row(
                  children: [
                    OrDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    OrDivider(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SocialButton(
                      value: 'google',
                      text: 'Google',
                      icon: Icons.g_mobiledata,
                    ),
                    SizedBox(width: 10),

                    SocialButton(
                      value: 'Apple',
                      text: 'Apple',
                      icon: Icons.apple,
                    ),
                  ],
                ),

                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QText(text: 'Don’t have an account?'),
                    SizedBox(width: 10),
                    ButtomText(
                      onTap: () {
                        Get.toNamed('/register');
                      },
                      value: 'Sign Up',
                      text: 'Sign Up',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
