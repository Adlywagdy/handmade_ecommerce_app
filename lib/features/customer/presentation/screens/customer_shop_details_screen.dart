import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/contact_seller_cubit/contact_seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/seller_profile_cubit/seller_profile_cubit.dart';

class CustomerShopDetailsScreen extends StatelessWidget {
  const CustomerShopDetailsScreen({super.key, required this.sellerId});

  final String sellerId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SellerProfileCubit()..getSellerProfileById(sellerId),
        ),
        BlocProvider(create: (context) => ContactSellerCubit()),
      ],
      child: Scaffold(
        backgroundColor: customerbackGroundColor,
        appBar: AppBar(
          backgroundColor: customerbackGroundColor,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            'Shop Details',
            style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
          ),
        ),
        body: BlocBuilder<SellerProfileCubit, SellerProfileState>(
          builder: (context, state) {
            if (state is SellerProfileInitial ||
                state is SellerProfileLoading) {
              return Center(
                child: CircularProgressIndicator(color: commonColor),
              );
            }

            if (state is SellerProfileError) {
              return _StatusView(
                title: 'Something went wrong',
                subtitle: state.message,
              );
            }

            if (state is SellerProfileNotFound) {
              return const _StatusView(
                title: 'Shop not found',
                subtitle: 'We could not load this seller right now.',
              );
            }

            if (state is! SellerProfileLoaded) {
              return const SizedBox.shrink();
            }

            return _ShopDetailsBody(seller: state.seller);
          },
        ),
      ),
    );
  }
}

class _ShopDetailsBody extends StatelessWidget {
  const _ShopDetailsBody({required this.seller});

  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SellerHeroCard(seller: seller),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'Contact',
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: seller.email,
                ),
                SizedBox(height: 12.h),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: seller.displayPhone,
                ),
                SizedBox(height: 12.h),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: seller.displayLocation,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'Shop Info',
            child: Column(
              children: [
                _DetailTile(label: 'Owner', value: seller.displayOwnerName),
                _DetailTile(label: 'Specialty', value: seller.displaySpecialty),
                _DetailTile(label: 'Badge', value: seller.displayBadge),
                _DetailTile(label: 'Status', value: seller.displayStatus),
                _DetailTile(
                  label: 'Submitted',
                  value: seller.displaySubmittedDate,
                  showDivider: false,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: seller.email.trim().isEmpty
                  ? null
                  : () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BlocProvider.value(
                        value: context.read<ContactSellerCubit>(),
                        child: _ContactSellerSheet(seller: seller),
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: commonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              icon: Icon(Icons.email_outlined, size: 20.r),
              label: Text(
                'Email Seller',
                style: AppTextStyles.t_16w600.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerHeroCard extends StatelessWidget {
  const _SellerHeroCard({required this.seller});

  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: [Colors.white, commonColor.withValues(alpha: 0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: commonColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38.r,
            backgroundColor: commonColor.withValues(alpha: 0.12),
            backgroundImage: seller.avatarUrl != null
                ? NetworkImage(seller.avatarUrl!)
                : null,
            child: seller.avatarUrl == null
                ? Icon(
                    Icons.storefront_outlined,
                    color: commonColor,
                    size: 32.r,
                  )
                : null,
          ),
          SizedBox(height: 14.h),
          Text(
            seller.displayName,
            textAlign: TextAlign.center,
            style: AppTextStyles.t_20w700.copyWith(color: blackDegree),
          ),
          SizedBox(height: 6.h),
          Text(
            seller.displaySpecialty,
            textAlign: TextAlign.center,
            style: AppTextStyles.t_14w500.copyWith(color: subTitleColor),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Rating',
                  value: seller.rating?.toStringAsFixed(1) ?? '0.0',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  label: 'Products',
                  value: '${seller.totalProducts ?? 0}',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  label: 'Sales',
                  value: '${seller.totalSales ?? 0}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.t_16w700.copyWith(color: blackDegree),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: commonColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: commonColor, size: 20.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
              ),
              SizedBox(height: 2.h),
              Text(
                value.trim().isEmpty ? 'N/A' : value,
                style: AppTextStyles.t_14w600.copyWith(color: blackDegree),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.t_14w500.copyWith(color: subTitleColor),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                value.trim().isEmpty ? 'N/A' : value,
                textAlign: TextAlign.end,
                style: AppTextStyles.t_14w600.copyWith(color: blackDegree),
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: 14.h),
          Divider(color: Colors.black12, height: 1.h),
          SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.t_16w700.copyWith(color: commonColor),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
          ),
        ],
      ),
    );
  }
}

class _ContactSellerSheet extends StatefulWidget {
  const _ContactSellerSheet({required this.seller});

  final SellerModel seller;

  @override
  State<_ContactSellerSheet> createState() => _ContactSellerSheetState();
}

class _ContactSellerSheetState extends State<_ContactSellerSheet> {
  late final TextEditingController _subjectController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: 'Custom order request');
    _messageController = TextEditingController(
      text:
          'Hello ${widget.seller.displayName},\n\nI would like to request a customized order.\n\nDetails:\n',
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactSellerCubit, ContactSellerState>(
      listener: (context, state) {
        if (state is ContactSellerSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email app opened successfully')),
          );
          Navigator.of(context).pop();
          context.read<ContactSellerCubit>().reset();
        }

        if (state is ContactSellerFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<ContactSellerCubit>().reset();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          20.h + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Send Email',
              style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
            ),
            SizedBox(height: 6.h),
            Text(
              'Write your custom request and continue in your email app.',
              style: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
            ),
            SizedBox(height: 18.h),
            _SheetTextField(
              controller: _subjectController,
              label: 'Subject',
              maxLines: 1,
            ),
            SizedBox(height: 14.h),
            _SheetTextField(
              controller: _messageController,
              label: 'Details',
              maxLines: 6,
            ),
            SizedBox(height: 18.h),
            BlocBuilder<ContactSellerCubit, ContactSellerState>(
              builder: (context, state) {
                final isLoading = state is ContactSellerLoading;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => context.read<ContactSellerCubit>().sendEmail(
                            email: widget.seller.email,
                            sellerName: widget.seller.displayName,
                            subject: _subjectController.text,
                            message: _messageController.text,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: commonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Continue to Email',
                            style: AppTextStyles.t_16w600.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.t_14w500.copyWith(color: blackDegree),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.t_12w500.copyWith(color: subTitleColor),
        filled: true,
        fillColor: customerbackGroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: commonColor),
        ),
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store_mall_directory_outlined,
              size: 44.r,
              color: commonColor,
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.t_14w500.copyWith(color: subTitleColor),
            ),
          ],
        ),
      ),
    );
  }
}
