import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_categorieslistdata.dart';

class Searchcategorieslist extends StatefulWidget {
  const Searchcategorieslist({super.key});

  @override
  State<Searchcategorieslist> createState() => _SearchcategorieslistState();
}

int selectedIndex = 0;

class _SearchcategorieslistState extends State<Searchcategorieslist> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorieslistdata.length,
      itemBuilder: (context, index) {
        return InkWell(
          onLongPress: () {
            // show category details
          },

          onTap: () {
            setState(() {
              selectedIndex = index;
              // trigger search filter based on selected category
            });
          },
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200).r,
              color: selectedIndex == index
                  ? commonColor
                  : commonColor.withValues(alpha: 0.1),
            ),
            child: Row(
              mainAxisSize: .min,
              spacing: 2.w,
              children: [
                Text(
                  categorieslistdata[index].categorytitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.t_14w600.copyWith(
                    color: selectedIndex == index ? Colors.white : commonColor,
                  ),
                ),

                Icon(
                  Icons.keyboard_arrow_down,
                  color: selectedIndex == index ? Colors.white : commonColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
