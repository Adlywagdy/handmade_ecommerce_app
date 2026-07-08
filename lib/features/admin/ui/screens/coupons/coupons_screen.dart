import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../logic/admin_cubit.dart';
import '../../../data/models/coupon_model.dart';
import '../../widgets/coupon_bottom_sheet.dart';

class AdminCouponsScreen extends StatelessWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Coupons',
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
            hintText: 'Search coupons...',
            onChanged: (v) => context.read<AdminCubit>().setCouponsQuery(v),
          ),
          Expanded(
            child: BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                final cubit = context.read<AdminCubit>();
                if (cubit.couponsList.isEmpty &&
                    state is GetCouponsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (cubit.couponsList.isEmpty &&
                    state is GetCouponsError) {
                  return Center(child: Text(state.error));
                }
                if (cubit.couponsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 64.r,
                          color: subTitleColor,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No coupons found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: subTitleColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Tap + to add a coupon',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final active = cubit.couponsByActive(active: true);
                final inactive = cubit.couponsByActive(active: false);
                return _CouponsBody(active: active, inactive: inactive);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCouponBottomSheet(context),
        backgroundColor: commonColor,
        child: Icon(Icons.add, color: Colors.white, size: 28.r),
      ),
    );
  }
}

class _CouponsBody extends StatelessWidget {
  final List<CouponModel> active;
  final List<CouponModel> inactive;

  const _CouponsBody({required this.active, required this.inactive});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (active.isNotEmpty) ...[
          _SectionHeader(title: 'Active (${active.length})'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CouponTile(coupon: active[index]),
              childCount: active.length,
            ),
          ),
        ],
        if (inactive.isNotEmpty) ...[
          _SectionHeader(title: 'Inactive (${inactive.length})'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CouponTile(coupon: inactive[index]),
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

class _CouponTile extends StatelessWidget {
  final CouponModel coupon;
  const _CouponTile({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Dismissible(
        key: ValueKey(coupon.id),
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
              title: const Text('Delete Coupon'),
              content: Text('Delete "${coupon.code}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: redDegree),
                  ),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) => cubit.deleteCoupon(coupon.id),
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
                child: Icon(
                  Icons.local_offer_outlined,
                  color: commonColor,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.code,
                      style: AppTextStyles.t_14w600,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      coupon.discountType == DiscountType.percentage
                          ? '${coupon.discountValue.toStringAsFixed(0)}% off'
                          : '${coupon.discountValue.toStringAsFixed(2)} EGP off',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: subTitleColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _buildSubtitle(coupon),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: coupon.isActive,
                activeThumbColor: commonColor,
                onChanged: (val) =>
                    cubit.toggleCouponActive(coupon.id, val),
              ),
              SizedBox(width: 4.w),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: commonColor,
                  size: 20.sp,
                ),
                onPressed: () =>
                    showCouponBottomSheet(context, coupon: coupon),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildSubtitle(CouponModel coupon) {
    final parts = <String>[];
    if (coupon.maxUses > 0) {
      parts.add('Max: ${coupon.maxUses}');
    }
    if (coupon.minOrderAmount > 0) {
      parts.add('Min: ${coupon.minOrderAmount.toStringAsFixed(0)} EGP');
    }
    if (coupon.expiryDate != null) {
      parts.add('Exp: ${DateFormat('MMM d, yyyy').format(coupon.expiryDate!)}');
    }
    return parts.isEmpty ? 'Unlimited' : parts.join('  •  ');
  }
}
