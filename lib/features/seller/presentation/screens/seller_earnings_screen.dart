import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/utils/time_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';
import 'package:handmade_ecommerce_app/features/seller/models/seller_model.dart';
class SellerEarningsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const SellerEarningsScreen({super.key, this.onBackPressed});

  @override
  State<SellerEarningsScreen> createState() => _SellerEarningsScreenState();
}

class _SellerEarningsScreenState extends State<SellerEarningsScreen> {
  int _selectedPeriod = 0; // 0 = Weekly, 1 = Monthly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: customerbackGroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: widget.onBackPressed != null
            ? IconButton(
                onPressed: widget.onBackPressed,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: const Color(0xFF0F172A),
                  size: 20.w,
                ),
              )
            : null,
        centerTitle: true,
        title: Text(
          'Earnings',
          style: TextStyle(
            color: commonColor,
            fontSize: 20.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              decoration: BoxDecoration(
                color: commonColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: commonColor.withValues(alpha: 0.18),
                ),
              ),
              child: IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notifications),
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: commonColor,
                  size: 22.w,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SellerLoaded) {
            final stats = state.stats;
            final revenue = stats.totalRevenue;
            final completedOrdersCount = state.orders.where((o) => o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered').length;
            final avgOrderValue = completedOrdersCount > 0 ? (double.parse(revenue) / completedOrdersCount).toStringAsFixed(2) : '0.00';
            
            final recentOrders = state.orders.take(5).toList();
            final recentTransactions = recentOrders.map((o) => _Transaction(
              orderId: o.orderId.length > 5 ? '#${o.orderId.substring(0, 5)}' : '#${o.orderId}',
              amount: o.totalAmount.toStringAsFixed(2),
              date: DateTime.tryParse(o.orderDate) ?? DateTime.now(),
              isCompleted: o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered',
            )).toList();

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),

                  // ── Total Balance Card ──
                  _buildBalanceCard(revenue),
                  SizedBox(height: 20.h),

                  // ── Revenue Statistics Header + Toggle ──
                  _buildRevenueHeader(),
                  SizedBox(height: 14.h),

                  // ── Chart ──
                  _EarningsChart(stats: stats, selectedPeriod: _selectedPeriod),
                  SizedBox(height: 16.h),

                  // ── Quick Stats Row ──
                  Row(
                    children: [
                      Expanded(child: _buildQuickStatCard(
                        title: 'Orders Processed',
                        value: completedOrdersCount.toString(),
                        icon: Icons.shopping_cart_outlined,
                        iconColor: commonColor,
                        iconBgColor: commonColor.withValues(alpha: 0.1),
                      )),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickStatCard(
                        title: 'Avg. Order Value',
                        value: 'EGP $avgOrderValue',
                        icon: Icons.bar_chart_rounded,
                        iconColor: primaryColor,
                        iconBgColor: primaryColor.withValues(alpha: 0.1),
                      )),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // ── Recent Transactions Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 16.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to all transactions
                        },
                        child: Text(
                          'View All ›',
                          style: TextStyle(
                            color: commonColor,
                            fontSize: 13.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // ── Transaction Cards ──
                  if (recentTransactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Text(
                          'No recent transactions',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 14.sp,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    )
                  else
                    ...recentTransactions.map((t) => _buildTransactionCard(t)),

                  SizedBox(height: 24.h),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Total balance card with gradient background
  Widget _buildBalanceCard(String balance) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [commonColor, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: commonColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'TOTAL BALANCE',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'EGP $balance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16.h),
          // Withdraw button
          GestureDetector(
            onTap: () => _showWithdrawSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 16.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Withdraw Funds',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Revenue statistics header with Weekly/Monthly toggle
  Widget _buildRevenueHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Revenue Statistics',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 16.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        // Toggle
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              _buildToggleButton('Weekly', 0),
              _buildToggleButton('Monthly', 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, int index) {
    final isActive = _selectedPeriod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? commonColor : const Color(0xFF94A3B8),
            fontSize: 12.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Quick stat card (Orders Processed / Avg. Order Value)
  Widget _buildQuickStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 18.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.w),
          ),
        ],
      ),
    );
  }

  /// Single transaction card
  Widget _buildTransactionCard(_Transaction transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: commonColor.withValues(alpha: 0.6),
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),

          // Order info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ${transaction.orderId}',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  TimeFormatter.format(transaction.date),
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+EGP ${transaction.amount}',
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: transaction.isCompleted
                      ? darkgreen.withValues(alpha: 0.08)
                      : goldColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  transaction.isCompleted ? 'COMPLETED' : 'PENDING',
                  style: TextStyle(
                    color: transaction.isCompleted ? darkgreen : goldColor,
                    fontSize: 9.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show withdraw funds bottom sheet
  void _showWithdrawSheet(BuildContext context) {
    double selectedAmount = 0;
    int selectedPresetIndex = -1;
    int selectedBankIndex = 0;
    final amountController = TextEditingController();
    final presetAmounts = [500.0, 1000.0, 2500.0, 5000.0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    Text(
                      'Withdraw Funds',
                      style: TextStyle(
                        color: const Color(0xFF0F172A),
                        fontSize: 20.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Available balance: EGP 12,840.00',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 13.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── Amount Input ──
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: const Color(0xFF334155),
                        fontSize: 13.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 18.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          prefixText: 'EGP  ',
                          prefixStyle: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 16.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: const Color(0xFFCBD5E1),
                            fontSize: 18.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                        ),
                        onChanged: (val) {
                          setSheetState(() {
                            selectedAmount =
                                double.tryParse(val) ?? 0;
                            selectedPresetIndex = -1;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── Quick Amount Presets ──
                    Row(
                      children: List.generate(presetAmounts.length, (i) {
                        final isSelected = selectedPresetIndex == i;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: i < presetAmounts.length - 1 ? 8.w : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setSheetState(() {
                                  selectedPresetIndex = i;
                                  selectedAmount = presetAmounts[i];
                                  amountController.text =
                                      presetAmounts[i].toStringAsFixed(0);
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? commonColor
                                      : commonColor.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? commonColor
                                        : commonColor.withValues(alpha: 0.15),
                                    width: 0.8,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'EGP ${presetAmounts[i].toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : commonColor,
                                    fontSize: 12.sp,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20.h),

                    // ── Withdraw To ──
                    Text(
                      'Withdraw to',
                      style: TextStyle(
                        color: const Color(0xFF334155),
                        fontSize: 13.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Bank accounts
                    _buildBankOption(
                      index: 0,
                      selectedIndex: selectedBankIndex,
                      bankName: 'National Bank of Egypt',
                      accountEnding: '•••• 4821',
                      icon: Icons.account_balance_rounded,
                      onTap: () => setSheetState(
                        () => selectedBankIndex = 0,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildBankOption(
                      index: 1,
                      selectedIndex: selectedBankIndex,
                      bankName: 'Vodafone Cash',
                      accountEnding: '010 •••• 3847',
                      icon: Icons.phone_android_rounded,
                      onTap: () => setSheetState(
                        () => selectedBankIndex = 1,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Confirm Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: selectedAmount > 0
                            ? () {
                                Navigator.pop(sheetContext);
                                _showWithdrawSuccess(context, selectedAmount);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: commonColor,
                          disabledBackgroundColor:
                              commonColor.withValues(alpha: 0.3),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          selectedAmount > 0
                              ? 'Withdraw EGP ${selectedAmount.toStringAsFixed(2)}'
                              : 'Enter amount',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Bank account option tile
  Widget _buildBankOption({
    required int index,
    required int selectedIndex,
    required String bankName,
    required String accountEnding,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? commonColor.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? commonColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? commonColor.withValues(alpha: 0.1)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? commonColor : const Color(0xFF64748B),
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 14.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    accountEnding,
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Radio indicator
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? commonColor : const Color(0xFFCBD5E1),
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show success snackbar after withdrawal
  void _showWithdrawSuccess(BuildContext context, double amount) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: darkgreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: darkgreen,
                size: 36.w,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Withdrawal Requested!',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 18.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'EGP ${amount.toStringAsFixed(2)} will be transferred to your account within 2-3 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 13.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(dialogCtx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: commonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock transaction data
class _Transaction {
  final String orderId;
  final String amount;
  final DateTime date;
  final bool isCompleted;

  const _Transaction({
    required this.orderId,
    required this.amount,
    required this.date,
    this.isCompleted = true,
  });
}

final _mockTransactions = [
  _Transaction(
    orderId: '#29841',
    amount: '124.00',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    isCompleted: true,
  ),
  _Transaction(
    orderId: '#29839',
    amount: '45.50',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    isCompleted: false,
  ),
  _Transaction(
    orderId: '#29835',
    amount: '89.00',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    isCompleted: true,
  ),
  _Transaction(
    orderId: '#29830',
    amount: '210.00',
    date: DateTime.now().subtract(const Duration(days: 2)),
    isCompleted: true,
  ),
  _Transaction(
    orderId: '#29825',
    amount: '67.50',
    date: DateTime.now().subtract(const Duration(days: 3)),
    isCompleted: true,
  ),
];

// ─── Earnings Chart (embedded) ───

class _EarningsChart extends StatefulWidget {
  final int selectedPeriod;
  final SellerDashboardStats stats;
  const _EarningsChart({required this.stats, this.selectedPeriod = 0});

  @override
  State<_EarningsChart> createState() => _EarningsChartState();
}

class _EarningsChartState extends State<_EarningsChart> {
  int _touchedIndex = -1;

  static const _wLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _mLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const _mData = [1800.0, 2100.0, 2850.0, 2400.0, 1950.0, 2520.0];

  @override
  void didUpdateWidget(covariant _EarningsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPeriod != widget.selectedPeriod) {
      setState(() => _touchedIndex = -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isW = widget.selectedPeriod == 0;
    final List<double> _wData = widget.stats.weeklySales.isNotEmpty ? widget.stats.weeklySales : List.filled(7, 0.0);
    final data = isW ? _wData : _mData;
    final labels = isW ? _wLabels : _mLabels;
    final maxDataValue = data.isEmpty ? 0.0 : data.reduce((a, b) => a > b ? a : b);
    final maxY = isW ? (maxDataValue + 200.0).clamp(600.0, double.infinity) : 3500.0;
    final interval = isW ? (maxY / 4) : 1000.0;
    
    // Peak index = default highlighted bar when nothing is touched
    final peakIdx = data.indexOf(data.reduce((a, b) => a > b ? a : b));
    final activeIdx = _touchedIndex >= 0 ? _touchedIndex : peakIdx;

    final defaultTotal = isW ? '+EGP 2,450.00' : '+EGP 9,820.00';
    final percentage = isW ? '12%' : '8%';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isW ? 'Weekly Earnings' : 'Monthly Earnings',
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 15.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _touchedIndex >= 0
                          ? 'EGP ${data[_touchedIndex].toInt()} — ${labels[_touchedIndex]}'
                          : defaultTotal,
                      key: ValueKey(_touchedIndex),
                      style: TextStyle(
                        color: _touchedIndex >= 0 ? commonColor : const Color(0xFF64748B),
                        fontSize: 13.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: _touchedIndex >= 0 ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: darkgreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, color: darkgreen, size: 14.w),
                    SizedBox(width: 3.w),
                    Text(
                      percentage,
                      style: TextStyle(
                        color: darkgreen,
                        fontSize: 12.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 180.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                      if (_touchedIndex != -1) {
                        setState(() => _touchedIndex = -1);
                      }
                      return;
                    }
                    
                    int newIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    if (_touchedIndex != newIndex) {
                      setState(() => _touchedIndex = newIndex);
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    getTooltipItem: (group, gi, rod, ri) {
                      return BarTooltipItem(
                        'EGP ${rod.toY.toInt()}',
                        TextStyle(
                          color: Colors.white,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.w,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == maxY) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Text(
                            value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toInt().toString(),
                            style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 10.sp, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.h,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                        final isLabelActive = idx == activeIdx;
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            labels[idx],
                            style: TextStyle(
                              color: isLabelActive ? commonColor : const Color(0xFF94A3B8),
                              fontSize: isW ? 11.sp : 10.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: isLabelActive ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) => FlLine(color: const Color(0xFFE2E8F0), strokeWidth: 0.8, dashArray: [5, 5]),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (i) {
                  final isBarActive = i == activeIdx;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i],
                        width: isW ? 28.w : 18.w,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(6.r)),
                        gradient: isBarActive
                            ? const LinearGradient(colors: [commonColor, primaryColor], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                            : LinearGradient(colors: [commonColor.withValues(alpha: 0.18), commonColor.withValues(alpha: 0.32)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: isBarActive,
                          toY: maxY,
                          color: commonColor.withValues(alpha: 0.04),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              duration: Duration.zero, // REMOVE ANIMATION TO PREVENT LAG ON DRAG
            ),
          ),
        ],
      ),
    );
  }
}
