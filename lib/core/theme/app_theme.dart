import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTextStyles {
  static final t_36w700 = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_30w800 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_30w700 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_24w500 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_20w700 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );

  static final t_18w700 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Plus Jakarta Sans',
    color: AppColors.textHeadline,
  );

  static final t_16w700 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );

  static final t_16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );

  static final t_16w500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_14w700 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_14w500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_14w600 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_12w700 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_12w500 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
  static final t_12w400 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHeadline,
    fontFamily: 'Plus Jakarta Sans',
  );
}
//-------------------------------------------------------------------

abstract class AppColors {
  // --- Brand & Primary Colors (هوية أيادي) ---
  // اللون البني الأساسي للأزرار الرئيسية (Primary Button)
  static const primaryBrown = Color(0xFF8B4513);
  // البرتقالي المحروق (للأزرار التفاعلية أو الـ Highlights)
  static const primaryTerracotta = Color(0xFFC05A3D);
  // لون النخيل/النمو (يستخدم في الـ Badges أو الـ Agriculture features)
  static const forestGreen = Color(0xFF07880E);

  // --- Typography (نظام النصوص) ---
  // لون العناوين الرئيسية (Heading 1, Price, Product Name) - Slate 900
  static const textHeadline = Color(0xFF0F172A);
  // النص الأساسي للقراءة (Body Medium) - Slate 800
  static const textPrimary = Color(0xFF1E293B);
  // نصوص الوصف والبيانات الثانوية - Slate 600
  static const textSecondary = Color(0xFF475569);
  // النصوص الباهتة (Placeholder, Disabled) - Slate 400
  static const textMuted = Color(0xFF94A3B8);
  static const cinnamonHandmade = Color(
    0xFFD2691E,
  ); // مثالي لأيقونات الحرف اليدوية أو تصنيف "الجلود"

  static const cinnamonOpacity80 = Color(0xCCD2691E);
  static const cinnamonOpacity70 = Color(0xB2D2691E);
  static const cinnamonOpacity60 = Color(0x99D2691E);
  static const cinnamonOpacity50 = Color(0x80D2691E);

  // --- Backgrounds & Surfaces (الخلفيات والمساحات) ---
  // الخلفية الدافئة المميزة للتطبيق (Warm Scaffolding)
  static const backgroundWarm = Color(0xFFF5E6D3);
  // اللون الأبيض المكسور للخلفيات البديلة
  static const backgroundOffWhite = Color(0xFFF8F7F6);
  // خلفية الكروت (Cards) في الـ Dark Mode كما ظهر في الصور
  static const backgroundDarkCard = Color(0xFF1C1C1E);
  // خلفية التطبيق الكاملة في الـ Dark Mode
  static const backgroundDarkFull = Color(0xFF0F172A);

  // --- State & Feedback (حالات النظام) ---
  // النجاح (Success) - للطلبات المكتملة
  static const successSurface = Color(0xFFDCFCE7);
  static const successMain = Color(0xFF15803D);

  // الخطأ (Error) - للتحذيرات وحذف المنتجات
  static const errorSurface = Color(0xFFFEF2F2);
  static const errorMain = Color(0xFFEF4444);
  static const errorDeepRuby = Color(0xFF9B2226);

  // التحذير (Warning) - مثل "Pending Approval" في لوحة الآدمن
  static const warningSurface = Color(0xFFFEF3C7);
  static const warningText = Color(0xFFB45309);

  // --- Decorative & Specials (لمسات جمالية) ---
  // الذهبي الشفاف للـ Premium Artisans أو التقييمات (Stars)
  static const goldHighlight = Color(0x26FFD700);
  // البنفسجي للأقسام التقنية أو الـ Special Editions
  static const premiumPurple = Color(0xFF7E22CE);
  // النيلي لـ "Track Order" أو المعلومات اللوجستية
  static const infoIndigo = Color(0xFF4338CA);

  // --- Opacity Variants (تدرجات الشفافية للـ Overlays) ---
  static const brownOpacity60 = Color(0x998B4513);
  static const brownOpacity10 = Color(0x1A8B4513);
}
