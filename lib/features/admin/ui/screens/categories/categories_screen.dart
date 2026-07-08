import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../logic/admin_cubit.dart';
import '../../../data/models/category_model.dart';
import '../../widgets/category_bottom_sheet.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.admCategories,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: blackDegree,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: AppLocalizations.of(context)!.admSearchCategoriesHint,
            onChanged: (v) => context.read<AdminCubit>().setCategoriesQuery(v),
          ),
          Expanded(
            child: BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                final cubit = context.read<AdminCubit>();
                if (cubit.categoriesList.isEmpty &&
                    state is GetCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (cubit.categoriesList.isEmpty &&
                    state is GetCategoriesError) {
                  return Center(child: Text(state.error));
                }
                if (cubit.categoriesList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64.r,
                          color: subTitleColor,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          AppLocalizations.of(context)!.admNoCategoriesFound,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: subTitleColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppLocalizations.of(context)!.admTapToAddCategory,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final active = cubit.categoriesByActive(active: true);
                final inactive = cubit.categoriesByActive(active: false);
                return _CategoriesBody(active: active, inactive: inactive);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryBottomSheet(context),
        backgroundColor: commonColor,
        child: Icon(Icons.add, color: Colors.white, size: 28.r),
      ),
    );
  }
}

class _CategoriesBody extends StatelessWidget {
  final List<CategoryModel> active;
  final List<CategoryModel> inactive;

  const _CategoriesBody({required this.active, required this.inactive});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (active.isNotEmpty) ...[
          _SectionHeader(
            title:
                '${AppLocalizations.of(context)!.admActive} (${active.length})',
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CategoryTile(category: active[index]),
              childCount: active.length,
            ),
          ),
        ],
        if (inactive.isNotEmpty) ...[
          _SectionHeader(
            title:
                '${AppLocalizations.of(context)!.admInactive} (${inactive.length})',
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CategoryTile(category: inactive[index]),
              childCount: inactive.length,
            ),
          ),
        ],
        SliverPadding(padding: EdgeInsets.only(bottom: 80.h)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: AppTextStyles.t_14w600.copyWith(color: subTitleColor),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Dismissible(
        key: ValueKey(category.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.w),
          decoration: BoxDecoration(
            color: redDegree,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.delete_outline, color: Colors.white, size: 24.r),
        ),
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.admDeleteCategory),
              content: Text(l10n.admDeleteCategoryConfirm(category.nameEN)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.admCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    l10n.admDeleteCategory,
                    style: TextStyle(color: redDegree),
                  ),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) => cubit.deleteCategory(category.id),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: commonColor.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: commonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: category.icon != null && category.icon!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          category.icon!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Icon(
                            Icons.category_outlined,
                            color: commonColor,
                            size: 22.r,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.category_outlined,
                        color: commonColor,
                        size: 22.r,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.nameEN, style: AppTextStyles.t_14w600),
                    if (category.nameAR.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          category.nameAR,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: subTitleColor,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    SizedBox(height: 2.h),
                    Text(
                      'Order: ${category.order}  |  Products: ${category.productsCount}',
                      style: TextStyle(fontSize: 11.sp, color: subTitleColor),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: category.isActive,
                activeThumbColor: commonColor,
                onChanged: (val) =>
                    cubit.toggleCategoryActive(category.id, val),
              ),
              SizedBox(width: 4.w),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: commonColor,
                  size: 20.sp,
                ),
                onPressed: () =>
                    showCategoryBottomSheet(context, category: category),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
