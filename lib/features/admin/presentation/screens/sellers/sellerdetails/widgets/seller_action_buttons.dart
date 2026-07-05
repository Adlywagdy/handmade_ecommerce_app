import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import '../../../../../../../core/theme/colors.dart';
import '../../../../widgets/custom_action_button.dart';

// The Approve / Reject row shown at the bottom of the seller details page.
// Used only when the seller is still pending.
class SellerActionButtons extends StatelessWidget {
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const SellerActionButtons({
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
          label: AppLocalizations.of(context)!.admApproveBtn,
          color: greenDegree,
          isLoading: isBusy,
          onTap: onApprove,
        ),
        SizedBox(width: 12.w),
        ActionButton(
          label: AppLocalizations.of(context)!.admRejectBtn,
          color: redDegree,
          style: ActionButtonStyle.outlined,
          isLoading: isBusy,
          onTap: onReject,
        ),
      ],
    );
  }
}
