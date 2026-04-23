import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../models/sellers_model.dart';
import '../../../widgets/custom_action_button.dart';

// One tile shown in the sellers list.
// Shows: avatar, name, email, specialty, submission date, optional badge,
// and (optionally) Approve / Reject buttons.
class SellerCard extends StatelessWidget {
  final SellerData seller;
  final bool showActions;
  final bool isProcessing;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onPreview;

  const SellerCard({
    super.key,
    required this.seller,
    this.showActions = true,
    this.isProcessing = false,
    this.onApprove,
    this.onReject,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPreview,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: commonColor.withValues(alpha: 0.10)),
        ),
        child: Column(
          children: [
            _SellerCardTop(seller: seller),
            if (showActions) ...[
              SizedBox(height: 14.h),
              _SellerCardActions(
                isProcessing: isProcessing,
                onApprove: onApprove,
                onReject: onReject,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
class _SellerCardTop extends StatelessWidget {
  final SellerData seller;

  const _SellerCardTop({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: commonColor.withValues(alpha: 0.10),
          child: SvgPicture.asset('assets/images/unknown_user_icon.svg'),
        ),
        SizedBox(width: 12.w),
        Expanded(child: _SellerInfo(seller: seller)),
        _SellerBadgeColumn(seller: seller),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////
class _SellerInfo extends StatelessWidget {
  final SellerData seller;

  const _SellerInfo({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          seller.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: blackDegree,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          seller.email,
          style: TextStyle(fontSize: 12.sp, color: subTitleColor),
        ),
        SizedBox(height: 4.h),
        Text(
          seller.specialty,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: commonColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Submitted: ${seller.submittedDate}',
          style: TextStyle(fontSize: 11.sp, color: greyTextColor),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////
class _SellerBadgeColumn extends StatelessWidget {
  final SellerData seller;

  const _SellerBadgeColumn({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (seller.badge != null)
          Text(
            seller.badge!,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: seller.badge == 'URGENT' ? redDegree : subTitleColor,
            ),
          ),
        SizedBox(height: 4.h),
        Icon(Icons.chevron_right, size: 18.sp, color: subTitleColor),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////
class _SellerCardActions extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _SellerCardActions({
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          label: 'Approve',
          color: greenDegree,
          onTap: onApprove,
          isLoading: isProcessing,
        ),
        SizedBox(width: 12.w),
        ActionButton(
          label: 'Reject',
          color: redDegree,
          style: ActionButtonStyle.outlined,
          onTap: onReject,
          isLoading: isProcessing,
        ),
      ],
    );
  }
}
