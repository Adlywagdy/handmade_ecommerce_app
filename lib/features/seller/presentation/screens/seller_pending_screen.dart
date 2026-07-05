import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/constants/seller_status.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';

class SellerPendingScreen extends StatefulWidget {
  const SellerPendingScreen({super.key});

  @override
  State<SellerPendingScreen> createState() => _SellerPendingScreenState();
}

class _SellerPendingScreenState extends State<SellerPendingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _sonarController;
  late final AnimationController _entranceController;

  late final Animation<double> _logoScale;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;

  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _sonarController = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    )..repeat();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entranceFade = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sonarController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        if (!mounted) return;
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final status = doc.data()?['status'] as String?;
      if (status != null && status.isNotEmpty) {
        HiveHelper.setStatusBoxValue(status);
      }

      if (!mounted) return;

      if (SellerStatus.isApproved(status)) {
        Get.offAllNamed(AppRoutes.sellerdashboard);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: commonColor,
          content: Text(
            status == SellerStatus.rejected
                ? 'Your application was not approved. Please contact support.'
                : 'You\'re still under review. We\'ll notify you soon.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not refresh status: $e')),
      );
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
    HiveHelper.setLoginBox(value: false);
    HiveHelper.clearEmailBox();
    if (!mounted) return;
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final status =
        HiveHelper.getStatusBoxValue()?.trim().toLowerCase() ??
            SellerStatus.pending;
    final isRejected = status == SellerStatus.rejected;

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _entranceFade,
          child: SlideTransition(
            position: _entranceSlide,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 12.h),
                            _buildLogoHero(isRejected),
                            SizedBox(height: 32.h),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                isRejected
                                    ? 'Application Not Approved'
                                    : 'Account Under Review',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: commonColor,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                isRejected
                                    ? 'We were unable to approve your seller application at this time. Reach out to our team if you\'d like to know more.'
                                    : 'Thanks for joining Ayady. Our curation team is reviewing your application — you\'ll be notified the moment it\'s approved.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subTitleColor,
                                  fontSize: 13.sp,
                                  height: 1.5,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                            SizedBox(height: 22.h),
                            _StatusPill(
                              status: status,
                              controller: _pulseController,
                            ),
                            SizedBox(height: 28.h),
                            _TimelineCard(status: status),
                            SizedBox(height: 18.h),
                            if (!isRejected) _buildEtaCard(),
                            const Spacer(),
                            SizedBox(height: 18.h),
                            _buildPrimaryButton(),
                            SizedBox(height: 6.h),
                            TextButton(
                              onPressed: _signOut,
                              style: TextButton.styleFrom(
                                foregroundColor: commonColor,
                              ),
                              child: Text(
                                'Sign out',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHero(bool isRejected) {
    final ringColor = isRejected ? redDegree : primaryColor;
    final heroSize = (220.w).clamp(160.0, 260.0);
    final logoSize = heroSize * 0.5;

    return SizedBox(
      height: heroSize,
      width: heroSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _sonarController,
            builder: (_, _) {
              return CustomPaint(
                size: Size.square(heroSize),
                painter: _SonarPainter(
                  progress: _sonarController.value,
                  color: ringColor,
                ),
              );
            },
          ),
          ScaleTransition(
            scale: _logoScale,
            child: Container(
              height: logoSize,
              width: logoSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ringColor.withValues(alpha: 0.18),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: ringColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              padding: EdgeInsets.all(logoSize * 0.16),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('assets/icons/Icon1.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEDE0CE)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: primaryColor,
              size: 18.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Estimated review time: 3–5 business days',
              style: TextStyle(
                color: const Color(0xFF1E293B),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: _isRefreshing ? null : _refreshStatus,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: _isRefreshing
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh_rounded, size: 20.w),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Refresh Status',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Plus Jakarta Sans',
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.controller});

  final String status;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final isRejected = status == SellerStatus.rejected;
    final baseColor = isRejected ? redDegree : primaryColor;
    final label = isRejected ? 'NOT APPROVED' : 'PENDING APPROVAL';

    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        final t = controller.value;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: 0.08 + 0.06 * t),
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: baseColor.withValues(alpha: 0.35 + 0.25 * t),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withValues(alpha: 0.6 * t),
                      blurRadius: 6 + 4 * t,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: baseColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isRejected = status == SellerStatus.rejected;
    final isApproved = status == SellerStatus.approved;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDE0CE)),
        boxShadow: [
          BoxShadow(
            color: commonColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _TimelineStep(
            label: 'Application submitted',
            isDone: true,
            isActive: false,
            isFirst: true,
            isLast: false,
          ),
          _TimelineStep(
            label: isRejected ? 'Reviewed' : 'Under review',
            isDone: isApproved || isRejected,
            isActive: !isApproved && !isRejected,
            isFirst: false,
            isLast: false,
            isError: isRejected,
          ),
          _TimelineStep(
            label: isApproved ? 'Approved — welcome aboard' : 'Approved',
            isDone: isApproved,
            isActive: false,
            isFirst: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.isDone,
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    this.isError = false,
  });

  final String label;
  final bool isDone;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final Color accent = isError
        ? redDegree
        : isDone
            ? greenDegree
            : isActive
                ? primaryColor
                : const Color(0xFFCBD5E1);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width: 22.w,
                height: isFirst ? 11.h : 22.h,
                child: !isFirst
                    ? Center(
                        child: Container(
                          width: 2.w,
                          color: const Color(0xFFE6D7C0),
                        ),
                      )
                    : null,
              ),
              isActive
                  ? _PulsingDot(color: accent)
                  : Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: isDone || isError
                            ? accent
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: accent, width: 2),
                      ),
                      child: isDone
                          ? Icon(Icons.check, color: Colors.white, size: 14.w)
                          : isError
                              ? Icon(Icons.close,
                                  color: Colors.white, size: 14.w)
                              : null,
                    ),
              Expanded(
                child: Container(
                  width: 2.w,
                  color: isLast
                      ? Colors.transparent
                      : const Color(0xFFE6D7C0),
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? primaryColor
                      : isDone
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                  fontSize: 13.sp,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});

  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) {
        final t = _c.value;
        return SizedBox(
          width: 22.w,
          height: 22.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 22.w * (0.6 + 0.4 * t),
                height: 22.w * (0.6 + 0.4 * t),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.18 * (1 - t)),
                ),
              ),
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SonarPainter extends CustomPainter {
  _SonarPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const int _ringCount = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;

    for (int i = 0; i < _ringCount; i++) {
      final t = (progress + i / _ringCount) % 1.0;
      final radius = _lerp(maxRadius * 0.32, maxRadius, t);
      final opacity = (1 - t) * 0.55;
      final stroke = _lerp(2.4, 0.6, t);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color.withValues(alpha: opacity);

      canvas.drawCircle(center, radius, paint);
    }
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(covariant _SonarPainter old) =>
      old.progress != progress || old.color != color;
}

