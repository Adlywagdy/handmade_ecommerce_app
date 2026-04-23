import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/extension/validation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/buttom_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/divider.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _formkey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 80,
          bottom: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: backGroundColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Image.asset('assets/icons/Icon1.png'),
                ),
                SizedBox(height: 20.h),
                Text('Welcome to Ayady', style: AppTextStyles.t_30w700),
                SizedBox(height: 16.h),

                Text(
                  'Please enter your details to continue',
                  style: AppTextStyles.t_16w400.copyWith(color: darkblue),
                ),
                SizedBox(height: 30.h),

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

                SizedBox(height: 15.h),

                Customtextfield(
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Password should be more than 5 letters";
                    }
                    return null;
                  },

                  label: 'Password',
                ),

                SizedBox(height: 10.h),
                ButtomText(
                  onTap: () {
                    Get.toNamed(AppRoutes.forgotPassword);
                  },

                  text: 'Forgot Password?',
                ),

                SizedBox(height: 20.h),

                BlocConsumer<AuthCubit, AuthState>(
                   listener: (context, state) {
                    if (state is LoginSuccessState) {
                       ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Success')),
                        );
                        Get.offAllNamed(AppRoutes.customerHome);
                   } else if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    }
                    else if (state is GoogleLoginSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Google Sign In Success')),
                    );
                       Get.offAllNamed(AppRoutes.customerHome);
                    } 
                        else if (state is GoogleLoginErrorState) {
                         ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(state.message)),
                         );
                         }
                   },


                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return CustomElevatedButton(
                      onPressed:isLoading
                        ? null
                        : () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          context.read<AuthCubit>().login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },

                      buttoncolor: primaryColor,
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.t_16w700.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30.h),

                Row(
                  children: [
                    OrDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8).w,
                      child: Text(
                        'Or continue with',
                        style: AppTextStyles.t_14w400.copyWith(color: darkblue),
                      ),
                    ),
                    OrDivider(),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    SocialButton(
                        text: 'Google',
                        icon: Icons.g_mobiledata,
                        onTap: () {
                        final state = context.read<AuthCubit>().state;
                        if (state is! AuthLoading) {
                          context.read<AuthCubit>().signInWithGoogle();
                        }
                       },
                        ),
                    SizedBox(width: 10.h),
                  ],
                ),

                SizedBox(height: 30.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTextStyles.t_14w400.copyWith(color: darkblue),
                    ),
                    SizedBox(width: 10.h),
                    ButtomText(
                      onTap: () {
                        Get.toNamed(AppRoutes.register);
                      },

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
