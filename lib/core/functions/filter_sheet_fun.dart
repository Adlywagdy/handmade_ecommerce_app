import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

void openFilterSheet(
  BuildContext context, {
  required SearchCubit searchCubit,
  String? selectedCategory,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: customerbackGroundColor,
    isScrollControlled: true,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      return FilterSheet(
        searchCubit: searchCubit,
        selectedcategory: selectedCategory,
      );
    },
  );
}

class FilterSheet extends StatefulWidget {
  final SearchCubit searchCubit;
  final String? selectedcategory;
  const FilterSheet({
    super.key,
    required this.searchCubit,
    this.selectedcategory,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late TextEditingController? mincontroller;
  late TextEditingController? maxcontroller;

  double? selectedrating;
  List<double?> ratingOptions = [null, 1, 2, 3, 4, 5];
  @override
  void initState() {
    mincontroller = TextEditingController();
    maxcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    mincontroller!.dispose();
    maxcontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        top: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      child: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: commonColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                context.l10n.filterAndSort,
                style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
              ),
              SizedBox(height: 14.h),
              Text(
                context.l10n.rating,
                style: AppTextStyles.t_14w600.copyWith(color: blackDegree),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(
                  ratingOptions.length,
                  (index) => ChoiceChip(
                    color: WidgetStatePropertyAll(customerbackGroundColor),
                    checkmarkColor: commonColor,
                    elevation: 1,

                    label: Text(
                      ratingOptions[index] == null
                          ? context.l10n.any
                          : '${ratingOptions[index]}+',
                      style: AppTextStyles.t_14w500.copyWith(
                        color: blackDegree,
                      ),
                    ),
                    selected: selectedrating == ratingOptions[index],
                    onSelected: (selected) {
                      setState(() {
                        selectedrating = selected
                            ? ratingOptions[index]
                            : selectedrating;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                context.l10n.priceSort,
                style: AppTextStyles.t_14w600.copyWith(color: blackDegree),
              ),
              SizedBox(height: 8.h),
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: PriceTextField(
                      controller: mincontroller,
                      hint: context.l10n.min,
                    ),
                  ),
                  Text(
                    context.l10n.to,
                    style: AppTextStyles.t_14w500.copyWith(color: blackDegree),
                  ),
                  Expanded(
                    child: PriceTextField(
                      controller: maxcontroller,
                      hint: context.l10n.max,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: commonColor.withValues(alpha: .5),
                        ),
                        foregroundColor: commonColor,
                      ),
                      onPressed: () {
                        Get.close(1);
                      },
                      child: Text(context.l10n.cancel),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: commonColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (!(formkey.currentState?.validate() ?? false)) {
                          return;
                        }

                        final effectiveCategory =
                            widget.selectedcategory ??
                            widget.searchCubit.selectedCategory?.categorytitle;

                        Get.close(1);

                        widget.searchCubit.filterproducts(
                          categoryname: effectiveCategory,
                          minprice:
                              mincontroller?.text != null &&
                                  mincontroller!.text.isNotEmpty
                              ? double.tryParse(mincontroller!.text)
                              : null,
                          maxprice:
                              maxcontroller?.text != null &&
                                  maxcontroller!.text.isNotEmpty
                              ? double.tryParse(maxcontroller!.text)
                              : null,
                          rating: selectedrating,
                        );
                      },
                      child: Text(context.l10n.apply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  const PriceTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.contains('-')) {
            return context.l10n.mustBePositive;
          }
        }

        return null;
      },
      keyboardType: TextInputType.number,
      controller: controller,
      cursorColor: commonColor,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.t_14w500.copyWith(color: blackDegree),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: commonColor.withValues(alpha: .5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: commonColor.withValues(alpha: .5)),
        ),
      ),
    );
  }
}
