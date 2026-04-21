import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../models/sellers_model.dart';
import '../../widgets/custom_action_button.dart';

class SellerDetailsScreen extends StatelessWidget {
  final String sellerId;

  const SellerDetailsScreen({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final cubit = context.read<AdminCubit>();
        final seller = cubit.sellerById(sellerId);
        if (seller == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Seller')),
            body: const Center(child: Text('Seller not found')),
          );
        }
        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Seller Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackDegree,
              ),
            ),
            centerTitle: true,
          ),
          body: _Body(seller: seller, cubit: cubit),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final SellerData seller;
  final AdminCubit cubit;

  const _Body({required this.seller, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final busy = cubit.isProcessing(seller.id);
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _HeaderCard(seller: seller),
        SizedBox(height: 16.h),
        _InfoSection(title: 'Contact', rows: [
          ('Email', seller.email),
          ('Phone', seller.phone ?? '—'),
          if (seller.city != null || seller.country != null)
            ('Location',
                '${seller.city ?? ''}${seller.city != null && seller.country != null ? ', ' : ''}${seller.country ?? ''}'),
        ]),
        SizedBox(height: 12.h),
        _InfoSection(title: 'Business', rows: [
          ('Specialty', seller.specialty),
          ('Rating', seller.rating.toStringAsFixed(1)),
          ('Total sales', seller.totalSales.toString()),
          ('Total products', seller.totalProducts.toString()),
          ('Wallet balance',
              '${seller.walletBalance.toStringAsFixed(2)} EGP'),
          ('Commission rate',
              '${(seller.commissionRate * 100).toStringAsFixed(1)}%'),
        ]),
        SizedBox(height: 12.h),
        _InfoSection(title: 'Timeline', rows: [
          ('Submitted',
              seller.submittedDate.isNotEmpty ? seller.submittedDate : '—'),
          (
            'Approved',
            seller.approvedAt != null
                ? '${seller.approvedAt!.year}-${seller.approvedAt!.month.toString().padLeft(2, '0')}-${seller.approvedAt!.day.toString().padLeft(2, '0')}'
                : '—',
          ),
          ('Status', seller.status.name),
        ]),
        SizedBox(height: 20.h),
        if (seller.status == SellerStatus.pending)
          Row(
            children: [
              ActionButton(
                label: 'Approve',
                color: greenDegree,
                isLoading: busy,
                onTap: () => cubit.approveSeller(seller.id),
              ),
              SizedBox(width: 12.w),
              ActionButton(
                label: 'Reject',
                color: redDegree,
                style: ActionButtonStyle.outlined,
                isLoading: busy,
                onTap: () => cubit.rejectSeller(seller.id),
              ),
            ],
          ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final SellerData seller;

  const _HeaderCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: commonColor.withValues(alpha: 0.10),
            child: Icon(Icons.person, color: commonColor, size: 32.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: blackDegree,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  seller.specialty,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: commonColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _statusColor(seller.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    seller.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(seller.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(SellerStatus s) {
    switch (s) {
      case SellerStatus.pending:
        return const Color(0xFFD97706);
      case SellerStatus.approved:
        return const Color(0xFF07880E);
      case SellerStatus.rejected:
        return const Color(0xFFD32F2F);
    }
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _InfoSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 10.h),
          for (final row in rows)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Text(
                    '${row.$1}:',
                    style: TextStyle(fontSize: 12.sp, color: subTitleColor),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      row.$2,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: blackDegree,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
