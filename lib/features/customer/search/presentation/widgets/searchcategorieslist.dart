import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';

class Searchcategorieslist extends StatefulWidget {
  const Searchcategorieslist({super.key});
  @override
  State<Searchcategorieslist> createState() => _SearchcategorieslistState();
}

class _SearchcategorieslistState extends State<Searchcategorieslist> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<SearchCubit>(context).selectedCategory != null) {
      final selected = BlocProvider.of<SearchCubit>(context).selectedCategory!;
      final foundIndex = BlocProvider.of<SearchCubit>(
        context,
      ).categoriesList.indexOf(selected);
      selectedIndex = foundIndex >= 0 ? foundIndex : 0;
    } else {
      selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: BlocProvider.of<SearchCubit>(context).categoriesList.length,
      itemBuilder: (context, index) {
        return Builder(
          builder: (itemContext) {
            return GestureDetector(
              onLongPressStart: (_) {
                FocusScope.of(context).unfocus();
                final subcategories = BlocProvider.of<SearchCubit>(
                  context,
                ).categoriesList[index].subcategories;
                if (subcategories != null && subcategories.isNotEmpty) {
                  final overlay = Overlay.of(
                    context,
                  ).context.findRenderObject();
                  final itemRenderObject = itemContext.findRenderObject();
                  if (overlay is! RenderBox || itemRenderObject is! RenderBox) {
                    return;
                  }

                  final Offset itemTopLeft = itemRenderObject.localToGlobal(
                    Offset.zero,
                    ancestor: overlay,
                  );
                  final Offset itemBottomRight = itemRenderObject.localToGlobal(
                    itemRenderObject.size.bottomRight(Offset.zero),
                    ancestor: overlay,
                  );

                  final RelativeRect itemPosition = RelativeRect.fromLTRB(
                    itemTopLeft.dx,
                    itemBottomRight.dy,
                    overlay.size.width - itemBottomRight.dx,
                    overlay.size.height - itemBottomRight.dy,
                  );

                  showMenu(
                    context: context,
                    color: customerbackGroundColor,
                    position: itemPosition,
                    items: subcategories
                        .map(
                          (category) => PopupMenuItem(
                            child: Text(category.categorytitle),
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                BlocProvider.of<SearchCubit>(
                                  context,
                                ).selectedCategory = category;
                              });
                              BlocProvider.of<SearchCubit>(
                                context,
                              ).filterproducts(
                                categoryname: category.categorytitle,
                              );
                            },
                          ),
                        )
                        .toList(),
                  );
                } else {
                  setState(() {
                    selectedIndex = index;
                    BlocProvider.of<SearchCubit>(
                      context,
                    ).selectedCategory = BlocProvider.of<SearchCubit>(
                      context,
                    ).categoriesList[index];
                  });
                  BlocProvider.of<SearchCubit>(context).filterproducts(
                    categoryname: BlocProvider.of<SearchCubit>(
                      context,
                    ).categoriesList[index].categorytitle,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: commonColor,
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      duration: const Duration(seconds: 2),
                      content: Text(
                        'No subcategories found. Showing all items in this category.',
                        style: AppTextStyles.t_14w600.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },

              onTap: () {
                setState(() {
                  selectedIndex = index;
                  BlocProvider.of<SearchCubit>(
                    context,
                  ).selectedCategory = BlocProvider.of<SearchCubit>(
                    context,
                  ).categoriesList[index];
                  BlocProvider.of<SearchCubit>(context).filterproducts(
                    categoryname: BlocProvider.of<SearchCubit>(
                      context,
                    ).categoriesList[index].categorytitle,
                  );
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
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2.w,
                  children: [
                    Text(
                      BlocProvider.of<SearchCubit>(
                        context,
                      ).categoriesList[index].categorytitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.t_14w600.copyWith(
                        color: selectedIndex == index
                            ? Colors.white
                            : commonColor,
                      ),
                    ),

                    Icon(
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
      },
    );
  }
}
