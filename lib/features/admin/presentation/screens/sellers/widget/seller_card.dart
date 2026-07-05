import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../models/sellers_model.dart';
import '../../../widgets/custom_action_button.dart';

class SellerCard extends StatelessWidget {
  final SellerData seller;
  final bool showActions;
  final Future<void> Function()? onApprove;
  final Future<void> Function()? onReject;
  final VoidCallback? onPreview;

  const SellerCard({
    super.key,
    required this.seller,
    this.showActions = true,
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
          AppLocalizations.of(context)!.admSubmittedLabel(seller.submittedDate),
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

/////////////////////////////////////////////////////////////////

class _SellerCardActions extends StatefulWidget {
  final Future<void> Function()? onApprove;
  final Future<void> Function()? onReject;

  const _SellerCardActions({
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<_SellerCardActions> createState() => _SellerCardActionsState();
}

class _SellerCardActionsState extends State<_SellerCardActions> {
  bool _approving = false;
  bool _rejecting = false;

  Future<void> _run({required bool approve, required Future<void> Function()? action}) async {
    if (action == null || _approving || _rejecting) return;
    setState(() => approve ? _approving = true : _rejecting = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => approve ? _approving = false : _rejecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _approving || _rejecting;
    return Row(
      children: [
        ActionButton(
          label: AppLocalizations.of(context)!.admApproveBtn,
          color: greenDegree,
          onTap: busy ? null   : () => _run(approve: true, action: widget.onApprove),
          isLoading: _approving,
        ),
        SizedBox(width: 12.w),
        ActionButton(
          label: AppLocalizations.of(context)!.admRejectBtn,
          color: redDegree,
          style: ActionButtonStyle.outlined,
          onTap: busy   ? null  : () => _run(approve: false, action: widget.onReject),
          isLoading: _rejecting,
        ),
      ],
    );
  }
}
