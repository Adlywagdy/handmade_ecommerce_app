import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/extension/validation.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset link sent to your email'),
              ),
            );

            Get.toNamed(
              AppRoutes.verifyPassword,
              arguments: _emailController.text.trim().toLowerCase(),
            );
          } else if (state is ForgotPasswordErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.passwordRecovery,
                      style: AppTextStyles.t_30w700.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      context.l10n.passwordRecoveryDescription,
                      style: AppTextStyles.t_12w500.copyWith(
                        color: primaryColor.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Customtextfield(
                      controller: _emailController,
                      label: context.l10n.emailAddress,
                      hintText: 'example@mail.com',
                      prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor.withValues(alpha: 0.6),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.emailIsRequired;
                        }
                        if (!value.emailValid()) {
                          return context.l10n.emailIsntValid;
                        }
                        return null;
                      },
                    ),
                    
                  ],),
                
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final bool isLoading = state is AuthLoading;

            return CustomElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().forgotPassword(
                          email: _emailController.text.trim(),
                        );
                      }
                    },
              buttoncolor: primaryColor,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      context.l10n.sendCode,
                      style: AppTextStyles.t_16w500.copyWith(
                        color: Colors.white,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
