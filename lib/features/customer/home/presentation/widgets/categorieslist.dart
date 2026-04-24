import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';

class HomeCategoriesList extends StatefulWidget {
  const HomeCategoriesList({super.key});

  @override
  State<HomeCategoriesList> createState() => _HomeCategoriesListState();
}

class _HomeCategoriesListState extends State<HomeCategoriesList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: searchCubit.categoriesList.length,
      itemBuilder: (context, index) {
        final category = searchCubit.categoriesList[index];
        final iconPath = category.categoryiconpath;

        return Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });

              searchCubit.selectedCategory = category;
              searchCubit.filterproducts(categoryname: category.categorytitle);
              Get.toNamed(AppRoutes.customerSearch);
            },
            child: Column(
              spacing: 8.h,
              children: [
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: selectedIndex == index
                      ? commonColor
                      : commonColor.withValues(alpha: 0.1),
                  child: iconPath == null || iconPath.isEmpty
                      ? Icon(
                          Icons.category_outlined,
                          color: selectedIndex == index
                              ? Colors.white
                              : commonColor,
                        )
                      : Image.network(
                          iconPath,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.category_outlined,
                            color: selectedIndex == index
                                ? Colors.white
                                : commonColor,
                          ),
                        ),
                ),
                Text(
                  category.categorytitle,
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
