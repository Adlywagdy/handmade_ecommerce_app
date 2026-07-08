import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../logic/admin_cubit.dart';
import '../../data/models/coupon_model.dart';

class CouponBottomSheet extends StatefulWidget {
  final CouponModel? coupon;

  const CouponBottomSheet({super.key, this.coupon});

  @override
  State<CouponBottomSheet> createState() => _CouponBottomSheetState();
}

class _CouponBottomSheetState extends State<CouponBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _discountValueController;
  late final TextEditingController _maxUsesController;
  late final TextEditingController _minOrderController;
  DiscountType _discountType = DiscountType.percentage;
  DateTime? _expiryDate;
  bool _isSaving = false;

  bool get _isEditing => widget.coupon != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.coupon?.code ?? '',
    );
    _discountValueController = TextEditingController(
      text: widget.coupon != null ? '${widget.coupon!.discountValue}' : '',
    );
    _maxUsesController = TextEditingController(
      text: widget.coupon != null ? '${widget.coupon!.maxUses}' : '0',
    );
    _minOrderController = TextEditingController(
      text: widget.coupon != null ? '${widget.coupon!.minOrderAmount}' : '0',
    );
    _discountType = widget.coupon?.discountType ?? DiscountType.percentage;
    _expiryDate = widget.coupon?.expiryDate;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountValueController.dispose();
    _maxUsesController.dispose();
    _minOrderController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final cubit = context.read<AdminCubit>();
    final code = _codeController.text.trim();
    final discountValue = double.tryParse(_discountValueController.text.trim()) ?? 0;
    final maxUses = int.tryParse(_maxUsesController.text.trim()) ?? 0;
    final minOrderAmount = double.tryParse(_minOrderController.text.trim()) ?? 0;

    if (_isEditing) {
      cubit.updateCoupon(
        id: widget.coupon!.id,
        code: code,
        discountType: _discountType,
        discountValue: discountValue,
        maxUses: maxUses,
        minOrderAmount: minOrderAmount,
        expiryDate: _expiryDate,
      );
    } else {
      cubit.addCoupon(
        code: code,
        discountType: _discountType,
        discountValue: discountValue,
        maxUses: maxUses,
        minOrderAmount: minOrderAmount,
        expiryDate: _expiryDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is CouponActionSuccess) {
          setState(() => _isSaving = false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: greenDegree,
            ),
          );
        } else if (state is CouponActionError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: redDegree),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  _isEditing ? 'Edit Coupon' : 'Add Coupon',
                  style: AppTextStyles.t_18w700,
                ),
                SizedBox(height: 20.h),
                _buildTextField(
                  controller: _codeController,
                  label: 'Coupon Code',
                  icon: Icons.confirmation_number_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter a coupon code'
                      : null,
                ),
                SizedBox(height: 12.h),
                _buildDiscountTypeDropdown(l10n),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: _discountValueController,
                  label: _discountType == DiscountType.percentage
                      ? 'Discount Percentage'
                      : 'Discount Amount',
                  icon: Icons.percent_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter a discount value';
                    }
                    final val = double.tryParse(v.trim());
                    if (val == null || val <= 0) return 'Must be > 0';
                    if (_discountType == DiscountType.percentage && val > 100) {
                      return 'Cannot exceed 100%';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: _maxUsesController,
                  label: 'Max Uses (0 = unlimited)',
                  icon: Icons.all_inclusive_outlined,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: _minOrderController,
                  label: 'Min Order Amount',
                  icon: Icons.shopping_cart_outlined,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12.h),
                _buildExpiryDatePicker(l10n),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: commonColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: commonColor.withValues(
                        alpha: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isSaving
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isEditing ? 'Update Coupon' : 'Add Coupon',
                            style: AppTextStyles.t_16w600.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountTypeDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<DiscountType>(
      initialValue: _discountType,
      decoration: InputDecoration(
        labelText: 'Discount Type',
        labelStyle: TextStyle(color: subTitleColor),
        prefixIcon: Icon(Icons.style_outlined, color: commonColor, size: 20.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: commonColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: const [
        DropdownMenuItem(
          value: DiscountType.percentage,
          child: Text('Percentage (%)'),
        ),
        DropdownMenuItem(
          value: DiscountType.fixed,
          child: Text('Fixed Amount'),
        ),
      ],
      onChanged: (val) {
        if (val != null) setState(() => _discountType = val);
      },
    );
  }

  Widget _buildExpiryDatePicker(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expiry Date (optional)',
          style: AppTextStyles.t_14w600.copyWith(color: subTitleColor),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 30)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: commonColor),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) setState(() => _expiryDate = picked);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: commonColor, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _expiryDate != null
                        ? DateFormat('MMM d, yyyy').format(_expiryDate!)
                        : 'Select expiry date',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _expiryDate != null ? blackDegree : subTitleColor,
                    ),
                  ),
                ),
                if (_expiryDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _expiryDate = null),
                    child: Icon(Icons.close, color: redDegree, size: 18.sp),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: commonColor,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: subTitleColor),
        prefixIcon: Icon(icon, color: commonColor, size: 20.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: commonColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: redDegree),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: redDegree),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

void showCouponBottomSheet(BuildContext context, {CouponModel? coupon}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<AdminCubit>(),
      child: CouponBottomSheet(coupon: coupon),
    ),
  );
}
