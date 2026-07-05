import 'package:flutter/material.dart';

class OrderDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? titlestyle;
  final TextStyle? valuestyle;
  const OrderDetailsRow({
    super.key,
    required this.title,
    required this.value,
    this.titlestyle,
    this.valuestyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titlestyle),
        Text(value, style: valuestyle),
      ],
    );
  }
}
