import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/cart/cart_cubit/cart_cubit.dart';

class CopounRow extends StatefulWidget {
  final void Function()? onTap;
  const CopounRow({super.key, this.onTap});

  @override
  State<CopounRow> createState() => _CopounRowState();
}

class _CopounRowState extends State<CopounRow> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            cursorColor: commonColor,

            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              filled: true,
              hint: Text(
                'Promo code',
                style: AppTextStyles.t_14w400.copyWith(color: subTitleColor),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: commonColor),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: commonColor.withValues(alpha: .2),
                ),
              ),
              border: OutlineInputBorder(
                gapPadding: 16.w,
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: commonColor.withValues(alpha: .2),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              final coupon = controller.text.trim();
              if (coupon.isEmpty) {
                showSnack(
                  title: "Error",
                  message: "Please enter a promo code",
                  bgColor: Colors.red,
                  icon: Icons.error,
                );
              } else {
                BlocProvider.of<CartCubit>(context).getOrderSummary(
                  products: BlocProvider.of<CartCubit>(
                    context,
                  ).cartProductsList,
                  coupon: coupon,
                  showCouponFeedback: true,
                );
              }
              controller.clear();
            },
            child: CustomTextContainer(
              text: "Apply",
              textstyle: AppTextStyles.t_16w700.copyWith(color: commonColor),
              horizontalpadding: 4.h,
              verticalpadding: 12.h,
              backGroundColor: commonColor.withValues(alpha: .1),
            ),
          ),
        ),
      ],
    );
  }
}
