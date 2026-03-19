import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.r),
              color: selectedIndex == index
                  ? commonColor
                  : commonColor.withValues(alpha: 0.1),
            ),
            child: Row(
              mainAxisSize: .min,

              children: [
                Text(
                  categorieslistdata[index].categorytitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : commonColor,
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
                selectedIndex == index
                    ? SizedBox()
                    : Icon(
                        Icons.keyboard_arrow_down,
                        color: selectedIndex == index
                            ? Colors.white
                            : commonColor,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
