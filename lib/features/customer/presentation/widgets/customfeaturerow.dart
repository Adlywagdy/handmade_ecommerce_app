import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class CustomFeatureRow extends StatelessWidget {
  final String title;
  final String buttontext;

  final TextStyle? buttontextstyle;
  final void Function()? onTap;
  const CustomFeatureRow({
    super.key,
    required this.title,
    required this.buttontext,

    this.buttontextstyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.t_18w700.copyWith(color: blackDegree)),

        GestureDetector(
          onTap: onTap,
          child: CustomTextContainer(
            text: buttontext,
            textstyle: buttontextstyle,
          ),
        ),
      ],
    );
  }
}
