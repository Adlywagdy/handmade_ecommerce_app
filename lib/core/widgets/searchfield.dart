import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class SearchField extends StatelessWidget {
  final Color? fillColor;
  final Color? iconColor;
  final Color? hintColor;
  final Color? cursorColor;
  final String hintText;
  final double? fontSize;
  const SearchField({
    super.key,
    this.fillColor,
    required this.hintText,
    this.iconColor,
    this.hintColor,
    this.cursorColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      autocorrect: true,
      cursorColor: cursorColor ?? commonColor,
      decoration: InputDecoration(
        hint: Text(
          hintText,
          style: TextStyle(
            color: hintColor ?? commonColor.withValues(alpha: .4),
            fontSize: fontSize ?? 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
        fillColor: fillColor ?? commonColor.withValues(alpha: .1),
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          color: iconColor ?? commonColor.withValues(alpha: .6),
        ),

        border: OutlineInputBorder(
          borderSide: .none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
