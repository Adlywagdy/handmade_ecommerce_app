import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/extension/validation.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/buttom_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/divider.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/social_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String? _selectedRole;
  bool _isChecked = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showTermsSnack() {
    showSnack(
      title: 'Terms Required',
      message: 'You must agree to the terms first.',
      bgColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  void _showRoleSnack() {
    showSnack(
      title: 'Choose Role',
      message: 'Please choose Customer or Seller first.',
      bgColor: Colors.orange,
      icon: Icons.person_add_alt_1,
    );
  }

  void _showRegisterErrorSnack(String message) {
    showSnack(
      title: 'Register Failed',
      message: message,
      bgColor: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  void _goToNextScreenByRole(String role) {
    if (role == 'customer') {
      showSnack(
        title: 'Account Created',
        message: 'Welcome to SoulCrafts.',
        bgColor: Colors.green,
        icon: Icons.check_circle_outline,
      );

      Get.offAllNamed(AppRoutes.customerlayout);
    } else {
      showSnack(
        title: 'Seller Request Sent',
        message: 'Your seller request is waiting for admin approval.',
        bgColor: Colors.green,
        icon: Icons.check_circle_outline,
      );

      Get.offAllNamed(AppRoutes.customerlayout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
        ),
        title: Text(
          'Create Account',
          style: AppTextStyles.t_16w700.copyWith(color: primaryColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).w,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join SoulCrafts',
                  style: AppTextStyles.t_30w700.copyWith(),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Experience the elegance of handcrafted items',
                  style: AppTextStyles.t_14w400.copyWith(color: blackDegree),
                ),
                SizedBox(height: 12.h),

                Customtextfield(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'John Doe',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                Customtextfield(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: "example@mail.com",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.emailValid()) {
                      return 'Email isn’t valid';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                Customtextfield(
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  label: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password should be more than 5 letters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                Text(
                  'Register As',
                  style: AppTextStyles.t_12w400.copyWith(
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 10.h),

                Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'customer';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'customer'
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                'Customer',
                                style: AppTextStyles.t_16w700.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'seller';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'seller'
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                'Seller',
                                style: AppTextStyles.t_16w700.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                Row(
                  children: [
                    Checkbox(
                      checkColor: commonColor,
                      activeColor: Colors.white,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the terms and conditions',
                        style: AppTextStyles.t_12w400.copyWith(
                          color: primaryColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is RegisterSuccessState) {
                      _goToNextScreenByRole(state.role);
                    } else if (state is RegisterErrorState) {
                      _showRegisterErrorSnack(state.message);

                      if (state.message.contains('already registered')) {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!mounted) return;
                          Get.offAllNamed(AppRoutes.login);
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return CustomElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!_isChecked) {
                                _showTermsSnack();
                                return;
                              }

                              if (_selectedRole == null) {
                                _showRoleSnack();
                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().register(
                                      fullName: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                      role: _selectedRole!,
                                    );
                              }
                            },
                      buttoncolor: primaryColor,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Create Account',
                              style: AppTextStyles.t_16w500.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),

                SizedBox(height: 20.h),

                Row(
                  children: [
                    const OrDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8).w,
                      child: Text(
                        'Or continue with',
                        style: AppTextStyles.t_14w400.copyWith(color: darkblue),
                      ),
                    ),
                    const OrDivider(),
                  ],
                ),

                SizedBox(height: 10.h),

                Row(
                  children: [
                    SocialButton(
                      text: 'Google',
                      icon: Icons.g_mobiledata,
                      onTap: () {
                        final state = context.read<AuthCubit>().state;
                        if (state is AuthLoading) return;

                        if (!_isChecked) {
                          _showTermsSnack();
                          return;
                        }

                        if (_selectedRole == null) {
                          _showRoleSnack();
                          return;
                        }

                        context.read<AuthCubit>().registerWithGoogle(
                              selectedRole: _selectedRole!,
                            );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppTextStyles.t_12w400.copyWith(
                        color: primaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    ButtomText(
                      text: 'Log In',
                      onTap: () {
                        Get.back();
                      },
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