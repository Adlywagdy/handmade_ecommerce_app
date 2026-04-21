import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';

class SocialButton extends StatelessWidget {
  final String text;

  final IconData icon;
  const SocialButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {

          final state =context.read<AuthCubit>().state;
           if (state is! AuthLoading) {
            context.read<AuthCubit>().signInWithGoogle();
             print("$text");
               }
        },
        child: CircleAvatar(
          radius: 40.r,
          backgroundColor:backGroundColor ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black),
              Text(
                text,
                style: AppTextStyles.t_14w600.copyWith(color: darkblue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
