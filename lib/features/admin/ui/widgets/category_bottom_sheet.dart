import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../logic/admin_cubit.dart';
import '../../data/models/category_model.dart';

class CategoryBottomSheet extends StatefulWidget {
  final CategoryModel? category;

  const CategoryBottomSheet({super.key, this.category});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final TextEditingController _nameENController;
  late final TextEditingController _nameARController;
  late final TextEditingController _orderController;
  File? _selectedImage;
  String? _existingIconUrl;
  bool _isSaving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameENController = TextEditingController(
      text: widget.category?.nameEN ?? '',
    );
    _nameARController = TextEditingController(
      text: widget.category?.nameAR ?? '',
    );
    _orderController = TextEditingController(
      text: '${widget.category?.order ?? 0}',
    );
    _existingIconUrl = widget.category?.icon;
  }

  @override
  void dispose() {
    _nameENController.dispose();
    _nameARController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _existingIconUrl = null;
      });
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null && !_isEditing) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.admPleaseSelectImage)));
      return;
    }

    setState(() => _isSaving = true);

    final cubit = context.read<AdminCubit>();
    final nameEN = _nameENController.text.trim();
    final nameAR = _nameARController.text.trim();
    final order = int.tryParse(_orderController.text.trim()) ?? 0;

    if (_isEditing) {
      cubit.updateCategory(
        id: widget.category!.id,
        nameEN: nameEN,
        nameAR: nameAR,
        imageFile: _selectedImage,
        order: order,
      );
    } else {
      cubit.addCategory(
        nameEN: nameEN,
        nameAR: nameAR,
        imageFile: _selectedImage!,
        order: order,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is CategoryActionSuccess) {
          setState(() => _isSaving = false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: greenDegree,
            ),
          );
        } else if (state is CategoryActionError) {
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
                  _isEditing ? l10n.admEditCategory : l10n.admAddCategory,
                  style: AppTextStyles.t_18w700,
                ),
                SizedBox(height: 20.h),
                _buildImagePicker(l10n),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _nameENController,
                  label: l10n.admCategoryNameEN,
                  icon: Icons.abc,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.admEnglishNameRequired
                      : null,
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: _nameARController,
                  label: l10n.admCategoryNameAR,
                  icon: Icons.translate,
                  textDirection: TextDirection.rtl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.admArabicNameRequired
                      : null,
                ),
                SizedBox(height: 12.h),
                _buildTextField(
                  controller: _orderController,
                  label: l10n.admDisplayOrder,
                  icon: Icons.sort_outlined,
                  keyboardType: TextInputType.number,
                ),
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
                            _isEditing
                                ? l10n.admButtonSave
                                : l10n.admAddCategory,
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

  Widget _buildImagePicker(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.admCategoryImage,
          style: AppTextStyles.t_14w600.copyWith(color: subTitleColor),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: commonColor.withValues(alpha: 0.2)),
            ),
            child: _buildImageContent(l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildImageContent(AppLocalizations l10n) {
    if (_selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8.r,
            right: 8.r,
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedImage = null;
                _existingIconUrl = widget.category?.icon;
              }),
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.r),
              ),
            ),
          ),
        ],
      );
    }

    if (_existingIconUrl != null && _existingIconUrl!.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              _existingIconUrl!,
              width: double.infinity,
              height: 120.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => _buildPlaceholder(l10n),
            ),
          ),
          Positioned(
            top: 8.r,
            right: 8.r,
            child: GestureDetector(
              onTap: () => setState(() {
                _existingIconUrl = null;
              }),
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.r),
              ),
            ),
          ),
        ],
      );
    }

    return _buildPlaceholder(l10n);
  }

  Widget _buildPlaceholder(AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          size: 36.r,
          color: commonColor.withValues(alpha: 0.6),
        ),
        SizedBox(height: 8.h),
        Text(
          l10n.admTapToPickImage,
          style: TextStyle(fontSize: 13.sp, color: subTitleColor),
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
    TextDirection? textDirection,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textDirection: textDirection,
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

void showCategoryBottomSheet(BuildContext context, {CategoryModel? category}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<AdminCubit>(),
      child: CategoryBottomSheet(category: category),
    ),
  );
}
