import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class OrderDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valuecolor;
  const OrderDetailsRow({
    super.key,
    required this.title,
    required this.value,
    this.valuecolor = blackDegree,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.t_14w400.copyWith(color: darkblue)),
        Text(value, style: AppTextStyles.t_14w600.copyWith(color: valuecolor)),
      ],
    );
  }
}
