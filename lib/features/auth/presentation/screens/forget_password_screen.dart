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
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showForgotPasswordSuccessSnack() {
    showSnack(
      title: 'Reset Link Sent',
      message: 'Please check your email to reset your password.',
      bgColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  void _showForgotPasswordErrorSnack(String message) {
    showSnack(
      title: 'Password Recovery Failed',
      message: message,
      bgColor: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(
            email: _emailController.text.trim().toLowerCase(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccessState) {
            _showForgotPasswordSuccessSnack();

            Get.toNamed(
              AppRoutes.verifyPassword,
              arguments: _emailController.text.trim().toLowerCase(),
            );
          } else if (state is ForgotPasswordErrorState) {
            _showForgotPasswordErrorSnack(state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(16).w,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Password Recovery',
                      style: AppTextStyles.t_30w700.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Enter your email address to receive a password reset link',
                      style: AppTextStyles.t_12w500.copyWith(
                        color: primaryColor.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Customtextfield(
                      controller: _emailController,
                      label: 'Email Address',
                      hintText: 'example@mail.com',
                      prefixIcon: Icon(
                        Icons.email,
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: keyboardHeight > 0 ? keyboardHeight + 16.h : 16.h,
        ),
        child: SafeArea(
          top: false,
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final bool isLoading = state is AuthLoading;

              return CustomElevatedButton(
                onPressed: isLoading ? null : _submitForgotPassword,
                buttoncolor: primaryColor,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Send Code',
                        style: AppTextStyles.t_16w500.copyWith(
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}