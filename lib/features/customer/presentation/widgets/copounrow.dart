import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';

class CopounRow extends StatefulWidget {
  const CopounRow({super.key});

  @override
  State<CopounRow> createState() => _CopounRowState();
}

late TextEditingController? controller;

class _CopounRowState extends State<CopounRow> {
  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
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
              // apply copoun logic
              // String copounCode = controller.text;
            },
            child: CustomTextContainer(
              text: "Apply",
              textstyle: AppTextStyles.t_16w700.copyWith(color: commonColor),
              horizontalpadding: 4.w,
              verticalpadding: 8.h,
              backGroundColor: commonColor.withValues(alpha: .1),
            ),
          ),
        ),
      ],
    );
  }
}
