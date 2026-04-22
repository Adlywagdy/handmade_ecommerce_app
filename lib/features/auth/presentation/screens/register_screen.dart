import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/extension/validation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/buttom_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/register_toggle.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

late GlobalKey<FormState> _formkey;
late TextEditingController _passwordController;
late TextEditingController _emailController;

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
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
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Ayady',
                  style: AppTextStyles.t_30w700.copyWith(color: primaryColor),
                ),

                SizedBox(height: 12.h),
                Text(
                  'Experience the elegance of handcrafted items',
                  style: AppTextStyles.t_14w400.copyWith(
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 12.h),
                Customtextfield(
                  label: 'Full Name',
                  hintText: 'JohnDoe',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                Customtextfield(
                  controller: _emailController,
                  label: 'EMAIL ADDRESS',
                  hintText: 'example@mail.com',
                  prefixIcon: Icon(
                    Icons.email,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.emailValid()) {
                      return "Email isn't valid";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                Customtextfield(
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password should be more than 5 letters";
                    }
                    return null;
                  },
                  label: 'Password',
                ),
                SizedBox(height: 15.h),
                Text(
                  'Register as:',
                  style: AppTextStyles.t_12w400.copyWith(
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 10.h),
                RegisterToggle(),
                SizedBox(height: 20.h),
                AgreeTermsRow(),

                SizedBox(height: 30.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          context.read<AuthCubit>().register(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      buttoncolor: primaryColor,
                      child: Text(
                        'Create Account',
                        style: AppTextStyles.t_16w500.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 30.h),
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

class AgreeTermsRow extends StatefulWidget {
  const AgreeTermsRow({super.key});

  @override
  State<AgreeTermsRow> createState() => _AgreeTermsRowState();
}

bool isChecked = false;

class _AgreeTermsRowState extends State<AgreeTermsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: commonColor,
          activeColor: Colors.white,
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        SizedBox(width: 8.w),
        Text(
          'I agree to the Terms of Service and Privacy Policy.',
          style: AppTextStyles.t_12w400.copyWith(
            color: primaryColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
