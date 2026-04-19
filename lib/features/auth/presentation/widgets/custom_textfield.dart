import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class Customtextfield extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const Customtextfield({
    super.key,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.isPassword = false,
    this.validator,
    this.controller,
  });

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && isObscure,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: primaryColor.withValues(alpha: 0.6)),
        hintText: widget.hintText,
        prefixIcon: (widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                child: Icon(
                  isObscure ? Icons.remove_red_eye : Icons.visibility_off,
                ),
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.6),
            width: 2.w,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.6),
            width: 2.w,
          ),
        ),
      ),
    );
  }
}
