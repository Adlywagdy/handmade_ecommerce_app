import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class FavoriteButton extends StatefulWidget {
  final ProductModel product;
  const FavoriteButton({super.key, required this.product});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

bool isFavorite = false;

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
          // toggle favorite state
        });
      },
      padding: EdgeInsets.zero,

      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: 0.7),
        ),
        iconSize: WidgetStatePropertyAll(20.r),
      ),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: commonColor,
      ),
    );
  }
}
