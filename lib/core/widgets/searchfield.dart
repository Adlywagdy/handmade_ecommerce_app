import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class SearchField extends StatelessWidget {
  final Color? fillColor;
  final Color? iconColor;
  final bool autofocus;
  final bool readOnly;
  final Color? cursorColor;
  final String hintText;

  final TextStyle? textstyle;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  const SearchField({
    super.key,
    this.fillColor,
    required this.hintText,
    this.iconColor,
    this.autofocus = false,

    this.cursorColor,
    this.onTap,
    this.onChanged,
    this.textstyle,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,

      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      autocorrect: true,
      cursorColor: cursorColor ?? commonColor,
      decoration: InputDecoration(
        hint: Text(hintText, style: textstyle),
        fillColor: fillColor ?? commonColor.withValues(alpha: .1),
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          color: iconColor ?? commonColor.withValues(alpha: .6),
        ),

        border: OutlineInputBorder(
          borderSide: .none,
          borderRadius: BorderRadius.circular(12).r,
        ),
      ),
    );
  }
}
