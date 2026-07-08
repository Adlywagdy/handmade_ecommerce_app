import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';

import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class SellerAddProductScreen extends StatefulWidget {
  const SellerAddProductScreen({super.key});

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isActive = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _titleARController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _descriptionARController = TextEditingController();

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleARController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _descriptionARController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: commonColor, size: 24.w),
          onPressed: () {
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            }
          },
        ),
        title: Text(
          context.l10n.addProduct,
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF1F5F9), // Light separator
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images Section
                _buildImagesSection(),
                SizedBox(height: 24.h),

                // Product Title
                _buildLabel(context.l10n.selProductTitle),
                _buildTextField(
                  hint: context.l10n.selProductTitleHint,
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.selProductTitleRequired;
                    }
                    if (value.trim().length < 3) {
                      return context.l10n.selTitleMin3Chars;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Product Title AR
                _buildLabel('Product Title (Arabic)'),
                _buildTextField(
                  hint: 'اسم المنتج بالعربي',
                  controller: _titleARController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Arabic title is required';
                    }
                    if (value.trim().length < 3) {
                      return context.l10n.selTitleMin3Chars;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Category dropdown (full-width)
                _buildLabel(context.l10n.category),
                BlocBuilder<SellerCubit, SellerState>(
                  builder: (context, state) {
                    List<CategoryModel> categories = [];
                    if (state is SellerLoaded) {
                      categories = state.categories;
                    }
                    
                    // If the list is empty, we show a fallback
                    if (categories.isEmpty) {
                      return Text('Loading categories...', style: TextStyle(color: Colors.grey, fontSize: 14.sp));
                    }

                    // Set initial value if not set
                    if (_categoryController.text.isEmpty && categories.isNotEmpty) {
                      _categoryController.text = categories.first.id ?? '';
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _categoryController.text.isNotEmpty && categories.any((c) => c.id == _categoryController.text) 
                          ? _categoryController.text 
                          : categories.first.id,
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF64748B), size: 20.w),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: commonColor)),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Text(
                            cat.localizedTitle(false), // Or true if app is in Arabic
                            style: TextStyle(fontSize: 14.sp, fontFamily: 'Plus Jakarta Sans', color: const Color(0xFF334155)),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _categoryController.text = val;
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),

                // Price and Stock Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(context.l10n.selPriceEgp),
                          _buildTextField(
                            hint: '450.00',
                            controller: _priceController,
                            prefixText: 'EGP',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.l10n.selPriceRequired;
                              }
                              final price = double.tryParse(value);
                              if (price == null) {
                                return context.l10n.selEnterValidNumber;
                              }
                              if (price < 0) {
                                return context.l10n.selPriceCannotBeNegative;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(context.l10n.stock),
                          _buildTextField(
                            hint: '10',
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.l10n.selStockRequired;
                              }
                              final stock = int.tryParse(value);
                              if (stock == null) {
                                return context.l10n.selEnterValidInteger;
                              }
                              if (stock < 0) {
                                return context.l10n.selStockCannotBeNegative;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Description
                _buildLabel(context.l10n.description),
                _buildTextField(
                  hint: context.l10n.describeYourProduct,
                  controller: _descriptionController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.selDescriptionRequired;
                    }
                    if (value.trim().length < 10) {
                      return context.l10n.selDescriptionMin10Chars;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Description AR
                _buildLabel('Product Description (Arabic)'),
                _buildTextField(
                  hint: 'وصف المنتج بالعربي',
                  controller: _descriptionARController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Arabic description is required';
                    }
                    if (value.trim().length < 10) {
                      return context.l10n.selDescriptionMin10Chars;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Active Listing Toggle
                _buildActiveListingToggle(),
                SizedBox(height: 32.h),

                // Action Buttons
                _buildActionButtons(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.selProductImages,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F5F2), // Light warm beige
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '${_selectedImages.length} / 5',
                style: TextStyle(
                  color: commonColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              ..._selectedImages.map((file) => Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: _buildImageCard(file),
              )),
              if (_selectedImages.length < 5)
                GestureDetector(
                  onTap: _pickImage,
                  child: _buildAddPhotoCard(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(File file) {
    return Stack(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4.w,
          right: 4.w,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImages.remove(file);
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 12.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoCard() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: const Color(0xFFD6C3B1), // Light brown matching design
        strokeWidth: 1.5,
        gap: 5.0,
        dashLength: 6.0,
        radius: 8.r,
      ),
      child: Container(
        width: 90.w,
        height: 90.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8F4), 
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: commonColor, size: 24.w),
            SizedBox(height: 6.h),
            Text(
              context.l10n.selAddPhoto,
              style: TextStyle(
                color: commonColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF0F172A),
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    int maxLines = 1,
    Widget? suffixIcon,
    String? prefixText,
    TextEditingController? controller,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.thisFieldIsRequired;
        }
        return null;
      },
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Plus Jakarta Sans',
        color: const Color(0xFF334155),
        height: 1.5,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        prefixText: prefixText != null ? '$prefixText ' : null,
        prefixStyle: TextStyle(
          color: const Color(0xFF94A3B8), 
          fontSize: 14.sp,
          fontFamily: 'Plus Jakarta Sans',
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: maxLines > 1 ? 16.h : 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Light border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: commonColor),
        ),
      ),
    );
  }

  Widget _buildActiveListingToggle() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5F2), // Soft warm beige matching card UI
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1EBE5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.selActiveListing,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  context.l10n.selVisibleToCustomers,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (val) {
              setState(() {
                _isActive = val;
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: commonColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocConsumer<SellerCubit, SellerState>(
      listener: (context, state) {
        if (state is SellerError) {
          Get.snackbar(
            context.l10n.error,
            state.message,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        } else if (state is SellerLoaded) {
          // Handled manually after the await call
        }
      },
      builder: (context, state) {
        if (state is SellerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImages.isEmpty) {
                      Get.snackbar(context.l10n.error, context.l10n.selPleaseAddAtLeastOneImage, backgroundColor: Colors.redAccent, colorText: Colors.white);
                      return;
                    }

                    double price = double.tryParse(_priceController.text) ?? 0;
                    int stock = int.tryParse(_stockController.text) ?? 0;
                    
                    final cubit = context.read<SellerCubit>();
                    await cubit.addProductWithImages(
                      name: _titleController.text,
                      nameAR: _titleARController.text,
                      description: _descriptionController.text,
                      descriptionAR: _descriptionARController.text,
                      price: price,
                      stock: stock,
                      categoryId: _categoryController.text,
                      imageFiles: _selectedImages,
                    );
                    
                    // Check if the operation succeeded
                    if (mounted && cubit.state is! SellerError) {
                      Get.back(); // Return to previous screen only on success
                      Get.snackbar(
                        context.l10n.success,
                        context.l10n.selProductAddedSuccessfully,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                icon: Icon(Icons.save_outlined, color: Colors.white, size: 20.w),
                label: Text(
                  context.l10n.selSaveProduct,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: commonColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: commonColor, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  context.l10n.selDiscardChanges,
                  style: TextStyle(
                    color: commonColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A custom painter to draw a dashed rounded rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashLength = 5.0,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius)));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = distance + dashLength;
        dashPath.addPath(metric.extractPath(distance, length), Offset.zero);
        distance = length + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
