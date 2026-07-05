import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import '../../../../../cubit/admin_cubit.dart';
import '../../../../../models/sellers_model.dart';
import 'info_row.dart';
import 'section_widget.dart';
import 'seller_action_buttons.dart';
import 'seller_header_card.dart';

class SellerDetailsBody extends StatelessWidget {
  final SellerData seller;
  final AdminCubit cubit;

  const SellerDetailsBody({
    super.key,
    required this.seller,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    // True while an approve/reject is running for this seller.
    final bool isBusy = cubit.isProcessing(seller.id);

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        SellerHeaderCard(seller: seller),
        SizedBox(height: 16.h),

        SectionWidget(
          title: AppLocalizations.of(context)!.admContactSectionTitle,
          rows: _buildContactRows(context),
        ),
        SizedBox(height: 12.h),

        SectionWidget(
          title: AppLocalizations.of(context)!.admBusinessSectionTitle,
          rows: _buildBusinessRows(context),
        ),
        SizedBox(height: 12.h),

        SectionWidget(
          title: AppLocalizations.of(context)!.admTimelineSectionTitle,
          rows: _buildTimelineRows(context),
        ),
        SizedBox(height: 20.h),

        if (seller.status == SellerStatus.pending)
          SellerActionButtons(
            isBusy: isBusy,
            onApprove: () => cubit.approveSeller(seller.id),
            onReject: () => cubit.rejectSeller(seller.id),
          ),
      ],
    );
  }

  // Contact info rows. "Location" is only added when at least one of
  // city/country is set, so we build this list step by step.
  List<InfoRow> _buildContactRows(BuildContext context) {
    final List<InfoRow> rows = [
      InfoRow(
        label: AppLocalizations.of(context)!.admEmailLabel,
        value: seller.email,
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admPhoneLabel,
        value: seller.phone ?? '—',
      ),
    ];

    final bool hasLocation = seller.city != null || seller.country != null;
    if (hasLocation) {
      final String city = seller.city ?? '';
      final String country = seller.country ?? '';
      final String separator =
          (seller.city != null && seller.country != null) ? ', ' : '';
      rows.add(
        InfoRow(
          label: AppLocalizations.of(context)!.admLocationLabel,
          value: '$city$separator$country',
        ),
      );
    }

    return rows;
  }

  // Business-related rows.
  List<InfoRow> _buildBusinessRows(BuildContext context) {
    return [
      InfoRow(
        label: AppLocalizations.of(context)!.admSpecialtyLabel,
        value: seller.specialty,
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admRatingLabel,
        value: seller.rating.toStringAsFixed(1),
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admTotalSalesLabel,
        value: seller.totalSales.toString(),
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admTotalProductsLabel,
        value: seller.totalProducts.toString(),
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admWalletBalanceLabel,
        value: '${seller.walletBalance.toStringAsFixed(2)} EGP',
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admCommissionRateLabel,
        value: '${(seller.commissionRate * 100).toStringAsFixed(1)}%',
      ),
    ];
  }

  // Timeline rows (submitted + approved + current status).
  List<InfoRow> _buildTimelineRows(BuildContext context) {
    final String submitted =
        seller.submittedDate.isNotEmpty ? seller.submittedDate : '—';
    final String approved = _formatApprovedDate(seller.approvedAt);

    return [
      InfoRow(
        label: AppLocalizations.of(context)!.admSubmittedDateLabel,
        value: submitted,
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admApprovedDateLabel,
        value: approved,
      ),
      InfoRow(
        label: AppLocalizations.of(context)!.admStatusLabel,
        value: seller.status.name,
      ),
    ];
  }

  // Turns an approvedAt DateTime into "YYYY-MM-DD", or "—" if null.
  String _formatApprovedDate(DateTime? date) {
    if (date == null) return '—';
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
