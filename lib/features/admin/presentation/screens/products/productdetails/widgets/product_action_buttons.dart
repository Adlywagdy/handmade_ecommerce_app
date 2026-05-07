import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import '../../../../widgets/custom_action_button.dart';

class ProductActionButtons extends StatelessWidget {
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ProductActionButtons({
    super.key,
    required this.isBusy,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          label: context.l10n.approve,
          color: greenDegree,
          isLoading: isBusy,
          onTap: onApprove,
        ),
        SizedBox(width: 12.w),
        ActionButton(
          label: context.l10n.reject,
          color: redDegree,
          style: ActionButtonStyle.outlined,
          isLoading: isBusy,
          onTap: onReject,
        ),
      ],
    );
  }
}
