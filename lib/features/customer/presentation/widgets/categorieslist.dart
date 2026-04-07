import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_categorieslistdata.dart';

class HomeCategoriesList extends StatefulWidget {
  const HomeCategoriesList({super.key});

  @override
  State<HomeCategoriesList> createState() => _HomeCategoriesListState();
}

int selectedIndex = 0;

class _HomeCategoriesListState extends State<HomeCategoriesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorieslistdata.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 13.0).w,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Column(
              spacing: 8.h,
              children: [
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: selectedIndex == index
                      ? commonColor
                      : commonColor.withValues(alpha: 0.1),
                  child: SvgPicture.asset(
                    categorieslistdata[index].categoryiconpath!,
                    colorFilter: .mode(
                      selectedIndex == index ? Colors.white : commonColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  categorieslistdata[index].categorytitle,
                  style: AppTextStyles.t_12w500.copyWith(color: darkblue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
